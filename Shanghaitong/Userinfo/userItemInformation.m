//
//  userItemInformation.m
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "userItemInformation.h"

@implementation userItemInformation
@synthesize avatar_url=_avatear_url;
@synthesize trust_num = _trust_num;
@synthesize userID=_userID;
@synthesize trusted_num = _trusted_num;
@synthesize username=_username;
@synthesize level=_level;
@synthesize area=_area;
@synthesize token=_token;
@synthesize duty=_duty;
@synthesize company=_company;
@synthesize score =_score;
@synthesize gold=_gold;

-(userItemInformation *)init
{
    if(self = [super init])
    {
        _avatear_url=[[NSMutableArray alloc] init];
        _username = [[NSString alloc]init];
        _level =[[NSString alloc]init];
//       _area=[[NSMutableArray alloc]init];
        _token=[[NSString alloc]init];
        _duty=[[NSString alloc]init];
        _company=[[NSString alloc]init];
        _trust_num=[[NSString alloc]init];
        _userID=[[NSString alloc]init];
        _gold=[[NSString alloc]init];
        _score=[[NSString alloc]init];
        _userID=[[NSString alloc]init];
    }
    return self;
}

@end
