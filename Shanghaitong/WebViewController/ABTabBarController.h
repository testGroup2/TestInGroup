//
//  ABTabBarController.h
//  Enoda
//
//  Created by Alexander Blunck on 09.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTabBar.h"
#import "AbTabBarItem.h"

#define ACTIVE_ABTABBAR_VIEW 2222


@interface ABTabBarController : UIViewController <ABTabBarDelegate>

@property (nonatomic, strong) ABTabBar       *tabBar;
@property (nonatomic, strong) NSMutableArray *tabBarItems;
@property (nonatomic) float   tabBarHeight;
@property (nonatomic, strong) UIImage *backgroundImage;

- (NSInteger)selectIndex;//选中试图控制器的位置
- (UIViewController*)selectController;//选中的试图控制器
- (void)abTabBarSwitchView:(UIViewController *)viewController;
- (void)alertToLogout;
@end
