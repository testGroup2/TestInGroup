//
//  ZHBaseTask.m
//  ZHIsland
//
//  Created by arthuryan on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHHttpBaseTask.h"
#import "ZHTaskManager.h"
#import "ASIFormDataRequest.h"
#import "CoreData/CoreData.h"
#import "ZHASIHttpRequest.h"
#import "ZHError.h"
#import "SXConst.h"
#import "ZHAppProfile.h"


// Private stuff
@interface ZHHttpBaseTask ()
-(void)addHeaders:(NSMutableDictionary*)headers;
@end

@implementation ZHHttpBaseTask

@synthesize delegate = delegate_;
@synthesize requestId = _requestId;
@synthesize userInfo = _userInfo;

#pragma mark initialize and dealloc

-(id) initWithParams:(NSMutableDictionary*)params {
    
    if( (self=[super init]) ) {
        if(params != nil){
           params_ = [params retain];
        }else {
            params_ = [[NSMutableDictionary alloc] init];
        }
        
        [self addAdditionalParams:params_];

        NSString *reqUrl = [self url];

        NSURL *nsUrl = [NSURL URLWithString:reqUrl];
        httpRequest_ = [self newHttpRequest:nsUrl];

        [httpRequest_ setDelegate:self];
        [httpRequest_ setDownloadProgressDelegate:self];
    }
    
    return self;
}

- (ZHASIHttpRequest*)newHttpRequest:(NSURL *)nsUrl
{
    return [[ZHASIHttpRequest alloc] initWithURL:nsUrl];
}

- (NSString *)deviceId
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
//插入token
- (void)addAdditionalParams:(NSMutableDictionary*)param
{
    // insert token
    NSString* utilParam = [self accessToken];
    if(utilParam != nil && [utilParam length] > 0){
        [param setObject:utilParam forKey:@"token"];
    }
    
}

- (NSString*)accessToken
{
    NSLog(@"token%@",[ZHAppProfile sharedInstance].accessToken);
    return [ZHAppProfile sharedInstance].accessToken;
}

-(void) dealloc {
    
    [_userInfo release];
    
    [httpRequest_ clearDelegatesAndCancel];
    [httpRequest_ release];
    // [delegate_ release];
    [params_ release];
    [super dealloc];
}

- (ASIHTTPRequest*) httpRequest {
    return httpRequest_;
}


- (void) execute {
    
}

// Cancel will not notify its delegate
- (void) cancel {
    [httpRequest_ clearDelegatesAndCancel];
    self.delegate = nil;
}

- (void)cancelPostBack
{
    self.delegate = nil;
}

- (NSString*) url {
    
    if ([[self requestMethod] isEqualToString:@"POST"] || 
        [[self requestMethod] isEqualToString:@"PUT"] || 
        (params_ == nil) || 
        ([params_ count] == 0)) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@", [self baseUrl], [self partureUrl]]);
        return [NSString stringWithFormat:@"%@%@", [self baseUrl], [self partureUrl]];
    }else {
        return nil;
    }
}

- (NSString*) partureUrl {
    return nil;
}

- (NSString*) requestMethod{
    return @"POST";
}

#pragma mark request mothods

- (void) requestGet:(NSMutableDictionary*)params : (NSMutableDictionary*)headers {
    [self addHeaders:headers];
    [httpRequest_ setRequestMethod:@"GET"];
}

- (void) requestPost:(NSMutableDictionary*)params : (NSMutableDictionary*)headers {
    [self addHeaders:headers];
    [self addHeader:@"cookie" :@"Z_AUTH=access_token"];
    [httpRequest_ setRequestMethod:@"POST"];
    if(params != nil && [params count] > 0) {
       
        ASIFormDataRequest* formDataRequest = (ASIFormDataRequest*)httpRequest_;
        NSArray *keys = [params allKeys]; // values in  foreach loop
        for (NSString *key in keys) { 
//            id value = [params objectForKey:key];
            [formDataRequest setPostValue:[params objectForKey:key] forKey:key];
        } 
    }
}

