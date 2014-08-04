//
//  cicleListItem.h
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface cicleListItem : NSObject
@property  (nonatomic,copy) NSString * titleLabel;
@property  (nonatomic,copy) NSString * timeLabel;
@property  (nonatomic,copy) NSString * detailLabel;
@property  (nonatomic,copy) NSString * fromLabel;
@property  (nonatomic,copy) NSMutableArray * userImageUrlArray;
@property  (nonatomic,copy) NSString * latestMessageLabel;
@property  (nonatomic,copy) UIButton * chatButton;
@end
