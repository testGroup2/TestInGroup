//
//  AppDelegate.m
//  Shanghaitong
//
//  Created by anita on 14-4-1.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "AppDelegate.h"
#import "SXLoginViewController.h"
#import "ZHAppProfile.h"
#import "SXConst.h"
#import "ZHOpenPlatformClient.h"
#import "ProjectSliderViewController.h"
#import "ABTabBar.h"
//引导页
#import "StartPageViewController.h"
#import "ABTabBarController.h"
#import "WebViewController.h"
#import "Audio.h"
#import "ShowPageViewController.h"
//wxshare
#import "WXApi.h"
//mqtt服务 接受推送
#import "MQTTKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "MQTTService.h"
//判断网络wifi/3G
#import "Reachability.h"

#import "UserInformation.h"
#import "userItemInformation.h"
#import "ShowProtocolViewController.h"
#import "NewMessagePromptView.h"

#import "HeartBeat.h"
#import "SocketCommunicate.h"
#import "ChatMessageInfo.h"
#import "ChatViewController.h"
#import "NewMessagePromptView.h"
#import "GTMBase64.h"
#import "CicleListViewController.h"
#import "CircleAbstractInfo.h"
@interface AppDelegate ()<ZHHttpTaskDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) MQTTService *service;
@property (nonatomic,assign) BOOL AcceptUnread;
@end
NSUncaughtExceptionHandler *_uncaughtExceptionHandler = nil;
@implementation AppDelegate
@synthesize window=_window;
@synthesize viewController=_viewController;
#pragma mark - UM
- (void)umengTrack{
    //正式   53c725ca56240baa7b04b0ce
    //测试   53c3372156240b95890e60c6
    [MobClick startWithAppkey:@"53c725ca56240baa7b04b0ce" reportPolicy:REALTIME channelId:nil];
    
}
void UncaughtExceptionHandler(NSException *excetion){
    NSLog(@"CRASH: %@",[excetion callStackSymbols]);
    //异常的堆栈信息
    NSArray *stackArray = [excetion callStackSymbols];
    
    //异常名称
    NSString *name = [excetion name];
    //异常原因
    NSString *resason = [excetion reason];
    NSString *syserror = [NSString stringWithFormat:@"mailto://495219869@qq.com?subject=bug报告&body=感谢您的配合!<br><br><br>""Error Detail:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                          name,resason,[stackArray componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[syserror stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    return;
}

#pragma  mark - Application
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (IOS_VERSION>=7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    [self umengTrack];
    
//    //保存处理异常的handler
//    _uncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
//    
//    //设置处理异常的Handler
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    
    self.msgResultArray = [NSMutableArray array];
    [WXApi registerApp:@"wxd35417163445703d"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMsg) name:@"kGetUnreadMsg" object:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"self.window : %@",self.window);
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.AcceptUnread = YES;
    
    //增加标识，用于判断是否是第一次启动应用...
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] == NO) { // 第一次启动
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UIStoryboard *startPage = [UIStoryboard storyboardWithName:@"StartPage" bundle:nil];
        StartPageViewController * spVC = [startPage instantiateViewControllerWithIdentifier:@"startPage"];
        self.window.rootViewController = spVC;
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] && [[NSUserDefaults standardUserDefaults] boolForKey:kAccessProtocal]) {
            [self showWebController];
        }else {
            [self showLoginViewController];
        }
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.window makeKeyAndVisible];
    
    //启动推送通知
    //registerForRemoteNotificationTypes  设定推送接受的类型
    /*
     UIRemoteNotificationTypeBadge   代表数字
     UIRemoteNotificationTypeSound   代表声音
     UIRemoteNotificationTypeAlert   代表内容
     */
    //one
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    //如果说启动成功  他会有一个提示框  然后用户会点确定和取消
    //这个提示框 是系统的，你无法不弹出
    //设置全局的样式
    [self customApperance];
    [self makeRedPoint];
    return YES;
}

