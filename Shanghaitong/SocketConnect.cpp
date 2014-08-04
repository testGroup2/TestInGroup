//
//  SocketConnect.cpp
//  Shanghaitong
//
//  Created by Steve Wang on 14-6-25.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#include "SocketConnect.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/socket.h>

#include <netinet/in.h>
#include <netinet/tcp.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>
#include <unistd.h>

int SocketConnect::sSocket()
{
    return socket(AF_INET, SOCK_STREAM, 0); //IP4
}

bool SocketConnect::sConnect(int fd, const char *host, uint16_t port, bool nonblock)
{
    char *ip = this->getIpFromHostName(host);
    struct sockaddr_in sAddr;
    memset(&sAddr, 0x00, sizeof(struct sockaddr_in));
    sAddr.sin_family = AF_INET;
    sAddr.sin_addr.s_addr = inet_addr(ip);
    sAddr.sin_port = htons(port);
    
    int ret = connect(fd, (struct sockaddr *)&sAddr, sizeof(struct sockaddr));
    if (ret < 0) {
        return false;
    }
    
    int flags = fcntl(fd, F_GETFL, 0);
    if (nonblock) {
        fcntl(fd, F_SETFL, flags | O_NONBLOCK);
    }
    
    return true;
}

void SocketConnect::sClose(int fd)
{
    close(fd);
}

char *SocketConnect::getIpFromHostName(const char *host)
{
    struct hostent *hostEnt = gethostbyname(host);
    if (!hostEnt) {
        printf("%s,解析失败\n", host);
        return NULL;
    }
    char **pIP = hostEnt->h_addr_list;
    char *ip = NULL;
    for (; *pIP != NULL; pIP++) {
        ip = inet_ntoa(*(struct in_addr *)*pIP);
        if (ip) {
            break;
        }
    }
    if (!ip) {
        printf("%s,解析失败\n", host);
        return NULL;
    }
    
    return ip;
}

int SocketConnect::sRecv(int fd, void *buff, int len)
{
    int32_t readAll = 0;
    char *ptr = (char *)buff;
    while (1) {
        signal(SIGPIPE, SIG_IGN);
        int32_t t = recv(fd, ptr + readAll, len - readAll, 0);
        if (t < 0) {
            if (errno == EINTR || errno == EAGAIN) {
                continue;
            }else {
                readAll = 0;
                break;
            }
        }
        readAll += t;
        if (readAll == len) {
            break;
        }
    }
    
    int32_t rLen = strlen(ptr);
    if (rLen > len) {
        ptr[len] = 0;
    }
    
    return readAll;
}

int SocketConnect::sSend(int fd, void *buff, int len)
{
    int32_t  writeall = 0;
    char *ptr = (char*)buff;
    while(1)
    {
        signal(SIGPIPE,SIG_IGN);
        int32_t n = send(fd, ptr + writeall, len - writeall, 0);
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
