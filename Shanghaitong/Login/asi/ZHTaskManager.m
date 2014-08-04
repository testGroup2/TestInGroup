//
//  ZHTaskManager.m
//  ZHIsland
//
//  Created by arthuryan on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZHTaskManager.h"

@interface ZHTaskManager()

- (void)removeTask:(ZHHttpBaseTask *)task;
- (BOOL)containTask:(ZHHttpBaseTask *)task;

@end

@implementation ZHTaskManager


SYNTHESIZE_SINGLETON_FOR_CLASS(ZHTaskManager);

#pragma mark init and dealloc
- (id)init {
    if (self = [super init]) {
        tasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
	[tasks release];
	[super dealloc];
}

#pragma mark private

- (void)addTask:(ZHHttpBaseTask *)task {
    [tasks addObject:task];
}

- (void)removeTask:(ZHHttpBaseTask *)task
{
    if ([self containTask:task])
    {
        [tasks removeObject:task];
    }
}

- (BOOL)containTask:(ZHHttpBaseTask *)task {
    return [tasks containsObject:task];
}

#pragma mark for UI calls

- (void)cancelTaskWithDelegate:(id)delegate
{
    NSArray *tmpTasks = [[tasks copy] autorelease];
    
    for (ZHHttpBaseTask *task in tmpTasks) {
        if (task.delegate == delegate) {
            [task cancel];
            [self removeTask:task];
        }
    }
}

- (void)cancelTaskWithRequestId:(NSInteger)rid
{
    NSArray *tmpTasks = [[tasks copy] autorelease];
    
    for (ZHHttpBaseTask *task in tmpTasks) {
        if (task.requestId == rid) {
            [task cancel];
            [self removeTask:task];
        }
    }
}

- (void)cancelPostBackWithDelegate:(id)delegate
{
    NSArray *tmpTasks = [[tasks copy] autorelease];
    
    for (ZHHttpBaseTask *task in tmpTasks) {
        if (task.delegate == delegate) {
            [task cancelPostBack];
        }
    }
    
}
- (void)cancelPostBackWithRequestId:(NSInteger)rid
{
    NSArray *tmpTasks = [[tasks copy] autorelease];
    
    for (ZHHttpBaseTask *task in tmpTasks) {
        if (task.requestId == rid) {
            [task cancelPostBack];
        }
    }
}

- (void)cancelTask:(ZHHttpBaseTask*)task
{
    [task cancel];
    [self removeTask:task];
}

- (void)cancelAllTaskPostBack
{
    NSArray *tmpTasks = [[tasks copy] autorelease];
    
    for (ZHHttpBaseTask *task in tmpTasks) {
        [task cancelPostBack];
    }
}

#pragma mark for Task Responses

- (void)taskFinished:(ZHHttpBaseTask *)task
{
    [self removeTask:task];
}

- (void)taskFailed:(ZHHttpBaseTask *)task
{
    [self removeTask:task];
}


@end
