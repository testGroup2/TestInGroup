//
//  ResourceLeftViewController.h
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceLeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * ResoucetableView;
    NSArray * ResoucedataArray;
}
@end
