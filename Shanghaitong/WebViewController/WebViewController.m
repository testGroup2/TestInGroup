//
//  WebToolViewController.m
//  商海通
//
//  Created by Liv on 14-3-23.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import "WebViewController.h"
#import "SXLoginViewController.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ShowPageViewController.h"
#import "ZHAppProfile.h"//应用程序概要文件
#import "WXApi.h"
#import "WXApiObject.h"
#import "Reachability.h"
#import "ShowUserViewController.h"
#import "ASIWebPageRequest.h"
@interface WebViewController ()<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,WXApiDelegate,ASIHTTPRequestDelegate>
@property (nonatomic) enum WXScene scene;
@property (nonatomic,strong) ASIWebPageRequest *request;
@property (nonatomic,strong) NSMutableURLRequest *urlRequest;
@property (nonatomic,assign) BOOL firstLoad;
@end
@implementation WebViewController
-(void)onReq:(BaseReq *)req
{
    
}
-(void) onResp:(BaseResp *)resp
{
    
}
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
    //截取substring
    if (startOffset >= 0 && endOffset >= 0) {
        partialString=[webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
    }
    return partialString;
}

//缓存并加载页面
-(void)loadPage
{
    NSLog(@"self.urlstring: %@", self.urlstring);
    if (!self.urlstring) {
        return ;
    }
    ASIFormDataRequest *rq = [ASIFormDataRequest requestWithURL:nil];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    NSString *tokenString = [rq encodeURL:token];

    NSString *newURLString = nil;
    if ([self.urlstring rangeOfString:@"?"].length != 0) {
        newURLString = [NSString stringWithFormat:@"%@&token=%@",self.urlstring, tokenString];
    }else {
        newURLString = [NSString stringWithFormat:@"%@?token=%@",self.urlstring, tokenString];
    }
    NSLog(@"newURLString: %@", newURLString);
    self.urlRequest = [self makeRequestWithURLString:newURLString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        self.urlRequest.timeoutInterval = 5.0f;
        [self.webView loadRequest:self.urlRequest];
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

//用指定url初始化
-(id) initWithURLString : (NSString *) urlString andType:(SHTLoadWebPage)type
{
    if (self = [super init]) {
        self.urlstring = urlString;
        self.pageType = type;
    }
    return self;
}

- (NSMutableURLRequest *)makeRequestWithURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    return request;
}

+(WebViewController *)shareWebViewController
{
    static WebViewController *webViewController = nil;
    if (webViewController == nil)
    {
        webViewController = [[self alloc] init];
    }
    return webViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.p.delegate = self;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.contentSize = self.webView.frame.size;
    self.webView.superview.backgroundColor = [UIColor redColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.urlRequest = [[NSMutableURLRequest alloc] init];
    self.urlRequest.timeoutInterval = 5.0f;
    if (iPhone5Srceen) { // iPhone 5
        if (SharedApp.mainTabBarViewController.tabBar.selectIndex == 0) {
            if (IOS_VERSION >= 7.0) {
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-138);
            }else{
               self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-118);
            }
        }
        else if(SharedApp.mainTabBarViewController.tabBar.selectIndex == 1){
            if (IOS_VERSION >= 7.0) {
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-157);
                
            }else{
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-93);
            }
        }
        else if ( SharedApp.mainTabBarViewController.tabBar.selectIndex == 2 || SharedApp.mainTabBarViewController.tabBar.selectIndex == 3 || SharedApp.mainTabBarViewController.tabBar.selectIndex == 4){
            if (IOS_VERSION >= 7.0) {
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-113);

            }else{
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-93);
            }
        }
    }else {
        if (SharedApp.mainTabBarViewController.tabBar.selectIndex == 0) {
            self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-138);
        }else if (SharedApp.mainTabBarViewController.tabBar.selectIndex == 1 || SharedApp.mainTabBarViewController.tabBar.selectIndex == 2 || SharedApp.mainTabBarViewController.tabBar.selectIndex == 3 || SharedApp.mainTabBarViewController.tabBar.selectIndex == 4){
            if (IOS_VERSION >= 7.0) {
               self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-113);
            }else{
                self.webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-93);
            }
        }
    }
    //初始化刷新按钮
    [self initEGO];
    //加载页面
    [self.view addSubview:self.webView];
    [self loadPage];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(110, 150, 100, 100)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)gobackkk
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else if (!self.webView.canGoBack){
        
    }
}

