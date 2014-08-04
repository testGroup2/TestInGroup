//
//  ZHHttpTaskDelegate.h
//  ZHIsland
//
//  Created by arthuryan on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZHHttpBaseTask;

@protocol ZHHttpTaskDelegate <NSObject>

@optional

#pragma mark request process event

- (void)onStart:(ZHHttpBaseTask *)task;

- (void)onFinish:(ZHHttpBaseTask *)task;

- (void)onProgress:(float)newProgress fromRequest:(ZHHttpBaseTask *)task;


#pragma mark upload&download

// Called when the request receives some data - bytes is the length of that data
- (void)didReceiveBytes:(long long)bytes fromRequest:(ZHHttpBaseTask *)task;

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)didSendBytes:(long long)bytes fromRequest:(ZHHttpBaseTask *)task;

// Called when a request needs to change the length of the content to download
- (void)incrementDownloadSizeBy:(long long)newLength fromRequest:(ZHHttpBaseTask *)task;

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)incrementUploadSizeBy:(long long)newLength fromRequest:(ZHHttpBaseTask *)task;

#pragma mark deal request

@required
- (void)onSuccess:(id) content fromRequest:(ZHHttpBaseTask *)task;

// error maybe ZHError for service error or NSError for http error
- (void)onFailed:(NSError*)error fromRequest:(ZHHttpBaseTask *)task;

@end
