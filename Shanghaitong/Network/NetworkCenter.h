//
//  NetworkCenter.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-5.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleDatabase.h"
@class ASIHTTPRequest;
#define NETWORK [NetworkCenter sharedDownload]


typedef NS_ENUM(NSInteger, SHTCircleCachePage){
    SHTCircleCachePageCircleThemeList,
    SHTCircleCachePageCircleDetail,
    SHTCircleCachePageCircleMember,
    SHTCircleCachePageCircleChat
};

typedef  void(^SHTNetworkCompletionHandler)(NSString *);
@interface NetworkCenter : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic,readonly) NSString *token;

+(NetworkCenter *)sharedDownload;

//登录
- (void)loginWithUserName:(NSString *)userName password:(NSString *)pass requestResult:(SHTNetworkCompletionHandler)aHandler;
//圈子列表
-(void)requestCircleListWithUptime:(NSString *)uptime requestResult:(SHTNetworkCompletionHandler)aHandler;
//圈子详情
- (void)requestCircleDetailWithid:(NSString *)detailId requestResult:(SHTNetworkCompletionHandler)aHandler;
//圈子创建圈子
- (void)requestCreateCircleWithCircleName:(NSString *)circleName circleDetail:(NSString *)circleDetail requestResult:(SHTNetworkCompletionHandler)aHandler;
//用户所在圈子列表（发布主题）
- (void)requestGetCircleListRequestResult:(SHTNetworkCompletionHandler)aHandler;
//进入圈子聊天
- (void)requestGetCircleMembersWithCircleID:(NSString *)circleId withIndex:(NSString *)index requestResult:(SHTNetworkCompletionHandler)aHandler;
//上传图片
- (void)requestUploadPicWithImageData:(NSData *)imageData RequestResult:(SHTNetworkCompletionHandler)aHandler;
//发布主题
- (void)requestContributeToCircleWithCircleId:(NSString *)circleId imageIdArray:(NSArray *)imageIdArray title:(NSString *)title simple:(NSString *)simpleDesc content:(NSString *)content requestResult:(SHTNetworkCompletionHandler)aHandler;
- (void)requestThemeListWithThemeId:(NSString *)circleId requestResult:(SHTNetworkCompletionHandler)aHandler;

//写圈子主题列表缓存数据
- (void)writeToDatabaseWithDownloadResult:(NSString *)responseString withPage:(SHTCircleCachePage)pageType isFirst:(BOOL)isFirst;
//读缓存主题列表数据
- (NSMutableArray *)readDatabase;
//读缓存主题详情数据
- (NSArray *)readCircleDetailDatabaseWithThemeId:(NSString *)themeId;
- (NSMutableArray *)readMemberListWithCircleId:(NSString *)circleId;
- (void)writeToDatabaseWithDownloadResult:(NSString *)responseString withCircleId:(NSString *)circleId;
//用户信息
- (void)requestUserInfoWithUserId:(NSString *)userId requestResult:(SHTNetworkCompletionHandler)aHandler;

- (void)getHotTagWithRequestResult:(SHTNetworkCompletionHandler)aHandler;
@end
