//
//  ChatViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ChatViewController.h"
#import "CicleMembersViewController.h"
#import "ChatInputView.h"
#import "ChatCell.h"
#import "ChatMessageInfo.h"
#import "CircleDatabase.h"
#import "UIImageView+WebCache.h"
#import "ShowPageViewController.h"
#import "SocketCommunicate.h"
#import "GTMBase64.h"
#import "Audio.h"
#import "ASIFormDataRequest.h"
#import "MemberInfo.h"
#import "CircleAbstractInfo.h"
#define CHATVIEW_HEIGHT 40
#define AMOUNT 10

@interface ChatViewController ()<ChatInputViewDelegate,UITextViewDelegate,ChatCellDelegate>
{
    float keyboardAndInputViewHeight;
    BOOL canHiddenKeyboard;
}
@property (nonatomic,strong)ChatInputView *chatInputView;
@property (nonatomic) BOOL sendMessageSuccess;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger recordIndex;
@property (nonatomic) BOOL canRefresh;
@property (nonatomic) BOOL canReload;
@property (nonatomic) BOOL directUp;
@property (nonatomic) NSInteger sectionCoount;
@property (nonatomic, copy) NSString   *chatMsgContent;
@property (nonatomic,strong) UIActivityIndicatorView *refreshIndicator;
@property (nonatomic) BOOL recvUnreadMsgFinished;
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark - lifeCycle
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    [MobClick beginEvent:@"chat" label:self.themeName];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"chat" label:self.themeName];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)ToCicleListVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ToCicleMembers
{
    CicleMembersViewController * cicleMembersVC = [[CicleMembersViewController alloc]init];
    [self.navigationController pushViewController:cicleMembersVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChatTableView:)
                                                name:@"kReciveUnreadMsg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChatTableViewFinish:)
                                                name:@"kReciveUnreadMsgFinish" object:nil];
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    keyboardAndInputViewHeight = CHATVIEW_HEIGHT;
    self.index = 1;
    self.sectionCoount = 2;
    //初始化数据源测试
    self.myDataArray = [[NSMutableArray alloc]init];
    self.buffArray = [[NSMutableArray alloc]init];
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"groupRightBtn"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.font = [UIFont fontWithName:@"heiti" size:22.0f];
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:22];
    self.navigationView.titleLabel.text = self.themeName;
    
    self.chatTableView = [[UITableView alloc]initWithFrame:self.contentFrame style:UITableViewStyleGrouped];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor whiteColor];
    if (!(IOS_VERSION >=7.0)) {
        self.chatTableView.backgroundView = nil;
    }
    [self.view addSubview:self.chatTableView];
    
    //读取数据库前10条数据,
    [DATABASE createChatRecords];
    self.recordIndex = [DATABASE fetchLastRecordIdWitThemeId:self.circleThemeID];
//    int nowId = [DATABASE fetchLastRecordIdDescWitThemeId:self.circleThemeID];
    NSMutableArray *cacheArray = (NSMutableArray *)[[[DATABASE fetchChatRecordsListWithCircleId:self.circleId andCircleThemeId:self.circleThemeID withIndex:self.index andAmount:AMOUNT] reverseObjectEnumerator] allObjects];
    self.chatTimeArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    if (cacheArray.count > 0) {
        self.myDataArray = cacheArray;
        for (int i = 0; i < [cacheArray count]; i++) {
            ChatMessageInfo *info = [cacheArray objectAtIndex:i];
            if (i == 0) {
                self.recordIndex = info.msgId;
            }
            [self.chatTimeArray addObject:info.nowDate];
        }
    }
    [self.chatTableView reloadData];
    if (self.myDataArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:
         [NSIndexPath indexPathForRow:0 inSection:self.myDataArray.count - 1]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.chatInputView = [[[NSBundle mainBundle]loadNibNamed:@"ChatInputView" owner:nil options:nil] lastObject];
    self.chatInputView.delegate = self;
    self.chatInputView.ChatInputTextView.delegate = self;
    self.chatInputView.center = CGPointMake(self.chatInputView.center.x,
                                            self.view.bounds.size.height - self.chatInputView.bounds.size.height * .5f);
    [self.view addSubview:self.chatInputView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    //活动指示器
    self.refreshIndicator  = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 15,-25, 30, 30)];
    self.refreshIndicator.color = [UIColor grayColor];
    self.refreshIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.chatTableView addSubview:self.refreshIndicator];
    self.refreshIndicator.hidden = YES;
    [self.refreshIndicator hidesWhenStopped];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatar:) name:@"refresh_head" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        self.chatInputView.placeHoderLabel.text = @"我来说两句";
    }
    else{
        self.chatInputView.placeHoderLabel.text = @"";
    }
}

