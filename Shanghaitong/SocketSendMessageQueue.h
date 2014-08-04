//
//  SocketSendMessageQueue.h
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketCommunicate.h"
#import "ChatMessageInfo.h"

SocketCommunicate   *sComm;
NSLock              *lock;

@interface SocketSendMessageQueue : NSObject

+ (SocketSendMessageQueue *)getInstace;

- (void)pushMessage:(char *)msg; // 任何类型的message

@end
