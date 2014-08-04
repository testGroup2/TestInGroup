//
//  ChatCell.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessageInfo;
@protocol  ChatCellDelegate<NSObject>

- (void)pressToSeeUserDetail:(NSString *)userId;
- (void)pressToResendMsg:(NSString *)content timeStamp:(NSString *)timeStamp nowDate:(NSString *)nowDate cellTag:(NSInteger)tag;

@end

@interface ChatCell : UITableViewCell
@property (nonatomic,assign) id<ChatCellDelegate> delegate;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *leftHeadImageView;
@property (nonatomic,strong) UILabel *leftNameLabel;
@property (nonatomic,strong) UIImageView *leftChatWindowView;
@property (nonatomic,strong) UILabel *leftChatLabel;
@property (nonatomic) BOOL isLoading;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *nowDate;

@property (nonatomic,strong) UIImageView *righttHeadImageView;
@property (nonatomic,strong) UIImageView *rightChatWindowView;
@property (nonatomic,strong) UILabel *rightChatLabel;
@property (nonatomic,strong) UIView *timeLine;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIButton *sendMessageButton;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) UITapGestureRecognizer *rightTapGesture;
@property (nonatomic,strong) UITapGestureRecognizer *leftTapGesture;
- (void)hiddenRightView;
- (void)hiddenLeftView;
- (void)hiddenFaildView;
- (void)hiddenTime;
- (void)appearTime;
- (void)configureCellWithChatMsg:(ChatMessageInfo *)chatInfo;
@end
