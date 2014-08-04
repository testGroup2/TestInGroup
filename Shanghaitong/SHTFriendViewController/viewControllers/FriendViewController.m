//
//  RViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-23.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "FriendViewController.h"
#import "ResourceSliderViewController.h"
#import "ResourceAlertTableViewController.h"
#import "FriendTableViewCell.h"
#import "FriendModel.h"
#define searchBarHeight 44

@interface FriendViewController () <UITextFieldDelegate,TSPopoverControllerDelegate>

@property (nonatomic) CGRect rect;
@property (nonatomic) CGRect contentFrame;
@property (strong, nonatomic)   UITextField *sTextField;

@property (strong, nonatomic)   UITableView *friendTable;
@property (strong, nonatomic)   NSMutableArray *friendArray;
@end

@implementation FriendViewController
-(void)refreshPage_Resource
{
    _rType = SearchResouceNone;
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
}
#pragma mark - LifeCycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendArray = [[NSMutableArray alloc]init];
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    UIImage *lImage = [UIImage imageNamed:@"leftlast.png"];
    self.navigationView.leftButton.frame = CGRectMake(0, STATUS_HEIGHT, lImage.size.width, lImage.size.height);
    self.navigationView.rightButton.frame = CGRectMake(270, STATUS_HEIGHT + 7, 39, 26);
    [self.navigationView.leftButton setImage:lImage forState:UIControlStateNormal];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.text = @"海友";
    
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
    //接受隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavi) name:@"hideNavi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavi) name:@"showNavi" object:nil];
    // 资源搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slcResult4:) name:@"resource_sousuo" object:nil];
    
    // 搜索框
    UIView *sBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height, 320, 50)];
    [sBgView setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    [sBgView setBackgroundColor:[AppTools colorWithHexString:@"#4B5970"]];
    [self.view addSubview:sBgView];
    
    self.sTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 260, 30)];
    self.sTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.sTextField.backgroundColor = [UIColor whiteColor];
    
    NSString * string =[NSString stringWithFormat:@" 搜索(行业、地区、资源等，模糊查找)"];
    self.sTextField.font =[UIFont systemFontOfSize:13];
    //placehoder颜色
    UIColor *  color = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.sTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
    self.sTextField.delegate = self;
    [sBgView addSubview:self.sTextField];
    
    UIImage *sImage = [UIImage imageNamed:@"search.png"];
    UIButton *btnsearch = [[UIButton alloc] initWithFrame:CGRectMake(280, self.sTextField.frame.origin.y+2, 25, 25)];
    [btnsearch setBackgroundImage:sImage forState:UIControlStateNormal];
    btnsearch.tag = 704;
    [btnsearch addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [sBgView addSubview:btnsearch];
    
    
    self.friendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationView.frame.size.height + 50, self.contentFrame.size.width, self.contentFrame.size.height - 50)];
    self.friendTable.delegate = self;
    self.friendTable.dataSource = self;
    self.friendTable.separatorStyle = UITableViewCellSelectionStyleNone;
    self.friendTable.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
    [self.view addSubview:self.friendTable];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX51];
    //    self.webViewController = [[WebViewController alloc] initWithURLString:urlString andType:SHTLoadWebPageResource];
    //最新资源
    NSString *proString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX60];
    //    self.Res0_VC = [[WebViewController alloc] initWithURLString:proString andType:SHTLoadWebPageResource];
    //最新感兴趣
    NSString *fdcString  = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX61];

    // 刚开始的时候，没有做筛选
    _rType = SearchResouceNone;
    UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    rswip.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.webViewController.webView addGestureRecognizer:rswip];
    UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    lswip.direction = UISwipeGestureRecognizerDirectionLeft;
    //    [self.webViewController.webView addGestureRecognizer:lswip];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark -
-(void) closeUserInterface
{
//    self.webViewController.webView.userInteractionEnabled = NO;
}
-(void) openUserInterface
{
//    self.webViewController.webView.userInteractionEnabled = YES;
}
#pragma mark - search
//最新资源
-(void) ResouceslcResul0:(NSNotification *) noti
{
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResBlueDown.png"] forState:UIControlStateNormal];
    self.ppoverController.rType = SearchZiyuan;
    _rType= SearchZiyuan;
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.webViewController setUrlstring:urlString];
//    [self.webViewController loadPage];
    NSDictionary *dict = (NSDictionary *) noti.userInfo;
    UIButton *btn = (UIButton *)[dict objectForKey:@"ResslcButton"];
    UILabel * label = (UILabel *)[self.view viewWithTag:467974];
    label.text = [btn titleForState:UIControlStateNormal];
