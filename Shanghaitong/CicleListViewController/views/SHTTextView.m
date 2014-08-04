//
//  SHTTextView.m
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SHTTextView.h"

@interface SHTTextView()<UITextViewDelegate>

@property (nonatomic,strong) UIToolbar *toolBar;

@end

@implementation SHTTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self makeView];
    }
    return self;
}
- (void)makeView{
    self.placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 200, 35)];
    self.placeHoderLabel.text = self.placeHoder;
    self.placeHoderLabel.font = [UIFont systemFontOfSize:18.0f];
    self.placeHoderLabel.textColor = COLOR_WITH_RGB(187, 186, 194);
    [self addSubview:self.placeHoderLabel];
    
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    if (IOS_VERSION >= 7.0) {
        self.toolBar.barTintColor = [AppTools colorWithHexString:@"#f9f9f9"];
    }
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame = CGRectMake(260, 0, 60, 30);
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.finishBtn.titleLabel.textColor = [UIColor blackColor];
    [self.finishBtn addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.finishBtn];
    [self setInputAccessoryView:self.toolBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChageWord:) name:UITextViewTextDidChangeNotification object:nil];
    
}
- (void)textViewChageWord:(NSNotification *)noti
{
    UITextView *textField = (UITextView *)noti.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.kmaxLength) {
                textField.text = [toBeString substringToIndex:self.kmaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.kmaxLength) {
            textField.text = [toBeString substringToIndex:self.kmaxLength];
        }
    }

}
- (void)hiddenKeyboard
{
    if (self.dele && [self.dele respondsToSelector:@selector(hiddenKeyboard)]) {
        [self.dele hiddenKeyboard];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
