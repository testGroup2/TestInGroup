//
//  ShowProtocolViewController.m
//  Shanghaitong
//
//  Created by LivH on 14-4-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//
#import "ASIFormDataRequest.h"
#import "userItemInformation.h"
#import "UserInformation.h"
#import "ShowProtocolViewController.h"

@interface ShowProtocolViewController ()<UIWebViewDelegate>
@property(nonatomic,strong) NSString * customUserAgent;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ShowProtocolViewController

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
    // Do any additional setup after loading the view.
    if (IOS_VERSION >= 7.0) {
        UIView *pitchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        pitchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar.png"]];
        [self.view addSubview:pitchView];
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    }
    else{
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROTOCOL_URL];
    [self loadPage];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.webView];

}
-(void)loadPage
{
    NSLog(@"self.urlstring: %@", self.urlString);
    if (!self.urlString) {
        return ;
    }
    
    ASIFormDataRequest *rq = [ASIFormDataRequest requestWithURL:nil];
    NSString *tokenString = [rq encodeURL:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    NSString *newURLString = nil;
    if ([self.urlString rangeOfString:@"?"].length != 0) {
        newURLString = [NSString stringWithFormat:@"%@&token=%@",self.urlString, tokenString];
    }else {
        newURLString = [NSString stringWithFormat:@"%@?token=%@",self.urlString, tokenString];
    }
    NSLog(@"newURLString: %@", newURLString);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:newURLString]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.webView loadRequest:req];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView Delegate - 
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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
    //定义UA
    if (self.customUserAgent == nil) {
        NSString * userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        [self setCustomUserAgent:[NSString stringWithFormat:@"%@ %@", userAgent, @"shangxin"]];
    }
    //第一次登录同意后返回主页面
    if ([request.URL.relativeString rangeOfString:@"shangxin://agreeprotocol"].length != 0 || SharedApp.protocol == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAccessProtocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SharedApp showWebController];
        return NO;
        
    }
    
    NSLog(@"pro request string is %@",request.URL.relativeString);
    //直接退出
    if ([request.URL.relativeString rangeOfString:@"shangxin://logout?alert=false"].length != 0) {
        [SharedApp logout];
        return NO;
    }
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
