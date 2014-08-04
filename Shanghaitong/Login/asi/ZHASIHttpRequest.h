//
//  ZHASIHttpRequest.h
//  ZHIsland
//
//  Created by arthur on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

#import "ASIHTTPRequest.h"
@class ZHError;

@interface ZHASIHttpRequest : ASIFormDataRequest{
    id _successData;
}

@property (nonatomic, copy) NSString *entityName;

- (id)getSuccessData;


-  (ZHError*)hanldeResponseString:(NSString*)rspStr;
@end

extern NSString *const ZHDeviceUnactivatedNotification;
extern NSString *const ZHInvalidTokenNotification; 
