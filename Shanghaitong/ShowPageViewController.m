//
//  ShowPageViewController.m
//  商海通
//
//  Created by Liv on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//
#import "ShowPageViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "ZHAppProfile.h"//应用程序概要文件
#import "ASIFormDataRequest.h"
#import "avatar_urlItem.h"
#import "ABTabBarController.h"
#import "ShowUserViewController.h"
#import "MyViewController.h"
#import "MViewController.h"
#import "RViewController.h"
#import "CicleListViewController.h"
#import "PViewController.h"
#import "CircleDatabase.h"
@interface ShowPageViewController ()<UIWebViewDelegate,WXApiDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) NSString * customUserAgent;
@property (nonatomic) enum WXScene scene;
@property (nonatomic,strong) UIButton *guideTabBarBtn;
@property (strong, nonatomic)   UIWebView *webView;
@property (assign, nonatomic)   BOOL    needRefresh;
@property (assign, nonatomic)   BOOL    needDismiss;
@property (assign, nonatomic)   BOOL    needGoBack;
@property (nonatomic, strong)   ABTabBar       *tabBar;

@end

@implementation ShowPageViewController

-(NSString *) getStringWithURLString : (NSString *) urlString
                         startString :(NSString *) startString
                           endString :(NSString *) endString
{
    NSString *webString=urlString;
    NSString *pageStart = startString;
    NSString *pageEnd = endString;
    int startOffset=[webString rangeOfString:pageStart].location + pageStart.length;
    int endOffset=[webString rangeOfString:pageEnd].location;
    if ([pageEnd isEqualToString:webString]) {
        endOffset = webString.length;
    }
    //截取substring
    NSString *partialString = nil;
    if (startOffset >= 0 && endOffset >= 0) {
        partialString=[webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
    }
    return partialString;
}

-(NSURLRequest *)makeRequestWithURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"secondWeb" label:self.urlString];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"secondWeb" label:self.urlString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    SharedApp.stayNotFirstPage = YES;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.userInteractionEnabled = YES;

    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.webView.frame = CGRectMake(0, 20, 320, 548);

        }else{
            self.webView.frame = CGRectMake(0, 0, 320, 548+20);
        }
    }else {
        if (IOS_VERSION >= 7.0) {
            self.webView.frame = CGRectMake(0, 20, 320, 460);
        }else{
            self.webView.frame = CGRectMake(0, 0, 320, 460);
        }
    }
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(110, 150, 100, 100)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.webView loadRequest:request];
    });
    
    UIImage *image = [UIImage imageNamed:@"showTabBarButton"];
    self.guideTabBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, [UIScreen mainScreen].bounds.size.height-kGuidBtnSide-5, kGuidBtnSide, kGuidBtnSide)];
    [self.guideTabBarBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.guideTabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.guideTabBarBtn addTarget:self action:@selector(pressedShowGuideTabBarBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guideTabBarBtn];

    if (IOS_VERSION >= 7.0) {
        _tabBar = [[ABTabBar alloc] initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }else{
        
        _tabBar = [[ABTabBar alloc]initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }
    _tabBar.delegate = SharedApp.mainTabBarViewController;
    [self.view addSubview:_tabBar];
    [_tabBar createTabs];
    _tabBar.hidden = YES;
    
    UITapGestureRecognizer *hideTabBarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHideTabBarTap)];
    hideTabBarTap.delegate = self;
    [self.webView addGestureRecognizer:hideTabBarTap];
    UIView *pitchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, STATUS_HEIGHT)];
    pitchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar.png"]];
    [self.view addSubview:pitchView];
}
#pragma mark - HiddenButton & appear
- (void)hiddenButton{
    self.guideTabBarBtn.hidden = YES;
    if (IOS_VERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
- (void)apearButton{
    self.guideTabBarBtn.hidden = NO;
}

#pragma mark - UIWebView Delegate -
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange telRange = [request.URL.absoluteString rangeOfString:@"tel:"];
    if (telRange.location == NSNotFound) {
    }
    else{
        return YES;
    }
    NSString *goBackProject = @"shangxin://goback?tag=0";
    NSString *goBackResource = @"shangxin://goback?tag=1";
    NSString *goBackMessage = @"shangxin://goback?tag=2";
    NSString *goBackCircle = @"shangxin://goback?tag=3";
    NSString *goBackMe = @"shangxin://goback?tag=4";
    if ([request.URL.relativeString rangeOfString:goBackProject].length != 0) {
        
    }else if ([request.URL.relativeString rangeOfString:goBackResource].length != 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPage_Myself" object:nil];
        
    }else if ([request.URL.relativeString rangeOfString:goBackMessage].length != 0) {
        
    }else if ([request.URL.relativeString rangeOfString:goBackCircle].length != 0) {
        
    }else if ([request.URL.relativeString rangeOfString:goBackMe].length != 0) {
        
    }else{
    
    if ([SharedApp networkStatus] == -1) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width/2-150/2, self.webView.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        return NO;
    }
    }
    NSLog(@"%@---%@",request.URL.absoluteString,request.URL.relativeString);
    //上传了图片
    if ([request.URL.absoluteString rangeOfString:@"shangxin://goback?tag=1&refresh=true&imgurl="].location != NSNotFound) {
        NSArray *arr = [request.URL.absoluteString componentsSeparatedByString:@"imgurl="];
        
        [[NSUserDefaults standardUserDefaults] setObject:[arr objectAtIndex:1] forKey:kUserPortraitURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [DATABASE updateChatRecordsWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] newUrl:[[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL]];
        });
        //提交刷新头像的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeUserHead" object:nil];
    }
    if ([request.URL.absoluteString isEqualToString:@"objc://hiddenButton"]) {
        NSArray *array = [request.URL.absoluteString componentsSeparatedByString:@"://"];
        NSString *str = [array objectAtIndex:0];
        if ([str isEqualToString:@"objc"]) {
            NSString *funcStr = [array objectAtIndex:1];
            SEL sel = NSSelectorFromString(funcStr);
            [self performSelector:sel];
        }
    }
    else if ([request.URL.absoluteString isEqualToString:@"objc://apearButton"]){
        NSArray *array = [request.URL.absoluteString componentsSeparatedByString:@"://"];
        NSString *str = [array objectAtIndex:0];
        if ([str isEqualToString:@"objc"]) {
            NSString *funcStr = [array objectAtIndex:1];
            SEL sel = NSSelectorFromString(funcStr);
            [self performSelector:sel];
        }
    }
    NSLog(@" 13145201111url string is %@",request.URL.relativeString);
    NSLog(@" self.webview url string is %@",self.webView.request.URL.relativeString);
    //do_add_pro.html
    NSRange do_add_pro_range = [request.URL.relativeString rangeOfString:@"add_pro"];
    if (do_add_pro_range.length != 0 ) {
        [self resignFirstResponder];
    }
    
    NSString *welfare_detail = @"index.php/Welfare/Index/welfare_detail";
    if ([request.URL.relativeString rangeOfString:welfare_detail].length != 0) {
        _needGoBack = YES;
    }
    
    //返回
    NSString *delprevString = @"del=prev";
    NSRange delprevRange = [request.URL.relativeString rangeOfString:delprevString];
    
    if (delprevRange.length !=0) {
        if (!_needGoBack) {
            _needDismiss = YES;
        }
    }
    
    //解决返回刷新问题
    //User/Index/my_user_list/type/trust self.webview
    //Index/user_show/id/
    if ([request.URL.relativeString rangeOfString:@"User/Index/user_show/id"].length != 0 && [self.webView.request.URL.relativeString rangeOfString:@"User/Index/my_user_list/"].length != 0) {
        ShowUserViewController *userPageVC = [[ShowUserViewController alloc] init];
        userPageVC.urlString = request.URL.relativeString;
        [self presentViewController:userPageVC animated:YES completion:nil];
                
        return NO;
    }
    
