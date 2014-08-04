//
//  NetworkCenter.m
//  Shanghaitong
//
//  Created by xuqiang on 14-5-5.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "NetworkCenter.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#import "CircleAbstractInfo.h"
#import "CircleDetailInfo.h"
#import "MemberInfo.h"

#import "NSData+AES256.h"
#define TIME_OUT 15
@interface  NetworkCenter ()<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSMutableData *resposeData;
@property (nonatomic) BOOL isNetworkReachable;
@property (nonatomic,strong) NSMutableData *mData;
@property (nonatomic,assign) SHTNetworkCompletionHandler bHndler;
@end

@implementation NetworkCenter
+(instancetype)sharedDownload{
    static NetworkCenter *interface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interface = [[self alloc]init];
    });
    return interface;
}
- (id)init{
    if (self = [super init]) {
        self.resposeData = [[NSMutableData alloc]init];
        self.mData = [[NSMutableData alloc]init];
    }
    return self;
}
- (NSString *)token{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
}
- (void)requestThemeListWithThemeId:(NSString *)circleId requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleTheme]]];
    [request setPostValue:circleId forKey:@"cid"];
    [request setPostValue:self.token forKey:@"token"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
    [request setFailedBlock:^{
        aHandler(@"-2");
    }];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)pass requestResult:(SHTNetworkCompletionHandler)aHandler
{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    self.bHndler = aHandler;
    static NSString *key = @"-aZSH,@C(g=Aky=I";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    [params setObject:userName forKey:@"username"];
    [params setObject:pass forKey:@"password"];
    
    NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", userName, pass];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_dt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAIN_URL,kLogin]]];
    NSLog(@"request.url.absoluteString == %@",request.url.absoluteString);
//    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:[[[data dataUsingEncoding:NSUTF8StringEncoding] AES256Encrypt:key] base64Encoding] forKey:@"t"];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
    [request setFailedBlock:^{
        aHandler(@"-2");
    }];
}

#pragma mark - write to database
- (void)writeToDatabaseWithDownloadResult:(NSString *)responseString withPage:(SHTCircleCachePage)pageType isFirst:(BOOL)isFirst
{
     if (pageType == SHTCircleCachePageCircleThemeList) {
        //写主题列表数据
        NSArray *responseArray = [[responseString objectFromJSONString] objectForKey:@"data"];
        if (isFirst) {
        }
        for (int i = 0; i < [responseArray count]; i++) {
            CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [responseArray objectAtIndex:i];
            info.circleTopic = [responseDict objectForKey:@"title"];
            info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info.circleDetail = [responseDict objectForKey:@"content"];
            info.circleImage = [responseDict objectForKey:@"cover_pic"];
            [DATABASE insertCircleThemeWithThemeInfo:info];
        }
    }
    if (pageType == SHTCircleCachePageCircleDetail) {
        //写主题详情
        NSDictionary * responseDict = [responseString objectFromJSONString];
        NSDictionary *dataDict = [responseDict objectForKey:@"data"];
        CircleDetailInfo *info = [[CircleDetailInfo alloc]init];
        info.circleDetailId = [dataDict objectForKey:@"id"];
        info.circleTitle = [dataDict objectForKey:@"title"];
        info.circleLeaderName = [[dataDict objectForKey:@"user"] objectForKey:@"username"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"ctime"] doubleValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        info.circleUpdateTime = [formatter stringFromDate:date];
        info.circleSmallImageArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [[dataDict objectForKey:@"pic"] count]; i++) {
            NSString *imageUrl = [[[dataDict objectForKey:@"pic"] objectAtIndex:i] objectForKey:@"url"];
            [info.circleSmallImageArray addObject:imageUrl];
        }
        info.circleNotice = [dataDict objectForKey:@"content"];
        
        [DATABASE insertCircleDetailWithInfo:info];
    }
}
- (void)writeToDatabaseWithDownloadResult:(NSString *)responseString withCircleId:(NSString *)circleId{
    
        NSDictionary *dictResponse = [[responseString objectFromJSONString] objectForKey:@"data"];
        if ([dictResponse objectForKey:@"page_is_first"]) {
            [DATABASE deleteMemberListWithCircleId:circleId];
        }
        NSDictionary *dict = [dictResponse objectForKey:@"datas"];
        NSArray *keyArr = [dict allKeys];
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < keyArr.count; i++) {
            [array addObject:[dict objectForKey:[keyArr objectAtIndex:i]]];
        }
