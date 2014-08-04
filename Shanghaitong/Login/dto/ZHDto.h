//
//  ZHDto.h
//  ZHIsland
//
//  Created by hu jianping on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHDto : NSObject <NSCoding>

+ (NSDictionary *)attributes;
+ (NSDictionary *)arrayAttributes;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)setDataWithDictionary:(NSDictionary *)dictionary;
- (void)setDataWithCoder:(NSCoder *)aDecoder;

- (NSString *)jsonString;
- (NSDictionary *)dictionaryValue;

@end

NSString *const ZHDtoTypeString;
NSString *const ZHDtoTypeNumber;
