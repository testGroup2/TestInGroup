//
//  CircleViewController.m
//  商海通
//
//  Created by Liv on 14-3-22.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

//#import "CircleListViewController.h"

#import "ShowPageViewController.h"
#import "ThemeListCell.h"
#import "ChatViewController.h"
#import "circleDetailViewController.h"
#import "AddCicleViewController.h"
#import "CircleAbstractInfo.h"
#import "SHTRefreshTableFooterView.h"
#import "SHTRefreshTableHeaderView.h"
#import "ContributeToCicleViewController.h"
#import "userItemInformation.h"
#import "CicleListViewController.h"
#import "Audio.h"
#import "MemberInfo.h"
#import "ChatMessageInfo.h"
#import "NewMessagePromptView.h"
#import "GTMBase64.h"
#import "ASIFormDataRequest.h"

@interface CircleListViewController ()<ThemeListCellDelegate,SHTRefreshTableDelegate,ContributeToCicleViewControllerDelegate,CircleDetailViewControllerDelegate,ChatViewControllerDelegate,ContributeToCicleViewControllerDelegate>
{
    BOOL _reloading;
}
@property (strong,nonatomic) SHTRefreshTableHeaderView *refreshHeaderView;
@property (strong,nonatomic) SHTRefreshTableFooterView *refreshFooterView;
@property (nonatomic) NSInteger subcribeIndexId;
@property (nonatomic) BOOL haveNoData;
@property (nonatomic,strong) NSString * index;
@property (nonatomic,strong) NSMutableArray *circleDataSourceArray;
@property (nonatomic,strong) ChatViewController *chatViewController;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isLast;
@property (nonatomic,strong) NSMutableArray *buffArray;

@property (nonatomic,strong) NSString *circleAdminID;
@property (nonatomic) BOOL isJudgeTabBarRedPoint;
@property (nonatomic,strong) NSString *notReadThemeId;
@property (nonatomic,assign) BOOL canInsert;
@property (nonatomic,assign) BOOL haveNotReadMsg;

@end
@implementation CircleListViewController

