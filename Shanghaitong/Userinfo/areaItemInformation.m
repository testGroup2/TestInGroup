//
//  areaItemInformation.m
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import "areaItemInformation.h"

@implementation areaItemInformation

//-(areaItemInformation *)init
//{
//    if(self = [super init])
//    {
//        _title = [[NSString alloc]init];
//        _area_id=[[NSString alloc]init];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.area_id = [aDecoder decodeObjectForKey:@"areaID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.area_id forKey:@"areaID"];
}

@end
