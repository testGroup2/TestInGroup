//
//  CircleDetailInfo.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-2.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleDetailInfo : NSObject
@property (nonatomic,strong) NSString *circleDetailId;
@property (nonatomic,strong) NSString *circleTitle;
@property (nonatomic,strong) NSString *circleLeaderName;
@property (nonatomic,strong) NSString *circleUpdateTime;
@property (nonatomic,strong) NSString *circleNotice;
@property (nonatomic,strong) NSMutableArray *circleSmallImageArray;
@property (nonatomic,strong) NSMutableArray *circleImageArray;
@end
