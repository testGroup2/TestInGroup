//
//  MViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-24.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "MyViewController.h"
#import "ShowPageViewController.h"
@interface MyViewController ()
@property (nonatomic) CGRect rect;
@property (nonatomic) CGRect contentFrame;
@end

@implementation MyViewController
- (void)enterMyNotification{
    
}
-(void)refreshPage_Myself
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX201];
    [self.webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"wo.png"];
        self.navigationItem.title = @"我";
        self.tabBarItem.title = @"我";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SharedApp.mainTabBarViewController.tabBar setHidden:NO];
    [MobClick beginEvent:@"MySelf"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            self.MyNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 21, 320, 44)];
            [self.MyNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MyNavbar];
        }else{
            self.MyNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.MyNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MyNavbar];
        }
    }else{
        if (IOS_VERSION  >= 7.0) {
            self.MyNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 21, 320, 44)];
            [self.MyNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MyNavbar];
        }else{
            self.MyNavbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [self.MyNavbar setBackgroundImage:  [UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
            [self.view addSubview:self.MyNavbar];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage_Myself) name:@"refreshPage_Myself" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMyNotification) name:@"enterMyNotification" object:nil];
    // Do any additional setup after loading the view from its nib.
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX201];
    self.webViewController = [[WebViewController alloc] initWithURLString:urlString andType:SHTLoadWebPageMySelf];
    [self.view addSubview:self.webViewController.view];
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLabel4.font = [UIFont systemFontOfSize:22];
    titleLabel4.textColor = [UIColor whiteColor];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    titleLabel4.text = @"我";
    [self.MyNavbar addSubview:titleLabel4];
    if (IOS_VERSION >= 7.0) {
        self.contentFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        self.rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        self.webViewController.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    }else{
        self.contentFrame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        self.rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.webViewController.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    }
    

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