- (void)makeRedPoint{
    if ([DATABASE fetchNotReadMessage] != 0) {
//        UIButton *msgButton = [SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:3];
//        NewMessagePromptView *newMsgView = [[NewMessagePromptView alloc] initWithFrame:CGRectMake(msgButton.frame.size.width-10-5, 5, 10, 10)];
//        [msgButton addSubview:newMsgView];
        [self updateTabbarNewMsg];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause 经· tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[HeartBeat sharedHeartBeat] stopHeartBeat];
    self.notReadAudio = NO;
    [self.msgResultArray removeAllObjects];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self clearNotificationPromptMessage];
    // 开启心跳
    [[HeartBeat sharedHeartBeat] startHeartBeat];
    // 获取未读消息
//    if (self.AcceptUnread) {
        [NSThread detachNewThreadSelector:@selector(getUnreadMsg) toTarget:self withObject:nil];
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序退出");
    [self.service stopService];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application{
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Private Method -

- (void)clearNotificationPromptMessage
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)getUnreadMsg
{
    // 获取离线消息
    SocketCommunicate *sComm = NULL;
    while (1) {
        if (!(sComm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:NO])) {
            [NSThread sleepForTimeInterval:5];
            continue;
        }
        break;
    }
    int16_t msg_type = 0x22;
    NSDictionary *hbDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] objectForKey:kUserID], kUserID, nil];
    char *data = NULL;
    int32_t msg_len;
    
    [sComm packSendMsg:msg_type msgDict:hbDict data:&data dataLen:&msg_len];
    if ([sComm send:data bufLen:msg_len] < 0) {
        NSLog(@"send unread msg failed.");
        if (data) {
            free(data);
            [sComm closeFD];
            return;
        }
    }
    int32_t total_len;
    int16_t msg_stat;
    
    uint32_t u32temp;
    uint16_t u16temp;
    
    read(sComm.sockfd, &total_len, sizeof(int32_t));
    u32temp = ntohl(total_len);
    
    read(sComm.sockfd, &msg_type, sizeof(int16_t));
    u16temp = ntohs(msg_type);
    
    [sComm recv:&msg_stat bufLen:sizeof(int16_t)];
    u16temp = ntohs(msg_stat);
    
    if (msg_stat == 0) {
        int32_t dataLen = u32temp - sizeof(int32_t) - sizeof(int16_t) - sizeof(int16_t);
        char *data = (char *)calloc(dataLen+1, sizeof(char));
        if (!data) {
            NSLog(@"can't alloc memory");
            return;
        }
        [sComm recv:data bufLen:dataLen];
        NSLog(@"unread msg data: %s", data);
        
        NSData *_data = [NSData dataWithBytes:data length:strlen(data)];
        NSError *error = nil;
        NSArray *messageArray = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"unread chatMsgDict: %@", messageArray);
        if (messageArray.count > 0) {
            [self performSelectorOnMainThread:@selector(updateTabbarNewMsg) withObject:nil waitUntilDone:YES];
            //存数据库
            if (!self.notReadAudio) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[Audio shareAudio] playAudio];
                });
            }
            self.notReadAudio = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kReciveUnreadMsgFinish" object:nil userInfo:nil];
            if (((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers.count == 2) {
                UIViewController *viewController = [((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:1];
                if ([viewController isKindOfClass:[ChatViewController class]]) {
                    ChatViewController *chatController = (ChatViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:1];
                    NSMutableArray *chatArray = [NSMutableArray array];
                    NSMutableArray *otherChat = [NSMutableArray array];
                    for (int i = 0; i < messageArray.count; i++) {
                        NSDictionary *newMsg = [messageArray objectAtIndex:i];
                        if ([chatController.circleThemeID isEqualToString:[newMsg objectForKey:@"topicID"]]) {
                            NSLog(@"[self.msgResultArray objectAtIndex:i]: %@", [messageArray objectAtIndex:i]);
                            [chatArray addObject:[messageArray objectAtIndex:i]];
                        }
                        else{
                            [otherChat addObject:newMsg];
                        }
                    }
                    CircleListViewController *list = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:0];
                    [list addNoti];
                    [chatController updateUnReadChatMsg:chatArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kGetThemeListOtherUnreadMsg" object:@{@"arr": otherChat}];
                }
                else{
                    CircleListViewController *list = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:0];
                    [list addNoti];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kGetThemeListUnreadMsg" object:@{@"arr": self.msgResultArray}];
                }
            }
            else{
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < messageArray.count; i++) {
                    ChatMessageInfo *info = [[ChatMessageInfo alloc] init];
                    NSDictionary *msgDict = [messageArray objectAtIndex:i];
                    info.content = [[NSString alloc] initWithData:[GTMBase64 decodeData:[[msgDict objectForKey:@"text"] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
                    info.circleThemeId = [msgDict objectForKey:@"topicID"];
                    info.timeStamp =  [NSString stringWithFormat:@"%@",[msgDict objectForKey:@"time"]];
                    info.isMySelf = NO;
                    info.nowDate = [AppTools getShortDateWithTimestamp:[NSString stringWithFormat:@"%@",[msgDict objectForKey:@"time"]]];
                    info.userId = [msgDict objectForKey:@"sendUserID"];
                    info.isSuccess = YES;
                    info.isLoading = NO;
                    
                    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCatUserInfo]]];
                    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
                    [request setPostValue:info.userId forKey:@"uid"];
                    [request setTimeOutSeconds:10];
                    [request startSynchronous];
                    NSDictionary *responseDict = [request.responseString objectFromJSONString];
                    NSDictionary *dataDict = [responseDict objectForKey:@"data"];
                    info.userName = [dataDict objectForKey:@"username"];
                    NSArray *imageArray = [dataDict objectForKey:@"avatar_url"];
                    if (imageArray.count > 0) {
                        info.userHeadImageUrl = [[imageArray objectAtIndex:0] objectForKey:@"small_url"];
                    }
                    [tempArr addObject:info];
                }
//                [DATABASE createChatRecords];
//                [DATABASE insertChatRecordsWithChatInfoArray:tempArr];  //这里有错
                CircleListViewController *list = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:0];
                list.notReadThemeArray = [[NSMutableArray alloc] init];
                [list addNoti];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kGetThemeListUnreadMsg" object:@{@"arr": messageArray,
                                                                                                        @"temp": tempArr}];
            }
            [self getUnreadMsg];
            if (data) {
                free(data);
                data = nil;
                [sComm closeFD];
            }
            return;
        }
        if (messageArray.count == 0) {
            
        }
