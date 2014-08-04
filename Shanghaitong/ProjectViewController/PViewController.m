//
//  PViewController.m
//  Shanghaitong
//
//  Created by Steve Wang on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "PViewController.h"
#import "ProjectSliderViewController.h"
#import "ProjectAlertTableViewController.h"
#import "CircleDatabase.h"
#import "NewMessagePromptView.h"
#define STATUS_HEIGHT (IOS_VERSION>=7.0?20:0)
static const unsigned int SVTopScrollViewTag = 10000;
static const unsigned int SVRootScrollViewTag = 10001;

@interface PViewController ()

@property (assign,nonatomic) CGRect contentFrame;
@property (assign,nonatomic) CGRect rootViewFrame;

@property (nonatomic,assign) BOOL refreshedPro;
@property (nonatomic,assign) BOOL refreshedHouse;
@property (nonatomic,assign) BOOL refreshedWel;
@end

@implementation PViewController

- (void)beginCaculateTime:(NSNotification *)noti{
    switch (_pType) {
        case 100:
        {// 项目
            //项目webview
            NSString *proString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROJECT_LIST_URL];
            [MobClick beginEvent:@"Project" label:@"众筹"];
        }
            break;
        case 101:
        {// 房地产
            //房地产webview
            NSString *fdcString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,REALTY_LIST_URL];
            [MobClick beginEvent:@"Project" label:@"房地产"];
        }
            break;
        case 102:
        {
            //抢福利webview
            NSString *fuliString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,ROB_WELFARE_LIST_URL];
            [MobClick beginEvent:@"Project" label:@"抢福利"];
        }
            break;
        default:
            break;
    }

}
-(void)refreshPage_Project:(NSNotification *)noti
{
    //点击 开始计时
    _sType = SearchNone;
    if (self.rightButton.isEnabled) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shaixuanDown.png"] forState:UIControlStateNormal];
    }else {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"GreyshaixuanDown.png"] forState:UIControlStateDisabled];
    }
    
    // 清空webview缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    });
    switch (_pType) {
        case 100:
        {// 项目
            UILabel *label100 = (UILabel *)[self.view viewWithTag:97809];
            label100.text = @"众筹";
            //项目webview
            NSString *proString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROJECT_LIST_URL];
            [MobClick event:@"Project" label:@"众筹"];
            [MobClick beginEvent:@"Project" label:@"众筹"];
            if ([[noti.userInfo objectForKey:@"key"] isEqualToString:@"1"]) {
                 [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:proString]]];
                break;
            }
            if (!self.refreshedPro) {
                [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:proString]]];
            }
            self.refreshedPro = YES;
        }
            break;
        case 101:
        {// 房地产
            UILabel *label100 = (UILabel *)[self.view viewWithTag:97809];
            label100.text = @"房地产";
            //房地产webview
            NSString *fdcString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,REALTY_LIST_URL];
            [MobClick event:@"Project" label:@"房地产"];
            [MobClick beginEvent:@"Project" label:@"房地产"];
            if ([[noti.userInfo objectForKey:@"key"] isEqualToString:@"1"]) {
                 [self.fdc_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fdcString]]];
                break;
            }
            if (!self.refreshedHouse) {
                [self.fdc_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fdcString]]];
            }
            self.refreshedHouse = YES;
        }
            break;
        case 102:
        {// 抢福利
            UILabel *label100 = (UILabel *)[self.view viewWithTag:97809];
            label100.text = @"抢福利";
            //抢福利webview
            NSString *fuliString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,ROB_WELFARE_LIST_URL];
            [MobClick event:@"Project" label:@"抢福利"];
            [MobClick beginEvent:@"Project" label:@"抢福利"];
            if ([[noti.userInfo objectForKey:@"key"] isEqualToString:@"1"]) {
                [self.fuli_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fuliString]]];
                break;
            }
            if (!self.refreshedWel) {
                 [self.fuli_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fuliString]]];
            }
            self.refreshedWel = YES;
        }
            break;
        default:
            break;
    }
    
}

