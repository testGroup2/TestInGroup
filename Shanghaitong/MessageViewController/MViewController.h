//
//  MViewController.h
//  Shanghaitong
//
//  Created by anita on 14-4-24.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@interface MViewController : UIViewController
@property (strong, nonatomic)  UINavigationBar * MessageNarbar;
@property (strong, nonatomic) UIButton *MessagelefttBtn;
@property (assign, nonatomic)   BOOL    didShowedLeft;
@property (strong,nonatomic) WebViewController *webViewController;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGRect contentFrame;
@end
