//
//  ZHError.m
//  ZHIsland
//
//  Created by arthuryan on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHError.h"
#include "AppDelegate.h"

@implementation ZHError 
    
@synthesize warningCode = warningCode_;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code warning:(NSInteger)warningCode userInfo:(NSDictionary *)dict {
    return [[[ZHError alloc] initWithDomain:domain code:code warning:warningCode userInfo:dict] autorelease];
}

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code warning:(NSInteger)warningCode  userInfo:(NSDictionary *)dict {    
    if((self = [super initWithDomain:domain code:code userInfo:dict]) != nil) {
        warningCode_ = warningCode;
    }
    return self;
}
@end
