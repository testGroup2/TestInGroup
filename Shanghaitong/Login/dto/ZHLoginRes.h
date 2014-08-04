//
//  ZHLoginRes.h
//  ZHIsland
//
//  Created by arthur on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDto.h"

@class ZHUser;

@interface ZHLoginRes : ZHDto

@property (nonatomic, retain) NSString *token;

@end
