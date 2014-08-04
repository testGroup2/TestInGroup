//
//  SocketCommunicate.h
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-12.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/socket.h>

#include <netinet/in.h>
#include <netinet/tcp.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>

@interface SocketCommunicate : NSObject

@property (nonatomic, assign)   int sockfd;

- (id)initWithIP:(NSString *)ip port:(NSInteger)port connectWithNonblock:(BOOL)flag;
- (id)initWithHost:(NSString *)host port:(NSInteger)port connectWithNonblock:(BOOL)flag;

- (void)packSendMsg:(int16_t)msgType msgDict:(NSDictionary *)dict data:(char **)data dataLen:(int32_t *)dLen; // socket通信协议的封装函数，客户端to服务器

- (NSInteger)recv:(void*)buff bufLen:(NSInteger)len;
- (NSInteger)send:(void*)buff bufLen:(NSInteger)len;

- (void)closeFD;

@end
