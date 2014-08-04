//
//  ChatInputView.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatInputViewDelegate <NSObject>

- (void)sendMessage:(NSString *)content isResend:(BOOL)resend timestamp:(NSString *)timestamp nowDate:(NSString *)nowDate;

@end
@interface ChatInputView : UIView
@property (nonatomic) id<ChatInputViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *ChatInputTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLabel;

- (IBAction)sendMessageAction:(id)sender;

@end