- (void) requestPut:(NSMutableDictionary*)params : (NSMutableDictionary*)headers {
    [self addHeaders:headers];
    [httpRequest_ setRequestMethod:@"PUT"]; 
    if(params != nil && [params count] > 0) {
        ASIFormDataRequest* formDataRequest = (ASIFormDataRequest*)httpRequest_;
        NSArray *keys = [params allKeys]; // values in  foreach loop
        for (NSString *key in keys) { 
            [formDataRequest setPostValue:[params objectForKey:key] forKey:key];
        }
    }
}

- (void) requestDelete:(NSMutableDictionary*)headers {
    [self addHeaders:headers];
    [httpRequest_ setRequestMethod:@"DELETE"];     
}

- (void) addHeader:(NSString*)name : (NSString*)val {
    [httpRequest_ addRequestHeader:name value:val];
}

-(void)addHeaders:(NSMutableDictionary*)headers {
    if(headers != nil){
        NSArray *keys = [headers allKeys]; // values in  foreach loop
        for (NSString *key in keys) { 
            [httpRequest_ addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
}

#pragma mark json-dictionary to object
//implement a default json-dictionary to object, if subclass want to do some 
//custom parse, please override this method without calling [super handleSuccessResponseData];
- (id) handleSuccessResponseData:(id)data withType:(NSString *)entityName
{
    id result = nil;
    
    Class cls = NSClassFromString(entityName);
    
    if([data isKindOfClass:[NSDictionary class]]){
        
        result = [[[cls alloc] initWithDictionary:data] autorelease];
        
    }else if([data isKindOfClass:[NSArray class]]){
        
        NSArray *arr = (NSArray*)data;
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        for (NSDictionary *dic in arr) {
            
            id item = [[cls alloc] initWithDictionary:dic];
                        
            if (item) [result addObject: item];
            
            [item release];
        }
    }
    
    return result;
    
}


#pragma mark request callback

// Override protocol ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    
//网络请求开始，记录网络请求的url和开始时间
#ifdef ZHHTTPRECORDTIMELOG
    NSString * url = [[ZHHttpRecordTime sharedInstance] InterceptUrl:request.url];
    unsigned long long line = [[ZHHttpRecordTime sharedInstance] getFileLine];
    NSString * time = [[ZHHttpRecordTime sharedInstance] getTime];
    NSString * space1 = [[ZHHttpRecordTime sharedInstance] getSpaceString:50-[url length]];
    NSString * space2 = [[ZHHttpRecordTime sharedInstance] getSpaceString:LINE_LENGTH-2-50-[time length]];
    NSString * str = [NSString stringWithFormat:@"%@%@%@%@\n",url,space1,time,space2];
    [[ZHHttpRecordTime sharedInstance] writeFile:line*LINE_LENGTH andStr:str];
    request.offsetLength = line*LINE_LENGTH;
    request.startTimeStr = time;
    [[ZHHttpRecordTime sharedInstance] setLine:line+1];
#endif
    
    
    SEL startSelector = @selector(onStart:fromRequest:);
    if (delegate_ && [delegate_ respondsToSelector:startSelector]) {
        [delegate_ performSelector:startSelector withObject:self];
    }
}

// Override protocol ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {

//网络请求结束，记录网络请求结束的时间以及与网络请求开始的时间差
#ifdef ZHHTTPRECORDTIMELOG
    if(request.offsetLength != 0 && request.startTimeStr != nil)
    {
        NSString * time = [[ZHHttpRecordTime sharedInstance] getTime];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+110 andStr:time];
        NSString * diff = [[ZHHttpRecordTime sharedInstance] getTimeDifference:time andStartTime:request.startTimeStr];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+135 andStr:diff];
    }
    request.offsetLength = 0;
    request.startTimeStr = nil;
