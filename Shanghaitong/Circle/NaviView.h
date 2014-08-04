//
//  NaviView.h
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NaviViewDelegate <NSObject>
- (void)rightButtonClick;
- (void)leftButtonClick;
@end

@interface NaviView : UIView
@property (nonatomic) id<NaviViewDelegate> delegate;
@property (nonatomic) BOOL hasLeftButton;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImage *rightImage;
@property (nonatomic,strong) UIImage *leftImage;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *leftButton;
- (id)initWithFrame:(CGRect)frame withHasLeft:(BOOL)hasLeft withHasRight:(BOOL)hasRight;
@end
