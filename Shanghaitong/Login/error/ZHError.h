//
//  ZHError.h
//  ZHIsland
//
//  Created by arthuryan on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHErrorCodes.h"

@interface ZHError : NSError {
    
}

@property (assign, readwrite, nonatomic) NSInteger warningCode;

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code warning:(NSInteger)warningCode  userInfo:(NSDictionary *)dict;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code warning:(NSInteger)warningCode userInfo:(NSDictionary *)dict;


@end
