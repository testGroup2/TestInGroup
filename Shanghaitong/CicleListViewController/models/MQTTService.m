 //
//  MQTTService.m
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "MQTTService.h"
#import "CircleDatabase.h"

#import "CicleListViewController.h"
#import "CircleAbstractInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "NewMessagePromptView.h"

#define kTopic @""
@interface  MQTTService()
@property (nonatomic,strong) NSString *chnnelID;
@end
MQTTService *service = nil;
@implementation MQTTService

+ (instancetype)shareServiceWithToken:(NSString *)token{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (service == nil) {
            service = [[self alloc]initWithToken:token];
        }
    });
    return service;
}
- (id)initWithToken:(NSString *)token{
    if (self = [super init]) {
        self.client = [[MQTTClient alloc] initWithClientId:token cleanSession:NO];
        [self.client connectToHost:kMQTTServerHost completionHandler:^(MQTTConnectionReturnCode code) {
            if (code == ConnectionAccepted) {
                NSLog(@"client is connected with id %@ md5 = %d", [self md5:token],[self md5:token].length);
                self.chnnelID = [[self md5:token] substringWithRange:NSMakeRange(8,16)];
                NSLog(@"chnnel----%@",self.chnnelID);
                [self.client subscribe:[NSString stringWithFormat:@"SHT/%@",self.chnnelID] withCompletionHandler:^(NSArray *grantedQos) {
                    NSLog(@"subscribed to topic %@--- grantedQos = %@", kTopic,grantedQos);
                }];
            }
            else{
                NSLog(@"连接MQTT失败");
            }
        }];
    }
    return self;
}
- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)stopService{
//    [self.client unsubscribe:[NSString stringWithFormat:@"SHT/%@",self.chnnelID] withCompletionHandler:nil];
}
-(void)startService:(BOOL)subcirce{
    [self.client setMessageHandler:^(MQTTMessage *message){
        NSLog(@"------%@--------",message.payloadString);        
        NSDictionary *dict = [[message payloadString] objectFromJSONString];
        NSInteger type = [[dict objectForKey:@"type"] integerValue];
        [DATABASE openDatabase];
        switch (type) {
            case PushMessageUpdateAvatar:
            {
                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"img_url"] forKey:kUserPortraitURL];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    [DATABASE updateChatRecordsWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] newUrl:[[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL]];
                });
            }
                break;
            case PushMessageCircleMumberDele:{
                NSString *circleId = [dict objectForKey:@"cid"];
                [DATABASE deleteCircleThemeListAllObjWithCircleId:circleId];
                if (SharedApp.mainTabBarViewController.tabBarItems.count > 0) {
                    CircleListViewController *circleController = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:0];
                    circleController.gloableUptime = @"0";
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gloable_uptime"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPushMessageCircleMumberDele" object:nil userInfo:nil];
                }
            }
                break;
            case PushMessageCircleUpdateCircleName:{
                NSLog(@"修改圈子标题");
                NSString *circleId = [dict objectForKey:@"cid"];
                NSString *title = [dict objectForKey:@"title"];
                [DATABASE updateCircleThemeListWithCircleId:circleId circleName:title];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeCircleName" object:nil userInfo:nil];
            }
            break;
            case PushMessageCircleCircleAddPeople:{
                NSLog(@"将本人加入到某圈子");
                NSString *circleId = [dict objectForKey:@"cid"];
                [NETWORK requestThemeListWithThemeId:circleId requestResult:^(NSString *response) {
                    if ([response isEqualToString:@"-1"]) {
                        return ;
                    }else if ([response isEqualToString:@"-2"]){
                        return ;
                    }
                    else{
                        NSDictionary *responseDict = [response objectFromJSONString];
                        NSMutableArray *resultArr = [NSMutableArray array];
                        if ([[responseDict objectForKey:@"status_code"] integerValue] == 0) {
                            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
                            NSArray *dataArray = [dataDict objectForKey:@"datas"];
                            for (int i = 0; i < [dataArray count]; i++) {
                                CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
                                NSDictionary *responseDict = [dataArray objectAtIndex:i];
                                info.circleTopic = [responseDict objectForKey:@"title"];
                                info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
                                info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
                                info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
                                info.circleImage = [responseDict objectForKey:@"cover_pic"];
                                info.adminId = [responseDict objectForKey:@"uid"];
                                info.themeSimple = [responseDict objectForKey:@"simple_desc"];
                                NSDictionary *lastDict = [responseDict objectForKey:@"last_chat"];
                                //lastChat
                                if ([[lastDict objectForKey:@"content_length"] integerValue] > 0) {
//                                    info.lastChat = [lastDict objectForKey:@"content"];
//                                    NSDictionary *userDict = [lastDict objectForKey:@"user"];
//                                    info.lastChatUserName = [userDict objectForKey:@"username"];
                                    info.isRead = @"1";
                                }
                                else{
                                    info.isRead = @"1";
                                }
                                //根据id删除原有的数据
                                if ([[responseDict objectForKey:@"uptime"] isEqualToString:@"0"]) {
                                    info.date = [responseDict objectForKey:@"ctime"];
                                }
                                else{
                                    info.date = [responseDict objectForKey:@"uptime"];
                                }
                                [resultArr addObject:info];
                            }
                            [DATABASE insertCircleThemeWithThemeInfo:resultArr];
                        }
                    }
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"kPushMessageCircleCircleAddPeople" object:nil userInfo:nil];
                }];
                
            }
                break;
            case PushMessageLogout:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SharedApp alertToLogout];
                });
            }
            break;
            case PushMessageDeleCircleTheme:{
                NSArray *themeIds = [dict objectForKey:@"id"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    for (int i =0; i <themeIds.count; i++) {
                        [DATABASE deleteCircleThemeListWithThemeId:[themeIds objectAtIndex:i]];
                    }
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kPushMessageDeleCircleTheme" object:nil];
            }
                break;
            case PushMessageRemoveRedpoint:{
               dispatch_async(dispatch_get_main_queue(), ^{
                   UIButton *msgButton = [SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:3];;
                   for (UIView *view in msgButton.subviews) {
                    if ([view isKindOfClass:[NewMessagePromptView class]]) {
                       [view removeFromSuperview];
                    }
                   }
               });
                
            }
                break;
            default:
                break;
        }
    }];

}


@end
