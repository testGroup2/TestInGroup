//
//  NewMessagePromptView.m
//  iSport
//
//  Created by Steve Wang on 13-6-14.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//

#import "NewMessagePromptView.h"

@implementation NewMessagePromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [AppTools colorWithHexString:@"#ff8694"];
        self.layer.cornerRadius = kUIViewRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
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