-(void)projectshowLeftClick
{
    [self proShowLeft];
}
-(void)projectshowRightClick
{
    [self showRight];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pType = ProjectXiangmu;
    }
    return self;
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

#pragma mark  - disable -
-(void) closeUserInterface
{
    self.rootView.userInteractionEnabled = NO;
    self.topView.userInteractionEnabled = NO;
}
-(void) openUserInterface
{
    self.rootView.userInteractionEnabled = YES;
    self.topView.userInteractionEnabled = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
    [MobClick beginEvent:@"Project" label:@"众筹"];
    [MobClick beginEvent:@"Project" label:@"房地产"];
    [MobClick beginEvent:@"Project" label:@"抢福利"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [MobClick endEvent:@"Project" label:@"众筹"];
//    [MobClick endEvent:@"Project" label:@"房地产"];
//    [MobClick endEvent:@"Project" label:@"抢福利"];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
            [self.bar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.bar];
        }else{
            self.bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.bar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.bar];
        }
    }else{
        if (IOS_VERSION  >= 7.0) {
            self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
            [self.bar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.bar];
        }else{
            self.bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.bar setBackgroundImage: [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.bar];
        }
    }
    
    UIImage *lImage = [UIImage imageNamed:@"leftlast.png"];
    UIButton *button1=[[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, lImage.size.width, lImage.size.height)];
    [button1 setBackgroundImage:lImage forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(projectshowLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar addSubview:button1];
    
    UIImage  *rImage = [UIImage imageNamed:@"rightlast.png"];
    UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake(270, STATUS_HEIGHT, rImage.size.width, rImage.size.height)];
    [button2 setBackgroundImage:rImage forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(projectshowRightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bar addSubview:button2];
    //点击标签控制器tabbar=0的 ----项目------刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage_Project:) name:@"refreshPage_Project" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.content_view = [[UIView alloc]initWithFrame: CGRectMake(0, 64, 320, 568-64)];
            self.contentFrame = self.content_view.frame;
        }else{
            self.content_view = [[UIView alloc]initWithFrame: CGRectMake(0, 64, 320, 568-64-20)];
            self.contentFrame = self.content_view.frame;
        }
    }else{
        if (IOS_VERSION >= 7.0) {
            self.content_view = [[UIView alloc]initWithFrame: CGRectMake(0, 64, 320, 480-64)];
            self.contentFrame = self.content_view.frame;
        }else{
            self.content_view = [[UIView alloc]initWithFrame: CGRectMake(0, 64, 320, 480-64)];
            self.contentFrame = self.content_view.frame;
        }
    }
    [self.view addSubview:self.content_view];
    //发送   项目--房地产--抢福利之间  禁止滑动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUserInterface) name:@"closeUserInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openUserInterface) name:@"openUserInterface" object:nil];
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(90, STATUS_HEIGHT, 140, 44)];
    titleLabel4.font = [UIFont systemFontOfSize:22];
    titleLabel4.textColor = [UIColor whiteColor];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    titleLabel4.text = @"众筹";
    titleLabel4.tag = 97809;
    [self.bar addSubview:titleLabel4];
    UITapGestureRecognizer *_tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    [self.view addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    //监听通知中心请求响应划出左右菜单事件,消息名为showLeft，回调对象为当前对象，回调方法为showLeft:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proShowLeft) name:@"projectShowLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRight) name:@"showRight" object:nil];
    
    //监听滑动选中的按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnState:) name:@"selectBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnState:) name:@"clickBtn" object:nil];
    //接收筛选框通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult:) name:@"hudong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult1:) name:@"fabu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult2:) name:@"xingqu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult3:) name:@"queding" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult4:) name:@"sousuo" object:nil];
    //互动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult:) name:@"selectButton" object:nil];
    //发布
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult1:) name:@"selectButton1" object:nil];
    //感兴趣
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult2:) name:@"selectButton2" object:nil];
    //确定
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult3:) name:@"selectButton3" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult4:) name:@"selectButton4" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginCaculateTime:) name:@"BeginCaculate" object:nil];
    //修改navi名字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviName:) name:@"NavigationBarName" object:nil];
    
    //设置滑动菜单
    CGRect webViewFrame = CGRectMake(0, 0, self.content_view.frame.size.width,self.content_view.frame.size.height -44);
    if (IOS_VERSION >= 7.0) {
        CGRect topViewFrame = CGRectMake(0, IOS7_STATUS_BAR_HEGHT, 320, 45);
        self.topView = [[SVTopScrollView alloc] initWithFrame:topViewFrame];
    }else{
        CGRect topViewFrame = CGRectMake(0, -21, 320, 45);
        self.topView = [[SVTopScrollView alloc] initWithFrame:topViewFrame];
    }
    self.topView.tag = SVTopScrollViewTag;
    //间隔筛选按钮竖线
    UIImageView * smallImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(270, 0, 2, 42)];
    smallImageView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
    //横线
    UIImageView * smallImageView1  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 41, 320, 2)];
    smallImageView1.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
    [self.topView addSubview:smallImageView];
    [self.topView addSubview:smallImageView1];
    self.topView.backgroundColor =[UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];
    self.topView.nameArray = @[@"众筹", @"房地产", @"抢福利"];
    [self.content_view  addSubview:self.topView];
    
    CGRect rootViewFrame = CGRectZero;
    if (IOS_VERSION >= 7.0) {
        rootViewFrame = CGRectMake(0, 44, 320, 460);
        self.rootView = [[SVRootScrollView alloc] initWithFrame:rootViewFrame];
    }else{
        rootViewFrame = CGRectMake(0, 24, 320, 460);
        self.rootView = [[SVRootScrollView alloc] initWithFrame:rootViewFrame];
    }
    self.rootView.pagingEnabled = YES;
    self.rootView.backgroundColor = [UIColor clearColor];
    self.rootView.tag = SVRootScrollViewTag;
    [self.content_view addSubview:self.rootView];
    
    //项目webview
    NSString *proString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,PROJECT_LIST_URL];