#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)backPageType:(NSInteger)type{
    self.pageType = type;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SharedApp.mainTabBarViewController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    if ([self.circleAdminID isKindOfClass:[NSNumber class]]) {
        self.circleAdminID = [NSString stringWithFormat:@"%@",self.circleAdminID];
    }
    if ((self.pageType != 2 && self.pageType != 1)||[self.circleAdminID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
        [self reloadData];
    }
    self.circleAdminID = nil;
    [MobClick beginEvent:@"CircleList"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)refreshViewController{
    [self showNetworkAnimation];
    [self refreshView];
}
- (void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getThemeListUnreadMsg:)
                                                 name:@"kGetThemeListUnreadMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getOtherUnreadMsg:)
                                                 name:@"kGetThemeListOtherUnreadMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushMsg:) name:@"kGetPushMsgNoti" object:nil];
}
- (void)getPushMsg:(NSNotification *)noti{
    [self reloadData];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageType = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewController) name:@"refreshPage_Circle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvChangeCircleNameNoti:) name:@"kChangeCircleName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMemberDele:) name:@"kPushMessageCircleMumberDele" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvAddSelfToCircle:) name:@"kPushMessageCircleCircleAddPeople" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleCircleTheme) name:@"kPushMessageDeleCircleTheme" object:nil];
    //将更新时间存本地userdefaults
    self.gloableUptime = [[NSUserDefaults standardUserDefaults] objectForKey:@"gloable_uptime"];
    //初始化数据源
    self.circleDataSourceArray = [[NSMutableArray alloc]init];
    self.listArray = [[NSMutableArray alloc]init];
    self.buffArray = [[NSMutableArray alloc]init];
    //navigationbar
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    [self.navigationView.leftButton setImage:[UIImage imageNamed:@"group_talk"] forState:UIControlStateNormal];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"rightEditBtn"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.text = @"圈子";
    
    //tableView
    self.circleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height) style:UITableViewStylePlain];
    self.circleTable.delegate = self;
    self.circleTable.dataSource = self;
    self.circleTable.showsVerticalScrollIndicator = NO;
    self.circleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.circleTable];
    [self createHeaderView];
    self.gloableUptime = [[NSUserDefaults standardUserDefaults] objectForKey:@"gloable_uptime"];
    
    //加载滚动动画
    [self showNetworkAnimation];
    [self.view bringSubviewToFront:self.networkActivity];
    [self loadData];
    [self createHeaderView];
    [self.circleTable reloadData];
    self.guidButton.hidden = YES;
}
#pragma mark - loadData
- (void)reloadData{
    [self.buffArray removeAllObjects];
    [self.listArray removeAllObjects];
    [DATABASE creatCircleThemeTable];
    self.listArray = [DATABASE fetchCircleTheme];
    //若数据库中有数据，加头视图
    if (self.listArray.count > 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        headView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableHeaderView = headView;
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        footView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableFooterView = footView;
    }
    [NETWORK  requestCircleListWithUptime:self.gloableUptime requestResult:^(NSString *respose) {
        if ([respose isEqualToString:@"-2"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
            [self.circleTable reloadData];
        }
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
            [self.circleTable reloadData];
        }
        else{
            self.circleDataSourceArray = [[[respose objectFromJSONString]
                                           objectForKey:@"data"]
                                          objectForKey:@"datas"];
            self.gloableUptime = [[[[respose objectFromJSONString]
                                    objectForKey:@"data"]
                                   objectForKey:@"uptime"] stringValue];
            [[NSUserDefaults standardUserDefaults] setObject:self.gloableUptime forKey:@"gloable_uptime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([self.circleDataSourceArray count] > 0) {
                [DATABASE creatCircleThemeTable];
                for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
                    CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
                    NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
                    info.circleTopic = [responseDict objectForKey:@"title"];
                    info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
                    info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
                    info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
                    info.circleImage = [responseDict objectForKey:@"cover_pic"];
                    info.adminId = [responseDict objectForKey:@"uid"];
                    info.themeSimple = [responseDict objectForKey:@"simple_desc"];
                    //lastChat
                    NSMutableArray *cacheArray = [DATABASE fetchChatRecordsListWithCircleId:nil andCircleThemeId:info.circleDetailID withId:UINT16_MAX];
                    if (cacheArray.count > 0) {
                        info.lastChat = ((ChatMessageInfo *)[cacheArray firstObject]).content;
                        info.lastChatUserName = ((ChatMessageInfo *)[cacheArray firstObject]).userName;
                    }
                    if ([[responseDict objectForKey:@"uptime"] isEqualToString:@"0"]) {
                        info.date =  [responseDict objectForKey:@"ctime"];
                    }else{
                        info.date =  [responseDict objectForKey:@"uptime"];
                    }
                    NSArray *arr = [DATABASE fetchCircleThemeListWithThemeId:info.circleDetailID];
                    if (arr.count > 0) {
                        [DATABASE updateCircleThemeListHaveNotReadWithAbstact:info];
                        self.canInsert = NO;
                        [self.buffArray addObject:info];
                    }
                    else{
                        self.canInsert = YES;
                        info.isRead = @"1";
                        [self.buffArray addObject:info];
                    }
                }
                if (self.canInsert) {
                    [DATABASE insertCircleThemeWithThemeInfo:self.buffArray];
                }
                [self.listArray removeAllObjects];
                self.listArray = [DATABASE fetchCircleTheme];
                [self createHeaderView];
            }
        }
        self.circleTable.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        [self hiddenNetworkAnimation];
        [self.circleTable reloadData];
        if (!self.isJudgeTabBarRedPoint) {
            [self judgeHaveNotReadData];
        }
    }];
}
- (void)loadData{
    [DATABASE creatCircleThemeTable];
    self.listArray = [DATABASE fetchCircleTheme];
    if (self.listArray.count > 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        headView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableHeaderView = headView;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        footView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableFooterView = footView;
    }
    self.gloableUptime = [[NSUserDefaults standardUserDefaults] objectForKey:@"gloable_uptime"];
    [NETWORK  requestCircleListWithUptime:self.gloableUptime requestResult:^(NSString *respose) {
        if ([respose isEqualToString:@"-2"]) {
            [self showNetworkErrorMessage:@"请求数据失败"];
            //从数据库中取
            [self makePitchView];
            [self.circleTable reloadData];
        }
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
            [self makePitchView];
            [self.circleTable reloadData];
        }
        else{
            self.circleDataSourceArray = [[[respose objectFromJSONString]
                                           objectForKey:@"data"]
                                          objectForKey:@"datas"];
            self.gloableUptime = [[[[respose objectFromJSONString]
                                    objectForKey:@"data"]
                                   objectForKey:@"uptime"] stringValue];
            [[NSUserDefaults standardUserDefaults] setObject:self.gloableUptime forKey:@"gloable_uptime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t groupp = dispatch_group_create();
            dispatch_group_async(groupp, t, ^{
                if ([self.circleDataSourceArray count] > 0) {
                    [DATABASE creatCircleThemeTable];
                    for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
                        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
                        NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
                        info.circleTopic = [responseDict objectForKey:@"title"];
                        info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
                        info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
                        info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
                        info.circleImage = [responseDict objectForKey:@"cover_pic"];
                        info.adminId = [responseDict objectForKey:@"uid"];
                        info.themeSimple = [responseDict objectForKey:@"simple_desc"];
                        //lastChat
                        NSMutableArray *cacheArray = [DATABASE fetchChatRecordsListWithCircleId:nil andCircleThemeId:info.circleDetailID withId:UINT16_MAX];
                        if (cacheArray.count > 0) {
                            info.lastChat = ((ChatMessageInfo *)[cacheArray firstObject]).content;
                            info.lastChatUserName = ((ChatMessageInfo *)[cacheArray firstObject]).userName;
                        }
                        if ([[responseDict objectForKey:@"uptime"] isEqualToString:@"0"]) {
                            info.date = [responseDict objectForKey:@"ctime"];
                        }
                        else{
                            info.date = [responseDict objectForKey:@"uptime"];
                        }
                        NSArray *arr = [DATABASE fetchCircleThemeListWithThemeId:info.circleDetailID];
                        if (arr.count > 0) {
                            CircleAbstractInfo *ab = [arr objectAtIndex:0];
                            if ([ab.isRead isEqualToString:@"0"]) {
                                info.isRead = @"0";
                                [DATABASE deleteCircleThemeListWithThemeId:info.circleDetailID];
                            }
                            else{
                                [DATABASE deleteCircleThemeListWithThemeId:info.circleDetailID];
                                info.isRead = @"1";
                            }
                        }else{
                            info.isRead = @"1";
                            [DATABASE deleteCircleThemeListWithThemeId:info.circleDetailID];
                        }
                        [self.buffArray addObject:info];
                        
                        if (self.haveNoData && ([info.circleDetailID integerValue] == self.subcribeIndexId)) {
                            info.isRead = @"0";
                            [DATABASE deleteCircleThemeListWithThemeId:info.circleDetailID];
                        }
                        for (int k = 0; k < self.notReadThemeArray.count; k++) {
                            NSString *themeId = [self.notReadThemeArray objectAtIndex:k];
                            if ([themeId isEqualToString:info.circleDetailID]) {
                                info.isRead = @"0";
                                [DATABASE deleteCircleThemeListWithThemeId:info.circleDetailID];
                            }
                        }
                        for (int k = 0; k < self.listArray.count; k++) {
                            CircleAbstractInfo *abstract = [self.listArray objectAtIndex:k];
                            if ([abstract.circleDetailID isEqualToString:info.circleDetailID]) {
                                [self.listArray removeObjectAtIndex:k];
                            }
                        }
                    }
                    if ([DATABASE insertCircleThemeWithThemeInfo:self.buffArray]) {
                        NSLog(@"新增数据加载插入数据库成功");
                    }
                    for (int k = 0; k < self.buffArray.count; k++) {
                        [self.listArray insertObject:[self.buffArray objectAtIndex:k] atIndex:0];
                    }
                    self.listArray = [DATABASE fetchCircleTheme];
                }
                
            });
            dispatch_group_wait(groupp, DISPATCH_TIME_FOREVER);
            dispatch_group_async(groupp, dispatch_get_main_queue(), ^{
                [self makePitchView];
                [self.circleTable reloadData];
            });
        }
        self.circleTable.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        [self hiddenNetworkAnimation];
        [self judgeHaveNotReadData];
    }];
}
- (void)judgeHaveNotReadData{
    if ([DATABASE fetchNotReadMessage] != 0) {
        [SharedApp updateTabbarNewMsg];
    }
    if ([DATABASE fetchNotReadMessage] == 0) {
        [SharedApp updateTabbarNotNewMsg];
    }
}

