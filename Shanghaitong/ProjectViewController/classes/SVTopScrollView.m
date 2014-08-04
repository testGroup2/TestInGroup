//
//  SVTopScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVTopScrollView.h"
#import "SVGloble.h"
#import "SVRootScrollView.h"

//按钮空隙
#define BUTTONGAP 50
//滑条宽度
#define CONTENTSIZEX 320
//按钮id
#define BUTTONID (sender.tag-100)
//滑动id
#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)
@implementation SVTopScrollView
@synthesize nameArray;
@synthesize scrollViewSelectedChannelID;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        userSelectedChannelID = 100;
        scrollViewSelectedChannelID = 100;
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWithArray = [NSMutableArray array];
    }
    return self;
}
- (void)initWithNameButtons
{
    float xPos = 0;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.nameArray objectAtIndex:i];
        [button setTag:i+100];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [button setTitleColor:[SVGloble colorFromHexRGB:@"255255255"] forState:UIControlStateNormal];
        [button setTitleColor:[SVGloble colorFromHexRGB:@"255116132"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(xPos, 0, 90, 49);
        [_buttonOriginXArray addObject:@(xPos)];
        xPos += 90;
        [_buttonWithArray addObject:@(button.frame.size.width)];
        [self addSubview:button];
    }
    self.contentSize = CGSizeMake(xPos, 44);
    if(shadowImageView == nil){
        if (!shadowImageView) {
            shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1.6, 90, 44)];
            [shadowImageView setImage:[UIImage imageNamed:@"red.png"]];
            [self addSubview:shadowImageView];
        }
    }
}
//点击顶部条滚动标签
- (void)selectNameButton:(UIButton *)sender
{
    [self adjustScrollViewContentX:sender];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sender,@"slcBtn", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickBtn" object:self userInfo:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Project" object:self];
    //如果更换按钮
    if (sender.tag != userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        userSelectedChannelID = sender.tag;
    }
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [shadowImageView setFrame:CGRectMake(sender.frame.origin.x, -2.5, 90, 44)];
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新闻页出现
                [(SVRootScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10001] setContentOffset:CGPointMake(BUTTONID*320, 0) animated:YES];
                ((SVRootScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10001]).scrollViewCurrentContentOffset = BUTTONID*320;
                //赋值滑动列表选择频道ID
                scrollViewSelectedChannelID = sender.tag;
            }
        }];
    }
    //重复点击选中按钮
    else {
    }
}
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
    float width = [[_buttonWithArray objectAtIndex:BUTTONID] floatValue];
    
    if (sender.frame.origin.x - self.contentOffset.x > CONTENTSIZEX-(BUTTONGAP+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
    }
    if (sender.frame.origin.x - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}

//滚动内容页顶部滚动
- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    lastButton.selected = NO;
}
- (void)setButtonSelect
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button,@"slcBtn", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBtn" object:self userInfo:dic];
    
    [UIView animateWithDuration:0.25 animations:^{
    [shadowImageView setFrame:CGRectMake(button.frame.origin.x, -2.5, 90, 44)];
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                userSelectedChannelID = button.tag;
            }
        }
    }];
}
-(void)setScrollViewContentOffset
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    float width = [[_buttonWithArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    if (originX - self.contentOffset.x > CONTENTSIZEX-(width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
    }
    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}
@end
