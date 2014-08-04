//
//  MembersTableViewCell.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-29.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberInfo;


@interface MembersTableViewCell : UITableViewCell
@property (nonatomic,strong) MemberInfo *memberInfo;
@property (nonatomic,strong) NSString *memberId;
@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UILabel *peopleName;
@property (strong, nonatomic)  UILabel *creditLabel;
@property (strong, nonatomic)  UILabel *companyNameLabel;
@property (strong, nonatomic)  UIView *sepratorLine;
@property (strong, nonatomic)  UILabel *creditNameLabel;
@property (strong, nonatomic) UILabel *lastTextLabel;
- (void)configureCellWithMemberInfo:(MemberInfo *)info;
- (void)configureOnePageLastCell;
@end
