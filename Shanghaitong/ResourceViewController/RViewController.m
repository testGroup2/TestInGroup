//
//  RViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-23.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "RViewController.h"
#import "ResourceSliderViewController.h"
#import "ResourceAlertTableViewController.h"
#import "SearchViewController.h"
#import "SearchView.h"
#define searchBarHeight 44

@interface RViewController () <UITextFieldDelegate,TSPopoverControllerDelegate,SearchViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic)  WebViewController *Res0_VC;
@property (strong, nonatomic)  WebViewController *Res1_VC;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic,strong) SearchView *searchView;
@property (strong, nonatomic)   UITextField *sTextField;
@property (strong, nonatomic)  UISearchBar *searchBar;
@property (strong , nonatomic) UIView *sBgView;
@property (strong, nonatomic) UIControl *searchBarControl;
@property (strong, nonatomic) UIButton *cacleBtn;
@end

@implementation RViewController
-(void)refreshPage_Resource
{
    _rType = SearchResouceNone;
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];

//    UILabel * label = (UILabel *)[self.view viewWithTag:467974];
//    label.text = @"海友";
//    [self.resouceNavbar addSubview:label];
    self.navigationView.titleLabel.text = @"海友";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX51];
    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void) leftButtonClick
{
    if (!_didShowedLeft) {
        [self closeUserInterface];
        _didShowedLeft = YES;
        [[ResourceSliderViewController sharedSliderController] showLeftViewController];
        //解决不能点击最后一行的bug
        UIViewController *v1 = [[UIViewController alloc] init];
        v1.view.frame = [UIScreen mainScreen].bounds;
        v1.view.backgroundColor = [UIColor redColor];
        [[ResourceSliderViewController sharedSliderController] presentViewController:v1 animated:NO completion:^{}];
        [v1 dismissViewControllerAnimated:NO completion:^{}];
        
    }else {
        [self openUserInterface];
        _didShowedLeft = NO;
        [[ResourceSliderViewController sharedSliderController] closeSideBar];
    }
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void) closeUserInterface
{
//    self.webViewController.webView.userInteractionEnabled = NO;
    self.searchBarControl.userInteractionEnabled = NO;
    self.searchBar.userInteractionEnabled = NO;
}
-(void) openUserInterface
{
//    self.webViewController.webView.userInteractionEnabled = YES;
    self.searchBarControl.userInteractionEnabled = YES;
    self.searchBar.userInteractionEnabled = YES;
}
#pragma mark - SearchRes
//最新资源
-(void) ResouceslcResul0:(NSNotification *) noti
{
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResBlueDown.png"] forState:UIControlStateNormal];
    self.ppoverController.rType = SearchZiyuan;
    _rType= SearchZiyuan;
//    NSDictionary *dic = noti.userInfo;
//    NSString *urlString = [dic objectForKey:@"urlString"];
     NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX59];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController loadPage];
    self.navigationView.titleLabel.text = @"最新资源";
     [MobClick event:@"search" label:[NSString stringWithFormat:@"最新资源"]];
