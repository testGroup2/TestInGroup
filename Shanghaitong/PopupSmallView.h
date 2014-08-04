//
//  PopupSmallView.h
//  iSport
//
//  Created by Steve Wang on 13-5-16.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupSmallView;

@protocol PopupSmallViewDelegate <NSObject>

@optional
- (void)popupViewDidDisappear;

@end

@interface PopupSmallView : UIView

@property (weak, nonatomic) id<PopupSmallViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withMessage:(NSString *)string;


@end
