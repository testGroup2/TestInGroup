//
//  BaseViewController.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-29.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "RootViewController.h"
#import "MBProgressHUD.h"
#import "ZHAlertView.h"

@interface RootViewController ()<ZHAlertViewDelegate,GuidBtnDelegate>
@property (nonatomic,strong) MBProgressHUD *progressView;
@property (nonatomic,strong) ZHAlertView *alertView;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.networkActivity= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.networkActivity];
    [self.view bringSubviewToFront:self.networkActivity];
    CGFloat originY;
    if (IOS_VERSION >= 7.0) {
        originY = [UIScreen mainScreen].bounds.size.height-kGuidBtnSide-5;
    }
    else{
        originY = [UIScreen mainScreen].bounds.size.height-kGuidBtnSide-5 - 20;
    }
    
    self.guidButton = [[[NSBundle mainBundle] loadNibNamed:@"GuidBtn" owner:self options:nil] lastObject];
    self.guidButton.frame = CGRectMake(5, originY, kGuidBtnSide, kGuidBtnSide);
    self.guidButton.layer.cornerRadius = 4.0f;
    self.guidButton.delegate = self;
    [self.view addSubview:self.guidButton];
    if (IOS_VERSION >= 7.0) {
        self.tabBar = [[ABTabBar alloc] initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }else{
        
        self.tabBar = [[ABTabBar alloc]initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }
    self.tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    [self.tabBar createTabs];
    self.tabBar.hidden = YES;
}
- (void)popCurrentViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)guidBttonAction{
    [MobClick event:@"guidBtn"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customMakeNavigationBarHasLeftButton:(BOOL)hasLeft withHasRightButton:(BOOL)hasRight
{
    self.navigationController.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    if (IOS_VERSION >= 7.0) {
        self.navigationView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, 320, 64) withHasLeft:hasLeft withHasRight:hasRight];
        self.contentFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 -TabBarViewHeight);
        self.rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        self.navigationView = [[NaviView alloc] initWithFrame:CGRectMake(0, 0, 320, 44) withHasLeft:hasLeft withHasRight:hasRight];
        self.contentFrame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44  -TabBarViewHeight);//TabBarViewHeight
        self.rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.navigationView.delegate = self;
    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar.png"]];
    [self.view addSubview:self.navigationView];
}
- (void)leftButtonClick{
    
}
- (void)rightButtonClick{
    
}
#pragma mark - alertMessage

- (BOOL)getErrorCodeWithJsonValue:(NSString *)testStr{
    NSDictionary *testDict = [testStr objectFromJSONString];
    ErrorMessageItem *errorItem = [[ErrorMessageItem alloc]init];
    errorItem.errorCode = [testDict[SHTError_Code] stringValue];
    if ([errorItem.errorCode isEqualToString:@"0"]) {
        errorItem.errorMessage = testDict[SHTError_desc];
        return NO;
    }
    else{
        [self showErrorMessage:errorItem.errorMessage];
        return YES;
    }
}
- (void)showErrorMessage:(NSString *)errorStr
{
    [self showNetworkErrorMessage:errorStr];
}

- (void)showNetworkErrorMessage:(NSString *)message{
     self.p= [[PopupSmallView alloc] initWithFrame:CGRectMake(85,self.view.frame.size.height - 88,150, 30) withMessage:message];
    self.p.layer.cornerRadius = 3;
    self.p.layer.masksToBounds = YES;
    [self.view addSubview:self.p];
    [self.view bringSubviewToFront:self.p];
}
- (void)showNetworkAnimation{
    
    [self.view addSubview:self.networkActivity];
    self.networkActivity.hidden = NO;
    self.networkActivity.center = CGPointMake(kScreenWidth / 2 - .5 * self.networkActivity.frame.size.width/2, self.contentFrame.size.height/2 + .5 * self.networkActivity.frame.size.height/2 + ORIGIN_Y);
    
    [self.networkActivity startAnimating];
    
}
- (void)hiddenNetworkAnimation{
    self.networkActivity.hidden = YES;
    [self.networkActivity removeFromSuperview];
}


@end
