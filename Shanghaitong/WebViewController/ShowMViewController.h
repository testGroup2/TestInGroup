//
//  ShowMViewController.h
//  Shanghaitong
//
//  Created by anita on 14-4-24.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMViewController : UIViewController
@property (nonatomic, strong) NSString  *urlString;
@property (nonatomic, assign) NSString  *labelText;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (strong, nonatomic) UINavigationBar *ShowMessageViewNavbar;
@property (strong, nonatomic) UIButton *showMessagelefttBtn ;
@end