//    self.pro_VC = [[WebViewController alloc] init];
//    self.pro_VC.view.frame = webViewFrame;
    self.pro_VC = [[WebViewController alloc] initWithURLString:proString andType:SHTLoadWebPagePro];
    self.pro_VC.view.frame = webViewFrame;
    
//    self.fdc_VC = [[WebViewController alloc] init];
//    self.fdc_VC.view.frame = webViewFrame;
//    self.fuli_VC = [[WebViewController alloc] init];
//    self.fuli_VC.view.frame = webViewFrame;
    //房地产webview
//    NSString *fdcString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,REALTY_LIST_URL];
    self.fdc_VC = [[WebViewController alloc] initWithURLString:nil andType:SHTLoadWebPageHouse];
    self.fdc_VC.view.frame = webViewFrame;
////    //抢福利webview
//    NSString *fuliString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,ROB_WELFARE_LIST_URL];
    self.fuli_VC = [[WebViewController alloc] initWithURLString:nil andType:SHTLoadWebPageWelfare];
    self.fuli_VC.view.frame = webViewFrame;
    
    [self.rootView initWithViews: @[self.pro_VC.view,self.fdc_VC.view,self.fuli_VC.view]];//
    [self.topView initWithNameButtons];
    
    [self creatButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Projectshaixuan:) name:@"ProjectshaixuanButton" object:nil];
    //当时刷新时只要求 项目，房地产刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFDC) name:@"refreshFDC" object:nil];
    // 刚开始的时候，没有做筛选
    _sType = SearchNone;
    [NSThread detachNewThreadSelector:@selector(analyzeUpdate) toTarget:self withObject:nil];
}
#pragma mark - analyzeUpdate
- (void)analyzeUpdate{
    [SharedApp analyzeUpdate];
}

-(void)Projectshaixuan:(NSNotification *) noti
{
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shaixuanDown"] forState:UIControlStateNormal];
    self.rightButton.selected = NO;
}

