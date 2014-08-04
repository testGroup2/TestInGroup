//
//  SocketConnect.h
//  Shanghaitong
//
//  Created by Steve Wang on 14-6-25.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#ifndef __Shanghaitong__SocketConnect__
#define __Shanghaitong__SocketConnect__

#include <iostream>

class SocketConnect
{
public:
    SocketConnect();
    ~SocketConnect();
    
    int sSocket();
    bool sConnect(int fd, const char *host, uint16_t port, bool nonblock);
    void sClose(int fd);
private:
    char *getIpFromHostName(const char *host);
    int sRecv(int fd, void *buff, int len);
    int sSend(int fd, void *buff, int len);
};

#endif /* defined(__Shanghaitong__SocketConnect__) */
