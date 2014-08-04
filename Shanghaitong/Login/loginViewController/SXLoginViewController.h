//
//  SXLoginViewController.h
//  shangxin
//
//  Created by jianping on 14-1-23.
//  Copyright (c) 2014年 ZHIsland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZHHttpTaskDelegate.h"

@interface SXLoginViewController : BaseViewController <ZHHttpTaskDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *pwdField;

- (IBAction)login:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;



@property (strong, nonatomic) IBOutlet UIView *userKuang;
@property (strong, nonatomic) IBOutlet UIView *passKuang;
@end
