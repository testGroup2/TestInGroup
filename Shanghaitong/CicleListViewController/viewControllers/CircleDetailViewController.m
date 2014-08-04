//
//  CircleDetailViewController.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "CircleDetailTitleView.h"
#import "CircleDetailInfo.h"
#import "ShowPageViewController.h"
#import "SDImageCache.h"
#import "MemberInfo.h"
#import "CircleReportViewController.h"

@interface CircleDetailViewController ()<UIScrollViewDelegate,ContributeToCicleViewControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIScrollView *groupInfoScrollView;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSMutableArray *imageSmallViewArray;
@property (nonatomic,strong) UIScrollView *scanScrollView;
@property (nonatomic,strong) NSMutableArray *imageSmallUrlArray;
@property (nonatomic,strong) UIButton *guideTabBarBtn;//按钮
@property (nonatomic, strong)   ABTabBar       *tabBar;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *imageBigUrlArray;
//@property (nonatomic,strong) UIActivityIndicatorView *activity;
@end

@implementation CircleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    [MobClick beginEvent:@"circleTheme" label:self.circleID];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"circleTheme" label:self.circleID];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.view.frame = CGRectMake(0, ORIGIN_Y, kScreenWidth, kScreenHeight - ORIGIN_Y);
     SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    self.dataDict = [[NSDictionary alloc]init];
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    [self.navigationView.rightButton setImage:[UIImage imageNamed:@"rightEditBtn"] forState:UIControlStateNormal];
    self.navigationView.titleLabel.text = self.circleName;
    self.navigationView.titleLabel.font = [UIFont fontWithName:@"heiti" size:22.0f];
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:22];
    self.groupInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ORIGIN_Y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.groupInfoScrollView];

    [NETWORK requestCircleDetailWithid:self.circleID requestResult:^(NSString *respose) {
        if ([respose isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            [self.view bringSubviewToFront:self.p];
            //从数据库中取
            if([[NETWORK readCircleDetailDatabaseWithThemeId:self.circleID] count] > 0){
                CircleDetailInfo *info = [[NETWORK readCircleDetailDatabaseWithThemeId:self.circleID] objectAtIndex:0];
                [self customMakeselfViewWithInfo:info];
            }  
        }
        else{
            NSDictionary *responseDict = [respose objectFromJSONString];
            NSDictionary *dict = [responseDict objectForKey:@"data"];
            CircleDetailInfo *info = [[CircleDetailInfo alloc]init];
            info.circleDetailId = self.circleID;
            info.circleTitle = [dict objectForKey:@"title"];
            info.circleNotice = [dict objectForKey:@"content"];
            info.circleLeaderName = [[dict objectForKey:@"user"] objectForKey:@"username"];
            info.circleSmallImageArray = [[NSMutableArray alloc]init];
            self.imageBigUrlArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [[dict objectForKey:@"pic"] count]; i++) {
                NSDictionary *imageDict = [[dict objectForKey:@"pic"] objectAtIndex:i];
                [info.circleSmallImageArray addObject:[imageDict objectForKey:@"small_url"]];
                [info.circleImageArray addObject:[imageDict objectForKey:@"url"]];
                [self.imageBigUrlArray addObject:[imageDict objectForKey:@"url"]];
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"ctime"] doubleValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            info.circleUpdateTime = [formatter stringFromDate:date];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([DATABASE fetchThemeDetailCountWithCircleDetailId:info.circleDetailId]) {
                    [DATABASE updateThemeDetailWIthCircleDetailId:info];
                }
                else{
                    [DATABASE insertCircleDetailWithInfo:info];
                }
            });
            [self customMakeselfViewWithInfo:info];
        }
    }];
    SharedApp.stayNotFirstPage = YES;
    self.guidButton.hidden = NO;
    [self.view bringSubviewToFront:self.guidButton];
    
    
    // 添加手势隐藏bar
    UITapGestureRecognizer *hideTabbar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTarbarTapgesture:)];
    hideTabbar.delegate = self;
    [self.view addGestureRecognizer:hideTabbar];
    
    
    UIButton *reportBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40-5, [UIScreen mainScreen].bounds.size.height-30-5, 40, 30)];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(pressedReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportBtn];

}