#pragma mark - ChatInputViewDelegate

- (void)sendChatMsg:(ChatMessageInfo *)info
{
    [NSThread sleepForTimeInterval:0.1];
    // send chat info to server
    SocketCommunicate *socketComm = NULL;
    if (!(socketComm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:NO])) {
        NSLog(@"init socket failed");
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
        return;
    }
    
    int16_t msg_type = 0x23;
    NSDictionary *chatDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[NSUserDefaults standardUserDefaults] objectForKey:kUserID], kUserID,
                              info.circleThemeId,kSubjectID,
                              _chatMsgContent, kChatMsgContent,
                              [NSString stringWithFormat:@"%@",[AppTools getNowDateTimeStamp]], kSendTimeInterval,nil];
    
    char *data = NULL;
    int32_t msg_len;
    
    [socketComm packSendMsg:msg_type msgDict:chatDict data:&data dataLen:&msg_len];
    
    if ([socketComm send:data bufLen:msg_len] < 0) {
        NSLog(@"send chat msg failed.");
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
        if (data) {
            free(data);
        }
        [socketComm closeFD];
        return;
    }
    int32_t total_len;
    int16_t msg_stat;
    if(read(socketComm.sockfd, &total_len, sizeof(int32_t)) == -1){
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
    }
    if(read(socketComm.sockfd, &msg_type, sizeof(int16_t)) == -1){
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
    }
    int ret = [socketComm recv:&msg_stat bufLen:sizeof(int16_t)];
    if (ret == 0) { // 接收服务器消息应答失败
        if (data) {
            free(data);
        }
        [socketComm closeFD];
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
        return;
    }
    
    if (msg_stat != 0) {
        [self performSelectorOnMainThread:@selector(performMain:) withObject:info waitUntilDone:YES];
        if (data) {
            free(data);
        }
        [socketComm closeFD];
        return;
    }
    NSLog(@"send chat msg successed");
    NSLog(@"send chat msg Status: %d", msg_stat);
    
    if (data) {
        free(data);
    }
    [self performSelectorOnMainThread:@selector(sendMsgSuccess:) withObject:info waitUntilDone:YES];
    [socketComm closeFD];
}
//发送失败
- (void)performMain:(ChatMessageInfo*)info{
    info.isSuccess = NO;
    info.isLoading = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DATABASE updateChatRecordsWithChatMsg:info];
    });
    [self.myDataArray replaceObjectAtIndex:[self.myDataArray count]-1 withObject:info];