//        if (messageArray.count > 0) {
////            [self updateTabbarNewMsg];
//            
//            [self performSelectorOnMainThread:@selector(updateTabbarNewMsg) withObject:nil waitUntilDone:YES];
//            //存数据库
//            if (!self.notReadAudio) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [[Audio shareAudio] playAudio];
//                });
//            }
//            self.notReadAudio = YES;
//            [self.msgResultArray addObjectsFromArray:messageArray];
//            if (data) {
//                free(data);
//                data = nil;
//                [sComm closeFD];
//            }
//               [self getUnreadMsg];
//        }
//        [self.msgResultArray removeAllObjects];
    }
}
- (void)analyzeUpdate{
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
//    ASIFormDataRequest *formRequst = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=841919073"]];
//    [formRequst startAsynchronous];
    ASIFormDataRequest *formRequst = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCheckUpdate]]];
    [formRequst setPostValue:[NSNumber numberWithInt:2] forKey:@"plat"];
    [formRequst setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
    [formRequst setPostValue:localVersion forKey:@"client_version"];
    [formRequst startAsynchronous];
    __weak ASIFormDataRequest *weakRequest = formRequst;
    [formRequst setCompletionBlock:^{
        NSLog(@"%@",weakRequest.responseString);
        NSDictionary *resultDic = [weakRequest.responseString objectFromJSONString];
        if ([[resultDic objectForKey:@"status_code"] intValue] != 0) {
            return ;
        }
        NSDictionary *dataDic = [resultDic objectForKey:@"data"];
        NSNumber *versionComp = [dataDic objectForKey:@"latest_version"];
        if ([versionComp intValue] == 0) {
            NSLog(@"需要更新");
            NSDictionary *versionInfo = [dataDic objectForKey:@"version_info"];
            [self performSelectorOnMainThread:@selector(alertToUpdate:) withObject:versionInfo waitUntilDone:YES];
        }
    }];
    [formRequst setFailedBlock:^{
        return ;
    }];
}

