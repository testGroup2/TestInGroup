//
//  NSData+AES256.m
//  AES
//
//  Created by Henry Yu on 2009/06/03.
//  Copyright 2010 Sevensoft Technology Co., Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "NSData+AES256.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

// static Byte saltBuff[] = {0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF};

static Byte ivBuff[]   = {0xA,1,0xB,5,4,0xF,7,9,0x17,3,1,6,8,0xC,0xD,91};

@implementation NSData (AES256)

/*加密方法*/

- (NSData *)AES256Encrypt:(NSString*)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
	NSUInteger dataLength = [self length];
    
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
	
	size_t numBytesEncrypted = 0;
    
//    const char *cStr = [key UTF8String];
//    UInt8 result[CC_MD5_DIGEST_LENGTH];
//    bzero(result, sizeof(result));
//    CC_MD5(cStr, strlen(cStr), result);
    
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
										  ivBuff /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
		return encryptData;
	}
	
	free(buffer); //free the buffer;
	return nil;
}

+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain key:(NSString*)key {
    NSData *plainText = [plain dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [plainText AES256Encrypt:key];
    if(encryptData) {
        return [encryptData base64Encoding];
    }
    
	return nil;
}

/*解密方法*/
- (NSData *)AES256Decrypt:(NSString*)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
	NSUInteger dataLength = [self length];
	
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    
//    const char *cStr = [key UTF8String];
//    UInt8 result[CC_MD5_DIGEST_LENGTH];
//    bzero(result, sizeof(result));
//    CC_MD5(cStr, strlen(cStr), result);
    
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES128,
										  ivBuff ,/* initialization vector (optional) */
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
        NSData *decryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
		return decryptData;
	}
	
	free(buffer); //free the buffer;
	return nil;
}

+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts key:(NSString*)key
{
    
    NSData *cipherData = [NSData dataWithBase64EncodedString:ciphertexts];
    NSData *decryptData = [cipherData AES256Decrypt:key];
    if(decryptData) {
        return [[[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding] autorelease];
    }
    
	return nil;
}

+ (id)dataWithBase64EncodedString:(NSString *)string;
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding
{
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [self length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';    
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}
@end
