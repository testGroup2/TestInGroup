//
//  ZHTaskManager.h
//  ZHIsland
//
//  Created by arthuryan on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHHttpBaseTask.h"
#import "SynthesizeSingleton.h"

@interface ZHTaskManager : NSObject {
    NSMutableArray *tasks;
}

- (void)addTask:(ZHHttpBaseTask *)task;

#pragma mark forUI

- (void)cancelTaskWithDelegate:(id)delegate;
- (void)cancelTaskWithRequestId:(NSInteger)rid;
- (void)cancelPostBackWithDelegate:(id)delegate;
- (void)cancelPostBackWithRequestId:(NSInteger)rid;
- (void)cancelTask:(ZHHttpBaseTask*)task;
- (void)cancelAllTaskPostBack;

#pragma mark for Task response

- (void)taskFinished:(ZHHttpBaseTask *)task;
- (void)taskFailed:(ZHHttpBaseTask *)task;


SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ZHTaskManager);

@end


