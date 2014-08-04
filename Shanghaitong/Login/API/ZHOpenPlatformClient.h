//
//  NTLNCartycoonClient.h
//  cartycoon
//
//  Created by 王祺 on 11-11-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHHttpClient.h"
#import "ZHHttpTaskDelegate.h"
#import "SynthesizeSingleton.h"
@interface ZHOpenPlatformClient : ZHHttpClient {
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ZHOpenPlatformClient);
-(id)doTask:(Class)cls withParams:(NSMutableDictionary *)params andDelegate:(id <ZHHttpTaskDelegate>)dele andId:(int)requestId;
#pragma mark account
- (void)login:(NSString*)username password: (NSString*)psw withDelegate:(id <ZHHttpTaskDelegate>)dele;

#pragma mark -- RegisterDeviceToken
- (void)registerDeviceToken:(NSData *)dt withDelegate:(id<ZHHttpTaskDelegate>)dele;
@end
