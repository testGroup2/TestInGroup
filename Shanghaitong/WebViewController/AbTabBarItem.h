//
//  AbTabBarItem.h
//
//  Created by Alexander Blunck on 15.02.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProjectSliderViewController.h"
#import "ResourceSliderViewController.h"
@interface AbTabBarItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, assign) ProjectSliderViewController  *pSliderViewControl;
@property(nonatomic, assign) ResourceSliderViewController *rSliderViewControl;
-(id) initWithTitle:(NSString *)title image:(UIImage*)image selectedImage:(UIImage*)selectedImage viewController:(UIViewController*)viewcontroller;


@end
