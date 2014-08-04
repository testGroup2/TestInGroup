//
//  SearchViewController.m
//  Shanghaitong
//
//  Created by xuqiang on 14-7-10.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, STATUS_HEIGHT, 280, 44)];
    searchBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar"]];//[AppTools colorWithHexString:@"#4B5970"];
    searchBar.placeholder = @"搜索(行业、地区、资源等，模糊查找)";
    
    UIButton *cacleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cacleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cacleBtn.frame = CGRectMake(280, 20, 30, 40);
    [self.navigationView addSubview:cacleBtn];
    [self.navigationView addSubview:searchBar];
    
}
- (void)leftButtonClick{
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
