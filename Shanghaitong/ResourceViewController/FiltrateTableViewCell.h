//
//  FiltrateTableViewCell.h
//  Shanghaitong
//
//  Created by xuqiang on 14-7-11.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  FiltrateTableViewCellDelegate<NSObject>

- (void)finishClickButtonWithUrl:(NSString *)urlStr andCellIndex:(NSInteger)index;

@end

@interface FiltrateTableViewCell : UITableViewCell
@property (nonatomic,assign) id<FiltrateTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configureWithAreaItems:(NSMutableArray *)items;
- (void)configureWithIndustryItems:(NSMutableArray *)items;
@end
