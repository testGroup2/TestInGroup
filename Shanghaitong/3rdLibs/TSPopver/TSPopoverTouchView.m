//
//  TSPopoverTouchView.m
//


#import "TSPopoverTouchView.h"

@implementation TSPopoverTouchView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate view:self touchesBegan:touches withEvent:event];
}

@end
