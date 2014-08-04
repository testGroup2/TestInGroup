//
//  SocketSendMessageQueue.m
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SocketSendMessageQueue.h"

static SocketSendMessageQueue *socketMsgQueue = nil;

@implementation SocketSendMessageQueue

+ (SocketSendMessageQueue *)getInstace
{
    @synchronized(self) {
        if (!socketMsgQueue) {
            socketMsgQueue = [[self alloc] init];
            lock = [[NSLock alloc] init];
            
            [NSThread detachNewThreadSelector:@selector(sendMsg) toTarget:self withObject:nil];
        }
    }
    
    return socketMsgQueue;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (!socketMsgQueue) {
            socketMsgQueue = [super allocWithZone:zone];
            
            return socketMsgQueue;
        }
    }
    
    return nil;
}


#pragma mark - Private Method -

- (void)sendMsg
{
    // 创建SOCKET
    // 连接服务器
    
    // 发送消息
    
    // 读数据
    
    // 成功，踢出已发送的消息
    // 失败，阻塞，继续发送
}

#pragma mark - Public Method -

- (void)pushMessage:(char *)msg
{
}

@end
