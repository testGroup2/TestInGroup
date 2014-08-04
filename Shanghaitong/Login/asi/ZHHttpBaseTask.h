//
//  ZHBaseTask.h
//  ZHIsland
//
//  Created by arthuryan on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "ZHASIHTTPRequest.h"
#import "ZHHttpTaskDelegate.h"


@interface ZHHttpBaseTask : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate> {
    
    ZHASIHttpRequest* httpRequest_;
    NSMutableDictionary* params_;
    int _requestId;
    
}

@property (assign, nonatomic) id delegate;
@property(assign, nonatomic) int requestId;

@property (retain, nonatomic) id userInfo;

-(id) initWithParams:(NSMutableDictionary*)params;

- (void)addAdditionalParams:(NSMutableDictionary*)param;

- (ZHASIHttpRequest*) httpRequest;

- (void) execute;

- (void) cancel;

- (void)cancelPostBack;

- (NSString*) url;

- (NSString*) partureUrl;

- (NSString*) requestMethod;

- (NSString*)accessToken;

- (void) requestGet:(NSMutableDictionary*)params : (NSMutableDictionary*)headers;

- (void) requestPost:(NSMutableDictionary*)params : (NSMutableDictionary*)headers;

- (void) requestPut:(NSMutableDictionary*)params : (NSMutableDictionary*)headers;

- (void) requestDelete:(NSMutableDictionary*)headers;

- (void) addHeader:(NSString*)name : (NSString*)value;

- (id) handleSuccessResponseData:(id)data withType:(NSString *)entityName;

- (NSString *)baseUrl;

- (NSDictionary*)parameters;
@end

@interface ZHHttpBaseTask1_0 : ZHHttpBaseTask
- (NSString *)baseUrl;
@end