//    NSDictionary *dict = (NSDictionary *) noti.userInfo;
//    UIButton *btn = (UIButton *)[dict objectForKey:@"ResslcButton"];
//    UILabel * label = (UILabel *)[self.view viewWithTag:467974];
//    label.text = [btn titleForState:UIControlStateNormal];
//    [self.resouceNavbar addSubview:label];
}
//最感兴趣
-(void) ResouceslcResul1:(NSNotification *) noti
{
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResYellowDown.png"] forState:UIControlStateNormal];
    
    self.ppoverController.rType = SearchResouceGanxingqu;
    _rType= SearchResouceGanxingqu;
//    NSDictionary *dic = noti.userInfo;
//    NSString *urlString = [dic objectForKey:@"urlString"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX60];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController loadPage];
     self.navigationView.titleLabel.text = @"最感兴趣";
    [MobClick event:@"search" label:[NSString stringWithFormat:@"最感兴趣"]];
//    UILabel * label = (UILabel *)[self.view viewWithTag:467974];
//    label.text = @"最感兴趣";
//    [self.resouceNavbar addSubview:label];
}
//资源的确定按钮
-(void) ResouceslcResul:(NSNotification *) noti
{
    
    //取出所有cell中的btn 实现单选
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
    self.ppoverController.rType = SearchResouceNone;
    _rType = SearchResouceNone;
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"url"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController loadPage];
    [self hiddenSearchView];
    
}
-(void)Resouceshaixuan:(NSNotification *) noti
{
    UIButton * btn = (UIButton *)[self.view viewWithTag:9654];
    [btn setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
}
#pragma mark - lifeCycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginEvent:@"Resource"];
    
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
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:NO];
    UIImage *lImage = [UIImage imageNamed:@"leftlast.png"];
    self.navigationView.leftButton.frame = CGRectMake(0, STATUS_HEIGHT, lImage.size.width, lImage.size.height);
    self.navigationView.rightButton.frame = CGRectMake(270, STATUS_HEIGHT + 7, 39, 26);
    [self.navigationView.leftButton setImage:lImage forState:UIControlStateNormal];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.text = @"海友";
    
    self.cacleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cacleBtn setTitleColor:[AppTools colorWithHexString:@"#bbb9b9"] forState:UIControlStateNormal];
    [self.cacleBtn addTarget:self action:@selector(hiddenSearchView) forControlEvents:UIControlEventTouchUpInside];
    self.cacleBtn.tag = 1000;
    self.cacleBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.cacleBtn.frame = CGRectMake(270, STATUS_HEIGHT + 3, 50, 40);
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage_Resource) name:@"refreshPage_Resource" object:nil];
    //接收关闭UserInterface通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUserInterface) name:@"closeUserInterface" object:nil];
    //openUserInterface
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openUserInterface) name:@"openUserInterface" object:nil];
    
    //接收筛选框通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul0:) name:@"ziyuan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul1:) name:@"ganxingqu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul0:) name:@"ResslcButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul1:) name:@"ResslcButton1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul:) name:@"ResslcButton2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResouceslcResul:) name:@"Resoucequeding" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Resouceshaixuan:) name:@"shaixuanButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initTitle) name:@"makeOriginTitle" object:nil];
    //接受隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavi) name:@"hideNavi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavi) name:@"showNavi" object:nil];
    // 资源搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult4:) name:@"resource_sousuo" object:nil];
    
    // 搜索框
    self.sBgView = [[UIView alloc]initWithFrame:CGRectMake(0, ORIGIN_Y, 320, 44)];
    [self.sBgView setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    [self.sBgView setBackgroundColor:[AppTools colorWithHexString:@"#4B5970"]];
    [self.view addSubview:self.sBgView];

    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, ORIGIN_Y, 320, 44)];
    self.searchBar.delegate = self;
    if (IOS_VERSION>=7.0) {
        self.searchBar.barTintColor = [AppTools colorWithHexString:@"#4B5970"];
    }
    self.searchBar.placeholder = @"搜索(行业、地区、资源等,模糊查找)";
    [self.view addSubview:self.searchBar];
    
    self.searchBarControl = [[UIControl alloc]init];
    self.searchBarControl.frame = self.searchBar.frame;
    [self.searchBarControl addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBarControl];
    
    
    if (IOS_VERSION >= 7.0) {
        self.contentFrame = CGRectMake(0, 64 + searchBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 64 - searchBarHeight);
        self.rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        CGRect webViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 44);
        self.Res0_VC.view.frame = webViewFrame;
        self.Res1_VC.view.frame = webViewFrame;
        self.sBgView.frame = CGRectMake(0, 64, 320, searchBarHeight);
    }else{
        self.contentFrame = CGRectMake(0, 44 + searchBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 44 - searchBarHeight);
        self.rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        CGRect webViewFrame = CGRectMake(0, -21, self.view.frame.size.width,self.view.frame.size.height - 24);
        self.Res0_VC.view.frame = webViewFrame;
        self.Res1_VC.view.frame = webViewFrame;
        self.sBgView.frame = CGRectMake(0, 64, 320, searchBarHeight);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX51];
    self.webViewController = [[WebViewController alloc] initWithURLString:urlString andType:SHTLoadWebPageResource];
    //最新资源
    NSString *proString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX60];
    self.Res0_VC = [[WebViewController alloc] initWithURLString:proString andType:SHTLoadWebPageResource];
    //最新感兴趣
    NSString *fdcString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX61];
    self.Res1_VC = [[WebViewController alloc] initWithURLString:fdcString andType:SHTLoadWebPageResource];
    
    self.webViewController.view.frame = self.contentFrame ;
    [self.view addSubview:self.webViewController.view];

    // 刚开始的时候，没有做筛选
    _rType = SearchResouceNone;
    UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    rswip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webViewController.webView addGestureRecognizer:rswip];
    UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    lswip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webViewController.webView addGestureRecognizer:lswip];
    
    self.searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, (IOS_VERSION>=7.0?kScreenHeight:kScreenHeight - 20), kScreenWidth,kScreenHeight - ORIGIN_Y)];
    self.searchView.backgroundColor = [AppTools colorWithHexString:@"#e1e1e1"];
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
}
#pragma mark - NetRequest Hot Tag
- (void)loadSearchHotTag{
    NSData *aData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kHotTagFileName]];
    NSDictionary *hotTags = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    NSString *time = [hotTags objectForKey:@"timeStamps"];
    NSLog(@"%f--%f",[[AppTools getNowDateTimeStamp] doubleValue], [time doubleValue]);
    if( [[hotTags objectForKey:@"value"] count] > 0){
        if (([[AppTools getNowDateTimeStamp] integerValue]  - [time integerValue] <= kCacheTimeout)) {
            [self.searchView configureHotLabelData:[hotTags objectForKey:@"value"] andNormalData:nil];
        }
        else{
            [NETWORK getHotTagWithRequestResult:^(NSString *response) {
                NSArray *hotTags = [[response objectFromJSONString] objectForKey:@"data"];
                NSDictionary *dict = @{@"timeStamps":[AppTools getNowDateTimeStamp],
                                       @"value":hotTags};
                NSString *hotTagFilePath = [[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kHotTagFileName];
                [[NSKeyedArchiver archivedDataWithRootObject:dict] writeToFile:hotTagFilePath atomically:YES];
                [self.searchView configureHotLabelData:hotTags andNormalData:nil];
            }];
        }
    }
    else{
        [NETWORK getHotTagWithRequestResult:^(NSString *response) {
            NSArray *hotTags = [[response objectFromJSONString] objectForKey:@"data"];
            NSDictionary *dict = @{@"timeStamps":[AppTools getNowDateTimeStamp],
                                   @"value":hotTags};
            NSString *hotTagFilePath = [[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kHotTagFileName];
            [[NSKeyedArchiver archivedDataWithRootObject:dict] writeToFile:hotTagFilePath atomically:YES];
            [self.searchView configureHotLabelData:hotTags andNormalData:nil];
        }];
    }
    
}
#pragma mark - beginSearch
- (void)search{
    [self.view bringSubviewToFront:self.searchView];
     self.navigationView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
    [self loadSearchHotTag];
    [self.searchView clearTagColor];
     [SharedApp.mainTabBarViewController.view sendSubviewToBack:SharedApp.mainTabBarViewController.tabBar];
    //统计进搜索页次数
    [MobClick event:@"search"];
    [UIView animateWithDuration:.3f animations:^{
         self.searchView.frame = CGRectMake(0, ORIGIN_Y, kScreenWidth,kScreenHeight - ORIGIN_Y);
        [self addSearchView];
    } completion:^(BOOL finished) {
       [self.searchBar becomeFirstResponder];
    }];
}

- (void)addSearchView{
    self.searchBar.frame = CGRectMake(0, STATUS_HEIGHT, 280, 44);
    self.searchBar.delegate = self;
    [self.navigationView addSubview:self.searchBar];
    [self.navigationView addSubview:self.cacleBtn];
}

- (void)removeSearchView{
    for (UIView *view in self.navigationView.subviews) {
        if([view isKindOfClass:[UISearchBar class]] || view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
    [SharedApp.mainTabBarViewController.view bringSubviewToFront:SharedApp.mainTabBarViewController.tabBar];
    [self.view addSubview:self.searchBar];
    self.searchBar.text = @"";
    self.searchBar.frame = CGRectMake(0, ORIGIN_Y, 320, 44);
    if (IOS_VERSION >= 7.0) {
        self.searchBar.barTintColor = [AppTools colorWithHexString:@"#4B5970"];
    }
    self.searchBarControl.frame = self.searchBar.frame;
    [self.view insertSubview:self.searchBarControl aboveSubview:self.searchBar];
}

- (void)hiddenSearchView{
    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar"]];
    [UIView animateWithDuration:.3f animations:^{
        self.searchView.center = CGPointMake(160,kScreenHeight + self.searchView.frame.size.height/2);
        [self removeSearchView];
    } completion:^(BOOL finished) {
        
    }];

}
#pragma mark -
-(void)rshowPopover:(id)sender forEvent:(UIEvent*)event
{
    if (_rType == SearchZiyuan) {
        [self.rightBtn setImage:[UIImage imageNamed:@"ResBlueUp.png"]forState:UIControlStateNormal];
    }else if (_rType == SearchResouceGanxingqu) {
        [self.rightBtn setImage:[UIImage imageNamed:@"ResYellowUp.png"]forState:UIControlStateNormal];
    }else if (_rType == SearchResouceNone) {
        [self.rightBtn setImage:[UIImage imageNamed:@"ResouceshaixuanUp.png"]forState:UIControlStateNormal];
    }
    ResourceAlertTableViewController *tableViewController = [[ResourceAlertTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 200);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    popoverController.resouceViewController = self;
    popoverController.delegate = self;
    popoverController.popoverBaseColor = [UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverWithTouch:event];
    //把popverController的指针给tableViewController
    popoverController.rType = _rType;
    tableViewController.tsPopViewController = popoverController;
    self.ppoverController = popoverController;
}

- (void)ChangeRightImageWithType:(resouceSearchType)type{
    UIButton *btn = (UIButton *)[self.resouceNavbar viewWithTag:9654];
    if (_rType == SearchZiyuan){
        [btn setImage:[UIImage imageNamed:@"ResBlueDown.png"] forState:UIControlStateNormal];
    }else if (_rType == SearchResouceGanxingqu){
        [btn setImage:[UIImage imageNamed:@"ResYellowDown.png"] forState:UIControlStateNormal];
    }else if (_rType == SearchResouceNone){
        [btn setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 
-(void) slcResul:(NSNotification *) noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController loadPage];
}

-(void) slcResult4:(NSNotification *) noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViewController setUrlstring:urlString];
    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void) hideNavi
{
    self.webViewController.view.frame = self.rect;
}
-(void) showNavi
{
    self.webViewController.view.frame = self.contentFrame;
}

- (void)initTitle{
    self.navigationView.titleLabel.text = @"海友";
}
#pragma mark - Target Action -
- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leftButtonClick];
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_didShowedLeft) {
            [((ResourceSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:1]).viewController)) closeSideBar];
            _didShowedLeft = NO;
        }
    }
}

