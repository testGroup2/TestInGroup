//
//  ZHLoginRes.m
//  ZHIsland
//
//  Created by arthur on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHLoginRes.h"

static NSMutableDictionary * _ZHLoginResAttributes = nil;

@implementation ZHLoginRes

- (void)dealloc
{
    [_token release];
    [super dealloc];
}

+ (NSDictionary *)attributes
{
    return _ZHLoginResAttributes;
}

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ZHLoginResAttributes = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
        [_ZHLoginResAttributes addEntriesFromDictionary:[[self superclass] attributes]];
        [_ZHLoginResAttributes setObject:ZHDtoTypeString forKey:@"token"];
        NSLog(@"ZHDtoTypeString:%@",ZHDtoTypeString);
    });
}


@end
