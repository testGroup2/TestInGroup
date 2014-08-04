//
//  MessageLeftViewController.m
//  商海通
//
//  Created by anita on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import "MessageLeftViewController.h"
#import "CustomImageView.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "UIImageView+WebCache.h"
#import "avatar_urlItem.h"
#import "MyTableViewCell.h"

#import "MessageSliderViewController.h"
#import "WebViewController.h"
//#import "ShowMessageViewController.h"
#import "ShowMViewController.h"
#import "ShowPageViewController.h"
//#import "MessageViewController.h"

NSString    *MesCellRedBackgroundColor = @"#E33253";

@interface MessageLeftViewController () <UIGestureRecognizerDelegate>
@property (strong,nonatomic) ShowMViewController *showMessageViewController;
@end

@implementation MessageLeftViewController

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
    NSString *nickname= [[NSUserDefaults standardUserDefaults] objectForKey:kUserNickName];
    NSString *portraitURL= [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(53, 160, 85, 25)];
    label.text= nickname;
    label.textAlignment = NSTextAlignmentCenter ;
    label.textColor= [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font= [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
//    NSMutableArray * user_imageArray = totaluseritem.avatar_url;
//    avatar_urlItem * item = [user_imageArray objectAtIndex:0];
//    NSString * str = item.small_url;
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(53, 70, 85, 85)];
    b.layer.cornerRadius = 8;
    b.layer.masksToBounds = YES;
    [b setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:portraitURL]]] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(pressedB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    if (iPhone5Srceen) {
        if (IOS_VERSION >=7.0) {
            b.frame = CGRectMake(53, 70, 85, 85);
            label.frame = CGRectMake(53, 160, 85, 25);
            MessagetableView.frame = CGRectMake(0, 197, 320, 480);
        }else{
            b.frame = CGRectMake(53, 50, 85, 85);
            label.frame = CGRectMake(53, 140, 85, 25);
            MessagetableView.frame = CGRectMake(0, 177, 320, 480);
        }
    }else {
        if (IOS_VERSION >= 7.0) {
            b.frame = CGRectMake(53, 38, 85, 85);
            label.frame = CGRectMake(53, 128, 85, 25);
            MessagetableView.frame = CGRectMake(0, 160, 320, 480);
        }else{
            b.frame = CGRectMake(53, 18, 85, 85);
            label.frame = CGRectMake(53, 108, 85, 25);
            MessagetableView.frame = CGRectMake(0, 140, 320, 480);
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
    [(MessageSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController closeSideBar];
//    UserInformation *userInformationDanLi= [UserInformation downloadDatadefaultManager];
//    userItemInformation *totaluseritem = [userInformationDanLi._userArray lastObject];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]);
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",DOMAIN_URL,URL_INDEX_USER_SHOW,[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]];
    ShowPageViewController *showPageVC = [[ShowPageViewController alloc] init];
    [showPageVC setUrlString:urlString];
    [SharedApp.mainTabBarViewController presentViewController:showPageVC animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:23.0/255.0 blue:47.0/255.0 alpha:1.0];
    MessagedataArray = [[NSArray alloc]initWithObjects:@"对项目感兴趣",@"为项目当红娘",@"项目评论",@"对资源感兴趣",@"谁信任了我",@"我的私信",@"圈子通知",@"系统消息", nil];
    MessagetableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    MessagetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MessagetableView.dataSource = self;
    MessagetableView.delegate = self;
    MessagetableView.scrollEnabled = NO;
    MessagetableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:MessagetableView];
    [self createUserImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self createUserImage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [MessagedataArray count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"MyTableViewCell";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil] lastObject];
    }
    UIImage *image =[UIImage imageNamed:[NSString stringWithFormat: @"Message%d.png",(indexPath.row)%20]];
    
    cell.imgView.image = image;
    cell.lbl.textColor = [UIColor colorWithRed:160.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
    cell.lbl.font= [UIFont systemFontOfSize:18];
    cell.lbl.text = MessagedataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *seleted = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    UIImageView * redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 40)];
    redImageView.backgroundColor = [AppTools colorWithHexString:MesCellRedBackgroundColor];
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
    
    [[MessageSliderViewController sharedSliderController] closeSideBar];

    switch (indexPath.row) {
        case 0:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX102];
            
//            [self.showMessageViewController setUrlString : str];
//            NSString * labelText = [MessagedataArray objectAtIndex:0];
//            [self.showMessageViewController setLabelText:labelText];
//            [SharedApp.mainTabBarViewController presentViewController:self.showMessageViewController animated:YES completion:nil];
            [[MessageSliderViewController sharedSliderController] closeSideBar];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
        case 1:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX103];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
            break;
        }
        case 2:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX104];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
        case 3:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX105];
            [self.showMessageViewController setUrlString : str];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
            break;
        }
        case 4:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX106];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
        case 5:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX107];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
        case 6:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX108];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
       
        case 7:
        {
            self.showMessageViewController = [[ShowMViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX109];
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadMessageWithUrl:)]) {
                [self.delegate loadMessageWithUrl:str];
            }
        }
            break;
          default:
            break;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Target Action -

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    [((MessageSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController)) closeSideBar];
//    ((MessageViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController)).MainVC).didShowedLeft = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
