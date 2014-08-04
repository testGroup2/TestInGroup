//
//  MViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-24.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "MViewController.h"
#import "MessageSliderViewController.h"
#import "MessageLeftViewController.h"
@interface MViewController ()<MessageLeftViewControllerDelegate>

@end

@implementation MViewController
-(void)refreshPage_Message
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX101];
    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
-(void)viewWillAppear:(BOOL)animated
{
    SharedApp.mainTabBarViewController.tabBar.hidden = NO;
}
-(void)MessageshowLeft
{
    if (!_didShowedLeft) {
        _didShowedLeft = YES;
        self.MessagelefttBtn.tag = 100010;
        [[MessageSliderViewController sharedSliderController] showLeftViewController];
        [(MessageLeftViewController *)([MessageSliderViewController sharedSliderController].LeftVC) setDelegate:self];
        //解决不能点击最后一行的bug
        UIViewController *v3 = [[UIViewController alloc] init];
        v3.view.frame = [UIScreen mainScreen].bounds;
        v3.view.backgroundColor = [UIColor redColor];
        [[MessageSliderViewController sharedSliderController]presentViewController:v3 animated:NO completion:^{}];
        [v3 dismissViewControllerAnimated:NO completion:^{}];
    }else {
        _didShowedLeft = NO;
        [[MessageSliderViewController sharedSliderController] closeSideBar];
    }
}
- (void)loadMessageWithUrl:(NSString *)url{
    
    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (IOS_VERSION>=7.0) {
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
//    }
//    else{
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//    }
    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.MessageNarbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44+STATUS_HEIGHT)];
            [self.MessageNarbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MessageNarbar];
        }else{
            self.MessageNarbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.MessageNarbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MessageNarbar];
        }
    }else{
        if (IOS_VERSION  >= 7.0) {
            self.MessageNarbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
            [self.MessageNarbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MessageNarbar];
        }else{
            self.MessageNarbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.MessageNarbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MessageNarbar];
        }
    }
    UIImage *lImage = [UIImage imageNamed:@"leftlast.png"];
    self.MessagelefttBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, lImage.size.width, lImage.size.height)];
    [self.MessagelefttBtn setBackgroundImage:lImage forState:UIControlStateNormal];
    [self.MessagelefttBtn addTarget:self action:@selector(MessageshowLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.MessageNarbar addSubview:self.MessagelefttBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage_Message) name:@"refreshPage_Message" object:nil];
    //接收关闭UserInterface通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUserInterface) name:@"closeUserInterface" object:nil];
    //openUserInterface
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openUserInterface) name:@"openUserInterface" object:nil];
    //接受隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavi) name:@"hideNavi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavi) name:@"showNavi" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX101];
    self.webViewController = [[WebViewController alloc] initWithURLString:urlString andType:SHTLoadWebPageMessage];
    NSLog(@"circle message is %@",self.webViewController.urlstring);
    
    [self.view addSubview:self.webViewController.view];
    [self.MessageNarbar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, 320, 44)];
    titleLabel4.font = [UIFont systemFontOfSize:22];
    titleLabel4.textColor = [UIColor whiteColor];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    titleLabel4.text = @"消息";
    [self.MessageNarbar addSubview:titleLabel4];
    if (IOS_VERSION >= 7.0) {
        self.contentFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        self.rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        self.webViewController.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    }else{
        self.contentFrame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        self.rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        self.webViewController.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    }
    UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    rswip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webViewController.webView addGestureRecognizer:rswip];
    UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    lswip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webViewController.webView addGestureRecognizer:lswip];
    
}
-(void) slcResul:(NSNotification *) noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController loadPage];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void) hideNavi
{
    self.webViewController.view.frame = self.rect;
}
-(void) showNavi
{
    self.webViewController.view.frame = self.contentFrame;
}
-(void) closeUserInterface
{
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
    self.webViewController.webView.userInteractionEnabled = NO;
}
-(void) openUserInterface
{
    self.webViewController.webView.userInteractionEnabled = YES;
}

#pragma mark - Target Action -

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self MessageshowLeft];
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_didShowedLeft) {
            [((MessageSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController)) closeSideBar];
            _didShowedLeft = NO;
        }
    }
}

@end