//    // 屏蔽空白页面
//    NSRange blankurl = [request.URL.relativeString rangeOfString:@"url=false"];
//    if (blankurl.length != 0) {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:self.webView.request.URL]];
//        return NO;
//    }

    //定义UA
    if (self.customUserAgent == nil) {
        NSString * userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        [self setCustomUserAgent:[NSString stringWithFormat:@"%@ %@", userAgent, @"shangxin"]];
        NSLog(@"userAgent : %@",self.customUserAgent);
    }


    //捕捉注销
    NSString *logoutString = @"shangxin://logout";
    NSString *goHomeString = @"shangxin://gohome?tag=0";
    NSString *tougaoString = @"index.php/Circle/Index/do_add_msg.html";
    NSLog(@"request.URL.relativeString: %@", request.URL.relativeString);
    NSLog(@"self.webView.request.URL.relativeString: %@", self.webView.request.URL.relativeString);
    if ([request.URL.relativeString rangeOfString:goHomeString].length!=0 && [self.webView.request.URL.relativeString rangeOfString:tougaoString].length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        
        SharedApp.stayNotFirstPage = NO;
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
    }
    
    NSRange logoutStr = [request.URL.relativeString rangeOfString:logoutString];
    NSString *path = [request.URL.relativeString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(logoutStr.length!=0 && [request.URL.relativeString rangeOfString:@"msg="].length != 0){ // 修改密码
        NSString *msg = [self getStringWithURLString:path startString:@"msg=" endString:path];
        NSLog(@"msg string is %@",path);
        NSRange cancleRange = [path rangeOfString:@"cancel=false"];
        if (cancleRange.length != 0) {
            UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    if([self.webView.request.URL.relativeString rangeOfString:@"User/Index/user_set"].length != 0 &&logoutStr.length != 0){ // 注销
        UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:nil message:@"您将退出到登陆页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        
    }
    
    //直接退出
    if ([request.URL.relativeString rangeOfString:@"shangxin://logout?alert=false"].length != 0) {
        SharedApp.logoutType = LogoutTypeNormal;
        [SharedApp logout];
        return NO;
    }
    
    //返回事件
//    NSString *goBackProject = @"shangxin://goback?tag=0";
//    NSString *goBackResource = @"shangxin://goback?tag=1";
//    NSString *goBackMessage = @"shangxin://goback?tag=2";
//    NSString *goBackCircle = @"shangxin://goback?tag=3";
//    NSString *goBackMe = @"shangxin://goback?tag=4";
//    if ([request.URL.relativeString rangeOfString:goBackProject].length != 0) {
//        
//    }else if ([request.URL.relativeString rangeOfString:goBackResource].length != 0) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPage_Myself" object:nil];
//    }else if ([request.URL.relativeString rangeOfString:goBackMessage].length != 0) {
//        
//    }else if ([request.URL.relativeString rangeOfString:goBackCircle].length != 0) {
//        
//    }else if ([request.URL.relativeString rangeOfString:goBackMe].length != 0) {
//        
//    }

    NSString *gobackString = @"shangxin://goback?tag=1";
    NSRange gobackRange = [request.URL.relativeString rangeOfString:gobackString];
   
    if ( gobackRange.length != 0) {
        if (_needDismiss) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            SharedApp.stayNotFirstPage = NO;

            _needDismiss = false;
            return NO;
        }
        
        if (_needGoBack) {
            [self.webView goBack];
            [self.webView goBack];
            _needGoBack = false;
            return NO;
        }
        
       
        // 检测上传图片参数是否存在
        NSString *imgString = @"imgurl=";
        if ([request.URL.relativeString rangeOfString:imgString].length != 0) {
            UserInformation *userInformationDanLi= [UserInformation downloadDatadefaultManager];
            userItemInformation *totaluseritem = [userInformationDanLi._userArray lastObject];
            
            NSMutableArray * user_imageArray = totaluseritem.avatar_url;
            avatar_urlItem * item = [user_imageArray objectAtIndex:0];
            item.small_url = [[request.URL.relativeString componentsSeparatedByString:imgString] lastObject];
        }
        // 响应refresh=true
        NSString *refreshString = @"refresh=true";
        NSLog(@"webView.request.URL.relativeString: %@", webView.request.URL.relativeString);
        
        if ([request.URL.relativeString rangeOfString:refreshString].length != 0) {
            _needRefresh = YES;
        }
        if (self.webView.canGoBack) {
            [self.webView goBack];
        }else {
            [self dismissViewControllerAnimated:YES completion:^{
                SharedApp.stayNotFirstPage = YES;
                
                int selectIndex = SharedApp.mainTabBarViewController.tabBar.selectIndex;

                AbTabBarItem * abItem =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:selectIndex];
                if ([abItem.viewController isKindOfClass:[MyViewController class]]) {
                    MyViewController *myself = (MyViewController *)abItem.viewController;
                    if (_needRefresh) {
                        [myself.webViewController.webView reload];
                    }
                }else if ([abItem.viewController isKindOfClass:[MViewController class]]) {
                    MViewController *myself = (MViewController *)abItem.viewController;
                    if (_needRefresh) {
                        [myself.webViewController.webView reload];
                    }
                }else if ([abItem.viewController isKindOfClass:[RViewController class]]) {
                    RViewController *myself = (RViewController *)abItem.viewController;
                    if (_needRefresh) {
                        [myself.webViewController.webView reload];
                    }
                }else if ([abItem.viewController isKindOfClass:[ProjectSliderViewController class]]) {
                    PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem.viewController).MainVC);
                    if (_needRefresh) {
                        [myself.pro_VC.webView reload];
                        [myself.fdc_VC.webView reload];
                        [myself.fuli_VC.webView reload];
                    }
                }
            }];
        }
        return NO;
    }
    //Welfare/Index/grab_detail
    NSString *fuliGoBackString = @"Welfare/Index/grab_detail";
    NSRange fuliRange = [self.webView.request.URL.relativeString rangeOfString:fuliGoBackString];
    if (gobackRange.length != 0 &&  fuliRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;
    }
    
    //Welfare/Index/grab_luck_detail/wid
    NSString *libaoString = @"/Welfare/Index/grab_luck_detail";
    NSRange libaoRange = [self.webView.request.URL.relativeString rangeOfString:libaoString];
    if (gobackRange.length != 0 &&  libaoRange.length != 0) {
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;

    }
    
    //index.php/Project/Index/do_add_confirm
    NSString *goHomeString_0 = @"shangxin://gohome?tag=0";
    NSString *proString = @"index.php/Project/Index/do_add_confirm";
    NSRange proStringRange = [self.webView.request.URL.relativeString rangeOfString:proString];
    if ([request.URL.relativeString rangeOfString:goHomeString_0].length != 0 &&  proStringRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;

        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;
    }
    
    // 二级页面点击地区，返回一级页并刷新--项目
    NSString *goHomeString_1 = @"shangxin://gohome?tag=1";
    NSRange proStringRange_1 = [request.URL.relativeString rangeOfString:goHomeString_1];
    
    if (proStringRange_1.length != 0) {
        NSString *area = [[request.URL.relativeString componentsSeparatedByString:@"&"] lastObject];
        if (area) {
            _needRefresh = YES;
            NSString *proString_1 = [NSString stringWithFormat:@"index.php/Project/Index/pro_list_sel?%@", area];
            NSString *url = [NSString stringWithFormat:@"%@%@", DOMAIN_URL, proString_1];
            [self dismissViewControllerAnimated:YES completion:Nil];
            SharedApp.stayNotFirstPage = NO;
            
            [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
            
            int selectIndex = SharedApp.mainTabBarViewController.tabBar.selectIndex;
            
            AbTabBarItem * abItem =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:selectIndex];
            if ([abItem.viewController isKindOfClass:[MyViewController class]]) {
//                MyViewController *myself = (MyViewController *)abItem.viewController;
//                if (_needRefresh) {
//                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                }
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:0]];
            }else if ([abItem.viewController isKindOfClass:[MViewController class]]) {
                MViewController *myself = (MViewController *)abItem.viewController;
                if (_needRefresh) {
                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
            }else if ([abItem.viewController isKindOfClass:[[ResourceSliderViewController sharedSliderController] class]]) {
//                RViewController *myself = (RViewController *)abItem.viewController;
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                 [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:0]];
            }else if ([abItem.viewController isKindOfClass:[ProjectSliderViewController class]]) {
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                    [myself.fdc_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                    [myself.fuli_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
            }else if ([[((UINavigationController *)(abItem.viewController)).viewControllers objectAtIndex:0] isKindOfClass:[CircleListViewController class]]){
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:0]];
            }
                
            return NO;
        }
    }
    
    // 二级页面点击地区，返回一级页并刷新--海友
    NSString *goHomeString_2 = @"shangxin://gohome?tag=2";
    NSRange proStringRange_2 = [request.URL.relativeString rangeOfString:goHomeString_2];
    
    if (proStringRange_2.length != 0) {
        NSString *area = [[request.URL.relativeString componentsSeparatedByString:@"&"] lastObject];
        if (area) {
            _needRefresh = YES;
            NSString *proString_2 = [NSString stringWithFormat:@"index.php/Resource/Index/resource_list_rel?%@", area];
            NSString *url = [NSString stringWithFormat:@"%@%@", DOMAIN_URL, proString_2];
            [self dismissViewControllerAnimated:YES completion:Nil];
            SharedApp.stayNotFirstPage = NO;
            
            [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
            
            int selectIndex = SharedApp.mainTabBarViewController.tabBar.selectIndex;
            
            AbTabBarItem * abItem =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:selectIndex];
            if ([abItem.viewController isKindOfClass:[MyViewController class]]) {
//                MyViewController *myself = (MyViewController *)abItem.viewController;
//                if (_needRefresh) {
//                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                }
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:1]];
                
            }else if ([abItem.viewController isKindOfClass:[MViewController class]]) {
//                MViewController *myself = (MViewController *)abItem.viewController;
//                if (_needRefresh) {
//                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                }
                MViewController *myself = (MViewController *)abItem.viewController;
                if (_needRefresh) {
                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
            }else if ([abItem.viewController isKindOfClass:[[ResourceSliderViewController sharedSliderController] class]]) {
//                RViewController *myself = (RViewController *)(((ResourceSliderViewController *)abItem.viewController).MainVC);
//                if (_needRefresh) {
//                    [myself.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//                }
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:1]];
            }else if ([abItem.viewController isKindOfClass:[ProjectSliderViewController class]]) {
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                    [myself.fdc_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                    [myself.fuli_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
            }else if ([[((UINavigationController *)(abItem.viewController)).viewControllers objectAtIndex:0] isKindOfClass:[CircleListViewController class]]){
                AbTabBarItem * abItem1 =(AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0];
                PViewController *myself = (PViewController *)(((ProjectSliderViewController *)abItem1.viewController).MainVC);
                if (_needRefresh) {
                    [myself.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
                [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:1]];
            }
            
            return NO;
        }
    }



    NSString *goHomeString_5 = @"shangxin://gohome?tag=5";
    NSString *proString5 = @"index.php/User/Index/pic_show";
    NSRange proStringRange5 = [self.webView.request.URL.relativeString rangeOfString:proString5];
    if ([request.URL.relativeString rangeOfString:goHomeString_5].length != 0 &&  proStringRange5.length != 0) {
        
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;

        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;

    }

    
    //index.php/Welfare/Index/add_welfare
    NSString *flString = @"index.php/Welfare/Index/add_welfare";
    NSRange flStringRange = [self.webView.request.URL.relativeString rangeOfString:flString];
    if ([request.URL.relativeString rangeOfString:goHomeString_0].length != 0 &&  flStringRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;

        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;

    }
    
    //Resource/Index/update_resource
    NSString *resString = @"Resource/Index/update_resource";
    NSRange resStringRange = [self.webView.request.URL.relativeString rangeOfString:resString];
    if ([request.URL.relativeString rangeOfString:goHomeString_0].length != 0 && resStringRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;

        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;

    }
    
    if (self.webView.canGoBack == NO && gobackRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        SharedApp.stayNotFirstPage = NO;

        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        return NO;

    }
    
    //shangxin://sharetowx(1) 朋友
    //shangxin://sharetowx(0) 朋友圈
    NSRange wxString = [request.URL.relativeString rangeOfString:@"shangxin://sharetowx?tag=1"];
    NSRange wxString0 = [request.URL.relativeString rangeOfString:@"shangxin://sharetowx?tag=0"];
    if (wxString.length != 0 || wxString0.length != 0) {

        if (wxString.length != 0) {
            [self setScene:WXSceneSession];
        }
        if (wxString0.length != 0) {
            [self setScene:WXSceneTimeline];
        }
        
        NSString *path = [request.URL.relativeString
                          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString *imgURLString = [self getStringWithURLString:path startString:@"imgurl=" endString:@"&weburl"];
        NSString *urlString = [self getStringWithURLString:path startString:@"weburl=" endString:@"&title"];
        NSString *titleString = [self getStringWithURLString:path startString:@"title=" endString:@"&desc"];
        NSString *descString = nil;
        if (wxString0.length != 0) {
          descString = [self getStringWithURLString:path startString:@"desc=" endString:@"&pid"];
        }else{
            descString = [self getStringWithURLString:path startString:@"desc=" endString:path];
        }
        NSLog(@"urlString  is  =====>  %@",urlString);
        NSLog(@"titleString is  ======> %@",titleString);
        [self sendLinkContentWithTitleString:titleString
                                   urlString:urlString
                                imgURLString:imgURLString
                                  descString:descString];
        return NO;
    }
    
    if ([SharedApp networkStatus] == -1) {
        [self.activityIndicatorView stopAnimating];
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width/2-150/2, self.webView.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        return NO;
    }
    return YES;
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
    if (_needRefresh) {
        [webView reload];
        _needRefresh = false;
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    if (error.code == -1009 ) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width/2-150/2, self.webView.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
       
    }
}

#pragma mark - AlertView Delegate -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [SharedApp logout];
    }else{
        [alertView removeFromSuperview];

    }
}

