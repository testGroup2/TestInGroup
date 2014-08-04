//
//  ZHRegisterDeviceTokenTask.m
//  ZHIsland
//
//  Created by hu jianping on 12-7-26.
//  Copyright (c) 2012年 www.zhisland.com. All rights reserved.
//

#import "ZHRegisterDeviceTokenTask.h"

@implementation ZHRegisterDeviceTokenTask

-(id) initWithParams:(NSMutableDictionary*)params {
    
    self = [super initWithParams:params];
    
    return self;
}

- (void) execute {
    [self requestPost:params_ : nil];
}

- (NSString*) partureUrl {
   return @"index.php/User/Public/login";
}

- (id) handleSuccessResponseData:(id)data withType:(NSString *)entityName
{
    return nil;
}

@end
