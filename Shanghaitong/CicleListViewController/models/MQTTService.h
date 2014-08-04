//
//  MQTTService.h
//  Shanghaitong
//
//  Created by xuqiang on 14-6-17.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MQTTKit.h"
@interface MQTTService : NSObject
@property (nonatomic, strong) MQTTClient *client;

+ (instancetype)shareServiceWithToken:(NSString *)token;
-(void)stopService;
-(void)startService:(BOOL)subcirce;
-(void)reciveData;
@end
