//
//  CicleMembersViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "CicleMembersViewController.h"
#import "MembersTableViewCell.h"
#import "MemberInfo.h"
#import "SHTRefreshTableFooterView.h"
#import "SHTRefreshTableHeaderView.h"
#import "ShowPageViewController.h"
#import "FooterView.h"
@interface CicleMembersViewController ()<SHTRefreshTableDelegate>
{
    BOOL _reloading;
}
@property (nonatomic,strong) FooterView *footView;
@property (nonatomic,strong) UIButton *guideTabBarBtn;
@property (nonatomic,strong) ABTabBar *tabBar;
@property (nonatomic,strong) UITableView *membersTable;
@property (nonatomic,strong) NSMutableArray *memberDataArray;
@property (nonatomic,strong) NSString *index;
@property (nonatomic) BOOL isLast;
@property (strong,nonatomic) SHTRefreshTableHeaderView *refreshHeaderView;
@property (strong,nonatomic) SHTRefreshTableFooterView *refreshFooterView;
@property (nonatomic) NSInteger finishCount;
@end

@implementation CicleMembersViewController
#pragma mark - lifeCycle
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
    [super viewWillAppear:animated];
    SharedApp.stayNotFirstPage = YES;
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    [MobClick beginEvent:@"memberList"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [MobClick endEvent:@"memberList"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.frame = CGRectMake(0, ORIGIN_Y, kScreenWidth, kScreenHeight - ORIGIN_Y);
    self.navigationController.navigationBarHidden = YES;
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    self.finishCount = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:NO];
    self.navigationView.titleLabel.text = @"圈子成员";
    
    self.memberDataArray = [[NSMutableArray alloc] init];
    self.index = @"0";
    self.membersTable = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                     self.contentFrame.origin.y,
                                                                     self.contentFrame.size.width,
                                                                     self.contentFrame.size.height + TabBarViewHeight)
                                                    style:UITableViewStylePlain];
    self.membersTable.delegate = self;
    self.membersTable.dataSource = self;
    self.membersTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.membersTable];
    //此为调加载数据方法
    [self refreshView];

    SharedApp.stayNotFirstPage = YES;
    self.guidButton.hidden = NO;
    [self.view bringSubviewToFront:self.guidButton];
}
- (void)popCurrentViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)guidBttonAction
{
    [super guidBttonAction];
    [MobClick endEvent:@"memberList"];
    [self.view bringSubviewToFront:self.tabBar];
    self.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -SHTRefresh
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[SHTRefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
	[self.membersTable addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}
//自己写的
- (void)setFinishFooterView{
    CGFloat height = MAX(self.membersTable.contentSize.height, self.membersTable.frame.size.height);
    if (self.footView && [self.footView superview]) {
        self.footView.frame = CGRectMake(0.0f,
                                         height,
                                         self.membersTable.frame.size.width,
                                         self.view.bounds.size.height);
    }
    else{
        self.footView = [[FooterView alloc] initWithFrame:
                         CGRectMake(0.0f, height,
                                    self.membersTable.frame.size.width, self.view.bounds.size.height)];
        [self.membersTable addSubview:self.footView];
    }
    
}
-(void)setFooterView{
    UIEdgeInsets test = self.membersTable.contentInset;
    CGFloat height = MAX(self.membersTable.contentSize.height, self.membersTable.frame.size.height);
    //    CGFloat height = self.membersTable.frame.size.height;
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.membersTable.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[SHTRefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.membersTable.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.membersTable addSubview:_refreshFooterView];
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
		self.membersTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self.membersTable scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.membersTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.membersTable scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    [_refreshHeaderView setState:SHTOPullRefreshLoading];
}
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	_reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:1.0];
    }
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    _reloading = NO;
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.membersTable];
        
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.membersTable];
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
    [self loadMemberDataWithCircleId:self.circleID Index:@"0"];
}
//加载调用的方法
-(void)getNextPageView{
    [NETWORK requestGetCircleMembersWithCircleID:self.circleID
                                       withIndex:self.index
                                   requestResult:^(NSString *response) {
                                       NSDictionary *dictResponse = [[response objectFromJSONString] objectForKey:@"data"];
                                       self.index = [dictResponse objectForKey:@"next_id"];
                                       if (self.isLast == NO) {
                                           self.isLast = [[dictResponse objectForKey:@"page_is_last"] boolValue];
                                       }
                                       if (self.isLast) {
                                           _reloading = NO;
                                           [_refreshHeaderView setState:SHTOPullRefreshNormal];
                                           [self setFinishFooterView];
                                           [self removeFooterView];
                                           return ;
                                       }
                                       else {
                                           [self packageDataToAddDataArray:dictResponse];
                                           [self.membersTable reloadData];
                                           [self finishReloadingData];
                                       }
                                   }];
}
#pragma mark - 加载数据
- (void)loadMemberDataWithCircleId:(NSString *)circleId Index:(NSString *)index{
    //刷新
    [self.memberDataArray removeAllObjects];
    [NETWORK requestGetCircleMembersWithCircleID:circleId withIndex:index requestResult:^(NSString *response) {
        if ([response isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            [self.view bringSubviewToFront:self.p];
            //从数据库中取
            self.memberDataArray = [NETWORK readMemberListWithCircleId:self.circleID];
            [self.membersTable reloadData];
            [self finishReloadingData];
            [self createHeaderView];
            return ;
        }
        if ([response isEqualToString:@"-2"]) {
            [self showNetworkErrorMessage:@"请求失败"];
            [self.view bringSubviewToFront:self.p];
            //从数据库中取
            self.memberDataArray = [NETWORK readMemberListWithCircleId:self.circleID];
            [self createHeaderView];
            [self.membersTable reloadData];
            return ;
        }
        else {
            NSDictionary *dictResponse = [[response objectFromJSONString] objectForKey:@"data"];
            self.index = [dictResponse objectForKey:@"next_id"];
            self.isLast = [[dictResponse objectForKey:@"page_is_last"] boolValue];
            //写缓存
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NETWORK writeToDatabaseWithDownloadResult:response withCircleId:self.circleID];
            });
            [self packageDataToAddDataArray:dictResponse];
            [self createHeaderView];
            //一页可全部显示
            if (self.memberDataArray.count < 5) {
                [self finishReloadingData];
            }
            else{
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
            }
            [self.membersTable reloadData];
        }
        [self.view bringSubviewToFront:self.guideTabBarBtn];
    }];
    
}
- (void)packageDataToAddDataArray:(NSDictionary *)response{
    //            NSMutableArray *array = [dictResponse objectForKey:@"datas"];
            NSDictionary *dict = [response objectForKey:@"datas"];
            NSArray *keyArr = [dict allKeys];
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < keyArr.count; i++) {
                [array addObject:[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
            for (int i = 0; i < array.count; i++) {
                NSDictionary *userDict = [array objectAtIndex:i];
                NSDictionary *userInfoDict = [userDict objectForKey:@"user"];
                MemberInfo *memberInfo = [[MemberInfo alloc]init];
                memberInfo.memberID = [[userInfoDict objectForKey:@"id"] stringValue];
                memberInfo.memberName = [userInfoDict objectForKey:@"username"];
                memberInfo.memberCredit = [[userInfoDict objectForKey:@"credit"] stringValue];
                memberInfo.memberPosition =[userInfoDict objectForKey:@"duty"];
                memberInfo.memberCompany = [userInfoDict objectForKey:@"company"];
                NSArray *urlArray = [userInfoDict objectForKey:@"avatar_url"];
                NSDictionary *userImageUrlDict = [urlArray objectAtIndex:0];
                memberInfo.memberHeadImageUrl = [userImageUrlDict objectForKey:@"url"];
                [self.memberDataArray addObject:memberInfo];
            }
}
-(void)testFinishedLoadData{
    [self setFooterView];
    [self finishReloadingData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.memberDataArray.count < 5 && self.memberDataArray.count > 0) {
        return [self.memberDataArray count] +1;
    }
    return [self.memberDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    MembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[MembersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.tag = indexPath.row;
    }
    //从数据源设置cell
    if (indexPath.row == self.memberDataArray.count) {
        MemberInfo *info = nil;
        [cell configureCellWithMemberInfo:info];
    }
    else{
        MemberInfo *info = [self.memberDataArray objectAtIndex:indexPath.row];
        [cell configureCellWithMemberInfo:info];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.memberDataArray.count) {
        return;
    }
//    MemberInfo *info = [[MemberInfo alloc]init];
    MemberInfo *info  =  [self.memberDataArray objectAtIndex:indexPath.row];
    ShowPageViewController *showPage = [[ShowPageViewController alloc] init];
    [showPage setUrlString:[NSString stringWithFormat:@"%@index.php/User/Index/user_show/id/%@.html", DOMAIN_URL, info.memberID]];
    [SharedApp.mainTabBarViewController presentViewController:showPage animated:YES completion:^{
    }];
    
}
#pragma mark - NaviViewDelegate
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
