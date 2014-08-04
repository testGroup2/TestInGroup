//
//  SHTTextField.m
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SHTTextField.h"

@interface SHTTextField()
//@property (nonatomic,strong) UIToolbar *toolBar;
@end

@implementation SHTTextField

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
    self.placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 200, 30)];
    self.placeHoderLabel.text = self.placeHoder;
    self.placeHoderLabel.font = [UIFont systemFontOfSize:18.0f];
    self.placeHoderLabel.textColor = COLOR_WITH_RGB(187, 186, 194);
    [self addSubview:self.placeHoderLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChageWord:) name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)textViewChageWord:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
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
- (void)hiddenKeyboard{
    if (self.dele && [self.dele respondsToSelector:@selector(hiddenTextFeildKeyboard)]) {
        [self.dele hiddenTextFeildKeyboard];
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
