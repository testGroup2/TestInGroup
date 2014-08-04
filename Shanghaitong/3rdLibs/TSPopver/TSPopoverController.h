//
//  TSPopoverViewController.h
//
//  Created by anita
//  Copyright (anita All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import <UIKit/UIKit.h>
#import "TSPopoverTouchesDelegate.h"
#import "SVTopScrollView.h"
@class RViewController;
@class FriendViewController;
enum {
    TSPopoverArrowDirectionTop = 0,
	TSPopoverArrowDirectionRight,
    TSPopoverArrowDirectionBottom,
    TSPopoverArrowDirectionLeft
};


typedef enum {
    SearchHudong,
    SearchFabu,
    SearchGanxingqu,
    SearchNone,
    SearchQueding
} SearchType;

typedef enum {
    SearchZiyuan,
    SearchResouceGanxingqu,
    SearchResouceNone,
    SearchResouceQueding
}resouceSearchType;

typedef NSUInteger TSPopoverArrowDirection;

enum {
    TSPopoverArrowPositionVertical = 0,
    TSPopoverArrowPositionHorizontal
};
typedef NSUInteger TSPopoverArrowPosition;

@class TSPopoverPopoverView;


@protocol TSPopoverControllerDelegate <NSObject>

- (void)ChangeRightImageWithType:(resouceSearchType)type;

@end

@interface TSPopoverController : UIViewController <TSPopoverTouchesDelegate>
{
    TSPopoverPopoverView * popoverView;
    TSPopoverArrowDirection arrowDirection;
    CGRect screenRect;
    int titleLabelheight;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic) int cornerRadius;
@property (nonatomic, readwrite) TSPopoverArrowPosition arrowPosition;
@property (nonatomic,assign) id<TSPopoverControllerDelegate> delegate;
@property (nonatomic) BOOL popoverGradient;

@property (nonatomic, assign) SVTopScrollView   *topScrollView;
@property (strong,nonatomic)RViewController * resouceViewController;
//@property (strong,nonatomic) FriendViewController *resouceViewController;
@property (assign, nonatomic)   SearchType  sType;
@property (assign, nonatomic)   resouceSearchType  rType;

- (id)initWithContentViewController:(UIViewController*)viewController;
- (id)initWithView:(UIView*)view;
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;
- (void) showPopoverWithCell:(UITableViewCell*)senderCell;
- (void) showPopoverWithRect:(CGRect)senderRect;
- (void) view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) dismissPopoverAnimatd:(BOOL)animated;

@end
