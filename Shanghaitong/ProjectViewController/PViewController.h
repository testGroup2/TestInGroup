//
//  PViewController.h
//  Shanghaitong
//
//  Created by Steve Wang on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebViewController.h"
#import "SVTopScrollView.h"
#import "SVRootScrollView.h"
#import "SVGloble.h"
#import "TSPopoverController.h"

@interface PViewController : UIViewController

typedef enum {
    ProjectXiangmu = 100,
    ProjectFangdichan,
    ProjectQiangfuli
}ProjectType;

@property (strong,nonatomic) SVTopScrollView *topView;
@property (strong,nonatomic) SVRootScrollView *rootView;
@property (strong,nonatomic) UIButton *rightButton ;
@property (strong, nonatomic) UIButton *ProleftBtn ;
@property (strong, nonatomic) UIButton *ProrightBtn;
@property (assign,nonatomic) TSPopoverController *ppoverController;

@property (strong, nonatomic)  WebViewController *pro_VC;
@property (strong, nonatomic)  WebViewController *fdc_VC;
@property (strong, nonatomic)  WebViewController *fuli_VC;
//项目--房地产--抢福利这三个按钮
@property (assign, nonatomic)   ProjectType pType;
//弹出框里面按钮的类型
@property (assign, nonatomic)   SearchType  sType;
@property (strong,nonatomic)UIView  *content_view;
@property (strong,nonatomic)UINavigationBar * bar;
@property (assign, nonatomic)   BOOL    didShowedLeft;
@property (assign, nonatomic)   BOOL    didShowedRight;

@end
