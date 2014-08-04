//
//  ProjectRightViewController.m
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ProjectRightViewController.h"
#import "MyTableViewCell.h"
#import "CustomImageView.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "UIImageView+WebCache.h"
#import "avatar_urlItem.h"

#import "ProjectSliderViewController.h"
#import "WebViewController.h"
//#import "UserViewController.h"
#import "PViewController.h"

NSString    *projectRightCellYellowBackgroundColor = @"#E3BE2B";
@interface ProjectRightViewController ()

@end

@implementation ProjectRightViewController
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
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 21)];
//    v.backgroundColor = [UIColor whiteColor];
//    
//    if (IOS_VERSION >= 7.0) {
//        [self.view addSubview:v];
//    }else{
//    }
    self.view.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:23.0/255.0 blue:47.0/255.0 alpha:1.0] ;
    ProjetdataArray = [[NSArray alloc]initWithObjects:@"发布项目",@"委托项目",@"发福利",@"更新资源",@"邀请朋友",nil];
    CGRect frame = CGRectMake(105, 58,320 , 480);
    ProjecttableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    ProjecttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ProjecttableView.dataSource = self;
    ProjecttableView.delegate = self;
    ProjecttableView.scrollEnabled = NO;
    ProjecttableView.backgroundView = nil;
    ProjecttableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ProjecttableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ProjetdataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"MyTableViewCell";
     MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil] lastObject];
    }
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat: @"ProjectRight%d.png",(indexPath.row)%20]];
    cell.lbl.textColor = [UIColor colorWithRed:160.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
    cell.lbl.font= [UIFont systemFontOfSize:18];
    cell.lbl.text = ProjetdataArray[indexPath.row];
    NSLog(@"aaaa%@",cell.lbl);
    cell.backgroundColor = [UIColor clearColor];
    UIView *seleted = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    UIImageView * redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(207, 0, 8, 40)];
    redImageView.backgroundColor = [AppTools colorWithHexString:projectRightCellYellowBackgroundColor];
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
            

            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX7];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            ShowPageViewController *show = [[ShowPageViewController alloc] init];
            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX8];
            [show setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:show animated:YES completion:nil];
        }
        case 2:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            

            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX9];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
        case 3:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            

            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX10];
            [self.showPageViewController setUrlString : str];
            [SharedApp.mainTabBarViewController presentViewController:self.showPageViewController animated:YES completion:nil];
        }
        case 4:
        {
            self.showPageViewController = [[ShowPageViewController alloc] init];
            

            NSString * str = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX11];
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
    // Dispose of any resources that can be recreated.
}

@end
