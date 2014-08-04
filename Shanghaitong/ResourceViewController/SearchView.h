//
//  SearchView.h
//  Shanghaitong
//
//  Created by xuqiang on 14-7-10.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SearchViewDelegate <NSObject>
- (void)sendResignFirstResponder;
- (void)sendBackWithKeyword:(NSString *)keyword andTag:(NSString *)tag;
- (void)searchDirectWithType:(NSInteger)type;
@end

@interface SearchView : UIView
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (strong, nonatomic) UIView *hotLabelView;
@property (strong, nonatomic) NSMutableArray *area;
@property (strong, nonatomic) NSMutableArray *industry;
@property (nonatomic,assign) id<SearchViewDelegate> delegate;
@property (nonatomic,strong) UIView *nomarlLabelView;

- (void)configureHotLabelData:(NSArray *)hotData andNormalData:(NSMutableArray *)nomarlData;
- (void)clearTagColor;
@end
