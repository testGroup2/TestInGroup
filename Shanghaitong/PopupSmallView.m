//
//  PopupSmallView.m
//  iSport
//
//  Created by Steve Wang on 13-5-16.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//

#import "PopupSmallView.h"

@implementation PopupSmallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withMessage:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = [UIColor whiteColor];
        content.text = string;
        content.opaque = NO;
        content.font = [UIFont systemFontOfSize:14];
        [self addSubview:content];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disappear) userInfo:nil repeats:NO];
    
    return self;
}

- (void)disappear
{
    if (self.superview) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
            [self.delegate popupViewDidDisappear];
        }];
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
