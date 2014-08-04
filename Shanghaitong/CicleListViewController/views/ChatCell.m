//
//  ChatCell.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ChatCell.h"
#import "ChatMessageInfo.h"
#import "AppTools.h"
#import "UIImageView+WebCache.h"
#define AJUST_HEIGHT 20

#define TIME_LINE_COLOR @"#999999"

@interface ChatCell ()
@end

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeView];
    }
    return self;
}
- (void)makeView {
    //初始化本人对话框65
        UIImage *rightImage = [UIImage imageNamed:@"chatImage_me"];
        rightImage = [rightImage stretchableImageWithLeftCapWidth:20 topCapHeight:25];
    
        self.righttHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260,10, 50,50)];
        self.righttHeadImageView.clipsToBounds = YES;
        self.righttHeadImageView.layer.cornerRadius = 2.0f;
        //添加手势
        self.righttHeadImageView.userInteractionEnabled = YES;
        self.rightTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSeeUserDetail)];
        [self.righttHeadImageView addGestureRecognizer:self.rightTapGesture];
    
        [self.contentView addSubview:self.righttHeadImageView];
        self.rightChatWindowView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 35 - AJUST_HEIGHT, 45, 20)];
        self.righttHeadImageView.layer.cornerRadius = 2.0f;
        self.rightChatWindowView.image = rightImage;
        [self.contentView addSubview:self.rightChatWindowView];
    
        self.sendMessageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0 , 20, 20)];
        [self.sendMessageButton setBackgroundImage:[UIImage imageNamed:@"MsgFaild"] forState:UIControlStateNormal];
        [self.sendMessageButton addTarget:self action:@selector(reSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sendMessageButton];
    
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.frame = CGRectMake(0, 0, 20, 20);
        [self.activity startAnimating];
        self.activity.hidesWhenStopped = YES;
        [self.contentView addSubview:self.activity];
    
    
        self.rightChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 35, 20)];
        self.rightChatLabel.backgroundColor = [UIColor clearColor];
        self.rightChatLabel.font = [UIFont systemFontOfSize:kChatMessageFontSize];
        self.rightChatLabel.numberOfLines = 1000;
        self.rightChatLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.rightChatWindowView addSubview:self.rightChatLabel];
        
    //初始化他人对话框
    UIImage *leftImage = [UIImage imageNamed:@"chatImage_other"];
    leftImage = [leftImage stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    self.leftHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,50,50)];
    self.leftHeadImageView.layer.cornerRadius = 5.0f;
    self.leftHeadImageView.userInteractionEnabled = YES;
    self.leftTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSeeUserDetail)];
    [self.leftHeadImageView addGestureRecognizer:self.leftTapGesture];
    self.leftHeadImageView.clipsToBounds = YES;
    self.leftHeadImageView.layer.cornerRadius = 2.0f;
    self.leftNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 95, 20)];
    self.leftNameLabel.font = [UIFont systemFontOfSize:kChatMessageFontSize];
    self.leftNameLabel.text = @"你的名字叫";
    [self.contentView addSubview:self.leftHeadImageView];
    [self.contentView addSubview:self.leftNameLabel];
    
    self.leftChatWindowView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 35, 45, 20)];
    self.leftChatWindowView.image = leftImage;
    
    [self.contentView addSubview:self.leftChatWindowView];
    self.leftChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 45, 20)];
    self.leftChatLabel.backgroundColor = [UIColor clearColor];
    self.leftChatLabel.font = [UIFont systemFontOfSize:kChatMessageFontSize];
    self.leftChatLabel.numberOfLines = 1000;
    self.leftChatLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.leftChatWindowView addSubview:self.leftChatLabel];
    
}
- (void)configureCellWithChatMsg:(ChatMessageInfo *)chatInfo{
    CGSize size = [chatInfo.content sizeWithFont:[UIFont systemFontOfSize:kChatMessageFontSize]
                               constrainedToSize:CGSizeMake(200,10000) lineBreakMode:NSLineBreakByCharWrapping];
    self.timeStamp = chatInfo.timeStamp;
    self.nowDate = chatInfo.nowDate;
    if (chatInfo.isMySelf) {
        //将左边隐藏同时调整frame
        [self hiddenLeftView];
        [self.righttHeadImageView setImageWithURL:[NSURL URLWithString:chatInfo.userHeadImageUrl] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
        self.userId = chatInfo.userId;
        self.content = chatInfo.content;
        self.rightChatLabel.text = chatInfo.content;
        self.rightChatLabel.frame = CGRectMake(10, 0, size.width + 9, size.height + 15);
        self.rightChatWindowView.frame = CGRectMake(kScreenWidth - 50 - 45 - size.width, 35 - AJUST_HEIGHT , size.width + 25, size.height +15);
        if (chatInfo.isLoading) {
            self.activity.frame = CGRectMake(CGRectGetMinX(self.rightChatWindowView.frame) - 25, CGRectGetMaxY(self.rightChatWindowView.frame) - 20, 20,20);
            [self.activity startAnimating];
        }
        else{
            [self.activity stopAnimating];
        }
        
        if (chatInfo.isSuccess) {
            self.sendMessageButton.hidden = YES;
        }
        else{
            self.sendMessageButton.frame = CGRectMake(CGRectGetMinX(self.rightChatWindowView.frame) - 25, CGRectGetMaxY(self.rightChatWindowView.frame) - 20, 20, 20);
            self.sendMessageButton.hidden = NO;
            [self.activity stopAnimating];
        }
    }
    else{
        [self.activity stopAnimating];
        [self hiddenFaildView];
        [self hiddenRightView];
        [self.leftHeadImageView setImageWithURL:[NSURL URLWithString:chatInfo.userHeadImageUrl] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
        self.leftChatLabel.text = chatInfo.content;
        self.leftNameLabel.text = chatInfo.userName;
        self.userId = chatInfo.userId;
        self.leftChatLabel.frame = CGRectMake(14, 0, size.width + 9, size.height + 15);
        self.leftChatWindowView.frame = CGRectMake(70, 30, size.width + 25, size.height +15);
    }

}
- (void)goToSeeUserDetail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressToSeeUserDetail:)]) {
        [self.delegate pressToSeeUserDetail:self.userId];
    }
}

