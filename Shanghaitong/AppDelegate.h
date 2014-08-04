//
//  AppDelegate.h
//  Shanghaitong
//
//  Created by anita on 14-4-1.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHHttpTaskDelegate.h"
#import "WXApi.h"
#import "ABTabBarController.h"
#import "BaseViewController.h"

typedef enum {
    LogoutTypeNormal,
    LogoutTypeSingleUser
}logoutType;

#define SharedApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class StartPageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate,ZHHttpTaskDelegate,UITabBarControllerDelegate, UIAlertViewDelegate>{
    
	UINavigationController *navigationController;
}

@property (strong, nonatomic)   UIWindow *window;
@property (strong,nonatomic)    StartPageViewController * viewController;
@property (nonatomic,strong)   ABTabBarController *mainTabBarViewController;
@property (nonatomic,strong)    BaseViewController *baseViewController;
@property (nonatomic,assign)    BOOL        didLogined;
@property (nonatomic,assign)    BOOL        showProtocol;
@property (nonatomic,assign)    BOOL        isNetworkReachable;
@property (nonatomic,assign)    BOOL        protocol;
@property (nonatomic, assign)   BOOL        stayNotFirstPage; // 判断是不是在非一级界面，比如YES表示不在一级界面，NO表示在一级界面
@property (nonatomic, assign)   int         tarBarSelectIndex;
@property (nonatomic,assign)    BOOL        notReadAudio;
@property (nonatomic, assign)   BOOL        didNeedRefreshList; // 是否需要刷新一级界面列表数据
@property (nonatomic,strong) NSMutableArray *msgResultArray;
@property (nonatomic,assign) logoutType logoutType;
@property (nonatomic,assign) NSInteger touchBtnIndex;
- (void)showLoginViewController;
- (void)showWebController;
- (void)testASINotification;
- (void)logout;
- (void)alertToLogout;
- (int)networkStatus;
- (void)analyzeUpdate;
- (void)getUnreadMsg;
- (void)updateTabbarNotNewMsg;
- (void)updateTabbarNewMsg;
@end
