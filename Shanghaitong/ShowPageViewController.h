//
//  ShowPageViewController.h
//  商海通
//
//  Created by Liv on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPageViewController : UIViewController
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicatorView;
- (void)apearButton;
- (void)hiddenButton;
@end
