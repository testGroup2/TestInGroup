//
//  CircleViewController.h
//  商海通
//
//  Created by Liv on 14-3-22.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

typedef NS_ENUM(NSInteger, ListType) {
    ListTypeChatView,
    ListTypeSelf,
    ListTypeOtherView
};


@interface CircleListViewController : RootViewController

@property (strong,nonatomic) UITableView *circleTable;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSString *gloableUptime;   //全局的更新时间
@property (nonatomic) ListType pageType;
@property (nonatomic,strong) NSMutableArray *notReadThemeArray;
- (void)updateTopicListWithMsg:(ChatMessageInfo *)msg;
- (void)updateUnReadMsg:(NSMutableArray *)unReadArr;
- (void)addNoti;
- (void)reloadData;
@end
