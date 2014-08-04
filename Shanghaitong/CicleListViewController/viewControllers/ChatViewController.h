//
//  ChatViewController.h
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@class ChatMessageInfo;
@protocol ChatViewControllerDelegate <NSObject>

- (void)sendLastChatMsg:(ChatMessageInfo*)lastChatMsg;
- (void)backPageType:(NSInteger)type;
- (void)refreshList;

@end

@interface ChatViewController : RootViewController
@property (nonatomic,assign) id<ChatViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *circleThemeID;
@property (nonatomic,strong) NSString *circleId;
@property (nonatomic,strong) NSString *circleName;
@property (nonatomic,strong) NSString *themeName;
@property (nonatomic,strong) UITableView *chatTableView;
@property (nonatomic,strong) NSMutableArray *myDataArray;
@property (nonatomic,strong) NSMutableArray *chatTimeArray;
@property (nonatomic,strong) NSMutableArray *buffArray;//缓冲数组

- (NSString *)getCurrentTime;
- (void)moveUpTable;
- (void)updateChatlIistWithMsg:(ChatMessageInfo *)msg;
- (void)updateUnReadChatMsg:(NSMutableArray *)unReadArr;
@end