//        NSMutableArray *array = [dictResponse objectForKey:@"datas"];
        for (int i = 0; i < array.count; i++) {
            MemberInfo *memberInfo = [[MemberInfo alloc]init];
            NSDictionary *userDict = [array objectAtIndex:i];
            memberInfo.circleId = [userDict objectForKey:@"cid"];
            NSDictionary *userInfoDict = [userDict objectForKey:@"user"];
            
            memberInfo.memberID = [[userInfoDict objectForKey:@"id"] stringValue];
            memberInfo.memberName = [userInfoDict objectForKey:@"username"];
            memberInfo.memberCredit = [[userInfoDict objectForKey:@"credit"] stringValue];
            memberInfo.memberPosition =[userInfoDict objectForKey:@"duty"];
            memberInfo.memberCompany = [userInfoDict objectForKey:@"company"];
            NSArray *urlArray = [userInfoDict objectForKey:@"avatar_url"];
            NSDictionary *userImageUrlDict = [urlArray objectAtIndex:0];
            memberInfo.memberHeadImageUrl = [userImageUrlDict objectForKey:@"url"];
//            if ([DATABASE fetchMemberListWithCircleId:memberInfo.memberID]) {
//                [DATABASE updateMemberListWithMemberInfo:memberInfo];
//            }
//            else{
                [DATABASE insertMemberListWithMemberInfo:memberInfo andCircleId:circleId];
//            }
        }
}
#pragma mark - read CircleThmeList database
- (NSMutableArray *)readDatabase
{
        return  [DATABASE fetchCircleTheme];
}
#pragma mark - readThemeDetail
- (NSArray *)readCircleDetailDatabaseWithThemeId:(NSString *)themeId{
    return [DATABASE fetchThemeDetailWithCircleDetailId:themeId];
}
#pragma mark - readMemberList
- (NSMutableArray *)readMemberListWithCircleId:(NSString *)circleId{
    return [DATABASE fetchMemberListWithCircleId:circleId];
}

#pragma mark - request get data
//请求圈子主题列表
-(void)requestCircleListWithUptime:(NSString *)uptime requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleList]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleList]);
    NSLog(@"%@",self.token);
    [request setPostValue:uptime forKey:@"uptime"];
    [request setPostValue:self.token forKey:@"token"];
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
    [request setFailedBlock:^{
        aHandler(@"-2");
    }];
}
//请求圈子详情
- (void)requestCircleDetailWithid:(NSString *)detailId requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleDetail]]];
    NSLog(@"%@",self.token);
    [request setTimeOutSeconds:TIME_OUT];
    [request setPostValue:detailId forKey:@"msg_id"];
    [request setPostValue:self.token forKey:@"token"];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
    
}
//请求创建圈子
- (void)requestCreateCircleWithCircleName:(NSString *)circleName circleDetail:(NSString *)circleDetail requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleCreate]]];
    [request setPostValue:circleName forKey:@"name"];
    [request setPostValue:circleDetail forKey:@"des"];
    [request setTimeOutSeconds:TIME_OUT];
    [request setPostValue:self.token forKey:@"token"];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
}
//用户所在圈子列表（发布主题）
- (void)requestGetCircleListRequestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kUserCircleList]]];
    [request setPostValue:self.token forKey:@"token"];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
}
//获取用户列表
- (void)requestGetCircleMembersWithCircleID:(NSString *)circleId withIndex:(NSString *)index requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCirckeMembers]]];
    [request setPostValue:self.token forKey:@"token"];
    [request setTimeOutSeconds:TIME_OUT];
    [request setPostValue:circleId forKey:@"cid"];
    [request setPostValue:index forKey:@"max_id"];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
    [request setFailedBlock:^{
        aHandler(@"-2");
    }];
}
//上传图片获取id
- (void)requestUploadPicWithImageData:(NSData *)imageData RequestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kUploadImage]]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/img.png",NSTemporaryDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:nil attributes:nil];
    }
    [imageData writeToFile:imagePath atomically:YES];
    [request addFile:imagePath forKey:@"circle_pic0"];
    [request setPostValue:self.token forKey:@"token"];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        NSLog(@"%@",weakRequest.responseString);
        aHandler(weakRequest.responseString);
    }];
}
//向圈子发主题
- (void)requestContributeToCircleWithCircleId:(NSString *)circleId imageIdArray:(NSArray *)imageIdArray title:(NSString *)title simple:(NSString *)simpleDesc content:(NSString *)content requestResult:(SHTNetworkCompletionHandler)aHandler
{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kContributeToCircle]]];
    [request setPostValue:self.token forKey:@"token"];
    [request setPostValue:circleId forKey:@"cid"];
    NSString *imageIdStr = [imageIdArray componentsJoinedByString:@","];
    [request setTimeOutSeconds:TIME_OUT];
    [request setPostValue:simpleDesc forKey:@"simple_desc"];
    [request setPostValue:imageIdStr forKey:@"album_id"];
    [request setPostValue:title forKey:@"title"];
    [request setPostValue:content forKey:@"content"];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];

}
//查用户信息
- (void)requestUserInfoWithUserId:(NSString *)userId requestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCatUserInfo]]];
    [request setPostValue:self.token forKey:@"token"];
    [request setPostValue:userId forKey:@"uid"];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    [request waitUntilFinished];
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];
}
- (void)getHotTagWithRequestResult:(SHTNetworkCompletionHandler)aHandler{
    if ([SharedApp networkStatus] == -1) {
        aHandler(@"-1");
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kHotTag]]];
    [request setPostValue:self.token forKey:@"token"];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    [request waitUntilFinished];
    __weak ASIFormDataRequest * weakRequest = request;
    [request setCompletionBlock:^{
        aHandler(weakRequest.responseString);
    }];

}
@end
