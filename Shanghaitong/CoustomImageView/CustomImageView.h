//
//  CustomImageView.h
//  SnsDemo
//
//  Created by DuHaiFeng on 13-9-11.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIImageView

@property (nonatomic,assign) id delegate;//回调对象
@property (nonatomic,assign) SEL method;//回调方法
@end






