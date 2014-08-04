//
//  ProjectLeftViewController.h
//  商海通
//
//  Created by anita on 14-3-27.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectLeftViewController : UIViewController<UITableViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UITableView *projectTableView;
    NSArray * projetDataArray;
}
@end
