//
//  ABTabBarController.m
//  Enoda
//
//  Created by Alexander Blunck on 09.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ABTabBarController.h"
#import "ProjectSliderViewController.h"
#import "ResourceSliderViewController.h"
#import "MessageSliderViewController.h"

#import "RViewController.h"
#import "MViewController.h"
#import "MyViewController.h"

#import "FriendViewController.h"

#import "CicleListViewController.h"

#import "ProjectLeftViewController.h"
#import "ProjectRightViewController.h"
#import "ResourceLeftViewController.h"
#import "MessageLeftViewController.h"
#import "NewMessagePromptView.h"

#import "AppDelegate.h"
#import "HeartBeat.h"

@implementation ABTabBarController

@synthesize tabBarItems=_tabBarItems, tabBarHeight=_tabBarHeight, backgroundImage=_backgroundImage;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabbar) name:@"swipeUp" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbar) name:@"swipeDown" object:nil];
        
        ProjectSliderViewController *sPVC = [[ProjectSliderViewController alloc] init];
        AbTabBarItem *pvcTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"众筹" image:[UIImage imageNamed:@"footer_ico_1.png"] selectedImage:[UIImage imageNamed:@"footer_ico_1"] viewController:sPVC];

//        FriendViewController *friendVC = [[FriendViewController alloc] init];
//        [ResourceSliderViewController sharedSliderController].LeftVC = [[ResourceLeftViewController alloc] init];
//        [ResourceSliderViewController sharedSliderController].RightVC = [[ProjectRightViewController alloc] init];
//        [ResourceSliderViewController sharedSliderController].MainVC = friendVC;
//        AbTabBarItem *resourceVCTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"海友" image:[UIImage imageNamed:@"footer_ico_2"] selectedImage:[UIImage imageNamed:@"footer_ico_2"] viewController:[ResourceSliderViewController sharedSliderController]];
        
        RViewController *resourceVC = [[RViewController alloc] init];
//        UINavigationController *resourceNavigationC = [[UINavigationController alloc] initWithRootViewController:resourceVC];
        [ResourceSliderViewController sharedSliderController].LeftVC = [[ResourceLeftViewController alloc] init];
        [ResourceSliderViewController sharedSliderController].RightVC = [[ProjectRightViewController alloc] init];
        [ResourceSliderViewController sharedSliderController].MainVC = resourceVC;
        AbTabBarItem *resourceVCTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"海友" image:[UIImage imageNamed:@"footer_ico_2"] selectedImage:[UIImage imageNamed:@"footer_ico_2"] viewController:[ResourceSliderViewController sharedSliderController]];
        
        
//        MViewController *messageVC = [[MViewController alloc] init];
//        [MessageSliderViewController sharedSliderController].LeftVC = [[MessageLeftViewController alloc]init];
//        [MessageSliderViewController sharedSliderController].RightVC = [[ProjectRightViewController alloc] init];
//        [MessageSliderViewController sharedSliderController].MainVC = messageVC;
//        AbTabBarItem *messageVCTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"footer_ico_3"] selectedImage:[UIImage imageNamed:@"footer_ico_3"] viewController:[MessageSliderViewController sharedSliderController]];
        
        CircleListViewController *circleListVC = [[CircleListViewController alloc] init];
        UINavigationController *circleNaviController = [[UINavigationController alloc]initWithRootViewController:circleListVC];
        
       AbTabBarItem *circleListVCTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"圈子" image:[UIImage imageNamed:@"footer_ico_4"] selectedImage:[UIImage imageNamed:@"footer_ico_4"] viewController:circleNaviController];
        
        MyViewController *myselfVC = [[MyViewController alloc] init];
        AbTabBarItem *myselfVCTabBarItem = [[AbTabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"footer_ico_5"] selectedImage:[UIImage imageNamed:@"footer_ico_5"] viewController:myselfVC];
        //messageVCTabBarItem
        self.tabBarItems = [NSMutableArray arrayWithArray:@[pvcTabBarItem,resourceVCTabBarItem,circleListVCTabBarItem,myselfVCTabBarItem]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        _tabBar = [[ABTabBar alloc] initWithTabItems:self.tabBarItems height:self.tabBarHeight backgroundImage:self.backgroundImage];
    }else{
        _tabBar = [[ABTabBar alloc]initWithTabItems:self.tabBarItems height:self.tabBarHeight backgroundImage:self.backgroundImage];
    }
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    
    [_tabBar createTabs];
    [_tabBar loadDefaultView];
    SharedApp.didLogined = YES;
    SharedApp.didNeedRefreshList = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"show main tab controller");
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)selectIndex
{
    return self.tabBar.selectIndex;
}

-(UIViewController*)selectController
{
    AbTabBarItem* tabBarItem = [self.tabBarItems objectAtIndex:self.selectIndex];
    UINavigationController* controller = (UINavigationController*)tabBarItem.viewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [controller.viewControllers objectAtIndex:0];
    }
    return controller;
}

#pragma mark - Notication Method -

-(void) showTabbar
{
    SharedApp.mainTabBarViewController.tabBar.hidden = NO;
}
-(void) hideTabbar
{
   SharedApp.mainTabBarViewController.tabBar.hidden = YES;
}

#pragma mark - ABTabBarDelegate -

-(void) abTabBarSwitchView:(UIViewController *)viewController
{
    //Remove Current active View by getting it via it's tag
    NSLog(@"viewController: %@", viewController);

    if (iPhone5Srceen) {
        if (IOS_VERSION >= 7.0) {
            viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarHeight);

        }else{
            viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height- self.tabBarHeight);//
        }
    }else{
        if (IOS_VERSION >= 7.0) {
            viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarHeight);
        }else{
            viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarHeight);
        }
    }
    
    NSLog(@"view  %@",self.view);
    NSLog(@"tabbar  %@",self.tabBar);
    viewController.view.tag = ACTIVE_ABTABBAR_VIEW;
    [self.view insertSubview:viewController.view belowSubview:_tabBar];
}

@end
