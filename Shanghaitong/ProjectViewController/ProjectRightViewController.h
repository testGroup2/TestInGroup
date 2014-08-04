//
//  ProjectRightViewController.h
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPageViewController.h"

@interface ProjectRightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *ProjecttableView;
    NSArray * ProjetdataArray;
}


@property (retain,nonatomic) ShowPageViewController *showPageViewController;

@end
