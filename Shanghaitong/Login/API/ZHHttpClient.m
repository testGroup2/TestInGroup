#import "ZHHttpClient.h"

@implementation ZHHttpClient

- (id)init {
	if (self = [super init]) {
        netQueue_ = [[ASINetworkQueue queue] retain];
        [netQueue_ setShouldCancelAllRequestsOnFailure:NO];
        [netQueue_ setMaxConcurrentOperationCount:4];
        [netQueue_ go];
	}
	return self;
}

- (void)dealloc {
    if (netQueue_ != nil) {
        [netQueue_ reset];
        [netQueue_ release];
        netQueue_ = nil;
    }
    
	[super dealloc];
}

- (void)addTask:(ZHHttpBaseTask*) task 
{
    
    [[ZHTaskManager sharedInstance] addTask:task];
    [task execute];

    [netQueue_ addOperation:[task httpRequest]];
}


@end
