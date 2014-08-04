//
//  TSPopoverTouchDelegate.h
//
//  Created by anita
//  Copyright anita All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import <UIKit/UIKit.h>


@protocol TSPopoverTouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end