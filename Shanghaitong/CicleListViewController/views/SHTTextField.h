//
//  SHTTextField.h
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SHTTextFieldDelegate <NSObject>
@required
- (void)hiddenTextFeildKeyboard;
@end

@interface SHTTextField : UITextField
@property (nonatomic,copy) NSString *placeHoder;
@property (nonatomic,assign) NSInteger kmaxLength;
@property (nonatomic,strong) UILabel *placeHoderLabel;
@property (nonatomic,strong) UIButton *finishBtn;

@property (nonatomic,assign) id<SHTTextFieldDelegate> dele;
@end
