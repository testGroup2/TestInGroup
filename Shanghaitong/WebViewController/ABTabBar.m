//
//  ABTabBar.m
//
//  Created by Alexander Blunck on 15.02.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ABTabBar.h"
#import "AbTabBarItem.h"
#import "RViewController.h"
#import "MessageSliderViewController.h"
#import "NewMessagePromptView.h"
#import "ShowPageViewController.h"
#import "ProjectRightViewController.h"
#import "AddCicleViewController.h"
#import "CircleAbstractInfo.h"
static const NSUInteger tabBarTitleHeight = 20;
static const NSUInteger tabBarTitleWidth = 30;
static const NSUInteger tabBarImageWidth = 23;
static const NSUInteger tabBarImageHeight = 23;
NSString   *tarBarBackgroundColor = @"#313b51";
NSString   *tarBarSelectedColor = @"#1F2637";

@interface ABTabBar()

@end

@implementation ABTabBar

@synthesize delegate;
@synthesize tabBarItemArray=_tabBarItemArray, buttonArray=_buttonArray;

-(id) initWithTabItems:(NSArray*)tabBarItemsArray height:(float)tbHeight backgroundImage:(UIImage*)bgImage
{
    if ((self = [super init])) {
        //Set TabBar Height
        tabBarHeight = tbHeight;
        //Frame
        if (iPhone5Srceen) {
            self.frame = CGRectMake(0, 568-tabBarHeight, 320, tabBarHeight);
            if (IOS_VERSION < 7.0) {
                self.frame = CGRectMake(0, 568- tabBarHeight - 20, 320, tabBarHeight);
            }
        }else {
            if (IOS_VERSION >= 7.0) {
                self.frame = CGRectMake(0, 480 - tabBarHeight, 320, tabBarHeight);
            }else{
                self.frame = CGRectMake(0, 480 - tabBarHeight, 320, tabBarHeight);
            }
        }
        //BackgroundImage if not set use simple black background
        if (bgImage == nil) {
            self.backgroundColor = [AppTools colorWithHexString:tarBarBackgroundColor];
        } else {
            self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        }
        //Load all tabBarItems into local Array
        self.tabBarItemArray= [NSMutableArray arrayWithArray:tabBarItemsArray];
        
        //Alocate Array to hold the UIButtons created from the ABTabBarItems
        self.buttonArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
    }
    return self;
}

-(void) createTabs
{
    //Calculate Tab Width
    int tabCount = self.tabBarItemArray.count;
    float tabWidth = 320 / tabCount;
    int tabCounter = 0;
    for (AbTabBarItem *aTabBarItem in self.tabBarItemArray) {
        float buttonXValue = tabWidth*tabCounter;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tabCounter;
        button.frame = CGRectMake(buttonXValue, 0, tabWidth, 49);
        
        //Keep button from "darkening out" when selected twice
        [button setAdjustsImageWhenHighlighted:NO];
        [button addTarget:self action:@selector(tabTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (aTabBarItem.image) { // 添加图片
            UIImageView *tabBarItemImage = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x+(button.frame.size.width)/2-tabBarImageWidth/2, button.frame.origin.y+5, tabBarImageWidth, tabBarImageHeight)];
            tabBarItemImage.tag = tabCounter;
            tabBarItemImage.image = aTabBarItem.image;
            [self addSubview:tabBarItemImage];
            [self.imageArray addObject:tabBarItemImage];
        }
        
        if (aTabBarItem.title) { // 添加标题
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x+(button.frame.size.width)/2-tabBarTitleWidth/2, 26, tabBarTitleWidth, tabBarTitleHeight)];
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor whiteColor];
            title.font = [UIFont systemFontOfSize:14.f];
            title.text = aTabBarItem.title;
            [self addSubview:title];
        }
        [self.buttonArray addObject:button];
        tabCounter += 1;
    }
    
    if ([DATABASE fetchNotReadMessage] > 0) {
        //   让tabbar上的小红点显示
        [SharedApp updateTabbarNewMsg];
    }
}

- (void)tabTouchUpInside:(UIButton *)touchedTab
{
    //Get ABTabBarItem index in array for corresponding button
    int indexOfTabInArray = [self.buttonArray indexOfObject:touchedTab];
    self.selectIndex = indexOfTabInArray;
    SharedApp.tarBarSelectIndex = indexOfTabInArray;
    if (SharedApp.stayNotFirstPage) {
        SharedApp.stayNotFirstPage = NO;
        SharedApp.didNeedRefreshList = NO;
        
        NSLog(@"SharedApp.tarBarSelectIndex: %d", SharedApp.tarBarSelectIndex);
        [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:SharedApp.tarBarSelectIndex]];
        
        if (self.selectIndex == ButtonIndexPro) {
            ProjectSliderViewController *pSlider = (ProjectSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexPro]).viewController;
            [pSlider closeSideBar];
        }else if (self.selectIndex == ButtonIndexResourc) {
            [(ResourceSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexResourc]).viewController closeSideBar];
        }