#pragma mark - sorted
- (NSArray *)sortedWithArray:(NSMutableArray *)arr
{
    NSArray * array = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[(CircleAbstractInfo *)obj1 date] longLongValue] > [[(CircleAbstractInfo *)obj2 date] longLongValue]) {
            return NSOrderedAscending;
        }
        else
            return NSOrderedDescending;
    }];
    return array;
}
#pragma mark -
- (void)makePitchView{
    if (self.listArray.count > 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        headView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableHeaderView = headView;
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        footView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
        self.circleTable.tableFooterView = footView;
    }
}
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[SHTRefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
	[self.circleTable addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.circleTable.contentInset;
    CGFloat height = MAX(self.circleTable.contentSize.height, self.circleTable.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.circleTable.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[SHTRefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.circleTable.frame.size.width,
                                         self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.circleTable addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.circleTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self.circleTable scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.circleTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.circleTable scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    [_refreshHeaderView setState:SHTOPullRefreshLoading];
}
#pragma mark -
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	_reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
}

#pragma mark -
- (void)finishReloadingData{
    _reloading = NO;
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.circleTable];
    }
    //    if (_refreshFooterView) {
    //        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.circleTable];
    //        [self setFooterView];
    //    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	return _reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	return [NSDate date];
}

-(void)refreshView{
    [self.buffArray removeAllObjects];
    self.isJudgeTabBarRedPoint = YES;
    [self reloadData];
    [self finishReloadingData];
    [self createHeaderView];
}