// 选择最新互动
-(void) slcResult:(NSNotification *) noti
{
    [MobClick event:@"ProSearch" label:@"最新互动"];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"BlueshaixuanDown"] forState:UIControlStateNormal];
    self.ppoverController.sType = SearchHudong;
    _sType = SearchHudong;
    NSLog(@"self.ppoverController: %@", self.ppoverController);
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.pro_VC setUrlstring:urlString];
    [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dict objectForKey:@"slcButton"];
    UILabel *titleLabel =(UILabel *)[self.view viewWithTag:97809];
    titleLabel.text = [btn titleForState:UIControlStateNormal];
}

// 选择最新发布
-(void) slcResult1:(NSNotification *) noti
{
    [MobClick event:@"ProSearch" label:@"最新发布"];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"YellowshaixuanDown"] forState:UIControlStateNormal];
    self.ppoverController.sType = SearchFabu;
    _sType = SearchFabu;
    
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.pro_VC setUrlstring:urlString];
    [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dict objectForKey:@"slcButton1"];
    UILabel *titleLabel =(UILabel *)[self.view viewWithTag:97809];
    titleLabel.text = [btn titleForState:UIControlStateNormal];
}
//选择最感兴趣
-(void) slcResult2:(NSNotification *) noti
{
    [MobClick event:@"ProSearch" label:@"最感兴趣"];
    
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"PinkshaixuanDown"] forState:UIControlStateNormal];
    self.ppoverController.sType = SearchGanxingqu;
    _sType = SearchGanxingqu;
    
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.pro_VC setUrlstring:urlString];
    [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dict objectForKey:@"slcButton2"];
    UILabel *titleLabel =(UILabel *)[self.view viewWithTag:97809];
    titleLabel.text = [btn titleForState:UIControlStateNormal];
}
//选择 确定按钮
-(void) slcResult3:(NSNotification *) noti
{
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shaixuanDown.png"] forState:UIControlStateNormal];
    self.ppoverController.sType = SearchNone;
    _sType = SearchNone;
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    [MobClick event:@"ProSearch" label:[NSString stringWithFormat:@"筛选:%@",urlString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.pro_VC setUrlstring:urlString];
    [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
//    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UILabel *titleLabel =(UILabel *)[self.view viewWithTag:97809];
    titleLabel.text = @"众筹";
}

-(void) slcResult4:(NSNotification *) noti
{
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"BlueshaixuanDown"] forState:UIControlStateNormal];
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //搜索关键词
    NSArray *arr = [urlString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"key="]];
    NSRange range = [urlString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"key="] options:NSCaseInsensitiveSearch];
    [MobClick event:@"ProSearch" label:[NSString stringWithFormat:@"搜索关键词:%@",[urlString substringWithRange:range]]];
    
    [self.pro_VC setUrlstring:urlString];
    [self.pro_VC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dict objectForKey:@"slcButton4"];
    UILabel *titleLabel =(UILabel *)[self.view viewWithTag:97809];
    titleLabel.text = [btn titleForState:UIControlStateNormal];
}
-(void) changeBtnState:(NSNotification *) noti
{
    NSDictionary *dic = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dic objectForKey:@"slcBtn"];
    UILabel *label1000 = (UILabel *)[self.view viewWithTag:97809];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Project" object:self userInfo:@{@"key": @"2"}];

    switch (btn.tag) {
        case 100: // 项目
            if (_sType == SearchHudong) {
                label1000.text = @"最新互动";
            }else if (_sType == SearchFabu) {
                label1000.text = @"最新发布";
            }else if (_sType == SearchGanxingqu) {
                label1000.text = @"最感兴趣";
            }else {
                _pType = ProjectXiangmu;
                label1000.text = @"众筹";
            }
            self.rightButton.enabled = YES;
            break;
        case 101: // 房地产
            _pType = ProjectFangdichan;
            label1000.text = @"房地产";
            self.rightButton.enabled = NO;
            [self.rightButton setBackgroundImage:[UIImage imageNamed:@"GreyshaixuanDown.png"] forState:UIControlStateDisabled];
            break;
        case 102: // 抢福利
            _pType = ProjectQiangfuli;
            label1000.text = @"抢福利";
            self.rightButton.enabled = NO;
            [self.rightButton setBackgroundImage:[UIImage imageNamed:@"GreyshaixuanDown.png"] forState:UIControlStateDisabled];
            break;
        default:
            break;
    }
}
//创建筛选的右按钮
-(void)creatButton
{
    self.rightButton = [[UIButton alloc] init];
    self.rightButton.frame = CGRectMake(267,0, 58, 40);
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shaixuanDown"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(ProshowPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 1000099;
    self.rightButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.topView  addSubview:self.rightButton];
}
-(void)ProshowPopover:(id)sender forEvent:(UIEvent*)event
{
    if (_didShowedRight) {
        return;
    }
    if (_sType == SearchHudong) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"BlueshaixuanUp.png"] forState:UIControlStateNormal];
    }else if (_sType == SearchFabu) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"YellowshaixuanUp"] forState:UIControlStateNormal];
    }else if (_sType == SearchGanxingqu) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"PinkshaixuanUp"] forState:UIControlStateNormal];
    }else if (_sType == SearchNone) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shaixuanUp"] forState:UIControlStateNormal];
    }
    ProjectAlertTableViewController *tableViewController = [[ProjectAlertTableViewController alloc]initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0, 0, 320, 280);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    popoverController.topScrollView = _topView;
    popoverController.cornerRadius = 0;
    popoverController.titleText = nil;
    popoverController.popoverBaseColor = [UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];
    popoverController.popoverGradient= NO;
    popoverController.sType = _sType;
    [popoverController showPopoverWithTouch:event];
    tableViewController.tsPopViewController = popoverController;
    self.ppoverController = popoverController;
}
-(void) hideNavi
{
    self.bar.hidden = YES;
    self.topView.hidden = YES;
    self.content_view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    self.rootView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void) showNavi
{
    self.topView.hidden = NO;
    self.bar.hidden = NO;
    self.content_view.frame = self.contentFrame;
    self.rootView.frame = self.rootViewFrame;
}
-(void) proShowLeft
{
    if (!_didShowedLeft) {
        _didShowedLeft = YES;
        
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController showLeftViewController];
        //解决不能点击最后一行的bug
        UIViewController *v1 = [[UIViewController alloc] init];
        v1.view.frame = [UIScreen mainScreen].bounds;
        v1.view.backgroundColor = [UIColor redColor];
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController presentViewController:v1 animated:NO completion:^{}];
        [v1 dismissViewControllerAnimated:NO completion:^{}];
    }else {
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        _didShowedLeft = NO;
    }
}