- (void)popCurrentViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)guidBttonAction
{
    [super guidBttonAction];
    [self.view bringSubviewToFront:self.tabBar];
    self.tabBar.hidden = NO;
}

#define TITLE_COLOR @"#555555"
#define NAME_COLOR @"#508dc5"
#define TIME_COLOR @"#999999"

- (void)customMakeselfViewWithInfo:(CircleDetailInfo *)info
{
    CircleDetailTitleView *headView = [[[NSBundle mainBundle]
                                        loadNibNamed:@"CircleDetailTtile"
                                        owner:nil
                                        options:nil]
                                       lastObject];
    headView.sepratorLine.backgroundColor = [AppTools colorWithHexString:@"#d4d4d4"];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width,88);
    headView.titleLabel.text =  info.circleTitle;
    headView.titleLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
    headView.nameLabel.text = info.circleLeaderName;
    //添加点击手势
     headView.nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameClickWithUserId:)];
    [headView.nameLabel addGestureRecognizer:tap];
    headView.nameLabel.textColor = [AppTools colorWithHexString:NAME_COLOR];
    headView.timeLabel.text = info.circleUpdateTime;
    headView.timeLabel.textColor = [AppTools colorWithHexString:TIME_COLOR];
    [self.groupInfoScrollView addSubview:headView];
    
    CGFloat y = CGRectGetMaxY(headView.frame);
    NSString *detailStr = info.circleNotice;
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.numberOfLines = 1000;
    detailLabel.font = [UIFont systemFontOfSize:16.0f];
    detailLabel.textColor = [AppTools colorWithHexString:@"#555555"];
    detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size;
    size = [detailStr sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(300, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    detailLabel.text = detailStr;
    detailLabel.frame = CGRectMake(10, y, size.width,size.height);
    [self.groupInfoScrollView addSubview:detailLabel];
    
    
    y = CGRectGetMaxY(detailLabel.frame);
    self.imageSmallViewArray  = [[NSMutableArray alloc]init];
    self.imageSmallUrlArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < info.circleSmallImageArray.count; i++) {
        [self.imageSmallUrlArray addObject:[info.circleSmallImageArray objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*78 + 8, y + 30, 70, 70)];
        [imageView setImageWithURL:[info.circleSmallImageArray objectAtIndex:i] placeholderImage:nil];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(tapActionShowInScrollView:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.imageSmallViewArray addObject:imageView];
        [self.groupInfoScrollView addSubview:imageView];
    }
    self.groupInfoScrollView.contentSize = CGSizeMake(kScreenWidth, 88 + size.height + 200);
}
//展示图片
#define kPageControlWidth 100
- (void)tapActionShowInScrollView:(UITapGestureRecognizer *)tap
{
    self.scanScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scanScrollView.showsHorizontalScrollIndicator = NO;
    self.scanScrollView.contentSize = CGSizeMake(kScreenWidth * self.imageSmallViewArray.count,kScreenHeight);
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85f];
    self.scanScrollView.backgroundColor = color;
    self.scanScrollView.delegate = self;
    [self.view addSubview:self.scanScrollView];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth - kPageControlWidth)/2, kScreenHeight - 50, kPageControlWidth, 20)];
    self.pageControl.numberOfPages = self.imageSmallViewArray.count;
    [self.view addSubview:self.pageControl];
    UIImageView *tapImageView = (UIImageView *)tap.view;
    if (self.imageBigUrlArray.count > 0) {
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:@[[self.imageBigUrlArray objectAtIndex:tapImageView.tag],@(tapImageView.tag)]];
    }
    if (self.imageSmallViewArray.count > 0) {
        for (int i = 0 ; i < self.imageSmallViewArray.count; i++) {
            UIImageView *imageView = [self.imageSmallViewArray objectAtIndex:i];
            UIImage *image = imageView.image;
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0,kScreenWidth * .8f,kScreenWidth * height / width * .8f)];
            imageView1.tag = i + 1000;
            imageView1.image = image;
            CGFloat originPoint =  kScreenHeight/2 - imageView1.frame.size.height/2;
            imageView1.frame = CGRectMake(imageView1.frame.origin.x + kScreenWidth *.1f,
                                          originPoint,
                                          imageView1.frame.size.width ,
                                          imageView1.frame.size.height);
            [self.scanScrollView addSubview:imageView1];
            self.scanScrollView.clipsToBounds = NO;
        }
        self.scanScrollView.pagingEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tapImageAction)];
        self.scanScrollView.userInteractionEnabled = YES;
        [self.scanScrollView addGestureRecognizer:tap];
        self.scanScrollView.contentOffset = CGPointMake(kScreenWidth * tapImageView.tag, 0);
        self.pageControl.currentPage = tapImageView.tag;
    }
}
- (void)downloadImage:(NSArray*)arr{
    if (SharedApp.networkStatus == -1) {
        [self showErrorMessage:@"无网络连接"];
        return;
    }
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromKey:[arr objectAtIndex:0]];
    UIImage *image = nil;
    if (cacheImage == nil) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[arr objectAtIndex:0]]];
        image = [UIImage imageWithData:imageData];
        [[SDImageCache sharedImageCache] storeImage:image forKey:[arr objectAtIndex:0]];
    }
    else{
        image = [[SDImageCache sharedImageCache] imageFromKey:[arr objectAtIndex:0]];
    }
    [self performSelectorOnMainThread:@selector(finishLoadView:) withObject:@[image,[arr objectAtIndex:1]] waitUntilDone:YES];
}
- (void)finishLoadView:(NSArray *)arr{
    int i = [[arr objectAtIndex:1] integerValue];
    UIImage *image = [arr objectAtIndex:0];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0,kScreenWidth,kScreenWidth * height/width)];
    imageView1.image = image;
    CGFloat originPoint =  kScreenHeight/2 - imageView1.frame.size.height/2;
    imageView1.frame = CGRectMake(imageView1.frame.origin.x,
                                  originPoint,
                                  imageView1.frame.size.width,
                                  imageView1.frame.size.height);
    for (UIView *imageView in self.scanScrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if (imageView.tag == 1000 + i) {
                    imageView.transform = CGAffineTransformMakeScale(1, 1);
                    [imageView removeFromSuperview];
                    [self.scanScrollView addSubview:imageView1];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    if (self.imageBigUrlArray.count >0) {
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:@[[self.imageBigUrlArray objectAtIndex:self.pageControl.currentPage],@(self.pageControl.currentPage)]];
    }
}