//        else if (self.selectIndex == 2) {
//            [(MessageSliderViewController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController closeSideBar];
//        }
        
        if (SharedApp.mainTabBarViewController.presentedViewController.presentedViewController) {
            UIViewController *temp = SharedApp.mainTabBarViewController.presentedViewController.presentedViewController;
            [SharedApp.mainTabBarViewController.presentedViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
                [SharedApp.mainTabBarViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }];
            [SharedApp.mainTabBarViewController presentViewController:temp animated:NO completion:nil];
            [temp dismissViewControllerAnimated:YES completion:^{}];
        }else {
            [SharedApp.mainTabBarViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            if(((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers.count == ButtonIndexMy){
                 UIViewController *viewController = [((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:1];
                [viewController.navigationController popToRootViewControllerAnimated:YES];
            }
            if(((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers.count == ButtonIndexCircle){
                UIViewController *v = [((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:ButtonIndexPro];
                [v dismissViewControllerAnimated:YES completion:nil];
                UIViewController *viewController = [((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:ButtonIndexCircle]).viewController).viewControllers objectAtIndex:1];
                
                [viewController.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        //关掉navigationcontroller
            if (self.delegate && [self.delegate respondsToSelector:@selector(popCurrentViewController)]) {
                [self.delegate popCurrentViewController];
            }
        SharedApp.didNeedRefreshList = YES;
        return;
    }
    
    if (touchedTab.tag == ButtonIndexPro) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginCaculate" object:nil];
        [MobClick endEvent:@"海友"];
        [MobClick endEvent:@"CircleList"];
        [MobClick endEvent:@"MySelf"];
    }else if (touchedTab.tag == ButtonIndexResourc){
        [MobClick event:@"Resource"];
        //pro 停止计时
        [MobClick endEvent:@"Project" label:@"众筹"];
        [MobClick endEvent:@"Project" label:@"房地产"];
        [MobClick endEvent:@"Project" label:@"抢福利"];
        [MobClick endEvent:@"CircleList"];
        [MobClick endEvent:@"MySelf"];
        
        [MobClick beginEvent:@"Resource"];
        
    }else if(touchedTab.tag == ButtonIndexCircle){
        [MobClick event:@"CircleList"];
        [MobClick beginEvent:@"CircleList"];
        
        [MobClick endEvent:@"Project" label:@"众筹"];
        [MobClick endEvent:@"Project" label:@"房地产"];
        [MobClick endEvent:@"Project" label:@"抢福利"];
        [MobClick endEvent:@"MySelf"];
        
        [MobClick endEvent:@"Resource"];
        
    }else if (touchedTab.tag == ButtonIndexMy){
        
        [MobClick event:@"MySelf"];
        [MobClick beginEvent:@"MySelf"];
        [MobClick endEvent:@"Project" label:@"众筹"];
        [MobClick endEvent:@"Project" label:@"房地产"];
        [MobClick endEvent:@"Project" label:@"抢福利"];
        [MobClick endEvent:@"CircleList"];
        [MobClick endEvent:@"Resource"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Myself" object:nil];
    }
   
    if (SharedApp.didNeedRefreshList) {
        //点击时刷新页面
        if (touchedTab.tag == ButtonIndexPro && SharedApp.didLogined &&touchedTab.selected == YES) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Project" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Project" object:self userInfo:@{@"key": @"1"}];
            
        }
        if (touchedTab.tag == ButtonIndexResourc && SharedApp.didLogined &&touchedTab.selected == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Resource" object:self];
            
        }
        if (touchedTab.tag == ButtonIndexCircle && SharedApp.didLogined &&touchedTab.selected == YES) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Message" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Circle" object:self];
            
        }
        if (touchedTab.tag == ButtonIndexMy && SharedApp.didLogined &&touchedTab.selected == YES) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Circle" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Myself" object:self];
            
        }
//        if (touchedTab.tag == 4 && SharedApp.didLogined &&touchedTab.selected == YES) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Myself" object:self];
//            
//        }
    }
    
    
    //Make sure to only switch views if you select an other tab than the one you are in now
    if (!touchedTab.selected) {
        //Get ViewController of touched tabBarItem
        UIViewController *viewController = [[self.tabBarItemArray objectAtIndex:indexOfTabInArray] viewController];
        _currentViewController = (UINavigationController *)viewController;
        //Tell Delegate to Switch View
        if (self.delegate && [self.delegate respondsToSelector:@selector(abTabBarSwitchView:)]) {
            [self.delegate abTabBarSwitchView:viewController];
        }
    }
    
    //Set All other tabs unselected
    for (UIButton *button in self.buttonArray) {
        [button setSelected:NO];
        button.backgroundColor = [UIColor clearColor];
    }
    //Set touched tab selected
    [touchedTab setSelected:YES];
    
    // 恢复所有按钮状态
//    for (UIButton *button in self.buttonArray) {
//        if (button.tag == 2) {
//            [button setBackgroundImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
//        }else {
//            [button setBackgroundImage:nil forState:UIControlStateNormal];
//        }
//    }
//    
//    if (touchedTab.tag == 2) {
//        [touchedTab setBackgroundImage:[UIImage imageNamed:@"mainPres"] forState:UIControlStateNormal];
//    }
    
    // 恢复所有图片状态
    for (UIImageView *imageView in self.imageArray) {
        switch (imageView.tag) {
            case 0:
                imageView.image = [UIImage imageNamed:@"footer_ico_1"];
                break;
            case 1:
                imageView.image = [UIImage imageNamed:@"footer_ico_2"];
                break;
//            case 2:
//                imageView.image = [UIImage imageNamed:@"footer_ico_3"];
//                break;
            case 2:
                imageView.image = [UIImage imageNamed:@"footer_ico_4"];
                break;
            case 3:
                imageView.image = [UIImage imageNamed:@"footer_ico_5"];
                break;
                
            default:
                break;
        }
    }
    [touchedTab setBackgroundColor:[AppTools colorWithHexString:tarBarSelectedColor]];

}

-(void) loadDefaultView
{
    // 默认加载中间这一项
    [self tabTouchUpInside:[self.buttonArray objectAtIndex:SharedApp.tarBarSelectIndex]];
}

#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
        }
    }
}
@end