- (void)handleGes:(UIGestureRecognizer *)gestureRecognizer
{
    // UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
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

-(void) initEGO
{
    //初始化refreshView，添加到webview 的 scrollView子视图中
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.webView.scrollView.bounds.size.height, self.webView.scrollView.frame.size.width, self.webView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.webView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //下拉刷新中间没有活动指示器activityIndicatorView
    [self.activityIndicatorView stopAnimating];
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    // 下拉刷新有反弹效果，上拉加载更多禁用反弹效果
    if (scrollView.contentSize.height == scrollView.frame.size.height) {
        scrollView.bounces = !(scrollView.contentOffset.y > 0);
        scrollView.scrollEnabled = scrollView.bounces;
    }else {
        if (scrollView.contentOffset.y > 0) {
            scrollView.bounces = NO;
        }else {
            scrollView.bounces = YES;
        }
    }
   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods -

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    
    NSLog(@"self.webView.request.URL.absoluteString: %@", self.webView.request.URL.absoluteString);
    NSString *originString = nil;
    switch (self.pageType) {
        case SHTLoadWebPagePro:
             originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROJECT_LIST_URL];
            break;
        case SHTLoadWebPageHouse:
            originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,REALTY_LIST_URL];
            break;
        case SHTLoadWebPageWelfare:
            originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,ROB_WELFARE_LIST_URL];
            break;
        case SHTLoadWebPageResource:
            originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX51];
            break;
        case SHTLoadWebPageMessage:
            originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX101];
            break;
        case SHTLoadWebPageMySelf:
            originString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX201];
            break;
        default:
            break;
    }
//    NSString *originString = [[self.webView.request.URL.absoluteString componentsSeparatedByString:@"token="] objectAtIndex:0];
//    UserInformation *user = [UserInformation downloadDatadefaultManager];
//    userItemInformation *u = [user._userArray lastObject];
    
    ASIFormDataRequest *rq = [ASIFormDataRequest requestWithURL:nil];
    NSString *tokenString = [rq encodeURL:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *newString = nil;
    
    //修改过的,缓存功能
    switch (self.pageType) {
        case SHTLoadWebPagePro:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationBarName" object:@"众筹"];
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROJECT_LIST_URL];
        }
            break;
        case SHTLoadWebPageHouse:{
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,REALTY_LIST_URL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationBarName" object:@"房地产"];
        }
            break;
        case SHTLoadWebPageWelfare:{
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,ROB_WELFARE_LIST_URL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationBarName" object:@"福利"];
        }
            break;
        case SHTLoadWebPageResource:
        {
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX51];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"makeOriginTitle" object:nil];
        }
            break;
        case SHTLoadWebPageMessage:
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX101];
            break;
        case SHTLoadWebPageMySelf:
            newString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX201];
            break;
        default:
            break;
     }
    if ([originString rangeOfString:@"?"].length != 0) {
        newString = [NSString stringWithFormat:@"%@&token=%@", originString, tokenString];
    }else {
        newString = [NSString stringWithFormat:@"%@?token=%@", originString, tokenString];
    }
    
    self.urlRequest.timeoutInterval = 5.0f;
    self.urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newString]];
    [self.webView loadRequest:self.urlRequest];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UIWebView Delegate -

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"------>request string  is %@ --- %@", request.URL.relativeString,self.urlRequest.URL.relativeString);
    NSLog(@"------>self webview string is %@",self.webView.request.URL.relativeString);
    if (!self.firstLoad) {
        request = self.urlRequest;
        self.firstLoad = YES;
    }
    if ([SharedApp networkStatus] == -1) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width/2-150/2, self.webView.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
        return NO;
    }
    
    //定义UA
    if (self.customUserAgent == nil) {
        NSString * userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        [self setCustomUserAgent:[NSString stringWithFormat:@"%@ %@", userAgent, @"shangxin"]];
        NSLog(@"userAgent : %@",self.customUserAgent);
    }
    
    //判断账号第一次登录
