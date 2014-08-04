//
//  BaseViewController.h
//
//  Created by qixiaolong on 12-4-14.
//  Copyright (c) 2011年 zhisland.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ZHAlertView.h"
#import "MBProgressHUD.h"


@interface BaseViewController : UIViewController<ZHAlertViewDelegate>
{
    ZHAlertView *_alertView;
    MBProgressHUD *_progressView;
}

@property (nonatomic, retain) ZHAlertView *alertView;
@property (nonatomic, retain) MBProgressHUD *progressView;

- (void)showAlert:(NSString *)content animated:(BOOL)animated;
- (void)showAlert:(NSString *)content animated:(BOOL)animated withTag:(int)tag;
- (void)showAlert:(NSString *)content animated:(BOOL)animated type:(int)type;
- (void)showAlert:(NSString *)content animated:(BOOL)animated withTag:(int)tag type:(ZHAlertViewType)type;

- (void)showProgress:(BOOL)animated;
- (void)showWaitingProgress:(BOOL)animated;
- (void)showProgress:(NSString *)message animated:(BOOL)animated;
- (void)hideProgress:(BOOL)animated;
- (void)cancelRemoteTask;
- (void)showNetError:(NSError *)error;
@end
