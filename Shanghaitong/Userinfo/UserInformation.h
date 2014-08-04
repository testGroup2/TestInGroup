//
//  URL_ClASS.h
//  jushang
//
//  Created by Enger_sky on 14-3-8.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation: NSObject
{
    NSString *token_CurrentString;//用户登录获取的token
    NSDictionary *userDataDict;//存整体登录获取信息
    NSMutableArray *areaArray; //  地区
    NSMutableArray *demandArray;// 需求
    NSMutableArray *userArray;//用户信息
    NSMutableArray *indArray;//行业信息
    NSInteger code;
}

@property (nonatomic,retain) NSMutableString *_token_CurrentString;
@property (nonatomic,retain) NSDictionary *_userDataDict;
@property (nonatomic,retain) NSMutableArray *_areaArray;
@property (nonatomic,retain) NSMutableArray *_demandArray;
@property (nonatomic,retain) NSMutableArray *_userArray;
@property (nonatomic,retain) NSMutableArray *_indArray;
@property (nonatomic,assign) NSUInteger code;

+(UserInformation*)downloadDatadefaultManager;
-(void)analysisLoginFinshData;
//-(void)Prit;

@end
