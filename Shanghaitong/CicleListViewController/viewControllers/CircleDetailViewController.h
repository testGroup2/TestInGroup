//
//  CircleDetailViewController.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "RootViewController.h"
#import "ContributeToCicleViewController.h"
@protocol CircleDetailViewControllerDelegate <NSObject>

- (void)reciveAdminID:(NSString *)adminID;

@end
@interface CircleDetailViewController : RootViewController
@property (nonatomic,assign) id<CircleDetailViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *circleID;
@property (nonatomic,strong) NSString *circleName;
@property (nonatomic,strong) NSString *administratorId;
@property (nonatomic,strong) ContributeToCicleViewController *contributeViewConroller;
@end