#pragma mark - Target Action -

- (void)pressedShowGuideTabBarBtn
{
    [MobClick event:@"guidBtn"];
    _tabBar.hidden = NO;
}

- (void)tappedHideTabBarTap
{
    _tabBar.hidden = YES;
}

-(void)onReq:(BaseReq *)req
{
}

-(void) onResp:(BaseResp *)resp
{
    
}

#pragma mark - WXShare Delegate -
- (void)sendLinkContentWithTitleString : (NSString *) titleString
                              urlString:(NSString *) urlString
                           imgURLString:(NSString *) imgURLString
                             descString:(NSString *) descString
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleString;
    message.description = descString;

    NSURL *imgurl = [NSURL URLWithString:imgURLString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = [self scene];
    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//自定义UserAgent，用来去掉网页版html导航
-(void)setCustomUserAgent:(NSString *)customUserAgent
{
    _customUserAgent = customUserAgent;
    if (self.customUserAgent) {
        @try {
            id webDocumentView = [self.webView valueForKey:@"documentView"];
            id webView = [webDocumentView valueForKey:@"webView"];
            [webView performSelector:@selector(setCustomUserAgent:) withObject:customUserAgent];
        }
        @catch (NSException *exception) {
            
        }
    }
    
}
- (void)handleGes:(UIGestureRecognizer *)gestureRecognizer
{
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"up");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"down");
    }
}

#pragma mark - UIGestureRecognizerDelegate -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
