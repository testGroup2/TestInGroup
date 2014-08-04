//
//  FriendTableViewCell.h
//  Shanghaitong
//
//  Created by xuqiang on 14-7-9.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendModel;
@interface FriendTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *uid;
- (void)configureCellWithFriend:(FriendModel *)item;
@end