//    [self.chatTableView reloadData];
    [self.chatTableView reloadSections:[NSIndexSet indexSetWithIndex:self.myDataArray.count -1] withRowAnimation:UITableViewRowAnimationNone];
}
//发送成功
- (void)sendMsgSuccess:(ChatMessageInfo *)info{
    info.isSuccess = YES;
    info.isLoading = NO;
    [DATABASE updateChatRecordsWithChatMsg:info];
//    [self.chatTableView reloadData];
    [self.chatTableView reloadSections:[NSIndexSet indexSetWithIndex:self.myDataArray.count -1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)sendMessage:(NSString *)content isResend:(BOOL)resend timestamp:(NSString *)timestamp nowDate:(NSString *)nowDate
{
    [DATABASE openDatabase];
    if (content == nil || [content isEqualToString:@""]) {
        return;
    }
    _chatMsgContent = [[NSString alloc] initWithData:[GTMBase64 encodeData:[content dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
    ChatMessageInfo *chatInfo = [[ChatMessageInfo alloc]init];
        chatInfo.content = content;
        chatInfo.isMySelf = YES;
        chatInfo.circleThemeId = self.circleThemeID;
        chatInfo.circleId = self.circleId;
        chatInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        chatInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
        chatInfo.userHeadImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL];
        chatInfo.isLoading = YES;
        if (SharedApp.networkStatus == -1) {
            chatInfo.isSuccess = NO;
            chatInfo.isLoading = NO;
            BOOL canInsert = NO;
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:chatInfo, nil];
            if (resend) {
                chatInfo.timeStamp = timestamp;
//                [DATABASE updateChatRecordsWithChatMsg:chatInfo];
                canInsert = YES;
            }
            else{
                chatInfo.timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                chatInfo.nowDate = [AppTools getCurrentTime];
                [DATABASE insertChatRecordsWithChatInfoArray:arr];
            }
            if (nowDate == nil) {
                chatInfo.nowDate = [AppTools getCurrentTime];
            }
            else{
                chatInfo.nowDate = nowDate;
            }
            [self.chatTimeArray addObject:chatInfo.nowDate];
            if (canInsert) {
               [DATABASE insertChatRecordsWithChatInfoArray:arr];
            }
            //将数据写入缓冲数组，数组存数据库，同时要实现即时通信
            [self.buffArray addObject:chatInfo];
            [self.myDataArray addObject:chatInfo];
            if (!resend) {
                [self.chatTableView reloadData];
            }
            [self moveUpTable];
            self.chatInputView.ChatInputTextView.text = nil;
            return;
        }
        chatInfo.nowDate = [AppTools getCurrentTime];
        chatInfo.timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        chatInfo.isSuccess = YES;
        chatInfo.isLoading = YES;
        [self.chatTimeArray addObject:chatInfo.nowDate];
        //将数据写入缓冲数组，存数据库，同时要实现即时通信
        NSMutableArray *arr = [NSMutableArray arrayWithObject:chatInfo];
        //删除发送失败的消息
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [DATABASE openDatabase];
            [DATABASE insertChatRecordsWithChatInfoArray:arr];
        });
        [self.buffArray addObject:chatInfo];
        [self.myDataArray addObject:chatInfo];
        [self.chatTableView reloadData];
        [self moveUpTable];
        self.chatInputView.ChatInputTextView.text = nil;
        [NSThread detachNewThreadSelector:@selector(sendChatMsg:) toTarget:self withObject:chatInfo];
}

#pragma mark - KeyboardShow & Hidden
- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //设置table滚动距离
    keyboardAndInputViewHeight = keyboardRect.size.height + CHATVIEW_HEIGHT;
    
    CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGPoint center = CGPointMake(self.chatInputView.center.x, self.view.bounds.size.height - keyboardRect.size.height - self.chatInputView.bounds.size.height * .5f);
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve << 16
                     animations:^{
                         self.chatInputView.center = center;
                     } completion:^(BOOL finished) {
                         [self moveUpTable];
                     }];
}

