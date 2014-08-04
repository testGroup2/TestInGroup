//
//  FooterView.m
//  Shanghaitong
//
//  Created by xuqiang on 14-5-29.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeView];
    }
    return self;
}
- (void)makeView{
//    self.footView = [[UIView alloc]init];
//    CGFloat height = MAX(self.membersTable.contentSize.height, self.membersTable.frame.size.height);
//    self.footView.frame = CGRectMake(0.0f,height,
//                                     self.membersTable.frame.size.width,
//                                     self.view.bounds.size.height);
    self.backgroundColor = [UIColor whiteColor];
//    [self.membersTable addSubview:self.footView];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    textLabel.text = @"已加载全部信息";
    textLabel.font = [UIFont systemFontOfSize:16.0f];
    textLabel.textColor = [AppTools colorWithHexString:@"#b3c0d6"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
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
