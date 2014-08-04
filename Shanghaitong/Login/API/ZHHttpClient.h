#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ZHHttpBaseTask.h"
#import "ZHTaskManager.h"

#define TIMEOUT_SEC		20.0

@interface ZHHttpClient : NSObject {
    ASINetworkQueue* netQueue_;
}

- (void)addTask:(ZHHttpBaseTask*) task;

@end
