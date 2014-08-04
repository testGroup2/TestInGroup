//
//  ProjectLeftViewController.m
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ProjectLeftViewController.h"
#import "CustomImageView.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "UIImageView+WebCache.h"
#import "avatar_urlItem.h"
#import "ProjectSliderViewController.h"
#import "WebViewController.h"
#import "MyTableViewCell.h"
#import "ShowPageViewController.h"
#import "PViewController.h"
#import "UIButton+WebCache.h"
NSString    *CellRedBackgroundColor = @"#E33253";
@interface ProjectLeftViewController ()
{
    CustomImageView * imageView ;
}
@property (strong,nonatomic) ShowPageViewController *showPageViewController;
@property (strong,nonatomic) UIButton *b;
@property (strong,nonatomic) UILabel *label;

@property(strong,nonatomic)WebViewController * webViewController;
@property(strong,nonatomic)UINavigationController * projectNav ;
@end

@implementation ProjectLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)createUserImage
{
    NSString *nickname= [[NSUserDefaults standardUserDefaults] objectForKey:kUserNickName];
    NSString *portraitURL= [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortraitURL];
    
    self.b = [[UIButton alloc] initWithFrame:CGRectZero];
    self.b.layer.cornerRadius = 8;
    self.b.layer.masksToBounds = YES;

    [self.b setImageWithURL:[NSURL URLWithString:portraitURL]];
    [self.b addTarget:self action:@selector(pressedB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.b];

    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    self.label.text= nickname;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor= [UIColor whiteColor];
    self.label.font= [UIFont systemFontOfSize:18];
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    
    [self.view setNeedsDisplay];

    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.b.frame = CGRectMake(53, 70, 85, 85);
            self.label.frame = CGRectMake(53, 160, 85, 25);
            projectTableView.frame = CGRectMake(0, 197, 320, 480);
        }else{
            self.b.frame = CGRectMake(53, 50, 85, 85);
            self.label.frame = CGRectMake(53, 140, 85, 25);
            projectTableView.frame = CGRectMake(0, 177, 320, 480);
        }

    }else {
        if (IOS_VERSION >= 7.0) {
            self.b.frame = CGRectMake(53, 40, 85, 85);
            self.label.frame = CGRectMake(53, 130, 85, 25);
            projectTableView.frame = CGRectMake(0, 163, 320, 480);
        }else{
            self.b.frame = CGRectMake(53, 20, 85, 85);
            self.label.frame = CGRectMake(53, 110, 85, 25);
            projectTableView.frame = CGRectMake(0, 143, 320, 480);
        }
    }
}

#pragma mark - userImageViewClick -
- (void)pressedB:(UIButton *)b
{
    if ([SharedApp networkStatus] == -1) {
        PopupSmallView *p = [[PopupSmallView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150/2, self.view.frame.size.height-30-58, 150, 30) withMessage:@"网络无法连接"];
        p.layer.cornerRadius = 3;
        p.layer.masksToBounds = YES;
        [self.view addSubview:p];
        return;
    }

    [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
    
//    UserInformation *userInformationDanLi= [UserInformation downloadDatadefaultManager];
//    userItemInformation *totaluseritem = [userInformationDanLi._userArray lastObject];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",DOMAIN_URL,URL_INDEX_USER_SHOW,[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]];
    
    ShowPageViewController *showPageVC = [[ShowPageViewController alloc] init];
    //SharedApp.secondPageViewController = showPageVC;

    [showPageVC setUrlString:urlString];
    [SharedApp.mainTabBarViewController presentViewController:showPageVC animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webViewController = [[WebViewController alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:23.0/255.0 blue:47.0/255.0 alpha:1.0] ;
    projetDataArray = @[@"感兴趣的项目",@"当红娘的项目",@"我的收藏", @"我评论的项目",@"我发布的项目",@"我抢到的福利",@"我发布的福利"];
    projectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    projectTableView.dataSource = self;
    projectTableView.delegate = self;
    projectTableView.scrollEnabled = NO;
    projectTableView.backgroundColor = [UIColor clearColor];
    projectTableView.backgroundView = nil;
    [projectTableView setSeparatorColor:[UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:112.0/255.0 alpha:1.0]];
    [self.view addSubview:projectTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.b removeFromSuperview];
    [self.label removeFromSuperview];
    [self createUserImage];
}
- (void)changeUserHeadImageView{
    [self.b removeFromSuperview];
    [self createUserImage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [projetDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"arr count is %@",projetDataArray[indexPath.row]);
    static NSString * cellIdentifier = @"MyTableViewCell";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setSelectedBackgroundView:[UIView new]];
    [[cell textLabel] setHighlightedTextColor:[UIColor purpleColor]];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat: @"project%d.png",(indexPath.row)%20]];
    cell.lbl.textColor = [UIColor colorWithRed:160.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
    cell.lbl.font= [UIFont systemFontOfSize:18];
    cell.lbl.text = projetDataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *seleted = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    UIImageView * redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 40)];
    redImageView.backgroundColor = [AppTools colorWithHexString:CellRedBackgroundColor];
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
    [(ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController closeSideBar];
    switch (indexPath.row) {
        case 0:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX0];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX1];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 2:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX2];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 3:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX3];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 4:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX4];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 5:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX5];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 6:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX6];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 7:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX7];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
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

@end