-(void)testFinishedLoadData{
    [self setFooterView];
}

#pragma mark - NaviViewDelegate
- (void)rightButtonClick
{
    ContributeToCicleViewController *contriViewController = [[ContributeToCicleViewController alloc]init];
    contriViewController.delegate = self;
    [self.navigationController pushViewController:contriViewController animated:YES];
    [MobClick event:@"createThemePage"];
}

- (void)leftButtonClick
{
    AddCicleViewController *addViewController = [[AddCicleViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
    [MobClick event:@"createCirclePage"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArray.count == 0) {
        return 0;
    }
    else{
        return [self.listArray count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.listArray count]) {
        return 60;
    }else {
        CircleAbstractInfo *info = [self.listArray objectAtIndex:indexPath.row];
        CGSize size = [info.themeSimple sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(193, 90) lineBreakMode:NSLineBreakByCharWrapping];
        if (size.height < 70) {
            return 183;
        }
        else {
            return 203;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifer = [NSString stringWithFormat:@"cellName%d",indexPath.row];
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[ThemeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.delegate = self;
        cell.tag = indexPath.row;
    }
    if (indexPath.row == [self.listArray count]) {
        CircleAbstractInfo *info = nil;
        [cell configureCellWithAbstract:info canLoadImage:NO];
    }
    else{
        [cell configureCellWithAbstract:[self.listArray objectAtIndex:indexPath.row] canLoadImage:YES];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.listArray.count) {
        CircleDetailViewController *detailViewController = [[CircleDetailViewController alloc]init];
        if (self.listArray.count == 0) {
            return;
        }
        CircleAbstractInfo *info = [self.listArray objectAtIndex:indexPath.row];
        detailViewController.circleName = info.circleName;
        detailViewController.circleID = info.circleDetailID;
        detailViewController.delegate = self;
        detailViewController.administratorId = info.adminId;
        [MobClick event:@"circleTheme" label:info.circleDetailID];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - ChatAction
- (void)chatWithCircleId:(NSString *)circleId themeId:(NSString *)themeId circleName:(NSString *)circleName themeName:(NSString *)themeName withUserId:(NSString *)uid cellTag:(NSInteger)tag
{
    //隐藏掉cell红点,通过设置数据库中元素来设置
    for (int i = 0; i < self.listArray.count;i++ ) {
        CircleAbstractInfo *info = [self.listArray objectAtIndex:i];
        if ([info.circleDetailID isEqualToString:themeId]) {
            if ([info.isRead isEqualToString:@"1"]) {
                break;
            }
            info.isRead = @"1";
            [DATABASE openDatabase];
            [DATABASE updateCircleThemeListNoTimeWithThemeId:info];
            [self.circleTable reloadData];
            break;
        }
    }
    if ([DATABASE fetchNotReadMessage] == 0) {
        //   让tabbar上的小红点隐藏
        [SharedApp updateTabbarNotNewMsg];  //remove掉bar上的小红点
    }
    //进入聊天页
    self.chatViewController = [[ChatViewController alloc]init];
    self.chatViewController.circleThemeID = themeId;
    self.chatViewController.circleId = circleId;
    self.chatViewController.themeName = themeName;
    self.chatViewController.delegate = self;
    [MobClick event:@"chat" label:themeName];
    
    [self.navigationController pushViewController:self.chatViewController animated:YES];
}
#pragma mark - ContributeControllerDelegate
- (void)backToCircleThemeListWith:(NSString *)adminId
{
    self.circleAdminID = adminId;
}
- (void)reciveAdminID:(NSString *)adminID
{
    self.circleAdminID = adminID;
}
#pragma  mark - 收到离线消息处理
- (void)getThemeListUnreadMsg:(NSNotification *)unReadNoti{
    __block  BOOL haveData = NO;
    self.haveNotReadMsg = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kGetThemeListUnreadMsg" object:nil];
    NSMutableArray *chatArray = [NSMutableArray array];
    dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, t, ^{
        NSDictionary *unReadDict = unReadNoti.object;
        NSMutableArray *unReadArray = [unReadDict objectForKey:@"arr"];
        NSMutableArray *arr = [unReadDict objectForKey:@"temp"];
        [DATABASE createChatRecords];
        [DATABASE insertChatRecordsWithChatInfoArray:arr];
        //        self.notReadThemeId = [[unReadArray lastObject] objectForKey:@"topicID"];
        self.listArray = [DATABASE fetchCircleTheme];
        for (int i = 0; i < unReadArray.count; i++) {
            ChatMessageInfo *info = [[ChatMessageInfo alloc] init];
            NSDictionary *msgDict = [unReadArray objectAtIndex:i];
            info.content = [[NSString alloc] initWithData:[GTMBase64 decodeData:[[msgDict objectForKey:@"text"] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
            info.circleThemeId = [msgDict objectForKey:@"topicID"];
            [self.notReadThemeArray addObject:info.circleThemeId];
            info.timeStamp = [msgDict objectForKey:@"time"];
            info.isMySelf = NO;
            info.nowDate = [AppTools getShortDateWithTimestamp:[msgDict objectForKey:@"time"]];
            info.userId = [msgDict objectForKey:@"sendUserID"];
            info.isSuccess = YES;
            info.isLoading = NO;
            CircleAbstractInfo *abstract = nil;
            for (int j = 0; j < self.listArray.count; j++) {
                abstract = [self.listArray objectAtIndex:j];
                if ([info.circleThemeId isEqualToString:abstract.circleDetailID]){
                    abstract.isRead = @"0";
                    haveData = YES;
                    abstract.lastChat = info.content;
                    MemberInfo *people = [DATABASE fetchUserNameWithUserId:info.userId];
                    abstract.lastChatUserName = people.memberName;
                    abstract.date =[NSString stringWithFormat:@"%d",[([AppTools getNowDateTimeStamp]) integerValue]];
                    [DATABASE updateCircleThemeListWithThemeId:abstract];
                }
            }
            if (!haveData) {
                self.haveNoData = !haveData;
                self.notReadThemeId = info.circleThemeId;
            }
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCatUserInfo]]];
            [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
            [request setPostValue:info.userId forKey:@"uid"];
            [request setTimeOutSeconds:10];
            [request startSynchronous];
            NSDictionary *responseDict = [request.responseString objectFromJSONString];
            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
            info.userName = [dataDict objectForKey:@"username"];
            NSArray *imageArray = [dataDict objectForKey:@"avatar_url"];
            if (imageArray.count > 0) {
                info.userHeadImageUrl = [[imageArray objectAtIndex:0] objectForKey:@"small_url"];
            }
            [chatArray addObject:info];
        }
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self.listArray removeAllObjects];
        self.listArray = [DATABASE fetchCircleTheme];
        [self.circleTable reloadData];
    });
    [self makeSubArrayWithDiffer:self.notReadThemeArray];
}

- (void)getOtherUnreadMsg:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kGetThemeListOtherUnreadMsg" object:nil];
    __block  BOOL haveData = NO;
    NSMutableArray *chatArray = [NSMutableArray array];
    dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, t, ^{
        NSDictionary *unReadDict = noti.object;
        NSMutableArray *unReadArray = [unReadDict objectForKey:@"arr"];
        self.notReadThemeId = [[unReadArray lastObject] objectForKey:@"topicID"];
        [self.listArray removeAllObjects];
        self.listArray = [DATABASE fetchCircleTheme];
        for (int i = 0; i < unReadArray.count; i++) {
            ChatMessageInfo *info = [[ChatMessageInfo alloc] init];
            NSDictionary *msgDict = [unReadArray objectAtIndex:i];
            info.content = [[NSString alloc] initWithData:[GTMBase64 decodeData:[[msgDict objectForKey:@"text"] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
            info.circleThemeId = [msgDict objectForKey:@"topicID"];
            info.timeStamp = [msgDict objectForKey:@"time"];
            info.isMySelf = NO;
            info.nowDate = [AppTools getShortDateWithTimestamp:[msgDict objectForKey:@"time"]];
            info.userId = [msgDict objectForKey:@"sendUserID"];
            info.isSuccess = YES;
            info.isLoading = NO;
            CircleAbstractInfo *abstract = nil;
            for (int j = 0; j < self.listArray.count; j++) {
                abstract = [self.listArray objectAtIndex:j];
                if ([info.circleThemeId isEqualToString:abstract.circleDetailID]){
                    abstract.isRead = @"0";
                    haveData = YES;
                    abstract.lastChat = info.content;
                    MemberInfo *people = [DATABASE fetchUserNameWithUserId:info.userId];
                    abstract.lastChatUserName = people.memberName;
                    abstract.date =[NSString stringWithFormat:@"%d",[([AppTools getNowDateTimeStamp]) integerValue]];
                    [DATABASE updateCircleThemeListWithThemeId:abstract];
                }
            }
            if (!haveData) {
                self.haveNoData = !haveData;
                self.notReadThemeId = info.circleThemeId;
            }
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCatUserInfo]]];
            [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
            [request setPostValue:info.userId forKey:@"uid"];
            [request setTimeOutSeconds:10];
            [request startSynchronous];
            NSDictionary *responseDict = [request.responseString objectFromJSONString];
            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
            info.userName = [dataDict objectForKey:@"username"];
            NSArray *imageArray = [dataDict objectForKey:@"avatar_url"];
            if (imageArray.count > 0) {
                info.userHeadImageUrl = [[imageArray objectAtIndex:0] objectForKey:@"small_url"];
            }
            [chatArray addObject:info];
        }
        [DATABASE insertChatRecordsWithChatInfoArray:chatArray];
        [SharedApp updateTabbarNewMsg];
        self.listArray = [DATABASE fetchCircleTheme];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self.circleTable reloadData];
    });
}
#pragma mark - 删掉重复主题id
- (void)makeSubArrayWithDiffer:(NSMutableArray *)arr{
    for (int i = 0; i < arr.count; i++) {
        for (int j = i+1; j < arr.count; j++) {
            if ([[arr objectAtIndex:i] isEqualToString:[arr objectAtIndex:j]]) {
                [arr removeObjectAtIndex:j];
                j--;
            }
        }
    }
}
#pragma mark - reciveMessage 在线消息
- (void)updateTopicListWithMsg:(ChatMessageInfo *)msg{
    if (msg.userId == nil || [msg.userId isEqualToString:@""]) {
        return;
    }
    //通过userid获取user信息
    [DATABASE createChatRecords];
    MemberInfo *meber =  [DATABASE fetchUserNameWithUserId:msg.userId];
    if (msg.userId == nil || [msg.userId isEqualToString:@""]) {
        return;
    }
    msg.userName = meber.memberName;
    if (!([msg.userName isEqualToString:@""] || msg.userName == nil)) {
        msg.userHeadImageUrl = meber.memberHeadImageUrl;
        msg.nowDate = [AppTools getCurrentTime];
        msg.timeStamp = [AppTools getNowDateTimeStamp];
        msg.isSuccess = YES;
        msg.isLoading = NO;
        if ([msg.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
            msg.isMySelf = YES;
        }
        else{
            msg.isMySelf = NO;
        }
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:msg, nil];
        dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, t, ^{
            [DATABASE insertChatRecordsWithChatInfoArray:tempArr];
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, t, ^{
            [self makeCellFirstWithThemeId:msg.circleThemeId andLastChat:msg.content andLastChatName:msg.userName];
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, t, ^{
            //            [self.listArray removeAllObjects];
            //            self.listArray = [DATABASE fetchCircleTheme];
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, t, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.circleTable reloadData];
            });
        });
    }
    else {
        [NETWORK requestUserInfoWithUserId:msg.userId requestResult:^(NSString *response) {
            NSDictionary *responseDict = [response objectFromJSONString];
            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
            msg.userName = [dataDict objectForKey:@"username"];
            NSArray *imageArray = [dataDict objectForKey:@"avatar_url"];
            msg.userHeadImageUrl = [[imageArray objectAtIndex:0] objectForKey:@"small_url"];
            msg.nowDate = [AppTools getCurrentTime];
            msg.timeStamp = [AppTools getNowDateTimeStamp];
            if ([msg.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
                msg.isMySelf = YES;
            }
            else{
                msg.isMySelf = NO;
            }
            NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:msg, nil];
            dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, t, ^{
                [DATABASE insertChatRecordsWithChatInfoArray:tempArr];
            });
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_group_async(group, t, ^{
                [self makeCellFirstWithThemeId:msg.circleThemeId andLastChat:msg.content andLastChatName:msg.userName];
            });
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_group_async(group, t, ^{
                //                self.listArray = [DATABASE fetchCircleTheme];
            });
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_group_async(group, t, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.circleTable reloadData];
                });
            });
        }];
    }
}

