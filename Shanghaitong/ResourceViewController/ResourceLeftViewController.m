//
//  ResourceLeftViewController.m
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ResourceLeftViewController.h"
#import "CustomImageView.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "UIImageView+WebCache.h"
#import "avatar_urlItem.h"
#import "MyTableViewCell.h"

#import "ResourceSliderViewController.h"
#import "WebViewController.h"
#import "ShowPageViewController.h"
#import "RViewController.h"

NSString    *ResCellRedBackgroundColor = @"#E33253";
@interface ResourceLeftViewController ()
@property (strong,nonatomic) ShowPageViewController *showPageViewController;
@property (strong,nonatomic) UIButton *b;
@end

@implementation ResourceLeftViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)createUserImage
{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSString *nickname= [[NSUserDefaults standardUserDefaults] objectForKey:kUserNickName];
    NSString *portraitURL= [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL];
    UILabel * label = [[UILabel alloc]init];
    label.text= nickname;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter ;
    label.textColor= [UIColor whiteColor];
    label.font= [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
    self.b = [[UIButton alloc] initWithFrame:CGRectMake(53, 50, 85, 85)];
    self.b.layer.cornerRadius = 8;
    self.b.layer.masksToBounds = YES;
    [self.b setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:portraitURL]]] forState:UIControlStateNormal];
    [self.b addTarget:self action:@selector(pressedB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.b];
    
    if (iPhone5Srceen) {
        if (IOS_VERSION >=7.0) {
            self.b.frame = CGRectMake(53, 70, 85, 85);
            label.frame = CGRectMake(53, 160, 85, 25);
            ResoucetableView.frame = CGRectMake(0, 197, 320, 480);
        }else{
            self.b.frame = CGRectMake(53, 50, 85, 85);
            label.frame = CGRectMake(53, 140, 85, 25);
            ResoucetableView.frame = CGRectMake(0, 177, 320, 480);
        }
    }else {
        if (IOS_VERSION >= 7.0) {
            self.b.frame = CGRectMake(53, 40, 85, 85);
            label.frame = CGRectMake(53, 130, 85, 25);
            ResoucetableView.frame = CGRectMake(0, 163, 320, 480);
        }else{
            self.b.frame = CGRectMake(53, 20, 85, 85);
            label.frame = CGRectMake(53, 110, 85, 25);
            ResoucetableView.frame = CGRectMake(0, 143, 320, 480);
        }

    }
}

- (void)pressedB:(UIButton *)b
{
    if ([SharedApp networkStatus] == -1) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150/2, self.view.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        return;
    }
    [(ResourceSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:1]).viewController closeSideBar];
//    UserInformation *userInformationDanLi= [UserInformation downloadDatadefaultManager];
//    userItemInformation *totaluseritem = [userInformationDanLi._userArray lastObject];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",DOMAIN_URL,URL_INDEX_USER_SHOW,[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]];
    ShowPageViewController *showPageVC = [[ShowPageViewController alloc] init];
    [showPageVC setUrlString:urlString];
    [SharedApp.mainTabBarViewController presentViewController:showPageVC animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self createUserImage];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserHeadImageView) name:@"kChangeUserHead" object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:23.0/255.0 blue:47.0/255.0 alpha:1.0] ;
    ResoucedataArray = [[NSArray alloc]initWithObjects:@"我感兴趣的",@"我的资源",nil];
    CGRect frame = CGRectMake(0, 170,320,480);
    ResoucetableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    ResoucetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ResoucetableView.dataSource = self;
    ResoucetableView.delegate = self;
    ResoucetableView.scrollEnabled = NO;
    ResoucetableView.backgroundColor = [UIColor clearColor];
    ResoucetableView.backgroundView = nil;
    [self.view addSubview:ResoucetableView];
}
-(void)changeUserHeadImageView{
    [self.b removeFromSuperview];
    [self createUserImage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ResoucedataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"MyTableViewCell";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil] lastObject];
    }
    UIImage *image =[UIImage imageNamed:[NSString stringWithFormat: @"Resouce%d.png",(indexPath.row)%20]];
    cell.imgView.image = image;
    cell.lbl.textColor = [UIColor colorWithRed:160.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
    cell.lbl.font= [UIFont systemFontOfSize:18];
    cell.lbl.text = ResoucedataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *seleted = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    UIImageView * redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 40)];
    redImageView.backgroundColor = [AppTools colorWithHexString:ResCellRedBackgroundColor];
    [seleted addSubview:redImageView];
    seleted.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [cell setSelectedBackgroundView:seleted];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([SharedApp networkStatus] == -1) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150/2, self.view.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        
        return;
    }

    [[ResourceSliderViewController sharedSliderController]closeSideBar];
    switch (indexPath.row) {
        case 0:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX52];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX53];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
               default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
