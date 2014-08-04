//
//  SHTTextView.h
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHTTextViewDelegate <NSObject>
@required
- (void)hiddenKeyboard;
@end

@interface SHTTextView : UITextView
//placeHoder
@property (nonatomic,copy) NSString *placeHoder;
//bool 是否需要折行
@property (nonatomic,assign) BOOL canFold;
//限制字符
@property (nonatomic,assign) NSInteger kmaxLength;
@property (nonatomic,strong) UILabel *placeHoderLabel;
@property (nonatomic,strong) UIButton *finishBtn;

@property (nonatomic,assign) id<SHTTextViewDelegate> dele;
@end
