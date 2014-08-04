//
//  CircleViewController.m
//  商海通
//
//  Created by Liv on 14-3-22.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import "CircleViewController.h"
#import "ShowPageViewController.h"
#import "CircleCell.h"
#import "ChatViewController.h"
#import "circleDetailViewController.h"
#import "AddCicleViewController.h"
#import "CircleAbstractInfo.h"
#import "SHTRefreshTableFooterView.h"
#import "SHTRefreshTableHeaderView.h"
#import "ContributeToCicleViewController.h"
#import "userItemInformation.h"

@interface CircleViewController ()<CircleCellDelegate,SHTRefreshTableDelegate,ContributeToCicleViewControllerDelegate>
{
    BOOL _reloading;
}
@property (strong,nonatomic) SHTRefreshTableHeaderView *refreshHeaderView;
@property (strong,nonatomic) SHTRefreshTableFooterView *refreshFooterView;
@property (strong,nonatomic) UITableView *circleTable;
@property (nonatomic,strong) NSString * index;
@property (nonatomic,strong) NSMutableArray *circleDataSourceArray;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isLast;
@property (nonatomic,strong) NSMutableArray *params;

@property (nonatomic,strong) NSString *circleAdminID;
@end
@implementation CircleViewController

#pragma mark - lifeCycle
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    userItemInformation *userInfomation = [[DATABASE fetchUserList] objectAtIndex:0];
    if ([self.circleAdminID isEqualToString:userInfomation.userID]) {
        [NETWORK  requestCircleListWithPageIndex:self.params requestResult:^(NSString *respose) {
            NSArray *dictResponse = [[respose objectFromJSONString] objectForKey:@"data"];
            if ([self getErrorCodeWithJsonValue:respose]) {
                return ;
            }
            if ([respose isEqualToString:@"-1"]) {
                [self showNetworkErrorMessage:@"网络无法连接"];
                //从数据库中取
                self.listArray = [NETWORK readDatabase];
                self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
                [self.circleTable reloadData];
                [self removeHeaderView];
                [self removeFooterView];
            }
            self.circleDataSourceArray = [[NSMutableArray alloc]init];
            [self.circleDataSourceArray addObjectsFromArray:dictResponse];
            for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
                CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
                NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
                info.circleTopic = [responseDict objectForKey:@"title"];
                info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
                info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
                info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
                info.circleDetail = [responseDict objectForKey:@"content"];
                info.circleImage = [responseDict objectForKey:@"cover_pic"];
                info.date = [responseDict objectForKey:@"uptime"];
                [self.params addObject:info.circleDetailID];
                [self.listArray addObject:info];
                [DATABASE insertCircleThemeWithThemeInfo:info];
            }
            //排序
            self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
            [self.circleTable reloadData];
            [self testFinishedLoadData];
        }];

    }
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
}
- (void)refreshViewController{
    [NETWORK  requestCircleListWithPageIndex:self.params requestResult:^(NSString *respose) {
        NSArray *dictResponse = [[respose objectFromJSONString] objectForKey:@"data"];
        if ([self getErrorCodeWithJsonValue:respose]) {
            return ;
        }
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
            self.listArray = [NETWORK readDatabase];
            self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
            [self.circleTable reloadData];
            [self removeHeaderView];
            [self removeFooterView];
        }
        [self.circleDataSourceArray removeAllObjects];
        [self.circleDataSourceArray addObjectsFromArray:dictResponse];
        for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
            CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
            info.circleTopic = [responseDict objectForKey:@"title"];
            info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info.circleDetail = [responseDict objectForKey:@"content"];
            info.circleImage = [responseDict objectForKey:@"cover_pic"];
            info.date = [responseDict objectForKey:@"uptime"];
            [self.params addObject:info.circleDetailID];
            [self.listArray addObject:info];
        }
        //排序
        self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
        [self.circleTable reloadData];
        [self testFinishedLoadData];
    }];
    self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据源
    self.params = [[NSMutableArray alloc]init];
    self.circleDataSourceArray = [[NSMutableArray alloc]init];
    self.listArray = [[NSMutableArray alloc]init];
    //navigationbar
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    [self.navigationView.leftButton setImage:[UIImage imageNamed:@"group_talk"] forState:UIControlStateNormal];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"rightEditBtn"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.text = @"圈子";
    //tableView
    self.circleTable = [[UITableView alloc]initWithFrame:self.contentFrame style:UITableViewStylePlain];
    self.circleTable.delegate = self;
    self.circleTable.dataSource = self;
    
    self.circleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.circleTable];
    [self createHeaderView];
    
