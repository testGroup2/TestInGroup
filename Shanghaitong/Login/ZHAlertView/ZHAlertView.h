//
//  ZHIslandAlertView.h
//  ZHIsland
//
//  Created by Qi XiaoLong on 11-11-9.
//  Copyright (c) 2011年 ZHIsland.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAlertView;

@protocol ZHAlertViewDelegate <NSObject>

@optional
- (void)alertViewHidden:(ZHAlertView *)alertView;

@end

typedef enum {
    ZHAlertViewTypeNote,
    ZHAlertViewTypeSuccess,
}ZHAlertViewType;

@interface ZHAlertView : UIView
{
    UILabel *_contentLabel;
    
    UIView *_backgroundView;
    
    UIImageView *_alertImage;
    
    ZHAlertViewType _type;
}

@property(nonatomic, assign) id<ZHAlertViewDelegate> delegate;

@property (nonatomic, assign) CGFloat yOffset;

@property(nonatomic, copy) NSString *content;

- (id)initWithView:(UIView *)view delegate:(id<ZHAlertViewDelegate>)delegate;

- (void)show:(BOOL)animated;

- (void)show:(NSString *)content animated:(BOOL)animated;

- (void)show:(NSString *)content animated:(BOOL)animated type:(ZHAlertViewType)type;

- (void)hide:(BOOL)animated;

@end
