//
//  ChatInputView.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sendBG"]];
}

- (IBAction)sendMessageAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessage:isResend:timestamp:nowDate:)]) {
        [self.delegate sendMessage:self.ChatInputTextView.text isResend:NO timestamp:nil nowDate:nil];
    }
}
@end
