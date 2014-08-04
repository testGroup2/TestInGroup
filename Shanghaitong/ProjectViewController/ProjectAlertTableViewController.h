//
//  AlertTableViewController.h
//  jushang
//
//  Created by Liv on 14-3-18.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSPopoverController.h"

@interface ProjectAlertTableViewController : UITableViewController<UITextFieldDelegate>
{
    CGSize _keyboardSize;
}
@property (nonatomic,assign) BOOL textChosedBoxShow;
@property (nonatomic,strong) NSMutableArray *areas;
@property (nonatomic,strong) NSMutableArray *inds;
@property (nonatomic,strong) NSMutableArray *dems;
@property (nonatomic,assign) TSPopoverController *tsPopViewController;
@end