- (void)nameClickWithUserId:(UITapGestureRecognizer *)tap
{
    if ([SharedApp networkStatus] == -1) {
        [self showNetworkErrorMessage:@"网络无法连接"];
        [self.view bringSubviewToFront:self.p];
        return;
    }
    ShowPageViewController *showPage = [[ShowPageViewController alloc] init];
    [showPage setUrlString:[NSString stringWithFormat:@"%@index.php/User/Index/user_show/id/%@.html", DOMAIN_URL, self.administratorId]];
    [self presentViewController:showPage animated:YES completion:^{}];
}

- (void)tapImageAction{
    self.scanScrollView.hidden = YES;
    [self.pageControl removeFromSuperview];
    [self.scanScrollView removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - NavigationViewDelegate
- (void)leftButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    SharedApp.stayNotFirstPage = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(reciveAdminID:)]) {
        [self.delegate reciveAdminID:self.administratorId];
    }
}
- (void)rightButtonClick{
    self.contributeViewConroller = [[ContributeToCicleViewController alloc]init];
    self.contributeViewConroller.delegate = self.delegate;
    [self.navigationController pushViewController:self.contributeViewConroller animated:YES];
}

#pragma mark - Gesture and Button Action -

- (void)hideTarbarTapgesture:(UITapGestureRecognizer *)gesture
{
    NSLog(@"hide Tarbar");
    [self.tabBar removeFromSuperview];
}

- (void)pressedReportBtn:(UIButton *)button
{
    CircleReportViewController *report = [[CircleReportViewController alloc] init];
    report.topic_id = [self.circleID integerValue];
    [self.navigationController pushViewController:report animated:YES];
    
}
@end
