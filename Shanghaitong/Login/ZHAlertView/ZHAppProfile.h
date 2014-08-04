//
//  ZHAppProfile.h
//  ZHIsland
//
//  Created by arthuryan on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import <CommonCrypto/CommonCryptor.h>

@interface ZHAppProfile : NSObject
{

}

@property (retain, readonly) KeychainItemWrapper* wapper;

@property (copy, readwrite) NSString* deviceId;
@property (copy, readwrite) NSString* accessToken;

+ (ZHAppProfile *)sharedInstance;

- (void)clearAcessToken;

@end

