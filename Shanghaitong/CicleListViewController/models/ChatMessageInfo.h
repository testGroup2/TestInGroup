//
//  ChatMessageInfo.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-1.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageInfo : NSObject
@property (nonatomic,strong) NSString *circleId;
@property (nonatomic,strong) NSString *circleThemeId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic) BOOL isMySelf;
@property (nonatomic,strong) NSString *nowDate;

@property (nonatomic,strong) NSString *userHeadImageUrl;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic, copy)  NSString *dataID;
@property (nonatomic) NSInteger msgId;
@property (nonatomic) BOOL isSuccess;
@property (nonatomic) BOOL isLoading;
@end
