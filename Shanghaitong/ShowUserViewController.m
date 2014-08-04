//
//  ShowUserViewController.m
//  Shanghaitong
//
//  Created by LivH on 14-4-14.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ShowUserViewController.h"

@interface ShowUserViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NSString * customUserAgent;
@property (assign, nonatomic)   BOOL    needRefresh;
@property (nonatomic, strong)   ABTabBar       *tabBar;

@end

@implementation ShowUserViewController

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
    
    SharedApp.stayNotFirstPage = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 20,self.view.frame.size.width,self.view.frame.size.height - 20);
    
    self.webView = [[UIWebView alloc] initWithFrame:rect];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.webView loadRequest:request];
    });
    [self.view addSubview:self.webView];
    
    UIImage *image = [UIImage imageNamed:@"showTabBarButton"];
    UIButton *guideTabBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, [UIScreen mainScreen].bounds.size.height-kGuidBtnSide-5, kGuidBtnSide, kGuidBtnSide)];
    [guideTabBarBtn setBackgroundImage:image forState:UIControlStateNormal];
    [guideTabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [guideTabBarBtn addTarget:self action:@selector(pressedShowGuideTabBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guideTabBarBtn];

    if (IOS_VERSION >= 7.0) {
        _tabBar = [[ABTabBar alloc] initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }else{
        
        _tabBar = [[ABTabBar alloc]initWithTabItems:SharedApp.mainTabBarViewController.tabBarItems height:SharedApp.mainTabBarViewController.tabBarHeight backgroundImage:SharedApp.mainTabBarViewController.backgroundImage];
    }
    _tabBar.delegate = SharedApp.mainTabBarViewController;
    
    [self.view addSubview:_tabBar];
    [_tabBar createTabs];
    _tabBar.hidden = YES;
    
    UITapGestureRecognizer *hideTabBarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHideTabBarTap:)];
    hideTabBarTap.delegate = self;
    [self.webView addGestureRecognizer:hideTabBarTap];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    NSLog(@"reques url string is %@------->",request.URL.relativeString);
    //定义UA
    if (self.customUserAgent == nil) {
        NSString * userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        [self setCustomUserAgent:[NSString stringWithFormat:@"%@ %@", userAgent, @"shangxin"]];
        NSLog(@"userAgent : %@",self.customUserAgent);
    }
    
    // shangxin://goback?tag=1&refresh=true
    if ([request.URL.relativeString rangeOfString:@"shangxin://goback?tag=1"].length != 0 && [self.webView canGoBack] == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Target Action -

- (void)pressedShowGuideTabBarBtn:(UIButton *)button
{
    _tabBar.hidden = NO;
}

- (void)tappedHideTabBarTap:(UITapGestureRecognizer *)gesture
{
    _tabBar.hidden = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
