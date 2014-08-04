//
//  ShowMViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-24.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ShowMViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MessageSliderViewController.h"
#import "WebViewController.h"
#import "ShowPageViewController.h"
#import "ABTabBarController.h"

@interface ShowMViewController ()<UIWebViewDelegate,WXApiDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong) NSString * customUserAgent;

@property (nonatomic) enum WXScene scene;

@property (strong, nonatomic) UIWebView *webView;
@property (assign, nonatomic)   BOOL    needRefresh;
@property (nonatomic, strong)   ABTabBar       *tabBar;

@end

@implementation ShowMViewController
-(NSString *) getStringWithURLString : (NSString *) urlString
                         startString :(NSString *) startString
                           endString :(NSString *) endString
{
    NSString *webString=urlString;
    NSString *pageStart = startString;
    NSString *pageEnd = endString;
    int startOffset=[webString rangeOfString:pageStart].location + pageStart.length;
    int endOffset=[webString rangeOfString:pageEnd].location + pageEnd.length;
    //截取substring
    NSString *partialString=[webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
    return partialString;
}
-(void)showMessageshowleft
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
    
    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.webView.frame = CGRectMake(0, 64, 320, 548-44);
            self.ShowMessageViewNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
            [self.ShowMessageViewNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.ShowMessageViewNavbar];
        }else{
            self.webView.frame = CGRectMake(0, 44, 320, 548-44);
            self.ShowMessageViewNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.ShowMessageViewNavbar setBackgroundImage: [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.ShowMessageViewNavbar];
        }
    }else{
        if (IOS_VERSION  >= 7.0) {
            self.webView.frame = CGRectMake(0, 64, 320, 460-44);
            self.ShowMessageViewNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
            [self.ShowMessageViewNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.ShowMessageViewNavbar];
        }else{
            self.webView.frame = CGRectMake(0, 44, 320, 460-44);
            self.ShowMessageViewNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.ShowMessageViewNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.ShowMessageViewNavbar];
        }
    }
    UIImage *lImage = [UIImage imageNamed:@"leftlast.png"];
    
    self.showMessagelefttBtn =[[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_HEIGHT, lImage.size.width, lImage.size.height)];
    [self.showMessagelefttBtn setBackgroundImage:lImage forState:UIControlStateNormal];
    [self.showMessagelefttBtn addTarget:self action:@selector(showMessageshowleft) forControlEvents:UIControlEventTouchUpInside];
    [self.ShowMessageViewNavbar addSubview:self.showMessagelefttBtn];
    [self.ShowMessageViewNavbar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
   
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, 320, 44)];
    titleLabel4.font = [UIFont systemFontOfSize:22];
    titleLabel4.textColor = [UIColor whiteColor];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    titleLabel4.text = self.labelText;
    [self.ShowMessageViewNavbar addSubview:titleLabel4];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(110, 150, 100, 100)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

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

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.customUserAgent == nil) {
        NSString * userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        [self setCustomUserAgent:[NSString stringWithFormat:@"%@ %@", userAgent, @"shangxin"]];
        NSLog(@"userAgent : %@",self.customUserAgent);
    }
    NSLog(@"urlstring is %@",request.URL.relativeString);
    //luck_success
    NSRange luck_success_range = [request.URL.relativeString rangeOfString:@"luck_success"];
    
    //grap_success
    NSRange grap_success_range = [request.URL.relativeString rangeOfString:@"grap_success"];
    
    //grab_luck_detail
    NSRange grab_luck_detail_range = [request.URL.relativeString rangeOfString:@"grab_luck_detail"];
    //grab_detail
    NSRange grab_detail_range = [request.URL.relativeString rangeOfString:@"grab_detail"];
    
    //do_grap/wid
    NSRange do_grap_range = [request.URL.relativeString rangeOfString:@"do_grap/wid"];
    //user_set
    NSRange user_set_range = [request.URL.relativeString rangeOfString:@"user_set"];
    
    //add_msg
    NSRange add_msgRange = [request.URL.relativeString rangeOfString:@"add_msg"];
    
    NSRange range = [request.URL.relativeString rangeOfString:@"pro_detail"];
    
    NSRange threeRang = [request.URL.relativeString rangeOfString:@"user_show"];
    //welfare_detail
    NSRange welfare_detail_range = [request.URL.relativeString rangeOfString:@"welfare_detail"];
    //circlemsg_detail
    NSRange circlemsg_detail = [request.URL.relativeString rangeOfString:@"circlemsg_detail"];
    //modify
    NSRange modify = [request.URL.relativeString rangeOfString:@"modify"];
    //my_user_list
    NSRange my_user_list = [request.URL.relativeString rangeOfString:@"my_user_list"];
    //pic_show
    NSRange pic_show = [request.URL.relativeString rangeOfString:@"pic_show"];
    //mywealth
    NSRange mywealth = [request.URL.relativeString rangeOfString:@"mywealth"];
    //my_pro_list
    NSRange my_pro_list = [request.URL.relativeString rangeOfString:@"my_pro_list"];
    //invitation
    NSRange invitation = [request.URL.relativeString rangeOfString:@"invitation"];
    
    //welfare_rel_detail
    NSRange welfare_rel_detail_range = [request.URL.relativeString rangeOfString:@"welfare_rel_detail"];
    
    //Share/interest_rank.html
    NSRange rankRange = [request.URL.relativePath rangeOfString:@"Share/interest_rank.html"];
    if (welfare_rel_detail_range.length != 0 || grap_success_range.length != 0 || grab_detail_range.length != 0 || grab_luck_detail_range.length != 0 ||luck_success_range.length != 0 || do_grap_range.length != 0 || user_set_range.length != 0|| rankRange.length != 0 || range.length != 0  || threeRang.length != 0 || welfare_detail_range.length != 0 ||circlemsg_detail.length != 0  ||modify.length != 0 ||my_user_list.length !=0  ||pic_show.length !=0 || mywealth.length != 0  ||my_pro_list.length != 0  ||invitation.length !=0 || add_msgRange.length != 0) {
        
        ShowPageViewController *spvc = [[ShowPageViewController alloc] init];
        [spvc setUrlString:request.URL.relativeString];
        [self presentViewController:spvc animated:YES completion:nil];
        
        //通知隐藏菜单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNavi" object:nil];
        return NO;
    }else{
        //启用刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showNavi" object:nil];
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
        
        NSString *imgURLString = [self getStringWithURLString:path startString:@"imgurl=" endString:@".jpg"];
        NSString *urlString = [self getStringWithURLString:path startString:@"weburl=" endString:@"html"];
        NSString *titleString = [self getStringWithURLString:path startString:@"title=" endString:path];
        
        [self sendLinkContentWithTitleString:titleString urlString:urlString imgURLString:imgURLString];
        return NO;
    }
    
    //返回事件
    NSString *gobackString = @"shangxin://goback?tag=1";
    NSRange gobackRange = [request.URL.relativeString rangeOfString:gobackString];
    if ( gobackRange.length != 0) {
        [self.webView goBack];
    }
    if (self.webView.canGoBack == NO && gobackRange.length != 0) {
        [self dismissViewControllerAnimated:YES completion:Nil];
        
        
    }
    
    return YES;
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
-(void)onReq:(BaseReq *)req
{
}

-(void) onResp:(BaseResp *)resp
{
    
}

- (void)sendLinkContentWithTitleString : (NSString *) titleString
                              urlString:(NSString *) urlString
                           imgURLString:(NSString *) imgURLString
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleString;
    message.description = titleString;
    
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
    // Dispose of any resources that can be recreated.
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

#pragma mark - Target Action -

- (void)pressedShowGuideTabBarBtn:(UIButton *)button
{
    _tabBar.hidden = NO;
}

- (void)tappedHideTabBarTap:(UITapGestureRecognizer *)gesture
{
    _tabBar.hidden = YES;
}

@end