//    [self.resouceNavbar addSubview:label];
}
//最感兴趣
-(void) ResouceslcResul1:(NSNotification *) noti
{
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResYellowDown.png"] forState:UIControlStateNormal];
    
    self.ppoverController.rType = SearchResouceGanxingqu;
    _rType= SearchResouceGanxingqu;
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.webViewController setUrlstring:urlString];
//    [self.webViewController loadPage];
//    UILabel * label = (UILabel *)[self.view viewWithTag:467974];
//    label.text = @"最感兴趣";
//    [self.resouceNavbar addSubview:label];
}
//资源的确定按钮
-(void) ResouceslcResul:(NSNotification *) noti
{
    UIButton * button = (UIButton *)[self.view viewWithTag:9654];
    [button setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
    self.ppoverController.rType = SearchResouceNone;
    _rType = SearchResouceNone;
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
-(void)Resouceshaixuan:(NSNotification *) noti
{
    UIButton * btn = (UIButton *)[self.view viewWithTag:9654];
    [btn setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
}

#pragma mark - NavigationViewDelegate
-(void) leftButtonClick
{
    if (!_didShowedLeft) {
        _didShowedLeft = YES;
        [[ResourceSliderViewController sharedSliderController] showLeftViewController];
        //解决不能点击最后一行的bug
        UIViewController *v1 = [[UIViewController alloc] init];
        v1.view.frame = [UIScreen mainScreen].bounds;
        v1.view.backgroundColor = [UIColor redColor];
        [[ResourceSliderViewController sharedSliderController] presentViewController:v1 animated:NO completion:^{}];
        [v1 dismissViewControllerAnimated:NO completion:^{}];
        
    }else {
        _didShowedLeft = NO;
        [[ResourceSliderViewController sharedSliderController] closeSideBar];
    }
}
-(void) rightButtonClick
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
//    [popoverController showPopoverWithTouch:event];
    [popoverController showPopoverWithTouch:UIControlStateNormal];
    //把popverController的指针给tableViewController
    popoverController.rType = _rType;
    tableViewController.tsPopViewController = popoverController;
    self.ppoverController = popoverController;
}
#pragma mark -
-(void) slcResul:(NSNotification *) noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.webViewController setUrlstring:urlString];
//    [self.webViewController loadPage];
}

-(void) slcResult4:(NSNotification *) noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *urlString = [dic objectForKey:@"urlString"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.webViewController setUrlstring:urlString];
//    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void) hideNavi
{
//    self.webViewController.view.frame = self.rect;
}
-(void) showNavi
{
//    self.webViewController.view.frame = self.contentFrame;
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

-(void)clickSearch
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString * lastString2;
    lastString2 = [NSString stringWithFormat:@"key=%@",self.sTextField.text];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX17,lastString2];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    [self.webViewController setUrlstring:urlString];
//    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    self.sTextField.text = @"";
}
#pragma mark - TSPopViewcontrollerDelgate
- (void)ChangeRightImageWithType:(resouceSearchType)type{
            if (_rType == SearchZiyuan){
                [self.navigationView.rightButton setImage:[UIImage imageNamed:@"ResBlueDown.png"] forState:UIControlStateNormal];
            }else if (_rType == SearchResouceGanxingqu){
                [self.navigationView.rightButton setImage:[UIImage imageNamed:@"ResYellowDown.png"] forState:UIControlStateNormal];
            }else if (_rType == SearchResouceNone){
                [self.navigationView.rightButton setImage:[UIImage imageNamed:@"ResouceshaixuanDown.png"] forState:UIControlStateNormal];
            }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifer = @"cell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewCell" owner:self options:nil] lastObject];
    }
    FriendModel *model = [[FriendModel alloc]init];
    model.pid = @"1";
    model.uid = @"123";
    model.name = @"徐强";
    model.position = @"总经理 ";
    model.resource = @"我有一块地皮 要卖 要要的没有啊";
    model.area = @"北京";
    model.industry = @"房地产";
    model.lastUpdate = @"08-08 12:00+更新";
    model.intrestedNum = @"10";
    [cell configureCellWithFriend:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //do sth
}
@end
