//
//  ThemeListCell.m
//  Shanghaitong
//
//  Created by xuqiang on 14-5-15.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ThemeListCell.h"
#import "UIImageView+WebCache.h"
#import "CircleAbstractInfo.h"
#import "AppTools.h"
#import "NewMessagePromptView.h"
#import "CircleDatabase.h"
#import "ChatMessageInfo.h"
#define TITLE_COLOR @"#555555"
#define DETAIL_COLOR @"#999999"
#define DETAIL_INFO_COLOR @"#555555"
#define EXPLAIN_COLOR @"#999999"
#define COME_COLOR @"#508dc5"


@interface ThemeListCell()
{
    UIView *bgView;
    CGFloat leftMagin;
}
@property (nonatomic,strong) NewMessagePromptView *nMsgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailNameLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *comeFromNameLabel;
@property (nonatomic,strong) UILabel *comeFromInfoLabel;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *lastChatLabel;
@property (nonatomic,strong)  UIButton *chatBtn;
@property (nonatomic,strong) UIView *sepratorLine;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong)UIView *chatView;
@end
@implementation ThemeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftMagin = 10;
        [self makeView];
        
    }
    return self;
}
- (void)makeView{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 3, 300, 183)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:bgView];
    //title
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMagin, 5, 290, 26)];
    self.titleLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [bgView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMagin, 30, 132, 21)];
    
    self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
    self.detailLabel.numberOfLines = 4;
    self.detailLabel.textColor = [AppTools colorWithHexString:DETAIL_INFO_COLOR];
    [bgView addSubview:self.detailLabel];
    
    //来自
    self.comeFromNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMagin, 58, 63, 21)];
    self.comeFromNameLabel.textColor = [AppTools colorWithHexString:DETAIL_COLOR];
    self.comeFromNameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.comeFromNameLabel.text = @"来 自:";
    [bgView addSubview:self.comeFromNameLabel];
    
    self.comeFromInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 58, 143, 21)];
    self.comeFromInfoLabel.textColor = [AppTools colorWithHexString:COME_COLOR];
    self.comeFromInfoLabel.font = [UIFont systemFontOfSize:15.0f];
    [bgView addSubview:self.comeFromInfoLabel];
    
    //头像
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 38, 80, 80)];
    [bgView addSubview:self.headImageView];
    
    //分隔线
    self.sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 300, 1)];
    self.sepratorLine.backgroundColor = [AppTools colorWithHexString:@"#d4d4d4"];
    [bgView addSubview:self.sepratorLine];
    
    self.chatView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 300, 35)];
    self.chatView.backgroundColor = [UIColor clearColor];
    self.chatView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatWithTag:)];
    [self.chatView addGestureRecognizer:tap];
    [bgView addSubview:self.chatView];
    
    //最后聊天
    self.lastChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 158, 177, 16)];
    self.lastChatLabel.font  = [UIFont systemFontOfSize:11.0f];
    self.lastChatLabel.textColor = [AppTools colorWithHexString:DETAIL_COLOR];
    self.lastChatLabel.text = @"暂时没有消息";
    [bgView addSubview:self.lastChatLabel];
    
    // 聊天按钮
    self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chatBtn setFrame:CGRectMake(245, 153, 45, 30)];
    [self.chatBtn setTitleColor:[AppTools colorWithHexString:COME_COLOR] forState:UIControlStateNormal];
    [self.chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
    self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.chatBtn addTarget:self action:@selector(chatWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.chatBtn];
    self.nMsgView = [[NewMessagePromptView alloc]initWithFrame:CGRectMake(self.chatBtn.frame.size.width - 10, 2, 10, 10)];
    [self.chatBtn addSubview:self.nMsgView];    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, 200, 40)];
    [self.contentView addSubview:self.label];
    
}
- (void)configureCellWithAbstract:(CircleAbstractInfo *)info canLoadImage:(BOOL)canLoadImage{
    NSLog(@"主题id%@",info.circleDetailID);
    if (self.label) {
        [self.label removeFromSuperview];
    }
    if (info == nil) {
        [self configureCellWithLastCell];
        return;
    }
    [self.contentView addSubview:bgView];
    self.contentView.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
    self.titleLabel.text = info.circleTopic;
    self.themeName = info.circleTopic;
    self.detailLabel.text = info.themeSimple;
    self.uId = info.adminId;
    self.detailLabel.numberOfLines = 4;
    self.detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
    CGSize size = [info.themeSimple sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(193, 90) lineBreakMode:NSLineBreakByCharWrapping];
    self.detailLabel.frame = CGRectMake(leftMagin, 36, size.width, size.height);
    //设置行间距
    if (!([self.detailLabel.text isEqualToString:@""] || self.detailLabel.text == nil)) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];  //调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
        self.detailLabel.attributedText = attributedString;
        [self.detailLabel sizeToFit];
    }
    
    CGRect rect =  bgView.frame;
    if (self.detailLabel.frame.size.height  < 70) {
        self.sepratorLine.frame = CGRectMake(0, 135, 300, 1);
        self.chatView.frame = CGRectMake(0, 136, 300, 37);
        bgView.frame =CGRectMake(rect.origin.x, 5, rect.size.width, 173);
    }
    else{
        bgView.frame =CGRectMake(rect.origin.x, 5, rect.size.width, 193);
        self.sepratorLine.frame = CGRectMake(0, 155, 300, 1);
        self.chatView.frame = CGRectMake(0, 156, 300, 38);
    }
    self.lastChatLabel.frame = CGRectMake(10, CGRectGetMaxY(self.sepratorLine.frame) + 12, 177, 16);
    self.chatBtn.frame = CGRectMake(245, CGRectGetMaxY(self.sepratorLine.frame) + 5, 45, 30);
    self.comeFromNameLabel.frame = CGRectMake(leftMagin, CGRectGetMaxY(self.detailLabel.frame)+2, 63, 21);
    self.comeFromInfoLabel.frame = CGRectMake(55, CGRectGetMaxY(self.detailLabel.frame) +2, 143, 21);
    self.comeFromInfoLabel.text = info.circleName;
    [self.headImageView setImageWithURL:[NSURL URLWithString:info.circleImage] placeholderImage:nil];
    self.themeId = info.circleDetailID;
    self.circleId = info.circleID;
    self.circleName = info.circleName;
    self.isRead = info.isRead;
    if ([info.isRead isEqualToString:@"0"]) {
        self.nMsgView.hidden = NO;
    }
    //if([info.isRead isEqualToString:@"0"])
    else {
        self.nMsgView.hidden = YES;
    }
    
    if (info.lastChat) {
        self.lastChatLabel.text =[NSString stringWithFormat:@"%@：%@",info.lastChatUserName,info.lastChat];
    }
    else {
        self.lastChatLabel.text = @"暂时没有消息";
//        self.nMsgView.hidden = YES;
    }
}
- (void)hiddenRedPoint{
    self.nMsgView.hidden = YES;
}
- (void)appearRedPoint{
    self.nMsgView.hidden = NO;
}
- (void)chatWithTag:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatWithCircleId:themeId:circleName:themeName:withUserId:cellTag:)]) {
        [self.delegate chatWithCircleId:self.circleId themeId:self.themeId circleName:self.circleName themeName:self.themeName withUserId:self.uId cellTag:self.tag];
    }
}
- (void)configureCellWithLastCell{
    [bgView removeFromSuperview];
    self.contentView.backgroundColor = self.label.textColor = [AppTools colorWithHexString:@"#4B5970"];
    self.label.font = [UIFont fontWithName:@"heiti" size:16.0f];
    self.label.text = @"已加载全部信息";
    self.label.font = [UIFont systemFontOfSize:16.0f];
    self.label.textColor = [AppTools colorWithHexString:@"#b3c0d6"];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.label];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
