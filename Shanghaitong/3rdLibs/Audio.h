//
//  Audio.h
//  Shanghaitong
//
//  Created by xuqiang on 14-6-4.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface Audio : NSObject
+(instancetype)shareAudio;
- (void)playAudio;
@end
