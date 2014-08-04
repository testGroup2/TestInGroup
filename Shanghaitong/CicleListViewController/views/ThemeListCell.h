//
//  ThemeListCell.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-15.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleAbstractInfo;
@protocol ThemeListCellDelegate <NSObject>

- (void)chatWithCircleId:(NSString *)circleId themeId:(NSString *)themeId circleName:(NSString *)circleName themeName:(NSString *)themeName withUserId:(NSString *)uid cellTag:(NSInteger)tag;

@end
@interface ThemeListCell : UITableViewCell
@property (nonatomic,assign) id<ThemeListCellDelegate> delegate;
@property (nonatomic,strong) NSString * themeId;
@property (nonatomic,strong) NSString *circleId;
@property (nonatomic,strong) NSString *circleName;
@property (nonatomic,strong) NSString *themeName;
@property (nonatomic,strong) NSString * isRead;
@property (nonatomic,strong) NSString *uId;
- (void)configureCellWithAbstract:(CircleAbstractInfo *)info canLoadImage:(BOOL)canLoadImage;
- (void)configureCellWithLastCell;
- (void)hiddenRedPoint;
- (void)appearRedPoint;
@end
