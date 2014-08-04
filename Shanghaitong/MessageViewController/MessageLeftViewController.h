//
//  MessageLeftViewController.h
//  商海通
//
//  Created by anita on 14-3-31.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageLeftViewControllerDelegate <NSObject>

- (void)loadMessageWithUrl:(NSString *)url;

@end

@interface MessageLeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * MessagetableView;
    NSArray * MessagedataArray;
}
@property (nonatomic,assign) id<MessageLeftViewControllerDelegate> delegate;
@end