#pragma mark - ALERT logout
- (void)alertToLogout{
    self.notReadAudio = NO;
    self.AcceptUnread = NO;
    self.didLogined = NO;
    SharedApp.stayNotFirstPage = NO;
    [DATABASE openDatabase];
    [DATABASE removeAllTables];
    [[HeartBeat sharedHeartBeat] stopHeartBeat];
    [self.service stopService];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessProtocal];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gloable_uptime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserInformation downloadDatadefaultManager]._userDataDict = nil;
    [self.mainTabBarViewController.tabBarItems removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&uid=%@",DOMAIN_URL,DEVICE_TOKEN_DEL,[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken],[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]];
    ASIHTTPRequest *httpReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [httpReq start];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您的帐号在别的手机登录，请重新登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alv.tag = 100;
    [alv show];
}
- (void)alertToUpdate:(NSDictionary *)data{
    NSString *versionContent = [data objectForKey:@"content"];
    UIAlertView *updateAlv = [[UIAlertView alloc]initWithTitle:@"升级提醒" message:versionContent delegate:self cancelButtonTitle:@"暂不体验" otherButtonTitles:@"马上升级", nil];
    updateAlv.tag = 101;
    [updateAlv show];
}
#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        self.logoutType = LogoutTypeSingleUser;
        [self logout];
    }
    else if(alertView.tag == 101){
        if (buttonIndex == 0) {
            return;
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/shang-hai-tong/id841919073?l=zh&ls=1&mt=8"]];
        }
    }
}

#pragma mark - Control -

- (void)showLoginViewController
{
//    [[ZHAppProfile sharedInstance] clearAcessToken];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessAccount];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessPassword];
    if (name && pwd) {
//        [[ZHOpenPlatformClient sharedInstance] login:name password:pwd withDelegate:self];
        [NETWORK loginWithUserName:name password:pwd requestResult:^(NSString *response) {}];
        
    }else{
        self.window.rootViewController = [[SXLoginViewController alloc] init];
    }
}

- (void)showWebController
{
    //程序入口
    _mainTabBarViewController = [[ABTabBarController alloc] init];
    _mainTabBarViewController.tabBarHeight = 49;
    self.window.rootViewController = _mainTabBarViewController;
    // 发送心跳与服务器建立连接
    [[HeartBeat sharedHeartBeat] startHeartBeat];
    // 获取未读消息
    
    //应该在被顶来下之后再收离线消息
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.service = [MQTTService shareServiceWithToken:[AppTools getDeviceUuid]];
        [self.service startService:YES];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.AcceptUnread) {
            [self getUnreadMsg];
        }
    });
    
}

#pragma mark - Network -
- (int)networkStatus
{
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSString *ip = kReachbilityAdd;//@"115.29.137.228"
    struct sockaddr_in  serverAddr;
    memset(&serverAddr, 0, sizeof(struct sockaddr_in));
    serverAddr.sin_len = sizeof(serverAddr);
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = htons(inet_addr([ip UTF8String]));
    serverAddr.sin_port = htons(80);
    
    Reachability *r = [Reachability reachabilityWithAddress:&serverAddr];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            return -1;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            return 1;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            return 2;
            break;
    }
    return -1;
}

//注册监听网络状态
-(void)testASINotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkStatusChange:) name:kReachabilityChangedNotification object:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@",DOMAIN_URL];
    Reachability * reachability=[Reachability reachabilityWithHostName:urlString];
    [reachability startNotifier];
}
//通知回调函数
-(void)networkStatusChange:(NSNotification *)notify{
    Reachability * reachability= [notify object];
    NetworkStatus netstatus= [reachability currentReachabilityStatus];
    if(netstatus == NotReachable) {
        NSLog(@"notify 网络不可用");
        self.isNetworkReachable = NO;
    }else if (netstatus == kReachableViaWiFi) {
        NSLog(@"notify wifi ok");
        self.isNetworkReachable = YES;
    }else if (netstatus == kReachableViaWWAN){
        NSLog(@"notify 3G ok");
        self.isNetworkReachable = YES;
    }    
}