#endif
    
    
    id successData = [httpRequest_ getSuccessData];
    
    SEL didSuccessSelector = @selector(onSuccess:fromRequest:);
    if(delegate_ != nil && [delegate_ respondsToSelector:didSuccessSelector])
    {
        successData = [self handleSuccessResponseData:successData withType:[[self httpRequest] entityName]];
    
        [delegate_ performSelector:didSuccessSelector withObject:successData withObject:self];
    }
    
    SEL didFinishSelector = @selector(onFinish:fromRequest:);
    if (delegate_ && [delegate_ respondsToSelector:didFinishSelector]) {
        [delegate_ performSelector:didFinishSelector withObject:self];
    }
    
    [[ZHTaskManager sharedInstance] taskFinished:self];
}

// Override protocol ASIHTTPRequestDelegate
// Network error
- (void)requestFailed:(ASIHTTPRequest *)request {
    
//网络请求失败，记录网络请求失败的时间以及与网络请求开始的时间差，文件中有fail失败标记    
#ifdef ZHHTTPRECORDTIMELOG
    if(request.offsetLength != 0 && request.startTimeStr != nil)
    {
        NSString * time = [[ZHHttpRecordTime sharedInstance] getTime];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+110 andStr:time];
        NSString * diff = [[ZHHttpRecordTime sharedInstance] getTimeDifference:time andStartTime:request.startTimeStr];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+135 andStr:diff];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+144 andStr:@"fail"];
    }
    request.offsetLength = 0;
    request.startTimeStr = nil;
#endif
    
    
    SEL failedSelector = @selector(onFailed:fromRequest:);
    if (delegate_ && [delegate_ respondsToSelector:failedSelector]) {
        [delegate_ performSelector:failedSelector withObject:[request error] withObject:self];
    }
    
    SEL didFinishSelector = @selector(onFinish:fromRequest:);
    if (delegate_ && [delegate_ respondsToSelector:didFinishSelector]) {
        [delegate_ performSelector:didFinishSelector withObject:self];
    }
    
    [[ZHTaskManager sharedInstance] taskFailed:self];   
}

// Override protocol ASIProgressDelegate
- (void)setProgress:(float)newProgress {
    
    SEL progressSelector = @selector(onProgress:fromRequest:);
    
    if (delegate_ && [delegate_ respondsToSelector:progressSelector]) {
        [delegate_ onProgress:newProgress fromRequest:self];
    }
}

// Override protocol ASIProgressDelegate
// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    
//网络请求第一个字节返回，记录网络返回的时间以及与网络请求开始的时间差     
#ifdef ZHHTTPRECORDTIMELOG
    if(request.offsetLength != 0 && request.startTimeStr != nil)
    {
        NSString * time = [[ZHHttpRecordTime sharedInstance] getTime];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+75 andStr:time];
        NSString * diff = [[ZHHttpRecordTime sharedInstance] getTimeDifference:time andStartTime:request.startTimeStr];
        [[ZHHttpRecordTime sharedInstance] writeFile:request.offsetLength+100 andStr:diff];
    }
#endif
    
    
    if (delegate_ && [delegate_ respondsToSelector:@selector(didReceiveBytes:fromRequest:)]) {
        [delegate_ didReceiveBytes:bytes fromRequest:self];
    }
}

// Override protocol ASIProgressDelegate
// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes {
    if (delegate_ && [delegate_ respondsToSelector:@selector(didSendBytes:fromRequest:)]) {
        [delegate_ didSendBytes:bytes fromRequest:self];
    }
}

// Override protocol ASIProgressDelegate
// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength {
    if (delegate_ && [delegate_ respondsToSelector:@selector(incrementDownloadSizeBy:fromRequest:)]) {
        [delegate_ incrementDownloadSizeBy:newLength fromRequest:self];
    }
}

// Override protocol ASIProgressDelegate
// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength {
    if (delegate_ && [delegate_ respondsToSelector:@selector(incrementUploadSizeBy:fromRequest:)]) {
        [delegate_ incrementUploadSizeBy:newLength fromRequest:self];
    }
}

- (NSString *)baseUrl
{
    return kBaseUrl ;
}

- (NSDictionary*)parameters
{
    return params_;
}

@end

