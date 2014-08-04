//
//  CircleAbstractInfo.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-2.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleAbstractInfo : NSObject
@property (nonatomic,strong) NSString *circleTopic;//主题title
@property (nonatomic,strong) NSString *adminId;
@property (nonatomic,strong) NSString *circleDetail;//详细content
@property (nonatomic,strong) NSString *circleName;//圈子名称 circl/name
@property (nonatomic,strong) NSString *circleID;//cid
@property (nonatomic,strong) NSString *circleDetailID;//id 进圈子详情使用
@property (nonatomic,strong) NSString *circleImage;//图片地址
@property (nonatomic,strong) NSString *circleAdminId;//圈主id
@property (nonatomic,strong) NSString *date;//生成时间
@property (nonatomic,strong) NSString *isRead;//是否已读
@property (nonatomic,strong) NSString *lastChat;//最后消息
@property (nonatomic,strong) NSString *lastChatUserName;
@property (nonatomic,strong) NSString *themeSimple;

@end
