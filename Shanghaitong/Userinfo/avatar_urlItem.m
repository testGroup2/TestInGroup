//
//  avatar_urlItem.m
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "avatar_urlItem.h"

@implementation avatar_urlItem
@synthesize url=_url;
@synthesize small_url=_small_url;

-(avatar_urlItem *)init
{
    if(self = [super init])
    {
        _url =[[NSString alloc]init];
        _small_url=[[NSString alloc]init];
    }
    return self;
}
@end
