//
//  CustomImageView.m
//  SnsDemo
//
//  Created by DuHaiFeng on 13-9-11.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView
@synthesize delegate=_delegate;
@synthesize method=_method;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view=[self viewWithTag:1000];
    if (!view) {
        view=[[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor=[UIColor whiteColor];
        view.alpha=0.75;
        view.tag=1000;
        [self addSubview:view];
    }
    else{
        view.hidden=NO;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view=[self viewWithTag:1000];
    if (view) {
        view.hidden=YES;
    }
    if ([self.delegate respondsToSelector:self.method]) {
        //调用self.delegate对象的self.method方法，self为方法的参数
        //[self.delegate method:self];
        [self.delegate performSelector:self.method withObject:self];
    }
    else{
        
        NSLog(@"回调方法没有实现:%@",NSStringFromSelector(self.method));
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"move");
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
    UIView *view=[self viewWithTag:1000];
    if (view) {
        view.hidden=YES;
    }
}

@end