//    if ([request.URL.relativeString rangeOfString:@"User/Public/protocol"].length != 0) {
//        ShowPageViewController *showVC = [[ShowPageViewController alloc] init];
//        [showVC setUrlString:request.URL.relativeString];
//        [SharedApp.mainTabBarViewController presentViewController:showVC animated:NO completion:nil];
//        SharedApp.showProtocol = YES;
//        return NO;
//    }

    
    //shangxin://sharetowx(1) 朋友
    //shangxin://sharetowx(0) 朋友圈
    NSRange friend = [request.URL.relativeString rangeOfString:@"shangxin://sharetowx?tag=0"];
    NSRange friendCub = [request.URL.relativeString rangeOfString:@"shangxin://sharetowx?tag=1"];
    if (friendCub.length != 0) {
        [self setScene:WXSceneSession];
        NSString *path = [request.URL.relativeString
                          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *imgURLString = [self getStringWithURLString:path startString:@"imgurl=" endString:@"&weburl"];
        NSString *urlString = [self getStringWithURLString:path startString:@"weburl=" endString:@"&title"];
        NSString *titleString = [self getStringWithURLString:path startString:@"title=" endString:@"&desc"];
        NSString *descString = [self getStringWithURLString:path startString:@"desc=" endString:path];
        NSLog(@"weburl String  is %@",urlString);
        NSLog(@"title string is %@",titleString);
        NSLog(@"descString is %@",descString);
        [self sendLinkContentWithTitleString:titleString
                                   urlString:urlString
                                imgURLString:imgURLString
                                  descString:descString];
        return NO;
        
    }else if (friend.length != 0) {

        [self setScene:WXSceneTimeline];
        NSString *path = [request.URL.relativeString
                          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *imgURLString = [self getStringWithURLString:path startString:@"imgurl=" endString:@"&weburl"];
        NSString *urlString = [self getStringWithURLString:path startString:@"weburl=" endString:@"&title"];
        NSString *titleString = [self getStringWithURLString:path startString:@"title=" endString:@"&desc"];
        NSString *descString = [self getStringWithURLString:path startString:@"desc=" endString:@"&pid"];
        NSLog(@"weburl String  is %@",urlString);
        NSLog(@"title string is %@",titleString);
        NSLog(@"descString is %@",descString);
        [self sendLinkContentWithTitleString:titleString
                                   urlString:urlString
                                imgURLString:imgURLString
                                  descString:descString];
        return NO;
    }
    
    //返回
    NSString *gobackString = @"shangxin://goback?tag=1";
    NSRange gobackRange = [request.URL.relativeString rangeOfString:gobackString];
    if ( gobackRange.length != 0) {
        [self gobackkk];
    }
    //捕捉注销
    NSString *logoutString = @"shangxin://logout";
    NSRange logoutStr = [request.URL.relativeString rangeOfString:logoutString];
    if (logoutStr.length != 0) {
        NSString *path = [request.URL.relativeString
                          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *msg = [self getStringWithURLString:path startString:@"msg=" endString:path];
        NSRange cancleRange = [path rangeOfString:@"cancel=false"];
        if (cancleRange.length != 0) {
            UIAlertView *alertView =[ [UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alertView show];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenkey"];
        [SharedApp showLoginViewController];
    }
    
    //判断URL是否包含二级页URL的字符
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
    //user_show
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
    //user_set.html
    NSRange user_sethtml = [request.URL.relativePath rangeOfString:@"user_set.html"];
    //update_resource.html
    NSRange update_resourcehtml = [request.URL.relativePath rangeOfString:@"update_resource.html"];
    
    //update_resource.html
    NSRange resource_detail = [request.URL.relativePath rangeOfString:@"index.php/Resource/Index/resource_detail"];
    
    //update_resource.html
    NSRange record_detail = [request.URL.relativePath rangeOfString:@"index.php/User/Index/credit_record"];
    
    NSRange my_msg_range = [request.URL.relativeString rangeOfString:@"index.php/User/AboutMe/lists"];
    
    //threeRang.length != 0 ||
    if (threeRang.length != 0 ||welfare_rel_detail_range.length != 0 || grap_success_range.length != 0 || grab_detail_range.length != 0 || grab_luck_detail_range.length != 0 ||luck_success_range.length != 0 || do_grap_range.length != 0 || user_set_range.length != 0|| rankRange.length != 0 || range.length != 0  ||  welfare_detail_range.length != 0 ||circlemsg_detail.length != 0  ||modify.length != 0 ||my_user_list.length !=0  ||pic_show.length !=0 || mywealth.length != 0  ||my_pro_list.length != 0  ||invitation.length !=0 || add_msgRange.length != 0  ||user_sethtml.length != 0  ||update_resourcehtml.length !=0 || resource_detail.length != 0
        || record_detail.length != 0 || my_msg_range.length != 0) {
        //用ShowPageViewController显示二级页面
        
        ShowPageViewController *spvc = [[ShowPageViewController alloc] init];
        [spvc setUrlString:request.URL.relativeString];
        [MobClick event:@"secondWeb" label:request.URL.relativeString];
        [SharedApp.mainTabBarViewController presentViewController:spvc animated:YES completion:nil];

        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
    self.activityIndicatorView.hidden = NO;
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
    
    NSLog(@"error string is %@",error.description);
    NSLog(@"%d",error.code);
    if (error.code == -1009 || error.code == 102 ) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width/2-150/2, self.webView.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        [self.activityIndicatorView stopAnimating];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
}

#pragma mark - PopupSmallViewDelegate -
-(void)popupViewDidDisappear
{
    _reloading = NO;
    [self.activityIndicatorView stopAnimating];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
}

//不要删除
#pragma mark - URL Cache -
- (void)loadURL:(NSURL *)url
{
    // Again, make sure we cancel any in-progress page load first
    [self.request setDelegate:nil];
    [self.request cancel];
    
    [self.request setUserAgentString:self.customUserAgent];

    [ASIHTTPRequest setDefaultUserAgentString:self.customUserAgent];
    NSLog(@"self.request userAgen : %@",self.customUserAgent);
    [self setRequest:[ASIWebPageRequest requestWithURL:url]];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(webPageFetchFailed:)];
    [self.request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
    
    // Tell the request to replace urls in this page with local urls
    [self.request setUrlReplacementMode:ASIReplaceExternalResourcesWithLocalURLs];

    // As before, tell the request to use our download cache
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    [self.request setDownloadDestinationPath:
     [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:self.request]];
    
    [self.request startAsynchronous];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    // Make sure you handle this error properly...
    NSLog(@"%@",[theRequest error]);
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    // The page has been downloaded with all external resources. Now, we'll load it into our UIWebView.
    // This time, we're telling our web view to load the file on disk directly.
    self.urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[theRequest downloadDestinationPath]]];
    [self.webView loadRequest:
     self.urlRequest];
}



@end
