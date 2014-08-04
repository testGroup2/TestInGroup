//
//  BaseViewController.m
//  ZHIsland
//
//  Created by qixiaolong on 11-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHTaskManager.h"
#import "ZHError.h"

@interface BaseViewController ()
@end
@implementation BaseViewController
@synthesize alertView = _alertView;
@synthesize progressView = _progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
    
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewWillDisappear:(BOOL)animated
{
    _alertView.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)showAlert:(NSString *)content animated:(BOOL)animated
{
    [self showAlert:content animated:animated withTag:9999];
}

- (void)showAlert:(NSString *)content animated:(BOOL)animated withTag:(int)tag
{
    [self showAlert:content animated:animated withTag:tag type:ZHAlertViewTypeNote];
}

- (void)showAlert:(NSString *)content animated:(BOOL)animated type:(int)type
{
    [self showAlert:content animated:animated withTag:999 type:type];
}

- (void)showAlert:(NSString *)content animated:(BOOL)animated withTag:(int)tag type:(ZHAlertViewType)type
{
    if(!_alertView) {
        _alertView = [[ZHAlertView alloc] initWithView:self.view delegate:self];
        [self.view addSubview:_alertView];
	}
    _alertView.delegate = self;
    _alertView.tag = tag;
    [self.view bringSubviewToFront:_alertView];
	[_alertView show:content animated:animated type:type];
}

- (void)showProgress:(BOOL)animated 
{
    [self showProgress:@"加载中" animated:animated];
}

- (void)showWaitingProgress:(BOOL)animated
{
    [self showProgress:@"请稍后" animated:animated];
}

- (void)showProgress:(NSString *)message animated:(BOOL)animated
{
    if(!_progressView) {
		_progressView = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:_progressView];
	}
	_progressView.labelText = message;
	[self.view bringSubviewToFront:_progressView];
	[_progressView show:animated];
}

- (void)hideProgress:(BOOL)animated 
{
	if (_progressView) {
		[_progressView hide:animated];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.progressView = nil;
    self.alertView = nil;
}

- (void)cancelRemoteTask
{
    if ([self conformsToProtocol:@protocol(ZHHttpTaskDelegate)]) {
        [[ZHTaskManager sharedInstance] cancelTaskWithDelegate:self];
    }
}

- (void)dealloc
{
    [self cancelRemoteTask];

    _alertView.delegate = nil;
    [_alertView removeFromSuperview];
    [_alertView release];
    
    [self.progressView removeFromSuperview];
    [_progressView release];
    
    [super dealloc];
}

- (void)showNetError:(NSError *)error
{
    if ([error isKindOfClass:[ZHError class]]) {
        [self showAlert:[error domain] animated:YES];
    } else {
        [self showAlert:@"无法连接网络！请检查网络设置" animated:YES];
    }
}

@end