-(void)keyboardWillHidden:(NSNotification *)noti{
    keyboardAndInputViewHeight = CHATVIEW_HEIGHT;
    NSDictionary *userInfo = [noti userInfo];
    CGPoint center = CGPointMake(self.chatInputView.center.x, self.view.bounds.size.height - self.chatInputView.bounds.size.height * .5f);
    CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve << 16
                     animations:^{
                         self.chatInputView.center = center;
                     } completion:^(BOOL finished) {
                         CGRect rect = self.chatTableView.frame;
                         rect.size.height = kScreenHeight - ORIGIN_Y - CHATVIEW_HEIGHT;
                         self.chatTableView.frame = rect;
                         if ([self.myDataArray count] >1) {
                             [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.myDataArray count] - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                         }
                     }];
}
#pragma mark - move up Table
- (void)moveUpTable
{
    float scrollOffset = self.chatTableView.contentSize.height + keyboardAndInputViewHeight  - kScreenHeight  + ORIGIN_Y;
    if (scrollOffset > 0) {
        CGRect rect = self.chatTableView.frame;
        rect.size.height = kScreenHeight - keyboardAndInputViewHeight - ORIGIN_Y - 5;
        if (IOS_VERSION < 7.0) {
            rect.size.height = kScreenHeight - keyboardAndInputViewHeight - ORIGIN_Y - 5 - 20;
        }
        self.chatTableView.frame = rect;
        canHiddenKeyboard = NO;
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.myDataArray count]-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark - UITableViewDataSource
#define TIME_HEIGHT 20
#define CELL_SPACE 50
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.myDataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageInfo *chatInfo = [self.myDataArray objectAtIndex:indexPath.section];
    CGSize lableSize ;
    CGSize size = [chatInfo.content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                               constrainedToSize:CGSizeMake(200, 10000)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    lableSize = size;
    return (lableSize.height + CELL_SPACE);
}
#define TIME_LINE_COLOR @"#999999"

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ChatMessageInfo *  chatInfo = [self.myDataArray objectAtIndex:section];
        if ([chatInfo.nowDate isEqualToString:[self.chatTimeArray objectAtIndex:section]]) {
            if((self.myDataArray.count - section) % 10 == 0){
                UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,21)];
                timeView.backgroundColor = [UIColor whiteColor];
                UIView *timeLine = [[UIView alloc] initWithFrame:CGRectMake(65,10,190, 1)];
                timeLine.backgroundColor = [AppTools colorWithHexString:TIME_LINE_COLOR];
                timeLine.alpha = .3f;
                UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120,0,74, 21)];
                timeLabel.backgroundColor = [UIColor whiteColor];
                timeLabel.text = chatInfo.nowDate;
                timeLabel.font = [UIFont systemFontOfSize:12.0];
                timeLabel.textColor = [AppTools colorWithHexString:TIME_LINE_COLOR];
                timeLabel.textAlignment = NSTextAlignmentCenter;
                [timeView addSubview:timeLine];
                [timeView addSubview:timeLabel];
                return timeView;
            }
            else {
                return nil;
            }
        }
        else{
            UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,21)];
            timeView.backgroundColor = [UIColor whiteColor];
            UIView *timeLine = [[UIView alloc] initWithFrame:CGRectMake(65,10,190, 1)];
            timeLine.backgroundColor = [AppTools colorWithHexString:TIME_LINE_COLOR];
            timeLine.alpha = .3f;
            UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120,0,74, 21)];
            timeLabel.backgroundColor = [UIColor whiteColor];
            timeLabel.text = chatInfo.nowDate;
            timeLabel.font = [UIFont systemFontOfSize:12.0];
            timeLabel.textColor = [AppTools colorWithHexString:TIME_LINE_COLOR];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [timeView addSubview:timeLine];
            [timeView addSubview:timeLabel];
            return timeView;
        }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    ChatMessageInfo *  chatInfo = [self.myDataArray objectAtIndex:section];
    if ([chatInfo.nowDate isEqualToString:[self.chatTimeArray objectAtIndex:section]]) {
        if ((self.myDataArray.count - section)%10 == 0) {
            return TIME_HEIGHT;
        }
        else{
            return 0.1;
        }
    }
    else{
        return TIME_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (!(IOS_VERSION >=7.0)) {
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.tag = indexPath.section;
    cell.delegate = self;
    ChatMessageInfo *chatInfo = [self.myDataArray objectAtIndex:indexPath.section];
    [cell configureCellWithChatMsg:chatInfo];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatInputView.ChatInputTextView resignFirstResponder];
}
#pragma mark - 下拉刷新
#pragma mark - UIScrollViewControllerDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /*
    self.canRefresh = YES;
    [self appearIndicator];
     */
    [self appearIndicator];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /*
    if (self.canRefresh && self.canReload && self.directUp) {
        [self loadRecord];
        [self hiddenIndicator];
        self.canRefresh = NO;
        self.canReload = NO;
    }*/
    if (self.directUp == YES) {
        [self loadRecord];
        self.directUp = NO;
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    /*
    if (self.chatTableView.contentOffset.y < 0 && self.canRefresh) {
        [self appearIndicator];
        self.canReload = YES;
    }
     */
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    if (self.chatTableView.contentOffset.y < 0 && self.canRefresh) {
        [self appearIndicator];
        self.canReload = YES;
        self.directUp = YES;
    }
     */
    if (self.chatTableView.contentOffset.y < 0) {
        self.directUp = YES;
    }
}
- (void)loadRecord{
    NSMutableArray *recordArray = (NSMutableArray *)[[[DATABASE fetchChatRecordsListWithCircleId:self.circleId andCircleThemeId:self.circleThemeID withId:self.recordIndex] reverseObjectEnumerator] allObjects];
    //计算出取出的数据cell总高度
//    CGFloat height = [self caculateHeightWithRecordArray:recordArray];
    if (recordArray.count == 0) {
        [self.refreshIndicator removeFromSuperview];
        return;
    }
    ChatMessageInfo *msg = [recordArray objectAtIndex:0];
    self.recordIndex = msg.msgId;
    [recordArray addObjectsFromArray:self.myDataArray];
    [self.myDataArray removeAllObjects];
    self.myDataArray  = recordArray;
    //再次初始化时间数组
    [self.chatTimeArray removeAllObjects];
    [self.chatTimeArray addObject:@"1"];
    for (int i = 0; i < [self.myDataArray count]; i++) {
//        ChatMessageInfo *info = [[ChatMessageInfo alloc]init];
        ChatMessageInfo *info = [self.myDataArray objectAtIndex:i];
        [self.chatTimeArray addObject:info.nowDate];
    }
//    self.chatTableView.contentOffset = CGPointMake(0, height + cellCount * TIME_HEIGHT);
    [self.chatTableView reloadData];
    int ret = [self.myDataArray count]-10*self.index;
    NSLog(@"scroll section: %d", ret);
    if (ret>0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ret] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.index++;
    }
}
- (void)appearIndicator{
    self.refreshIndicator.hidden = NO;
    [self.refreshIndicator startAnimating];
}
- (void)hiddenIndicator{
    self.refreshIndicator.hidden = YES;
    [self.refreshIndicator stopAnimating];
}
#pragma mark - sortedArray
- (NSArray *)sortedArrayWithArray:(NSMutableArray *)chatList{
    NSArray *arr = [chatList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[(ChatMessageInfo *)obj1 timeStamp] longLongValue] < [[(ChatMessageInfo *)obj2 timeStamp] longLongValue]) {
            return NSOrderedDescending;
        }
        else{
            return NSOrderedAscending;
        }
    }];
    return arr;
}

