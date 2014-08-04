//
//  ContributeToCicleViewController.h
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@protocol ContributeToCicleViewControllerDelegate <NSObject>

- (void)backToCircleThemeListWith:(NSString *)adminId;
//- (void)backToCircleDetailWithAdminId:(NSString *)adminId;

@end
typedef NS_ENUM(NSUInteger, SHTImageScanState){
    SHTImageScanStateAll,
    SHTImageScanStateAdd
};
@interface ContributeToCicleViewController : RootViewController<UITextFieldDelegate>
{
}
@property (nonatomic,assign) id<ContributeToCicleViewControllerDelegate> delegate;


@end
