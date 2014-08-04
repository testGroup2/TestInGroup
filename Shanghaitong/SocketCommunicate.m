//
//  SocketCommunicate.m
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-12.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SocketCommunicate.h"

@implementation SocketCommunicate

- (id)initWithIP:(NSString *)ip port:(NSInteger)port connectWithNonblock:(BOOL)flag
{
    if (self = [super init]) {
        if ((_sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) { // ipv4
            self = nil;
            return self;
        }
        
        struct sockaddr_in  serverAddr;
        memset(&serverAddr, 0x00, sizeof(struct sockaddr_in));
        serverAddr.sin_family = AF_INET;
        serverAddr.sin_addr.s_addr = inet_addr([ip UTF8String]);
        serverAddr.sin_port = htons(port);
        
        if (![self connectSocketServer:(struct sockaddr_in)serverAddr withNonBlock:flag]) {
            close(_sockfd);
            self = nil;
        }
    }
    
    return self;
}

- (id)initWithHost:(NSString *)host port:(NSInteger)port connectWithNonblock:(BOOL)flag
{
    struct hostent *hostTest;
    hostTest = gethostbyname(host.UTF8String);
    if (!hostTest) {
        NSLog(@"解析域名失败");
        return nil;
    }
    char **pIP = hostTest->h_addr_list;
    char *IP = NULL;
    for (; *pIP != NULL; pIP++) {
        IP = inet_ntoa(*(struct in_addr *)*pIP);
        if (IP != NULL) {
            break;
        }
    }
    if (IP == NULL) {
        NSLog(@"domain %s dns fail", host.UTF8String);
        return nil;
    }
    
    NSString *gwIp = [NSString stringWithFormat:@"%s", IP];
    NSLog(@"gwIp=%@",gwIp);
    
    return [self initWithIP:gwIp port:port connectWithNonblock:flag];
}

#pragma mark - Private Method -

- (BOOL)connectSocketServer:(struct sockaddr_in)serverAddr withNonBlock:(BOOL)flag
{
    int ret = connect(_sockfd, (struct sockaddr*)&serverAddr, sizeof(struct sockaddr));
    if (ret < 0) {
        return false;
    }
    int flags = fcntl(_sockfd, F_GETFL, 0);
    if (flag) {
        fcntl(_sockfd, F_SETFL, flags | O_NONBLOCK);
    }
    
    return true;
}

- (void)packSendMsg:(int16_t)msgType msgDict:(NSDictionary *)dict data:(char **)data dataLen:(int32_t *)msg_len
{
    switch (msgType) {
        case 0x21:
        {
            // send heartbeat
            uint16_t u16temp;
            uint32_t u32temp;
            
            char cuserID[100] = {0};
            sprintf(cuserID, "%d", [[dict objectForKey:kUserID] integerValue]);
            
            *msg_len = sizeof(int32_t) + sizeof(int16_t) + sizeof(int16_t) +sizeof(int32_t) + strlen(cuserID); //msg自身的长度+消息类型长度+消息状态长度+value的长度+发送数据内容的长度
            
            int16_t key = 0x01;
            
            int32_t vlen = strlen(cuserID);
            
            *data = (char *)calloc(*msg_len, 1);
            if (!*data) {
                NSLog(@"calloc memory failed");
                return ;
            }
            char *offset = *data;
            u32temp = htonl(*msg_len);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            u16temp = htons(msgType);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u16temp = htons(key);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(vlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, cuserID, vlen);
        }
            break;
        case 0x22:
        {
            uint32_t u32temp;
            uint16_t u16temp;
            
            char cuserID[100] = {0};
            sprintf(cuserID, "%d", [[dict objectForKey:kUserID] integerValue]);
            
            *msg_len = sizeof(int32_t) + sizeof(int16_t) + sizeof(int16_t) +sizeof(int32_t) + strlen(cuserID); //msg自身的长度+消息类型长度+消息状态长度+value的长度+发送数据内容的长度
            int16_t key = 0x01;
            int32_t vlen = strlen(cuserID);
            
            *data = (char *)calloc(*msg_len, 1);
            if (!*data) {
                NSLog(@"calloc memory failed");
                return ;
            }
            char *offset = *data;
            
            u32temp = htonl(*msg_len);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            u16temp = htons(msgType);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u16temp = htons(key);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(vlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, cuserID, vlen);
        }
            break;
        case 0x23:
        {
            uint32_t u32temp;
            uint16_t u16temp;

            char cuserID[100] = {0};
            sprintf(cuserID, "%d", [[dict objectForKey:kUserID] integerValue]);
            
            int16_t uIDkey = 0x01;
            int32_t uIDvlen = strlen(cuserID);
            
            int16_t sIDkey = 0x02;
            int32_t sIDvlen = strlen(((NSString *)[dict objectForKey:kSubjectID]).UTF8String);
            
            int16_t ckey = 0x03;
            int32_t cvlen = strlen(((NSString *)[dict objectForKey:kChatMsgContent]).UTF8String);
            
            int16_t tkey = 0x04;
            int32_t tvlen = strlen(((NSString *)[dict objectForKey:kSendTimeInterval]).UTF8String);
            
            *msg_len = sizeof(int32_t)*5 + sizeof(int16_t)*5 + uIDvlen + sIDvlen + cvlen + tvlen;
            
            *data = (char *)calloc(*msg_len, 1);
            if (!*data) {
                NSLog(@"calloc memory failed");
                return;
            }
            char *offset = *data;
            
            u32temp = htonl(*msg_len);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            u16temp = htons(msgType);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u16temp = htons(uIDkey);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(uIDvlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, cuserID, uIDvlen);
            offset += uIDvlen;
            
            u16temp = htons(sIDkey);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(sIDvlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, ((NSString *)[dict objectForKey:kSubjectID]).UTF8String, sIDvlen);
            offset += sIDvlen;
            
            u16temp = htons(ckey);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(cvlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, ((NSString *)[dict objectForKey:kChatMsgContent]).UTF8String, cvlen);
            offset += cvlen;
            
            u16temp = htons(tkey);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(tvlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, ((NSString *)[dict objectForKey:kSendTimeInterval]).UTF8String, tvlen);
        }
            break;
            
        default:
            break;
    }

}

- (NSInteger)recv:(void*)buff bufLen:(NSInteger)len
{
    int32_t  readall = 0;
    char*     ptr = (char*)buff;
    
    while(1)
    {
        signal(SIGPIPE, SIG_IGN);
        int32_t n = recv(_sockfd, ptr + readall, len - readall, 0);
        if(n < 0)
        {
            if(errno == EINTR || errno == EAGAIN)
            {
                continue;
            }
            else
            {
                readall = 0;
                break;
            }
        }
        readall += n;
        if (readall == len) break;
    }
    
    
    int32_t rlen = strlen(ptr);
    if(rlen > len) ptr[len] = 0;
    return readall;
}

- (NSInteger)send:(void*)buff bufLen:(NSInteger)len
{
    int32_t  writeall = 0;
    char* ptr = (char*)buff;
    
    while(1)
    {
        signal(SIGPIPE,SIG_IGN);
        int32_t n = send(_sockfd, ptr + writeall, len - writeall, 0);
        if(n < 0)
        {
            if(errno == EINTR || errno == EAGAIN)
            {
                continue;
            }
            else
            {
                writeall = -1;
                break;
            }
            
        }
        writeall += n;
        if (writeall == len) break;
    }
    return writeall;
}

- (void)closeFD
{
    close(_sockfd);
}

@end
