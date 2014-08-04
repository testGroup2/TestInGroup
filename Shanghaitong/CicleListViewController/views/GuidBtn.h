//
//  GuidBtn.h
//  Shanghaitong
//
//  Created by xuqiang on 14-6-18.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuidBtnDelegate <NSObject>

- (void)guidBttonAction;

@end

@interface GuidBtn : UIView
@property (weak, nonatomic) IBOutlet UIButton *guidBtn;
@property (nonatomic,strong) id<GuidBtnDelegate> delegate;
- (IBAction)clickAction:(id)sender;

@end