//    [self testFinishedLoadData];  //不分页 不加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewController) name:@"refreshPage_Circle" object:nil];
    //数据库取数据
    self.listArray = [DATABASE fetchCircleTheme];
    self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
    for (int i = 0; i < self.listArray.count; i++) {
        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
        info = [self.listArray objectAtIndex:i];
        [self.params addObject:info.circleDetailID];
    }
    
    [NETWORK  requestCircleListWithPageIndex:self.params requestResult:^(NSString *respose) {
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
//            self.listArray = [NETWORK readDatabase];
            [self.circleTable reloadData];
            return ;
        }
       else if ([self getErrorCodeWithJsonValue:respose]) {
            return ;
        }
       else{
        self.circleDataSourceArray = [[respose objectFromJSONString] objectForKey:@"data"];
        for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
            CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
            info.circleTopic = [responseDict objectForKey:@"title"];
            info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info.circleDetail = [responseDict objectForKey:@"content"];
            info.circleImage = [responseDict objectForKey:@"cover_pic"];
            info.date = [responseDict objectForKey:@"uptime"];
            [self.params addObject:info.circleDetailID];
            [self.listArray addObject:info];
            [DATABASE insertCircleThemeWithThemeInfo:info];
        }
        
        self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        headView.backgroundColor = COLOR_WITH_RGB(59.0, 70.0, 93.0);
        self.circleTable.tableHeaderView = headView;
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        footView.backgroundColor = COLOR_WITH_RGB(59.0, 70.0, 93.0);
        self.circleTable.tableFooterView = footView;
        [self.circleTable reloadData];
        [self createHeaderView];
       }
    }];
}
//排序
- (NSArray *)sortedWithArray:(NSMutableArray *)arr
{
    NSArray * array = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[(CircleAbstractInfo *)obj1 date] longLongValue] > [[(CircleAbstractInfo *)obj2 date] longLongValue]) {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
    }];
    return array;
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
    UIEdgeInsets test = self.circleTable.contentInset;
    CGFloat height = MAX(self.circleTable.contentSize.height, self.circleTable.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.circleTable.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[SHTRefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.circleTable.frame.size.width, self.view.bounds.size.height)];
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