- (void)hiddenFaildView{
    self.sendMessageButton.hidden = YES;
}
- (void)appearFaildView{
    self.sendMessageButton.hidden = NO;
}

- (void)hiddenTime{
    self.timeLabel.hidden = YES;
    self.timeLine.hidden = YES;
}

- (void)appearTime{
    self.timeLabel.hidden = NO;
    self.timeLine.hidden = NO;
}

- (void)hiddenRightView{
    self.rightChatLabel.hidden = YES;
    self.rightChatWindowView.hidden = YES;
//    self.rightNameLabel.hidden = YES;
    self.righttHeadImageView.hidden = YES;
    
    self.leftHeadImageView.hidden = NO;
    self.leftChatLabel.hidden = NO;
    self.leftChatWindowView.hidden = NO;
    self.leftNameLabel.hidden = NO;
}
- (void)hiddenLeftView{
    self.leftChatLabel.hidden = YES;
    self.leftChatWindowView.hidden = YES;
    self.leftHeadImageView.hidden = YES;
    self.leftNameLabel.hidden =YES;
    
    self.rightChatLabel.hidden = NO;
    self.rightChatWindowView.hidden = NO;
    self.righttHeadImageView.hidden = NO;

}

- (void)reSendMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressToResendMsg:timeStamp:nowDate:cellTag:)]) {
        [self.delegate pressToResendMsg:self.content timeStamp:self.timeStamp nowDate:self.nowDate cellTag:self.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
