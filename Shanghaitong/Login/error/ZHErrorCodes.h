//
//  ZHErrorCodes.h
//  ZHIsland
//
//  Created by arthuryan on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef ZHIsland_ZHErrorCodes_h
#define ZHIsland_ZHErrorCodes_h

enum ZHErrorStatusCode {
    ZHStatusCodeSuccess = 0,
    ZHStatusCodeServiceException = 1001,        //服务端异常
    ZHStatusCodeDeviceUnactivated = 2001,       //设备未激活
    ZHStatusCodeInvalidToken = 2101,            //无效访问标识
    ZHStatusCodeCommonInputProtocolError = 3001, //公共输入协议错误
    ZHStatusCodeAPIInputProtocolError = 3002,    //接口输入协议错误
    ZHStatusCodeOperationFailed = 4001,          //操作失败
};

enum ZHErrorWarningCode {
    ZHWarningCodeSuccess = 0,
};
#endif