-(void)clickSearchWithKeyword:(NSString *)key andTag:(NSString *)tag
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString * lastString2;
    if ([tag isEqualToString:@"1"]) {
        lastString2 = [NSString stringWithFormat:@"key=%@&tag=1",key];
    }
    else{
        lastString2 = [NSString stringWithFormat:@"key=%@",key];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX17,lastString2];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self.webViewController setUrlstring:urlString];
//    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.webViewController loadPage];
    [self hiddenSearchView];
}
#pragma mark - SearchViewDelegate
- (void)sendResignFirstResponder{
    [self.searchBar resignFirstResponder];
}
- (void)sendBackWithKeyword:(NSString *)keyword andTag:(NSString *)tag{
    [MobClick event:@"search" label:[NSString stringWithFormat:@"热门标签:%@",keyword]];
    [self clickSearchWithKeyword:keyword andTag:@"1"];
    [self hiddenSearchView];
    NSLog(@"%f",self.webViewController.webView.frame.size.height);
}

- (void)searchDirectWithType:(NSInteger)type{
    if (type == 0) {
        [self ResouceslcResul0:nil];
    }
    else if (type == 1){
        [self ResouceslcResul1:nil];
    }
    [self hiddenSearchView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [MobClick event:@"search" label:[NSString stringWithFormat:@"关键词:%@",searchBar.text]];
    
    [self clickSearchWithKeyword:searchBar.text andTag:nil];
}
@end
