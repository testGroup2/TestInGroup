//
//  GuidBtn.m
//  Shanghaitong
//
//  Created by xuqiang on 14-6-18.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "GuidBtn.h"

@implementation GuidBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)clickAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidBttonAction)]) {
        [self.delegate guidBttonAction];
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