#pragma mark - APNS Notification -

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    NSLog(@"pToken:%@",pToken);
    NSLog(@"pToken.description: %@", pToken.description);
    NSArray *t1Token = [pToken.description componentsSeparatedByString:@" "];
    NSString *t1TokenString = [[NSString alloc] init];
    for (NSString *s in t1Token) {
        t1TokenString = [t1TokenString stringByAppendingString:s];
    }
    NSArray *t2Token = [t1TokenString componentsSeparatedByString:@"<"];
    NSString *t2TokenString = [t2Token lastObject];

    NSArray *t3Token = [t2TokenString componentsSeparatedByString:@">"];
    NSString *t3TokenString = [t3Token objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:t3TokenString forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *alert = [aps valueForKey:@"alert"];                   //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];    //badge数量
    NSString *sound = [aps valueForKey:@"sound"];                   //播放的声音
    NSLog(@"content: %@", alert);
    NSLog(@"badge: %d", badge);
    NSLog(@"sound: %@", sound);
    unsigned int pushMsgType = [[aps valueForKey:@"type"] integerValue];
    if (pushMsgType > PushMessagePushOfflineMsg) {
        //1.7版本超出错误处理
        return;
    }
    if (pushMsgType == PushMessagePushOfflineMsg) { // 这是聊天未读消息
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            return;
//        }else{
        self.tarBarSelectIndex = ButtonIndexCircle;
        [_mainTabBarViewController.tabBar tabTouchUpInside:[_mainTabBarViewController.tabBar.buttonArray objectAtIndex:ButtonIndexCircle]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kGetPushMsgNoti" object:nil];
            return;
//        }
    }
    [self clearNotificationPromptMessage];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UIButton *msgButton = [_mainTabBarViewController.tabBar.buttonArray objectAtIndex:ButtonIndexMy];
        NewMessagePromptView *newMsgView = [[NewMessagePromptView alloc] initWithFrame:CGRectMake(msgButton.frame.size.width-10-10, 5, 10, 10)];
        [msgButton addSubview:newMsgView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Myself" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Myself" object:nil];
        ShowPageViewController *showPageVC = [[ShowPageViewController alloc]init];
        showPageVC.urlString = [NSString stringWithFormat:@"%@index.php/User/AboutMe/lists.html",DOMAIN_URL];
        [SharedApp.mainTabBarViewController presentViewController:showPageVC animated:YES completion:nil];
    }
    switch (pushMsgType) {
        case PushMessageProject:
            
            break;
        case PushMessageInfo:
            
            break;
        case PushMessageInterest:
            
            break;
        case PushMessageSystem:
            
            break;
        case PushMessageDiscussProject:
            
            break;
        case PushMessageVisitorProjectInterest:
            
            break;
        case PushMessageIntermediary:
            
            break;
        case PushMessageResourceInterest:
            
            break;
        case PushMessageCircleNotification:
            
            break;
        case PushMessagePrivateLetter:
            
            break;
        case PushMessageTrustMe:
            
            break;
        case PushMessagePublishSubject:
            
            break;
        case PushMessageInviteCircle:
            break;
        case PushMessageRemoveCircle:
            
            break;
        case PushMessageProjectCheckNotification:
            
            break;
        case PushMessageProjectCooperation:
            
            break;
        case PushMessageSubjectCheckPass:
            
            break;
        case  PushMessageProjectOffline:
            break;
        default:
            break;
    }
    
}

