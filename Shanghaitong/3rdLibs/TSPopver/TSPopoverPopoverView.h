//
//  TSPopoverPopoverView.h
//
//  Created by anita
//  Copyright (anita All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import <UIKit/UIKit.h>
#import "TSPopoverController.h"

@interface TSPopoverPopoverView : UIView

@property (nonatomic) int cornerRadius;
@property (nonatomic) CGPoint arrowPoint;
@property (nonatomic) BOOL isGradient;
@property (nonatomic, strong) UIColor *baseColor;
@property (nonatomic, readwrite) TSPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) TSPopoverArrowPosition arrowPosition;



@end
