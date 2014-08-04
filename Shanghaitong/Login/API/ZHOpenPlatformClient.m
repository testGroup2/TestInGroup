//
//  NTLNCartycoonClient.m
//  cartycoon
//
//  Created by 王祺 on 11-11-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZHOpenPlatformClient.h"
#import "ZHHttpLoginTask.h"
#import "ZHRegisterDeviceTokenTask.h"
#import "NSData+AES256.h"

@interface ZHOpenPlatformClient()

-(id)doTask:(Class)cls withParams:(NSMutableDictionary *)params andDelegate:(id <ZHHttpTaskDelegate>)dele andId:(int)requestId ;

@end

@implementation ZHOpenPlatformClient

SYNTHESIZE_SINGLETON_FOR_CLASS(ZHOpenPlatformClient);


-(id)doTask:(Class)cls withParams:(NSMutableDictionary *)params andDelegate:(id <ZHHttpTaskDelegate>)dele andId:(int)requestId
{
    
    BOOL isNetWorkAvailible = true;
    
    if(isNetWorkAvailible )
    {
        ZHHttpBaseTask * task = [[cls alloc] initWithParams:params];
        task.delegate = dele;
        task.requestId = requestId;
        [self addTask:task];
        [task release];
        return task;
    }
    return nil;
}

#pragma mark account

- (void)login:(NSString*)username password: (NSString*)psw withDelegate:(id <ZHHttpTaskDelegate>)dele
{
    static NSString *key = @"-aZSH,@C(g=Aky=I";
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:username forKey:@"username"];
    [params setObject:psw forKey:@"password"];
    
    NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", username, psw];

    [params setObject:[[[data dataUsingEncoding:NSUTF8StringEncoding] AES256Encrypt:key] base64Encoding] forKey:@"t"];

    [self doTask:[ZHHttpLoginTask class] withParams:params andDelegate:dele andId:0];
    
    //设置默认登录状态
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_dt"];
    
}

#pragma mark -- RegisterDeviceToken

- (void)registerDeviceToken:(NSData *)dt withDelegate:(id<ZHHttpTaskDelegate>)dele
{
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:[dt description] forKey:@"device_token"];
    [self doTask:[ZHRegisterDeviceTokenTask class] withParams:params andDelegate:dele andId:0];
}

@end
