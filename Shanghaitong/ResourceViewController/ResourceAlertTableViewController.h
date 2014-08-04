//
//  AlertTableViewController.h
//  jushang
//
//  Created by Liv on 14-3-18.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSPopoverController.h"
@interface ResourceAlertTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *areas;
@property (nonatomic,strong) NSMutableArray *inds;
@property (nonatomic,assign) TSPopoverController *tsPopViewController;

@end
