//
//  MessageSliderViewController.h
//  商海通
//
//  Created by anita on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MessageSliderViewController : UIViewController
@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,assign)float LeftSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;

@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;

@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;

@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;

@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;
+(MessageSliderViewController *)sharedSliderController;
- (void)showContentControllerWithModel:(NSString*)className;
- (void)showLeftViewController;
- (void)showRightViewController;
- (void)closeSideBar;
@end
