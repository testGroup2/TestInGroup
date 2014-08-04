//
//  MembersTableViewCell.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-29.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "MembersTableViewCell.h"
#import "MemberInfo.h"
#import "UIImageView+WebCache.h"
@implementation MembersTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeView];
    }
    return self;
}
- (void)makeView{
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 80, 80)];
    self.peopleName = [[UILabel alloc]initWithFrame:CGRectMake(103, 22, 64, 21)];
    self.creditNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 22, 63, 21)];
    self.creditNameLabel.font = [UIFont systemFontOfSize:15.0];
    self.creditNameLabel.textColor = [UIColor darkGrayColor];
    self.creditLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 22, 63, 21)];
    self.creditLabel.font = [UIFont systemFontOfSize:15.0f];
    self.creditLabel.textColor = [UIColor darkGrayColor];
    self.lastTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 50, 213, 38)];
    self.companyNameLabel.numberOfLines = 2;
    self.companyNameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(5, 99, 310, 0)];
    self.sepratorLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.peopleName];
    [self.contentView addSubview:self.creditNameLabel];
    [self.contentView addSubview:self.creditLabel];
    [self.contentView addSubview:self.companyNameLabel];
    [self.contentView addSubview:self.sepratorLine];
    [self.contentView addSubview:self.textLabel];
}
#define NAME_COLOR @"#508dc5"
#define COMPANY_COLOR @"#999999"
- (void)configureCellWithMemberInfo:(MemberInfo *)info
{
    if (self.lastTextLabel) {
        [self.lastTextLabel removeFromSuperview];
    }
    if (info == nil) {
        [self configureOnePageLastCell];
        return;
    }
    self.creditNameLabel.text = @"信用值";
    self.peopleName.text = info.memberName;
    self.peopleName.textColor = [AppTools colorWithHexString:NAME_COLOR];
    self.creditLabel.text = info.memberCredit;
    self.sepratorLine.frame = CGRectMake(5, 99.5, 310, 0.5);
    self.companyNameLabel.text = [NSString stringWithFormat:@"%@ %@",info.memberCompany,info.memberPosition];
    self.companyNameLabel.textColor = [AppTools colorWithHexString:COMPANY_COLOR];
    self.memberId = info.memberID;
    [self.headImageView setImageWithURL:[NSURL URLWithString:info.memberHeadImageUrl]];
    self.headImageView.layer.cornerRadius = 2.0f;
    self.headImageView.clipsToBounds = YES;
    
}
- (void)configureOnePageLastCell{
    self.lastTextLabel.textAlignment = NSTextAlignmentCenter;
    self.lastTextLabel.font = [UIFont systemFontOfSize:16.0f];
    self.lastTextLabel.text = @"已加载全部信息";
    self.lastTextLabel.textColor = [AppTools colorWithHexString:@"#b3c0d6"];
    self.lastTextLabel.center = self.contentView.center;
    [self.contentView addSubview:self.lastTextLabel];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 99.5, 310, 0.5)];
//    view.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:view];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
