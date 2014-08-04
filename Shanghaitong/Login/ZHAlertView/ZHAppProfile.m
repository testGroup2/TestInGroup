//
//  ZHAppProfile.m
//  ZHIslandIM
//
//  Created by arthuryan on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHAppProfile.h"
#import "KeychainItemWrapper.h"

NSString * const kCheckDeviceId = @"kCheckDeviceId";

@interface ZHAppProfile ()

@property (nonatomic, retain) NSString * versionName;
@property (nonatomic, assign) UInt16 versionNum;

@end

static ZHAppProfile *sharedInstance;

@implementation ZHAppProfile
@synthesize deviceId = _deviceId;
@synthesize accessToken = _accessToken;

+ (ZHAppProfile *)sharedInstance
{
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		sharedInstance = [[ZHAppProfile alloc] init];
	});
	
	return sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self) {
        _wapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"jushang" accessGroup:nil];
    }
	return self;
}

- (NSString*)accessToken
{
    if(_accessToken == nil) {
        _accessToken = [[_wapper objectForKey:(id)kSecAttrAccount] copy];
    }
    NSLog(@"_accessToken%@",_accessToken);
    return _accessToken;
}

- (void)setAccessToken:(NSString*)acessToken
{
    [_wapper setObject:acessToken forKey:(id)kSecAttrAccount];
    [_accessToken release];
    _accessToken = [acessToken copy];
}

- (void)clearAcessToken
{
    [_wapper resetKeychainItem];
    self.accessToken = nil;
}

#pragma mark For Blog Client

- (UInt16)getVersionNum
{
    [self getVersion];
    
    return _versionNum;
}

-(NSString *)getVersion
{
    if(!_versionName) {
        _versionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        [_versionName retain];
        
        
        float vserion = [_versionName floatValue];
        int mainVer = (int)vserion;
        
        int p = 10;
        int iNum = 0;
        
        while (1) {
            float fNUm = vserion * p;
            iNum = (int)fNUm;
            if(iNum >= fNUm) {
                break;
            }
            p *= 10;
        }
        
        int minorVer = iNum % p;
        
        _versionNum = (((mainVer << 8) | minorVer) & 0xFFFF);
    }

    return _versionName;
}

#pragma mark Memory Management

- (void)dealloc
{
    [_deviceId release];
    [_accessToken release];
    [_versionName release];
    [_wapper release];
    [_deviceId release];
    [super dealloc];
}

#pragma mark Blog

@end
