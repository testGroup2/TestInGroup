//
//  ZHHttpLoginTask.m
//  ZHIsland
//
//  Created by arthuryan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHHttpLoginTask.h"
#import "ZHLoginRes.h"

@implementation ZHHttpLoginTask

-(id) initWithParams:(NSMutableDictionary*)params {
    
    self = [super initWithParams:params];
    [[self httpRequest] setEntityName:NSStringFromClass(ZHLoginRes.class)];
    
    return self;
}
- (void) execute {
    [self requestPost:params_ : nil];
}
- (NSString*) partureUrl
{
    return @"index.php/User/Public/login";
}

@end
