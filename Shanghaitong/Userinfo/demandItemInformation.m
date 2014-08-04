//
//  demandItemInformation.m
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "demandItemInformation.h"

@implementation demandItemInformation
//@synthesize demandID=_demandID;
//@synthesize des=_des;

//-(demandItemInformation *)init
//{
//    if(self = [super init])
//    {
//        _des=[[NSString alloc] init];
//        _demandID=[[NSString alloc]init];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.des = [aDecoder decodeObjectForKey:@"des"];
        self.demandID = [aDecoder decodeObjectForKey:@"demandID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.des forKey:@"des"];
    [aCoder encodeObject:self.demandID forKey:@"demandID"];
}

@end
