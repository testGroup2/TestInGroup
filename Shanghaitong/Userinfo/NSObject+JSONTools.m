//
//  NSObject+JSONTools.m
//  商海通
//
//  Created by LivH on 14-3-29.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import "NSObject+JSONTools.h"

@implementation NSObject (JSONTools)

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    //fprintf(stdout, "%s", attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if(attribute[1] == '@') {
                return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
            } else {
                return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
            }
        }
    }
    return "@";
}

-(id) initWithDict:(id) dict {
    if (self) {
        if (!dict)
            return self;
        unsigned int propCount, i;
        objc_property_t* properties = class_copyPropertyList([self class], &propCount);
        for (i = 0; i < propCount; i++) {
            objc_property_t prop = properties;
            const char *propName = property_getName(prop);
            if(propName) {
                const char *propType = getPropertyType(prop);
                NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
                NSString *type = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
                id obj = [dict objectForKey:name];
                if (!obj)
                    continue;
                if ([type isEqualToString:@"i"] || [type isEqualToString:@"l"] || [type isEqualToString:@"s"]) {
                    [self setValue:[NSNumber numberWithInteger:[obj integerValue]] forKey:name];
                } else if ([type isEqualToString:@"I"] || [type isEqualToString:@"L"] || [type isEqualToString:@"S"]) {
                    [self setValue:[NSNumber numberWithLongLong:[obj longLongValue]] forKey:name];
                } else if ([type isEqualToString:@"f"] || [type isEqualToString:@"d"]) {
                    [self setValue:[NSNumber numberWithDouble:[obj doubleValue]] forKey:name];
                } else if ([type isEqualToString:@"NSString"]) {
                    [self setValue:[NSString stringWithFormat:@"%@", obj] forKey:name];
                } else if ([type isEqualToString:@"c"]) {
                    [self setValue:[NSNumber numberWithChar:[obj charValue]] forKey:name];
                } else {
                    [self setValue:obj forKey:name];
                }        
            }
        }
        free(properties);
        
    }
    return self;
}

@end