- (void)packageAndSaveDatabaseWith:(NSDictionary *)lastChatInfo circleId:(NSString *)circleId themeId:(NSString *)themeId{
    ChatMessageInfo *msg = [[ChatMessageInfo alloc]init];
    msg.circleId = circleId;
    msg.circleThemeId = themeId;
    msg.content = [lastChatInfo objectForKey:@"content"];
    msg.timeStamp = [lastChatInfo objectForKey:@"ctime"] ;
    if ([[[lastChatInfo objectForKey:@"uid"] stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
        msg.isMySelf = YES;
    }
    else{
        msg.isMySelf = NO;
    }
    
    msg.nowDate = [self makeDateWithTimeStamp:[lastChatInfo objectForKey:@"ctime"]];
    NSDictionary *userDict = [lastChatInfo objectForKey:@"user"];
    msg.userId = [[userDict objectForKey:@"id"] stringValue];
    msg.userName = [userDict objectForKey:@"username"];
    msg.userHeadImageUrl = [[[userDict objectForKey:@"avatar_url"] firstObject] objectForKey:@"url"];
    msg.isSuccess = YES;
    msg.isLoading = NO;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:msg, nil];
    [DATABASE createChatRecords];
    [DATABASE insertChatRecordsWithChatInfoArray:arr];
}

- (NSString *)makeDateWithTimeStamp:(NSString *)timeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * currentTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]]];
    return currentTime;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error);
}

#pragma mark - ZHHttpTaskDelegate -

//跳转到界面
- (void)onSuccess:(id) content fromRequest:(ZHHttpBaseTask *)task
{
    [self.baseViewController hideProgress:YES];
    [self showWebController];
}

- (void)onFailed:(NSError*)error fromRequest:(ZHHttpBaseTask *)task
{
    self.window.rootViewController = [[SXLoginViewController alloc] init] ;
}

#pragma mark - logout -
- (void)logout
{
    self.notReadAudio = NO;
    self.didLogined = NO;
    SharedApp.stayNotFirstPage = NO;
    [DATABASE openDatabase];
    [DATABASE removeAllTables];//移除主题详情列表，和圈子成员表
    
    [[HeartBeat sharedHeartBeat] stopHeartBeat];
    [self.service stopService];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessProtocal];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gloable_uptime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNickName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPortraitURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UserInformation downloadDatadefaultManager]._userDataDict = nil;
    [self.mainTabBarViewController.tabBarItems removeAllObjects];
    [self showLoginViewController];
    
    //发一个http请求到服务器，删除device_token
     NSString *target = [[self md5:[AppTools getDeviceUuid]] substringWithRange:NSMakeRange(8, 16)];
    if (self.logoutType == LogoutTypeSingleUser) {
    }
    else{
        NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,DEVICE_TOKEN_DEL];
        ASIFormDataRequest *httpReq = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        [httpReq setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"uid"];
        [httpReq setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
        [httpReq setPostValue:target forKey:@"target"];
        [httpReq startAsynchronous];
    }
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserID];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
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
#pragma mark - customApperance
- (void)customApperance{
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
#pragma mark - UI -

- (void)updateChatListNewMsgViewWithMsg:(ChatMessageInfo *)chatMsg
{
    ChatViewController *chatController = (ChatViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:3]).viewController).viewControllers objectAtIndex:1];
    [chatController updateChatlIistWithMsg:chatMsg];
}

- (void)updateTabbarNewMsg
{
    //优化
    BOOL hasSubViews = NO;
    if (SharedApp.mainTabBarViewController.tabBar.buttonArray.count > 0) {
    UIButton *msgButton = [SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:2];
    for (UIView *subView in msgButton.subviews) {
        if ([subView isKindOfClass:[NewMessagePromptView class]]) {
            hasSubViews = YES;
            break;
        }
    }
    if (!hasSubViews) {
        NewMessagePromptView *newMsgView = [[NewMessagePromptView alloc] initWithFrame:CGRectMake(msgButton.frame.size.width-10-5, 5, 10, 10)];
        [msgButton addSubview:newMsgView];
    }
    }
}

- (void)updateTopicCellNewMsgView:(ChatMessageInfo *)chatMsg
{
    CircleListViewController *list = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:3]).viewController).viewControllers objectAtIndex:0];
    [list updateTopicListWithMsg:chatMsg];
}

- (void)updateTabbarNotNewMsg{
    UIButton *msgButton = [SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:2];
    for (UIView *v in msgButton.subviews) {
        [v removeFromSuperview];
    }
}
@end