#pragma mark - NaviViewDelegate
- (void)leftButtonClick
{
    [self.chatInputView.ChatInputTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    //存数据
    [DATABASE createChatRecords];
    //返回lastchat
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendLastChatMsg:)]){
        [self.delegate sendLastChatMsg:[self.buffArray lastObject]];
        [self.delegate backPageType:1];
    }
    
    if (self.recvUnreadMsgFinished) {
        [self.delegate refreshList];
    }
    
}

- (void)rightButtonClick
{
    CicleMembersViewController *membersViewController = [[CicleMembersViewController alloc]init];
    membersViewController.circleID = self.circleId;
    [MobClick event:@"memberList"];
    [self.navigationController pushViewController:membersViewController animated:YES];
}

#pragma mark - ChatCellDelegate
- (void)pressToSeeUserDetail:(NSString *)userId
{
    ShowPageViewController *showPage = [[ShowPageViewController alloc] init];
    [showPage setUrlString:[NSString stringWithFormat:@"%@index.php/User/Index/user_show/id/%@.html", DOMAIN_URL,userId]];
    [SharedApp.mainTabBarViewController presentViewController:showPage animated:YES completion:^{
        
    }];
}
- (void)pressToResendMsg:(NSString*)content timeStamp:(NSString *)timeStamp nowDate:(NSString *)nowDate cellTag:(NSInteger)tag
{
    if (SharedApp.networkStatus == -1) {
        return;
    }
    ChatMessageInfo *info = [self.myDataArray objectAtIndex:tag];
    [self.myDataArray removeObjectAtIndex:tag];
    [self.chatTimeArray removeObjectAtIndex:tag + 1];
    //如果此条数据在数据库 将此条数据在数据库中也删除,根据timestamp查找数据库
    [DATABASE deleteChatRecordsWithTimeStamp:timeStamp];
    int flag;
    if (self.buffArray.count > 0) {
    for (int i = 0; i < self.buffArray.count; i++) {
        ChatMessageInfo *info = [self.buffArray objectAtIndex:i];
        if ([info.timeStamp isEqualToString:timeStamp]) {
            flag = i;
            [self.buffArray removeObjectAtIndex:flag];
            break;
        }
    }
    }
    [self sendMessage:content isResend:YES timestamp:info.timeStamp nowDate:nowDate];
}
#pragma mark - 收到离线消息
- (void)updateUnReadChatMsg:(NSMutableArray *)unReadArr{
    dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *chatRecord = [[NSMutableArray alloc]init];
    dispatch_group_async(group, t, ^{
    [DATABASE openDatabase];
    [SharedApp updateTabbarNotNewMsg];
    for (int i = 0; i < unReadArr.count; i++) {
        ChatMessageInfo *info = [[ChatMessageInfo alloc] init];
        NSDictionary *msgDict = [unReadArr objectAtIndex:i];
        info.content = [[NSString alloc] initWithData:[GTMBase64 decodeData:[[msgDict objectForKey:@"text"] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
        info.circleThemeId = [msgDict objectForKey:@"topicID"];
        info.timeStamp = [msgDict objectForKey:@"time"];
        info.isMySelf = NO;
        info.nowDate = [AppTools getShortDateWithTimestamp:[msgDict objectForKey:@"time"]];
        info.userId = [msgDict objectForKey:@"sendUserID"];
        info.isSuccess = YES;
        info.isLoading = NO;
        
        NSLog(@"info.userId: %@", info.userId);

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
        [chatRecord addObject:info];
        [self.chatTimeArray addObject:info.nowDate];
        //查找最后一条离线消息与当前聊天表中存的时间一样的消息删除掉原来的
//        if (i == unReadArr.count - 1) {
//            if ([DATABASE fetchChatRecordsWithMsg:nil timeStamp:info.timeStamp]){
//                [DATABASE deleteChatRecordsWithTimeStamp:info.timeStamp];
//            }
//        }
    }
        [DATABASE insertChatRecordsWithChatInfoArray:chatRecord];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self.myDataArray addObjectsFromArray:chatRecord];
        [self.chatTableView reloadData];
        [self moveUpTable];
    });
}
#pragma mark - 收离线未读数据拿过来
- (void)updateChatTableView:(NSNotification *)noti{
    NSMutableArray *arr = noti.object;
    for (int i = 0; i < arr.count; i++) {
        ChatMessageInfo *msg = [arr objectAtIndex:i];
        [self.chatTimeArray addObject:msg.nowDate];
    }
    [self.myDataArray addObjectsFromArray:arr];
    [self.chatTableView reloadData];
}
#pragma mark - 收离线消息结束
-(void)updateChatTableViewFinish:(NSNotification *)noti{
    //收离线消息完成，将CicleListViewController里未读标记去掉
    self.recvUnreadMsgFinished = YES;
    //更新数据库 并在返回时将此Id的cell置已读
//    [DATABASE updateCircleThemeRedPointIsRead:@"1" themeId:self.circleThemeID];
//    NSLog(@"--收离线消息完成--");
    
}

#pragma mark - 收到在线消息
- (void)updateChatlIistWithMsg:(ChatMessageInfo *)msg{
    if ([self.circleThemeID isEqualToString:msg.circleThemeId]) {
        msg.nowDate = [AppTools getCurrentTime];
        msg.circleId = self.circleId;
        if ([msg.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
            msg.isMySelf = YES;
        }
        else{
            msg.isMySelf = NO;
        }
        msg.timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        //通过userid获取user信息
        [NETWORK requestUserInfoWithUserId:msg.userId requestResult:^(NSString *response) {
            NSDictionary *responseDict = [response objectFromJSONString];
            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
            msg.userName = [dataDict objectForKey:@"username"];
            NSArray *imageArray = [dataDict objectForKey:@"avatar_url"];
            if (imageArray.count > 0) {
                msg.userHeadImageUrl = [[imageArray objectAtIndex:0] objectForKey:@"small_url"];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *arr = [NSMutableArray arrayWithObject:msg];
                [DATABASE insertChatRecordsWithChatInfoArray:arr];
            });
            //先查找聊天数据中此人的信息, 改掉头像，再查数据库 将此人在数据库中的信息更新
            for (int i = 0;i < self.myDataArray.count;i++) {
                ChatMessageInfo *info = [self.myDataArray objectAtIndex:i];
                //查用户
                if ([info.userId isEqualToString:msg.userId]) {
                    if (![info.userHeadImageUrl isEqualToString:msg.userHeadImageUrl]) {
                        //更改此信息头像
                        info.userHeadImageUrl = msg.userHeadImageUrl;
//                        [self.myDataArray replaceObjectAtIndex:i withObject:msg];
                        [DATABASE updateChatRecordsWithUserId:msg.userId newUrl:msg.userHeadImageUrl];
                    }
                }
            }
            [self.chatTimeArray addObject:msg.nowDate];
            [self.buffArray addObject:msg];
            [self.myDataArray addObject:msg];
            [self.chatTableView reloadData];
            [self moveUpTable];
        }];
    }
    
}
#pragma mark - reciveImageChage
//- (void)changeAvatar:(NSNotification *)noti{
//    //将自己的cell自己的头像换掉
//    [DATABASE updateChatRecordsWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] newUrl:[[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL]];
//}
#pragma mark - packdge ChatInfo
- (ChatMessageInfo *)packgeWithMsgContent:(NSString *)content{
    ChatMessageInfo *chatInfo = [[ChatMessageInfo alloc]init];
    chatInfo.content = content;
    chatInfo.isMySelf = YES;
    chatInfo.circleThemeId = self.circleThemeID;
    chatInfo.circleId = self.circleId;
    chatInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    chatInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    chatInfo.userHeadImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL];
    chatInfo.timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    chatInfo.nowDate = [self getCurrentTime];
    chatInfo.isLoading = YES;
    return chatInfo;
}
@end
