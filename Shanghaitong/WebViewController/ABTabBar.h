//
//  ABTabBar.h
//
//  Created by Alexander Blunck on 15.02.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbTabBarItem.h"

//Delegate Declaration
@protocol ABTabBarDelegate <NSObject>
@optional
- (void)popCurrentViewController;
@required //These methods need to be implemented
- (void)abTabBarSwitchView:(UIViewController*)viewController;

@end

@interface ABTabBar : UIView <UIAlertViewDelegate>
{
    float tabBarHeight;
}
@property (nonatomic, strong) NSMutableArray *tabBarItemArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger selectIndex;//选中试图控制器的位置
@property (nonatomic, strong) UINavigationController *currentViewController;
@property (nonatomic, strong) UIImageView *tabBarBottomLight;

-(id) initWithTabItems:(NSArray*)tabBarItemsArray height:(float)tbHeight backgroundImage:(UIImage*)bgImage;
-(void) createTabs;
-(void) loadDefaultView;
-(void)tabTouchUpInside:(UIButton *)touchedTab;

//Declare Delegate as property
@property(nonatomic, strong) id <ABTabBarDelegate> delegate;

@end
