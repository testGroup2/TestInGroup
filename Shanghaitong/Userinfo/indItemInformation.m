//
//  IndItemInformation.m
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "indItemInformation.h"

@implementation indItemInformation
//@synthesize indID = _indID;
//@synthesize name = _name;
//-(indItemInformation *)init
//{
//    if(self = [super init])
//    {
//        _name = [[NSString alloc]init];
//        _indID = [[NSString alloc] init];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.indID = [aDecoder decodeObjectForKey:@"indID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.indID forKey:@"indID"];
}

@end
