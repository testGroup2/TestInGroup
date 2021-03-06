//
//  MessageSliderViewController.m
//  商海通
//
//  Created by anita on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import "MessageSliderViewController.h"
#import "MViewController.h"
#import "MessageLeftViewController.h"
typedef NS_ENUM(NSInteger, RMoveDirection) {
    RMoveDirectionLeft = 0,
    RMoveDirectionRight
};
@interface MessageSliderViewController ()<UIGestureRecognizerDelegate,MessageLeftViewControllerDelegate>{
    UIView *_mainContentView;
    UIView *_leftSideView;
    UIView *_rightSideView;
    NSMutableDictionary *_controllersDict;
    UIPanGestureRecognizer *_panGestureRec;
}

@end

@implementation MessageSliderViewController
-(void)dealloc{
#if __has_feature(objc_arc)
    _mainContentView = nil;
    _leftSideView = nil;
    _rightSideView = nil;
    _controllersDict = nil;
    _panGestureRec = nil;
    _LeftVC = nil;
    _RightVC = nil;
    _MainVC = nil;
#else
    [_mainContentView release];
    [_leftSideView release];
    [_rightSideView release];
    [_controllersDict release];
    [_tapGestureRec release];
    [_panGestureRec release];
    [_LeftVC release];
    [_RightVC release];
    [_MainVC release];
    [super dealloc];
#endif
    
}
+(MessageSliderViewController *)sharedSliderController
{
    static MessageSliderViewController * sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    return sharedSVC;
}
- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder])) {
        _LeftSContentOffset=160;
        _RightSContentOffset=160;
        _LeftSContentScale=0.85;
        _RightSContentScale=0.85;
        _LeftSJudgeOffset=100;
        _RightSJudgeOffset=100;
        _LeftSOpenDuration=0.4;
        _RightSOpenDuration=0.4;
        _LeftSCloseDuration=0.3;
        _RightSCloseDuration=0.3;
	}
	return self;
}

- (id)init{
    if (self = [super init]){
        self.tabBarItem.title = @"消息";
        self.navigationController.title = @"消息";
        self.tabBarItem.image = [UIImage imageNamed:@"xiaoxi.png"];
        _LeftSContentOffset=220;
        _RightSContentOffset=120;
        _LeftSContentScale=1;
        _RightSContentScale=1;
        _LeftSJudgeOffset=200;
        _RightSJudgeOffset=200;
        _LeftSOpenDuration=0.4;
        _RightSOpenDuration=0.4;
        _LeftSCloseDuration=0.3;
        _RightSCloseDuration=0.3;
    }
    return self;
}

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
    _controllersDict = [NSMutableDictionary dictionary];
    [self initSubviews];
    if (_LeftVC==nil) {
        _LeftVC=[[NSClassFromString(@"LeftViewController") alloc] init];
    }
    if (_RightVC==nil) {
        _RightVC=[[NSClassFromString(@"RightViewController") alloc] init];
    }
    [self initChildControllers:_LeftVC rightVC:_RightVC];
    [self showContentControllerWithModel:_MainVC!=nil?NSStringFromClass([_MainVC class]):@"MainViewController"];
}
#pragma mark - Init

- (void)initSubviews
{
    _rightSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_rightSideView];
    
    _leftSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_leftSideView];
    
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mainContentView];
    
}

- (void)initChildControllers:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC
{
    [self addChildViewController:leftVC];
    leftVC.view.frame=CGRectMake(0, 0, leftVC.view.frame.size.width, leftVC.view.frame.size.height);
    
    [_leftSideView addSubview:leftVC.view];
    
    [self addChildViewController:rightVC];
    rightVC.view.frame=CGRectMake(0, 0, rightVC.view.frame.size.width, rightVC.view.frame.size.height);
    [_rightSideView addSubview:rightVC.view];
}

#pragma mark - Actions

- (void)showContentControllerWithModel:(NSString *)className
{
    [self closeSideBar];
    UIViewController *controller = _controllersDict[className];
    if (!controller)
    {
        Class c = NSClassFromString(className);
#if __has_feature(objc_arc)
        controller = [[c alloc] init];
#else
        controller = [[[c alloc] init] autorelease];
#endif
        [_controllersDict setObject:controller forKey:className];
    }
    if (_mainContentView.subviews.count > 0)
    {
        UIView *view = [_mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    controller.view.frame = _mainContentView.frame;
    [_mainContentView addSubview:controller.view];
    self.MainVC=controller;
}

- (void)showLeftViewController
{
    
    SharedApp.mainTabBarViewController.tabBar.userInteractionEnabled = NO;
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
    [self.view sendSubviewToBack:_rightSideView];
    [self configureViewShadowWithDirection:RMoveDirectionRight];
    [UIView animateWithDuration:_LeftSOpenDuration
                     animations:^{
                         _mainContentView.transform = conT;
                         if (iPhone5Srceen) {
                             if (IOS_VERSION >= 7.0) {
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(220, 568-49, 320, 49);

                             }else{
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(220, 568-69, 320, 49);
                             }
                         }else {
                             if (IOS_VERSION >= 7.0) {
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(220, 480-49, 320, 49);
                             }else{
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(220, 480-49-20, 320, 49);
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)showRightViewController
{
    //通知关闭userInterface
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeUserInterface" object:self];
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
    [self.view sendSubviewToBack:_leftSideView];
    [self configureViewShadowWithDirection:RMoveDirectionLeft];
    [UIView animateWithDuration:_RightSOpenDuration
                     animations:^{
                         _mainContentView.transform = conT;
                     }
                     completion:^(BOOL finished) {
    }];
}
-(void)onReq:(BaseReq *)req
{
    
}
-(void) onResp:(BaseResp *)resp
{
    
}
- (void)closeSideBar
{
    SharedApp.mainTabBarViewController.tabBar.userInteractionEnabled = YES;
    
    ((MViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController)).MainVC).didShowedLeft = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"openUserInterface" object:self];
    CGAffineTransform oriT = CGAffineTransformIdentity;
    [UIView animateWithDuration:_mainContentView.transform.tx==_LeftSContentOffset?_LeftSCloseDuration:_RightSCloseDuration
                     animations:^{
                         _mainContentView.transform = oriT;
                         if (iPhone5Srceen) {
                             if (IOS_VERSION >=7.0) {
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(0, 568-49, 320, 49);
                             }else{
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(0, 568-69, 320, 49);
                             }
                         }else {
                             if (IOS_VERSION >= 7.0) {
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(0, 480-49, 320, 49);
                             }else{
                                 SharedApp.mainTabBarViewController.tabBar.frame = CGRectMake(0, 480-69, 320, 49);
                             }
                             
                         }
                     }
                     completion:^(BOOL finished) {
    }];
}
#pragma mark -
- (CGAffineTransform)transformWithDirection:(RMoveDirection)direction
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    switch (direction) {
        case RMoveDirectionLeft:
            translateX = -_RightSContentOffset;
            transcale = _RightSContentScale;
            break;
        case RMoveDirectionRight:
            translateX = _LeftSContentOffset;
            transcale = _LeftSContentScale;
            break;
        default:
            break;
    }
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    return conT;
}

- (void)configureViewShadowWithDirection:(RMoveDirection)direction
{
    CGFloat shadowW;
    switch (direction)
    {
        case RMoveDirectionLeft:
            shadowW = 2.0f;
            break;
        case RMoveDirectionRight:
            shadowW = -2.0f;
            break;
        default:
            break;
    }
    _mainContentView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
