//
//  HeartBeat.m
//  Shanghaitong
//
//  Created by Steve Wang on 14-5-12.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "HeartBeat.h"
#import "SocketCommunicate.h"
#import "CircleDatabase.h"
#import "userItemInformation.h"
#import "ChatMessageInfo.h"
#import "ChatViewController.h"
#import "NewMessagePromptView.h"
#import "GTMBase64.h"
#import "CicleListViewController.h"
#import "Audio.h"

const   int16_t   i16HeartBeatType        = 0x21;
const   int16_t   i16GetUnreadMsgType     = 0x22;
const   int16_t   i16SendMsgType          = 0x23;
const   int16_t   i16ServerPushMsgType    = 0x24;


#define TIME_OUT 5

@interface HeartBeat()
@property (nonatomic, copy)     NSMutableArray  *onlineMsgDataIDs;
@property (nonatomic, strong)   SocketCommunicate *scomm;
@property (nonatomic, assign)   int lastDataID; // 用于记录最后一次消息的数据ID
@property (nonatomic, assign) BOOL sendResponseSuccess;
@property (nonatomic, assign) BOOL canRecvUnreadMsg;
@end

@implementation HeartBeat

static HeartBeat * heartBeat = nil;
static bool isSendHB = false; // 表示是否能发送心跳
static NSLock *lock = NULL;

#pragma mark - Init -

+ (HeartBeat *)sharedHeartBeat
{
    @synchronized(self) {
        if (!heartBeat) {
            heartBeat = [[self alloc] init];
        }
    }
    heartBeat.userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue];
    return heartBeat;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (!heartBeat) {
            heartBeat = [super allocWithZone:zone];
            
            return heartBeat;
        }
    }
    
    return nil;
}

#pragma mark - Private Method -

- (void)sendOnlineMsgResponse:(NSString *)dataIDStr
{
    int dataId = [dataIDStr intValue];
            SocketCommunicate *sendResponseComm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:NO];
            if (!sendResponseComm) {
                NSLog(@"init send online response socket failed.");
                return;
            }
            
            uint32_t u32temp;
            uint16_t u16temp;
            
            int32_t msg_len;
            int16_t msg_type = 0x24;
            int16_t msg_status = 0;
            
            char dataID[100] = {0};
            char userID[100] = {0};
                      
//            sprintf(dataID, "%d", [onlineMsgDataID integerValue]);
            sprintf(dataID, "%d", dataId);
            sprintf(userID, "%d", _userID);
    
            msg_len = sizeof(int32_t)*3 + sizeof(int16_t)*4 + strlen(dataID)+strlen(userID);
            
            char *responseData = NULL;
            responseData = (char *)calloc(msg_len, 1);
            if (!responseData) {
                NSLog(@"calloc memory failed");
                [sendResponseComm closeFD];
                sendResponseComm = nil;
                return;
//                break;
            }
            
            char *offset = responseData;
            
            u32temp = htonl(msg_len);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            u16temp = htons(msg_type);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u16temp = htons(msg_status);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            int16_t key = 0x01;
            int32_t vlen = strlen(userID);
            
            u16temp = htons(key);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(vlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, userID, vlen);
            offset += vlen;
            
            int16_t dataIDKey = 0x05;
            int32_t dataIDVlen = strlen(dataID);
            
            u16temp = htons(dataIDKey);
            memcpy(offset, &u16temp, sizeof(int16_t));
            offset += sizeof(int16_t);
            
            u32temp = htonl(dataIDVlen);
            memcpy(offset, &u32temp, sizeof(int32_t));
            offset += sizeof(int32_t);
            
            memcpy(offset, dataID, dataIDVlen);
            
            if ([sendResponseComm send:responseData bufLen:msg_len] < 0) {
                NSLog(@"在线消息，客户端应答失败");
                free(responseData);
                responseData = nil;
                self.sendResponseSuccess = NO;
                [sendResponseComm closeFD];
                sendResponseComm = nil;
                return;
//                break;
            }
            NSLog(@"在线消息，客户端应答成功");
            free(responseData);
            responseData = nil;
            self.sendResponseSuccess = YES;
            [sendResponseComm closeFD];
            sendResponseComm = nil;
//        }
        [_onlineMsgDataIDs removeAllObjects];
//    }
    
}

#pragma mark - NetWork Control -

- (void)startHeartBeat
{
    // 开始心跳
    _didStopHB = NO;
    
    _lastDataID = 0;

    if (!lock) {
        lock = [[NSLock alloc] init];
    }
    if (!_onlineMsgDataIDs) {
        _onlineMsgDataIDs = [[NSMutableArray alloc]init];
    }
    
    [NSThread detachNewThreadSelector:@selector(heartBeatControlStatus) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(heartBeatControlSend) toTarget:self withObject:nil];
}

