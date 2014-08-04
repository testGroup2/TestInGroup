//
//  Audio.m
//  Shanghaitong
//
//  Created by xuqiang on 14-6-4.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "Audio.h"

@implementation Audio
static Audio *audio = nil;
+(instancetype)shareAudio{
    @synchronized(self){
        if (audio == nil) {
            audio = [[self alloc]init];
        }
        return audio;
    }
}
- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)playAudio{
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],@"/sms-received1.caf"];
    SystemSoundID soundID = 1007;
    NSURL *filePath = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