- (void)makeCellFirstWithThemeId:(NSString *)themeId andLastChat:(NSString *)content andLastChatName:(NSString *)userName{
    int flag = 0;
    BOOL haveData = NO;
    //    if (self.listArray.count>0) {
    for (int i =0 ; i<self.listArray.count; i++) {
        CircleAbstractInfo *info = [self.listArray objectAtIndex:i];
        if ([info.circleDetailID isEqualToString:themeId]) {
            //找到对应位置
            haveData = YES;
            flag = i;
            break;
        }
    }
    if (!haveData) {
        self.haveNoData = !haveData;
        self.notReadThemeId = themeId;
        [self.notReadThemeArray addObject:themeId];
    }
    NSString *uptime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] + 8*60*60];
    CircleAbstractInfo *info = nil;
    info = [[DATABASE fetchCircleThemeWith:themeId] lastObject];
    if (!info) {
        ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kCircleList]]];
        [formRequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"gloable_uptime"] forKey:@"gloable_uptime"];
        [formRequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken] forKey:@"token"];
        [formRequest startSynchronous];
        NSString * respose = formRequest.responseString;
        NSMutableArray * circleDataSourceArray = [[[respose objectFromJSONString]
                                                   objectForKey:@"data"]
                                                  objectForKey:@"datas"];
        NSString * gloableUptime = [[[[respose objectFromJSONString]
                                      objectForKey:@"data"]
                                     objectForKey:@"uptime"] stringValue];
        [[NSUserDefaults standardUserDefaults] setObject:gloableUptime forKey:@"gloable_uptime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableArray *buffArray = [NSMutableArray array];
        [DATABASE creatCircleThemeTable];
        for (int i = 0; i < [circleDataSourceArray count]; i++) {
            CircleAbstractInfo *info1 = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
            info1.circleTopic = [responseDict objectForKey:@"title"];
            info1.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info1.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info1.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info1.circleImage = [responseDict objectForKey:@"cover_pic"];
            info1.adminId = [responseDict objectForKey:@"uid"];
            info1.themeSimple = [responseDict objectForKey:@"simple_desc"];
            NSDictionary *lastDict = [responseDict objectForKey:@"last_chat"];
            //lastChat
            if ([[lastDict objectForKey:@"content_length"] integerValue]>0) {
            }
            else{
            }
            if ([[responseDict objectForKey:@"uptime"] isEqualToString:@"0"]) {
                info1.date = [responseDict objectForKey:@"ctime"];
            }
            else{
                info1.date = [responseDict objectForKey:@"uptime"];
            }
            NSArray *arr = [DATABASE fetchCircleThemeListWithThemeId:info1.circleDetailID];
            if (arr.count > 0) {
                [DATABASE deleteCircleThemeListWithThemeId:info1.circleDetailID];
                info1.isRead = @"1";
                [buffArray addObject:info1];
            }
            else{
                info1.isRead = @"1";
                [buffArray addObject:info1];
            }
        }
        if ([DATABASE insertCircleThemeWithThemeInfo:buffArray]) {
        }
        for (int i = 0; i < buffArray.count; i++) {
            [self.listArray addObject:[buffArray objectAtIndex:i]];
        }
        info = [[DATABASE fetchCircleThemeWith:themeId] lastObject];
    }
    else{
        info.isRead = @"0";
        info.date = uptime;
        info.lastChat = content;
        info.lastChatUserName = userName;
    }
    [DATABASE updateCircleThemeListWithThemeId:info];
    [self.listArray removeObjectAtIndex:flag];
    [self.listArray insertObject:info atIndex:0];
    [self makeSubArrayWithDiffer:self.notReadThemeArray];
    
}
#pragma mark - ChatViewControllerDelegate
- (void)sendLastChatMsg:(ChatMessageInfo *)lastChatMsg
{
    //    self.listArray = [DATABASE fetchCircleTheme];
    for (int i = 0; i < [self.listArray count]; i++) {
        CircleAbstractInfo *info = [self.listArray objectAtIndex:i];
        if ([lastChatMsg.circleThemeId isEqualToString:info.circleDetailID]) {
            info.lastChat = lastChatMsg.content;
            info.date =  [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            info.isRead = @"1";
            info.lastChatUserName = lastChatMsg.userName;
            [DATABASE creatCircleThemeTable];
            [DATABASE updateCircleThemeListWithThemeId:info];
            
            [self.listArray removeObjectAtIndex:i];
            [self.listArray insertObject:info atIndex:0];
            [self.circleTable reloadData];
            break;
        }
    }
}

- (void)refreshList{
    if ([DATABASE fetchNotReadMessage] == 0) {
        //   让tabbar上的小红点隐藏
        [SharedApp updateTabbarNotNewMsg];//remove小红点
    }
    [self.listArray removeAllObjects];
    self.listArray = [DATABASE fetchCircleTheme];
    [self.circleTable reloadData];
}

- (NSString *)makeDateWithTimeStamp:(NSString *)timeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * currentTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]]];
    return currentTime;
}
#pragma mark - recive mqtt push noti
- (void)recvChangeCircleNameNoti:(NSNotification *)noti{
    [self reloadData];
}
- (void)recvMemberDele:(NSNotification *)noti{
    [self reloadData];
}
- (void)recvAddSelfToCircle:(NSNotification *)noti{
    [self reloadData];
}
- (void)deleCircleTheme{
    [self reloadData];
}

@end