- (void)stopHeartBeat
{
    _didStopHB = YES;
    if (_scomm) {
        [_scomm closeFD];
        _scomm = nil;
    }
}
- (void)heartBeatControlSend
{
    // 1.prepare send
    while (1) {
        if (_didStopHB) {
            break;
        }
        
        if (!(_scomm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:YES])) {
            [NSThread sleepForTimeInterval:TIME_OUT];
            continue;
        }
        
        break;
    }
    
    // 2.start send
    fd_set rfd_set;
    fd_set wfd_set;
    
    struct timeval tv;
    int fd = _scomm.sockfd;
    
    while (1) {
        if (_didStopHB) {
            _scomm = nil;
            break;
        }
        
        tv.tv_sec = 1;
        tv.tv_usec = 0;
        
        FD_ZERO(&rfd_set);
        FD_ZERO(&wfd_set);
        FD_SET(fd, &rfd_set);
        
        if ([SharedApp networkStatus] == -1) { // 断网处理
            NSLog(@"network has failed.");
            SharedApp.notReadAudio = NO;
            [NSThread sleepForTimeInterval:5];
            self.canRecvUnreadMsg = YES;
            continue;
        }
        if (self.canRecvUnreadMsg) {
            //接收未读消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kGetUnreadMsg" object:nil];
            self.canRecvUnreadMsg = NO;
        }
        
        if ([self getHeartBeartStatus]) {
            FD_SET(fd, &wfd_set);
        }
        
        int32_t ret = select(fd + 1, &rfd_set, &wfd_set, NULL, &tv);
        if (ret < 0) { // Erro
            NSLog(@"error to select fd");
            [NSThread sleepForTimeInterval:TIME_OUT];
            continue;
        }else if (ret == 0) { // 超时
        }else if (FD_ISSET(fd, &rfd_set)) {     //fd上有新的数据可读
            if (![self readData:_scomm]) {
                NSLog(@"read msg failed.");
                // 关闭FD，重连服务器
                [_scomm closeFD];
                _scomm = nil;
                while (1) {
                    if (!(_scomm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:YES])) {
                        NSLog(@"reconnect socket failed.");
                        [NSThread sleepForTimeInterval:TIME_OUT];
                        continue;
                    }
                    fd = _scomm.sockfd;
                    break;
                }
                continue;
            }
            else {
            }
            
        }
        else if (FD_ISSET(fd, &wfd_set)) { //fd上有新的数据可写
            // send heartBeat info to server
            int16_t msg_type = 0x21;
            NSDictionary *hbDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:_userID], kUserID,nil];
            char *data = NULL;
            int32_t msg_len;
            
            [_scomm packSendMsg:msg_type msgDict:hbDict data:&data dataLen:&msg_len];
            
            if ([_scomm send:data bufLen:msg_len] < 0) {
                if (!data) free(data);
                NSLog(@"send chat msg failed.");
                // 关闭FD，重连服务器
                [_scomm closeFD];
                _scomm = nil;
                
                while (1) {
                    if (!(_scomm = [[SocketCommunicate alloc] initWithHost:GW_HOST port:GW_PORT connectWithNonblock:YES])) {
                        [NSThread sleepForTimeInterval:TIME_OUT];
                        NSLog(@"reconnect socket failed.");

                        continue;
                    }
                    fd = _scomm.sockfd;
                    
                    break;
                }
                continue;
            }
            if (!data) free(data);data = nil;
            
            NSLog(@"fd: %d | user: %d send a heartBeat | time: %@ ", fd, _userID, [AppTools stringFromDate:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
}

- (void)heartBeatControlStatus
{
    while (1) {
        if (_didStopHB) {
            break;
        }

        [lock lock];
        if (!isSendHB) {
            isSendHB = true;
        }
        [lock unlock];
        
        [NSThread sleepForTimeInterval:kSendHeartBeatInterval];
    }
}

- (bool)getHeartBeartStatus
{
    [lock lock];
    if (isSendHB) {
        isSendHB = false;
        [lock unlock];
        return true;
    }
    
    [lock unlock];
    return false;
}

- (BOOL)readData:(SocketCommunicate *)sComm
{
    
    int32_t total_len;
    int16_t msg_type;
    int16_t msg_stat;
    
    read(sComm.sockfd, &total_len, sizeof(int32_t));
    total_len = ntohl(total_len);
    read(sComm.sockfd, &msg_type, sizeof(int16_t));
    msg_type = ntohs(msg_type);
    
    switch (msg_type) {
        case i16HeartBeatType: // 心跳
        {
            [sComm recv:&msg_stat bufLen:sizeof(int16_t)];
            msg_stat = ntohs(msg_stat);
            if (msg_stat == 0) {
                NSLog(@"heartBeat Status: %d", msg_stat);
            }else {
                NSLog(@"recv heartbeat stus code failed");
                return false;
            }
        }
            break;
        case i16GetUnreadMsgType: // 获取未读消息
        {
            NSLog(@"有未读消息");
        }
            break;
        case i16SendMsgType: // 消息发送
            
            break;
        case i16ServerPushMsgType: // 服务器推送聊天消息
        {
            int32_t dataLen = total_len - sizeof(int32_t) - sizeof(int16_t);
            char *data = (char *)calloc(dataLen+1, sizeof(char));
            [sComm recv:data bufLen:dataLen];

            NSLog(@"data: %s", data);
            
            NSData *_data = [NSData dataWithBytes:data length:strlen(data)];
            NSDictionary *chatMsgDict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"chatMsgDict: %@", chatMsgDict);
            NSArray *messageArray = [chatMsgDict objectForKey:@"message"];
            if (messageArray.count > 0) {
            int recvDataID = [[chatMsgDict objectForKey:@"dataID"] integerValue];
            
            if (recvDataID != _lastDataID) {
            _lastDataID = recvDataID;
            [NSThread detachNewThreadSelector:@selector(sendOnlineMsgResponse:) toTarget:self withObject:[NSString stringWithFormat:@"%d",recvDataID]];
//            [self sendOnlineMsgResponse:[NSString stringWithFormat:@"%d",recvDataID]];
            // 对于在线消息，给服务器应答
            [_onlineMsgDataIDs addObject:[chatMsgDict objectForKey:@"dataID"]];
            [DATABASE openDatabase];
            // 处理收到的聊天信息
            if (messageArray.count > 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[Audio shareAudio] playAudio];
                });
                NSDictionary *messageItem = [messageArray objectAtIndex:0];
                ChatMessageInfo *chatMsg = [[ChatMessageInfo alloc] init];
                chatMsg.userId = [messageItem objectForKey:@"sendUserID"];
                chatMsg.dataID = [chatMsgDict objectForKey:@"dataID"];
                chatMsg.content = [[NSString alloc] initWithData:[GTMBase64 decodeData:[[messageItem objectForKey:@"text"] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
                chatMsg.timeStamp = [messageItem objectForKey:@"time"];
                chatMsg.circleThemeId = [messageItem objectForKey:@"topicID"];
                if (((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers.count == 2) {
                    UIViewController *viewController = [((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:1];
                    if ([viewController isKindOfClass:[ChatViewController class]]) {
                        ChatViewController *chatController = (ChatViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:1];
                        if ([chatController.circleThemeID isEqualToString:chatMsg.circleThemeId]) {
                            NSLog(@"在聊天界面中");
                            [self performSelectorOnMainThread:@selector(updateChatListNewMsgViewWithMsg:) withObject:chatMsg waitUntilDone:YES];
                        }else {
                            //在当聊天界面，但收到的不是当前主题的消息
                            [self performSelectorOnMainThread:@selector(updateTabbarNewMsgView) withObject:nil waitUntilDone:YES];
                            [self performSelectorOnMainThread:@selector(updateTopicCellNewMsgView:) withObject:chatMsg waitUntilDone:YES];
                        }
                    }else {
                        // 不在聊天界面
                        [self performSelectorOnMainThread:@selector(updateTabbarNewMsgView) withObject:nil waitUntilDone:YES];
                        [self performSelectorOnMainThread:@selector(updateTopicCellNewMsgView:) withObject:chatMsg waitUntilDone:YES];
                    }
                }else { // 需要在TabBar和相应主题Cell添加消息提醒（小红点）
                    [self performSelectorOnMainThread:@selector(updateTabbarNewMsgView) withObject:nil waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(updateTopicCellNewMsgView:) withObject:chatMsg waitUntilDone:YES];
                }
            }
            }
            if (data) {
                free(data);
                data = nil;
            }
        }
    }
            break;
        default:
            return false;
    }
    
    return true;
    
}

#pragma mark - Update UI -

- (void)updateChatListNewMsgViewWithMsg:(ChatMessageInfo *)chatMsg
{
    ChatViewController *chatController = (ChatViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:1];
    [chatController updateChatlIistWithMsg:chatMsg];
}

- (void)updateTabbarNewMsgView
{
//    UIButton *msgButton = [SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:3];
//    NewMessagePromptView *newMsgView = [[NewMessagePromptView alloc] initWithFrame:CGRectMake(msgButton.frame.size.width-10-5, 5, 10, 10)];
//    [msgButton addSubview:newMsgView];
    [SharedApp updateTabbarNewMsg];
}

- (void)updateTopicCellNewMsgView:(ChatMessageInfo *)chatMsg
{
    CircleListViewController *list = (CircleListViewController *)[((UINavigationController *)((AbTabBarItem *)[SharedApp.mainTabBarViewController.tabBarItems objectAtIndex:2]).viewController).viewControllers objectAtIndex:0];
    [list updateTopicListWithMsg:chatMsg];
}

@end