#pragma mark-
#pragma mark force to show the refresh headerView
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
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.circleTable];
        [self setFooterView];
    }
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
    //刷新
    [NETWORK  requestCircleListWithPageIndex:self.params requestResult:^(NSString *respose) {
        self.circleDataSourceArray = [[respose objectFromJSONString] objectForKey:@"data"];
//        if ([self getErrorCodeWithJsonValue:respose]) {
//            return ;
//        }
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            //从数据库中取
            self.listArray = [NETWORK readDatabase];
            [self.circleTable reloadData];
            [self testFinishedLoadData];
        }
        for (int i = 0; i < [self.circleDataSourceArray count]; i++) {
            CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [self.circleDataSourceArray objectAtIndex:i];
            info.circleTopic = [responseDict objectForKey:@"title"];
            info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info.circleDetail = [responseDict objectForKey:@"content"];
            info.circleImage = [responseDict objectForKey:@"cover_pic"];
            info.date = [responseDict objectForKey:@"uptime"];
            NSLog(@"%@",info.date);
            [self.params addObject:info.circleDetailID];
            [self.listArray addObject:info];
            [DATABASE insertCircleThemeWithThemeInfo:info];
        }
        //排序
        self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
        [self.circleTable reloadData];
        [self testFinishedLoadData];
    }];
    self.listArray = [[NSMutableArray alloc]initWithArray:[self sortedWithArray:self.listArray]];
}
//加载调用的方法
-(void)getNextPageView{
    if (self.isLast) {
        [self showErrorMessage:@"已经是最后一页"];
        [self.view bringSubviewToFront:self.p];
        self.refreshFooterView.statusLabel.text = @"已经加载全部资源";
        self.refreshFooterView.lastUpdatedLabel.hidden = YES;
        self.refreshFooterView.activityView.hidden = YES;
        self.refreshFooterView.arrowImage.hidden = YES;
        return;
    }
    else{
    [NETWORK  requestCircleListWithPageIndex:self.index requestResult:^(NSString *respose) {
        NSDictionary *dictResponse = [[respose objectFromJSONString] objectForKey:@"data"];
        if ([self getErrorCodeWithJsonValue:respose]) {
            return ;
        }
        
        self.isLast = [[dictResponse objectForKey:@"page_is_last"] boolValue];
        if (self.isLast) {
                [self showErrorMessage:@"已经是最后一页"];
                [self.view bringSubviewToFront:self.p];
                self.refreshFooterView.statusLabel.text = @"已经加载全部资源";
                self.refreshFooterView.lastUpdatedLabel.hidden = YES;
                self.refreshFooterView.activityView.hidden = YES;
                self.refreshFooterView.arrowImage.hidden = YES;
                _reloading = NO;
            return;
        }
        else{
            self.index = [dictResponse objectForKey:@"next_id"];
        }
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dictResponse objectForKey:@"datas"]];
        for (int i = 0; i < [arr count]; i++) {
            CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
            NSDictionary *responseDict = [arr objectAtIndex:i];
            info.circleTopic = [responseDict objectForKey:@"title"];
            info.circleID = [[responseDict objectForKey:@"cid"] stringValue];
            info.circleDetailID = [[responseDict objectForKey:@"id"] stringValue];
            info.circleName = [[responseDict objectForKey:@"circle"] objectForKey:@"name"];
            info.circleDetail = [responseDict objectForKey:@"content"];
            info.circleImage = [responseDict objectForKey:@"cover_pic"];
            [self.listArray addObject:info];
        }
        [NETWORK writeToDatabaseWithDownloadResult:respose withPage:SHTCircleCachePageCircleThemeList isFirst:NO];
        [self.circleTable reloadData];
        [self testFinishedLoadData];
    }];
    }
}
-(void)testFinishedLoadData{
//    [self setFooterView];
    [self finishReloadingData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - NaviViewDelegate
- (void)rightButtonClick
{
    ContributeToCicleViewController *contriViewController = [[ContributeToCicleViewController alloc]init];
    contriViewController.delegate = self;
    [SharedApp.mainTabBarViewController presentViewController:contriViewController animated:YES completion:nil];
}

- (void)leftButtonClick
{
    AddCicleViewController *addViewController = [[AddCicleViewController alloc]init];
    [SharedApp.mainTabBarViewController presentViewController:addViewController animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellName";
    CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    [cell configurCellWith:[self.listArray objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleDetailViewController *detailViewController = [[CircleDetailViewController alloc]init];
    if (self.listArray.count == 0) {
        return;
    }
    CircleAbstractInfo *info = [self.listArray objectAtIndex:indexPath.row];
    detailViewController.circleName = info.circleName;
    detailViewController.circleID = info.circleDetailID;
    [SharedApp.mainTabBarViewController presentViewController:detailViewController animated:YES completion:nil];
}

#pragma mark - Target Action -
- (void)pressedRightButton:(UIButton *)button
{
}

#pragma mark - ChatAction
- (void)chatWithCircleId:(NSString *)circleID andCircleThemeId:(NSString *)circleThemeId andCircleName:(NSString *)circleName
{
    //进入聊天页
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    chatViewController.circleThemeID = circleThemeId;
    chatViewController.circleId = circleID;
    chatViewController.circleName = circleName;
    [SharedApp.mainTabBarViewController presentViewController:chatViewController animated:YES completion:nil];
    
    
}
#pragma mark - ContributeControllerDelegate
- (void)backToCircleThemeListWith:(NSString *)adminId
{
    self.circleAdminID = adminId;
}
@end
