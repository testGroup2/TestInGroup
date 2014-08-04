//
//  RViewController.h
//  Shanghaitong
//
//  Created by anita on 14-4-23.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TSPopoverController.h"

@interface FriendViewController : RootViewController
@property (strong, nonatomic) UIButton *lefttBtn ;
@property (strong, nonatomic) UIButton *rightBtn ;
@property (assign, nonatomic) resouceSearchType  rType;
@property (assign, nonatomic) TSPopoverController *ppoverController;
@property (assign, nonatomic)   BOOL    didShowedLeft;
@end
