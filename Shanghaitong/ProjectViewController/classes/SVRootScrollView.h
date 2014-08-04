//
//  SVRootScrollView.h
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, SHTLoadWebPageName) {
//    SHTLoadWebPageNamePro,
//    SHTLoadWebPageNameHouse,
//    SHTLoadWebPageNameWel
//};

@interface SVRootScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
    BOOL isRightScroll;
}
@property (nonatomic, retain) NSArray *viewNameArray;
@property (nonatomic, assign)   float   scrollViewCurrentContentOffset;
//@property (nonatomic,assign) SHTLoadWebPageName loadType;
- (void)initWithViews : (NSArray *) views;
- (void)loadData;
@end
