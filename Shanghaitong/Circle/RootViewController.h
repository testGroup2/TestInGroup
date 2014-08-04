//
//  BaseViewController.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-29.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "NetworkCenter.h"
#import "UIImageView+WebCache.h"
#import "ErrorMessageItem.h"
#import "PopupSmallView.h"
#import "AppTools.h"
#import "ABTabBar.h"
#import "GuidBtn.h"
//NSString* const SHTError_Code                      = @"warning_code";
//NSString* const SHTError_desc                      = @"warning_desc";

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NaviViewDelegate,ABTabBarDelegate>
{
    UIImage *_rightImage;
    UIImage *_leftImage;
}
@property (nonatomic,strong) UIActivityIndicatorView *networkActivity;
@property (nonatomic,strong) NaviView *navigationView;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic,strong) NSString *errorCode;
@property (nonatomic,strong) PopupSmallView *p;
@property (nonatomic,strong) GuidBtn *guidButton;
@property (nonatomic,strong) ABTabBar *tabBar;
- (void)customMakeNavigationBarHasLeftButton:(BOOL)hasLeft withHasRightButton:(BOOL)hasRight;
- (BOOL)getErrorCodeWithJsonValue:(NSString *)testStr;
- (void)showErrorMessage:(NSString *)errorStr;
- (void)showNetworkErrorMessage:(NSString *)message;
- (void)showNetworkAnimation;
- (void)hiddenNetworkAnimation;
- (void)guidBttonAction;
@end
