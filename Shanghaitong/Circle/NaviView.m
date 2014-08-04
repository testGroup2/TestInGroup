//
//  NaviView.m
//  Shanghaitong
//
//  Created by xuqiang on 14-4-30.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "NaviView.h"

@implementation NaviView

- (id)initWithFrame:(CGRect)frame withHasLeft:(BOOL)hasLeft withHasRight:(BOOL)hasRight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeViewWithHasLeft:hasLeft withHasRight:hasRight];
    }
    return self;
}
#define WIDTH 200
- (void)makeViewWithHasLeft:(BOOL)hasLeft withHasRight:(BOOL)hasRight
{
    float origin_x = (kScreenWidth - WIDTH)/2;
    if (IOS_VERSION >= 7.0) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, 21, 200, 44)];
    }
    else{
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, 0, 200, 44)];
    }
    self.titleLabel.font = [UIFont systemFontOfSize:22.0f];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleLabel];
    
    if (hasRight) {
        UIView *lView = [[UIView alloc]init];
        if (IOS_VERSION >= 7.0) {
            lView.frame = CGRectMake(270, 21, 50, 44);
        }
        else{
            lView.frame = CGRectMake(270, 0, 50, 44);
        }
        lView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *leftap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
        [lView addGestureRecognizer:leftap];
        [self addSubview:lView];
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IOS_VERSION >= 7.0) {
            self.rightButton.frame = CGRectMake(280, 25, 35, 35);
        }
        else{
            self.rightButton.frame = CGRectMake(280, 5, 35, 35);
        }
        [self.rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightButton];
        
    }    
    if(hasLeft) {
        UIView *lView = [[UIView alloc]init];
        if (IOS_VERSION >= 7.0) {
            lView.frame = CGRectMake(270, 21, 50, 44);
        }
        else{
            lView.frame = CGRectMake(270, 0, 50, 44);
        }
        lView.frame = CGRectMake(0, 0, 50, 44);
        lView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *leftap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
        [lView addGestureRecognizer:leftap];
        [self addSubview:lView];
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IOS_VERSION >= 7.0) {
             self.leftButton.frame = CGRectMake(7,25, 35, 35);
        }
        else{
            self.leftButton.frame = CGRectMake(7,5, 35, 35);
        }
        [self.leftButton setImage:[UIImage imageNamed:@"back_16_12"] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftButton];
    }
}

- (void)rightClick{
    if (_delegate && [_delegate respondsToSelector:@selector(rightButtonClick)]) {
        [self.delegate rightButtonClick];
    }
}

- (void)back
{
    if (_delegate && [_delegate respondsToSelector:@selector(rightButtonClick)]) {
        [self.delegate leftButtonClick];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