-(void) showRight
{
    if (!_didShowedRight) {
        _didShowedRight = YES;
        
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController showRightViewController];
        //解决不能点击最后一行的bug
        UIViewController *v1 = [[UIViewController alloc] init];
        v1.view.frame = [UIScreen mainScreen].bounds;
        v1.view.backgroundColor = [UIColor redColor];
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController presentViewController:v1 animated:NO completion:^{}];
        [v1 dismissViewControllerAnimated:NO completion:^{}];
    }else {
        [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
        
        _didShowedRight = NO;
    }
}
-(void) closeSideBar
{
    [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void) refreshFDC
{
    [self.fdc_VC.webView reload];
}
- (void)changeNaviName:(NSNotification *)noti{
    //看是否需要
//    NSLog(@"%@",noti.object);
//    for (UIView *view in self.bar.subviews) {
//        if ([view isKindOfClass:[UILabel class]]) {
//            [view removeFromSuperview];
//        }
//    }
//    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(90, STATUS_HEIGHT, 140, 44)];
//    titleLabel4.font = [UIFont systemFontOfSize:22];
//    titleLabel4.textColor = [UIColor whiteColor];
//    titleLabel4.backgroundColor = [UIColor clearColor];
//    titleLabel4.textAlignment = NSTextAlignmentCenter;
//    titleLabel4.text = @"众筹";
//    titleLabel4.tag = 97809;
//    [self.bar addSubview:titleLabel4];
}

@end
