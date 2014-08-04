//
//  ZHDto.m
//  ZHIsland
//
//  Created by hu jianping on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHDto.h"
#import "JSONKit.h"

NSString *const ZHDtoTypeString = @"NSString";
NSString *const ZHDtoTypeNumber = @"NSNumber";

@interface ZHDto()

- (id)init;

@end

@implementation ZHDto

- (id)init
{
    return [super init];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if (self) {
        [self setDataWithDictionary:dictionary];
    }
    
    return self;
}

- (void)setDataWithDictionary:(NSDictionary *)dictionary
{
    [[self.class attributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [dictionary objectForKey:key];
        if (value != nil && ![value isKindOfClass:[NSNull class]]) {
            if ([obj isEqualToString:ZHDtoTypeString]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    value = [value stringValue];
                }
            } else if ([obj isEqualToString:ZHDtoTypeNumber]) {
                if ([value isKindOfClass:[NSString class]]) {
                    value = [NSNumber numberWithLongLong:[value longLongValue]];
                }
            } else if ([NSClassFromString(obj) isSubclassOfClass:ZHDto.class]) {
                if ([value isKindOfClass:[NSDictionary class]] && [value count]) {
                    value = [[[NSClassFromString(obj) alloc] initWithDictionary:value] autorelease];
                } else {
                    value = nil;
                }
            }
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }];
    
    [[self.class arrayAttributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [dictionary objectForKey:key];
        if ([value isKindOfClass:[NSArray class]] && [value count] > 0) {
            NSArray *rowArray = value;
            NSMutableArray *arrayValue = [NSMutableArray arrayWithCapacity:[value count]];
            if ([obj isEqualToString:ZHDtoTypeString]) {
                
                [rowArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        [arrayValue addObject:[obj stringValue]];
                    } else {
                        [arrayValue addObject:obj];
                    }
                }];
                
            } else if ([obj isEqualToString:ZHDtoTypeNumber]) {
                
                [rowArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [arrayValue addObject:[NSNumber numberWithLongLong:[obj longLongValue]]];
                    } else {
                        [arrayValue addObject:obj];
                    }
                }];
                
            } else if ([NSClassFromString(obj) isSubclassOfClass:ZHDto.class]) {//DTO:
                [rowArray enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop) {
                    if ([obj2 isKindOfClass:[NSDictionary class]]) {
                        NSObject *tmp = [[[NSClassFromString(obj) alloc] initWithDictionary:obj2] autorelease];
                        if (tmp) {
                            [arrayValue addObject:tmp];
                        }
                    }
                }];
            } else if ([[rowArray lastObject] isKindOfClass:NSClassFromString(obj)]) {
                [rowArray enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop) {
                    [arrayValue  addObject:obj2];
                }];
            }
            
            [self setValue:arrayValue forKey:key];
        }
    }];
    
}

- (void)setDataWithCoder:(NSCoder *)aDecoder
{
    [[self.class attributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSValue *value = [aDecoder decodeObjectForKey:key];
        if (value) {
            [self setValue:value forKey:key];
        }
    }];
    
    [[self.class arrayAttributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSValue *value = [aDecoder decodeObjectForKey:key];
        if (value) {
            [self setValue:value forKey:key];
        }
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        [self setDataWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [[self.class attributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSValue *value = [self valueForKey:key];
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }];
    
    [[self.class arrayAttributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSValue *value = [self valueForKey:key];
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }];
}

- (NSString *)jsonString
{
    return [self.dictionaryValue JSONString];
}

- (NSDictionary *)dictionaryValue
{
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [[self.class attributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSObject *value = [self valueForKey:key];
        if (value) {
            if ([value isKindOfClass:[ZHDto class]]) {
                [dict setObject:[(ZHDto *)value dictionaryValue] forKey:key];
            } else {
                [dict setObject:value forKey:key];
            }
        }
        
        [[self.class arrayAttributes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSArray *value = [self valueForKey:key];
            if (value.count > 0) {
                if ([value.lastObject isKindOfClass:[ZHDto class]]) {
                    NSMutableArray *dtoItems = [NSMutableArray arrayWithCapacity:value.count];
                    for (ZHDto *dto in value) {
                        [dtoItems addObject:[dto dictionaryValue]];
                    }
                    [dict setObject:dtoItems forKey:key];
                } else {
                    [dict setObject:value forKey:key];
                }
            }
        }];
    }];
    
    return dict;
}

+ (NSDictionary *)attributes
{
    return nil;
}

+ (NSDictionary *)arrayAttributes
{
    return nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
