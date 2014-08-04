//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"
#import "SVGloble.h"
#import "SVTopScrollView.h"
#import "PViewController.h"

#define POSITIONID (int)(scrollView.contentOffset.x/320)

@implementation SVRootScrollView

@synthesize viewNameArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews : (NSArray *) views
{
    for (int i = 0; i < [views count]; i++) {
        UIView *view = views[i];
        NSLog(@"view.frame.origin.y: %f", view.frame.origin.y);
        view.frame = CGRectMake(0+view.frame.size.width*i, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];

        self.contentSize = CGSizeMake(view.frame.size.width * (i + 1),view.frame.size.height );
        }
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedLeft) {
        [((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)) closeSideBar];
        ((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedLeft = NO;
    }else if (((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedRight) {
        [((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)) closeSideBar];
        ((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedRight = NO;
    }else if (scrollView.contentOffset.x == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"projectShowLeft" object:self userInfo:nil];
        NSLog(@"rightdragging %f !",scrollView.contentOffset.x);
    }else if (scrollView.contentOffset.x == 640) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showRight" object:self userInfo:nil];
        NSLog(@"leftdragging %f !",scrollView.contentOffset.x);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedLeft) {
        [scrollView setContentOffset:CGPointMake(_scrollViewCurrentContentOffset, scrollView.contentOffset.y) animated:NO];return;
    }else if (((PViewController *)((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC).didShowedRight) {
        [scrollView setContentOffset:CGPointMake(_scrollViewCurrentContentOffset, scrollView.contentOffset.y) animated:NO];return;
    }

    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];

    if (!isLeftScroll) {
        [self loadData];
    }
    _scrollViewCurrentContentOffset = scrollView.contentOffset.x;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage_Project" object:self];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/viewNameArray.count)/pagewidth)+1;
    UILabel *label = (UILabel *)[self viewWithTag:page+200];
    label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:page]];
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [(SVTopScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10000] setButtonUnSelect];
    
    ((SVTopScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10000]).scrollViewSelectedChannelID = POSITIONID+100;
    [(SVTopScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10000] setButtonSelect];
    [(SVTopScrollView *)[((ProjectSliderViewController *)(((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:0]).viewController)).MainVC.view viewWithTag:10000] setScrollViewContentOffset];
}
@end
