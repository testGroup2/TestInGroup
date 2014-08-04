//
//  FriendTableViewCell.m
//  Shanghaitong
//
//  Created by xuqiang on 14-7-9.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "FriendModel.h"
#import "UIImageView+WebCache.h"
@interface FriendTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *resourceName;
@property (weak, nonatomic) IBOutlet UILabel *resource;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UILabel *industryName;
@property (weak, nonatomic) IBOutlet UILabel *industry;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *interestedQulity;
@property (weak, nonatomic) IBOutlet UILabel *interestedName;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *sepratorLine;

@end

@implementation FriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [AppTools colorWithHexString:@"#4B5970"];
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
     self.bgView.layer.cornerRadius = 3.0f;
    self.avatarImageView.layer.cornerRadius = 3.0f;
}
- (void)configureCellWithFriend:(FriendModel *)item{
    self.pid = item.pid;
    self.uid = item.uid;
    self.name.text = item.name;
    self.position.text = item.position;
    
    self.resource.numberOfLines = 20;
    self.resource.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [item.resource sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(135, 100) lineBreakMode:NSLineBreakByCharWrapping];
    self.resource.frame = CGRectMake(60, 47, size.width, size.height);
    self.resource.text = item.resource;
    CGRect rect = self.resource.frame;
    
    self.areaName.frame = CGRectMake(10, CGRectGetMaxY(rect), 42, 21);
    self.area.frame = CGRectMake(60 , CGRectGetMaxY(rect), 125, 21);
    self.area.text = item.area;
    rect = self.areaName.frame;
    
    self.industryName.frame = CGRectMake(10,CGRectGetMaxY(rect), 42,21);
    self.industry.frame = CGRectMake(60, self.industryName.frame.origin.y, 190, 21);
    self.industry.text = item.industry;
    
    rect = self.industry.frame;
    
    self.sepratorLine.frame = CGRectMake(0, CGRectGetMaxY(rect) + 9, 300, 0.5f);
    
    self.lastUpdate.frame = CGRectMake(10, CGRectGetMaxY(rect) + 24, 130, 21);
    self.lastUpdate.text = item.lastUpdate;
    rect = self.lastUpdate.frame;
    self.interestedQulity.frame = CGRectMake(202, CGRectGetMaxY(rect), 42, 21);
    self.interestedQulity.text = item.intrestedNum;
    self.interestedName.frame = CGRectMake(252, CGRectGetMaxY(rect), 42, 21);
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:item.avatarUrl] placeholderImage:nil];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
