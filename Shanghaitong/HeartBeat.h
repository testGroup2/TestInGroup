//
//  HeartBeat.h
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-12.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartBeat : NSObject

//用户的userID
@property (atomic) NSUInteger userID;
@property (nonatomic, assign)   BOOL    didStopHB; // 程序退出运行时，需要停止心跳

//心跳单例
+ (HeartBeat *)sharedHeartBeat;
- (void)startHeartBeat;
- (void)stopHeartBeat;

@end
