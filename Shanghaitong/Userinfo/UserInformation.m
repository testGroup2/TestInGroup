//
//  URL_ClASS.m
//  jushang
//
//  Created by Enger_sky on 14-3-8.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "UserInformation.h"
#import "areaItemInformation.h"
#import "demandItemInformation.h"
#import "indItemInformation.h"
#import "userItemInformation.h"
#import "avatar_urlItem.h"
#import "ZHAppProfile.h"//应用程序概要文件
#import "CircleDatabase.h"

@implementation UserInformation
@synthesize _token_CurrentString;
@synthesize _userDataDict;
@synthesize _areaArray;
@synthesize _demandArray;
@synthesize _indArray;
@synthesize _userArray;
@synthesize code=_code;


+(UserInformation*)downloadDatadefaultManager
{
    static   UserInformation *_user= nil;
    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
        _user = [[self alloc] init];
//    });
    return _user;
}

-(UserInformation*)init
{
    if(self = [super init])
    {
        _token_CurrentString =[[NSMutableString alloc] initWithCapacity:0];
        _userDataDict =[[NSDictionary alloc]init];
        _userArray=[[NSMutableArray alloc]init];
        _demandArray=[[NSMutableArray alloc]init];
        _indArray =[[NSMutableArray alloc]init];
        _areaArray=[[NSMutableArray alloc]init];
        
        
    }
    return self;
}

-(void)analysisLoginFinshData
{
    if(!_userDataDict)
        return ;
    
    if ([_userArray count] > 0) {
        [_userArray removeAllObjects];
    }
    
    NSLog(@"_userDataDict: %@", _userDataDict);
    code = [[userDataDict objectForKey:@"code"] integerValue];
    NSDictionary *msgDict=[_userDataDict objectForKey:@"msg"];
    
    NSArray *array1=[msgDict objectForKey:@"area"];
    if ([msgDict objectForKey:@"area"]) {
        if (array1.count > 0) {
            for(NSDictionary * dict1 in array1)
            {
                areaItemInformation *areaItem=[[areaItemInformation alloc] init];
                areaItem.title=[dict1 objectForKey:@"title"];
                areaItem.area_id=[dict1 objectForKey:@"area_id"];
                [_areaArray addObject:areaItem];
                [areaItem release];
            }
        }

    }
    
    NSArray *demands=[msgDict objectForKey:@"demand"];
    if (demands.count > 0) {
        for(NSDictionary *dict1 in demands)
        {
            demandItemInformation *demandItem=[[demandItemInformation alloc] init];
            demandItem.demandID=[dict1 objectForKey:@"id"];
            demandItem.des=[dict1 objectForKey:@"des"];
            [_demandArray addObject:demandItem];
            [demandItem release];
        }
    }
    
    NSArray *array3=[msgDict objectForKey:@"ind"];
    if (array3.count > 0) {
        for(NSDictionary *dict1 in array3)
        {
            indItemInformation *indItem=[[indItemInformation alloc] init];
            indItem.indID=[dict1 objectForKey:@"id"];
            
            indItem.name=[dict1 objectForKey:@"name"];
            [_indArray addObject:indItem];
            [indItem release];
        }
    }
    NSArray * array4 = [msgDict objectForKey:@"user"];
    NSLog(@"arr4 is %d",array4.count);
    
    NSDictionary *dict1=[msgDict objectForKey:@"user"];
    userItemInformation *userItem=[[userItemInformation alloc] init];
    userItem.trust_num=[dict1 objectForKey:@"trust_num"];
    userItem.trusted_num=[dict1 objectForKey:@"trusted_num"];
    userItem.userID=[dict1 objectForKey:@"id"];

    NSArray *array5 =[dict1 objectForKey:@"avatar_url"];
    if (array5.count > 0) {
        for(NSDictionary *dict1 in array5)
        {
            avatar_urlItem *ava=[[avatar_urlItem alloc]init];
            ava.url=[dict1 objectForKey:@"url"];
            ava.small_url=[dict1 objectForKey:@"small_url"];
            [userItem.avatar_url addObject:ava];
            [ava release];
        }
    }
    
    userItem.username=[dict1  objectForKey:@"username"];
    userItem.level = [dict1 objectForKey:@"level"];
    userItem.token =[dict1 objectForKey:@"token"];
    userItem.duty =[dict1 objectForKey:@"duty"];
    userItem.company=[dict1 objectForKey:@"company"];
    userItem.score=[dict1 objectForKey:@"score"];
    userItem.gold=[dict1 objectForKey:@"gold"];
    
    userItem.protocol = ([[dict1 objectForKey:@"protocol"] integerValue]) == 0 ? NO : YES;
    SharedApp.protocol = userItem.protocol;
    [_userArray addObject:userItem];
    
    [[NSUserDefaults standardUserDefaults] setObject:userItem.userID forKey:kUserID];
    if (userItem.avatar_url.count > 0) {
        avatar_urlItem *avatar = [userItem.avatar_url objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:avatar.url forKey:kUserPortraitURL];
    }
    [[NSUserDefaults standardUserDefaults] setBool:SharedApp.protocol forKey:kAccessProtocal];
    [[NSUserDefaults standardUserDefaults] setObject:userItem.token forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:userItem.username forKey:kUserNickName];
    [[NSUserDefaults standardUserDefaults] setObject:[[array5 lastObject] objectForKey:@"small_url"] forKey:kUserPortraitURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *areaFilePath = [[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectAreaFileName];
    NSString *indFilePath = [[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectIndFileName];
    
    NSString *demandFilePath = [[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectDemandFileName];
    [[NSKeyedArchiver archivedDataWithRootObject:_areaArray] writeToFile:areaFilePath atomically:YES];
    [[NSKeyedArchiver archivedDataWithRootObject:_indArray] writeToFile:indFilePath atomically:YES];
    [[NSKeyedArchiver archivedDataWithRootObject:_demandArray] writeToFile:demandFilePath atomically:YES];
}

@end
