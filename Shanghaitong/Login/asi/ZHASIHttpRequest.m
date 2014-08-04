//
//  ZHASIHttpRequest.m
//  ZHIsland
//
//  Created by arthur on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHASIHttpRequest.h"
#import "JSONKit.h"
#import "ZHError.h"

#import "UserInformation.h"
#import "ASIFormDataRequest.h"

#import "areaItemInformation.h"
#import "demandItemInformation.h"
#import "indItemInformation.h"
#import "userItemInformation.h"


@implementation ZHASIHttpRequest{
    UserInformation * userInformation;
}
@synthesize entityName = _entityName;

// OVERRIDE

- (void) dealloc
{
//    [_ctx release];
    if(_entityName != nil)
    {
        [_entityName release];
    }
    if(_successData != nil)
    {
        [_successData release];
    }
    [super dealloc];
}

// this is the http thread, so put the deserialize operation here 
// without blocking main thread
- (void) requestFinished{
    
    NSString *responseString = [self responseString];

    id testDelegate = [self.delegate retain];
//    if ([testDelegate respondsToSelector:@selector(handleDataRecved)]) {
//        [testDelegate performSelector:@selector(handleDataRecved)];
//    }
    [testDelegate release];
    
    if(responseString == nil)
    {
        [super requestFinished];
        return;
    }
    
    @autoreleasepool {
        ZHError * rspError = [self hanldeResponseString:responseString];
        if(!rspError) {
            [super requestFinished];
        }else {
            [self failWithError:rspError];
        }
    }
}

-  (ZHError*)hanldeResponseString:(NSString *)rspStr{
    NSRange range= [rspStr rangeOfString:@"404 Not Found"];
    if (range.length > 0) {
        ZHError *error1 = [[ZHError alloc] init];
        error1.warningCode = 10003;
        return error1;
    }
   NSDictionary* res = (NSDictionary*)[rspStr objectFromJSONString];
   NSNumber* status = [res objectForKey:@"code"];
   if (status == nil) {
       status = [NSNumber numberWithInt:10003];
   }
   NSInteger statusCode = [status integerValue];
    
   ZHError *rspError = nil;
    
   if(statusCode > 0 ) {
        rspError = [ZHError errorWithDomain:[[res objectForKey:@"msg"] objectForKey:@"data"] code:statusCode warning:0 userInfo:nil];
    }
   else {
       
        id dataDic = [res objectForKey:@"msg"];
       _successData = [dataDic retain];
       userInformation= [UserInformation downloadDatadefaultManager];
       userInformation._userDataDict = [res copy];
       [UserInformation downloadDatadefaultManager]._userDataDict = [res copy];
       NSLog(@"userInformation._userDataDict  %@",userInformation._userDataDict);
       [self analysisData];

   }
       return rspError;

}

- (void)failWithError:(NSError *)theError
{
    [super failWithError:theError];
}

- (id)getSuccessData
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"-------------------   ");
    NSLog(@"Token 2 ===  %@",_successData);
    return _successData;
    NSLog(@"-------------------   ");

}

-(void)analysisData
{
     [[UserInformation downloadDatadefaultManager] analysisLoginFinshData];
}

@end

NSString *const ZHDeviceUnactivatedNotification = @"ZHDeviceUnactivatedNotification";
NSString *const ZHInvalidTokenNotification = @"ZHInvalidTokenNotification";
