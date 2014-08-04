//
//  ZHAlertView.m
//  ZHIsland
//
//  Created by Qi XiaoLong on 11-11-9.
//  Copyright (c) 2011年 ZHIsland.com. All rights reserved.
//

#import "ZHAlertView.h"

#define MAX_CONTENT_WIDTH    200.0f
#define TOP_MARGINE          10.0f

#define SUCCESS_TOP_MARGINE             40.0f
#define SUCCESS_LABEL_IMAGE_MARGINE     20.0f
#define SUCCESS_BOTTOM_MARGINE          40.0f
#define SUCCESS_MIN_WIDTH               175.0f

@interface ZHAlertView ()

- (void)updateContent:(NSString *)newContent;

@end

@implementation ZHAlertView

@synthesize delegate = _delegate;
@synthesize content = _content;
@synthesize yOffset = _yOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.opaque = NO;
        _backgroundView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f].CGColor;

        _backgroundView.layer.cornerRadius = 8.0f;
        _backgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _backgroundView.layer.shadowOffset = CGSizeMake(2.0, 2.0f);
                _backgroundView.layer.shadowOpacity = 0.7f;
                _backgroundView.layer.shadowRadius = 2.0f;
        _backgroundView.layer.borderWidth = 1.0f;
        
        [self addSubview:_backgroundView];
        [_backgroundView release];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.opaque = NO;
        _contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _contentLabel.adjustsFontSizeToFitWidth = NO;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor whiteColor];
        
        [_backgroundView addSubview:_contentLabel];
        [_contentLabel release];
        
        _alertImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _alertImage.image = [UIImage imageNamed:@"prompt_alert"];
        
        [_backgroundView addSubview:_alertImage];
        [_alertImage release];
    }
    
    return self;
}

- (id)initWithView:(UIView *)view delegate:(id<ZHAlertViewDelegate>)delegate
{
    if (!view) {
        
		[NSException raise:@"ZHAlertViewIsNilException"
					format:@"The view used in the ZHAlertView initializer is nil."];
	}
    
    _delegate = delegate;
    
	id me = [self initWithFrame:view.bounds];
    
	return me;
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
}

- (void)setYOffset:(CGFloat)yOffset
{
    _yOffset = yOffset;
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)newContent
{
    if ([NSThread isMainThread]) {
        
		[self updateContent:newContent];
		[self setNeedsLayout];
        
	} else {
        
		[self performSelectorOnMainThread:@selector(updateContent:)
                               withObject:newContent
                            waitUntilDone:NO];
        
		[self performSelectorOnMainThread:@selector(setNeedsLayout)
                               withObject:nil
                            waitUntilDone:NO];
	}
}

- (void)updateContent:(NSString *)newContent
{
    if (_content != newContent) {
        
        [_content release];
        _content = [newContent copy];
    }
}

- (void)layoutSubviews
{
    if (!self.content) {
        
        return;
    }
    
    CGSize size = self.bounds.size;
    
    _contentLabel.frame = CGRectMake(0, 0, MAX_CONTENT_WIDTH, 20.0f);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = self.content;
    [_contentLabel sizeToFit];
    
    CGSize contentSize = _contentLabel.frame.size;
    
    CGFloat imgWidth = _alertImage.image.size.width;
    CGFloat imgHeight = _alertImage.image.size.height;
    
    //    if(_type == ZHAlertViewTypeSuccess) {
    //        float width = MAX(contentSize.width, imgWidth) + 40.0f;
    //        width = MAX(SUCCESS_MIN_WIDTH, width);
    //
    //        float height = contentSize.height + imgHeight + SUCCESS_TOP_MARGINE + SUCCESS_BOTTOM_MARGINE + SUCCESS_LABEL_IMAGE_MARGINE;
    //
    //        _backgroundView.frame = CGRectMake((size.width - width) / 2,  (size.height - height) / 3 + self.yOffset, width, height);
    //         _alertImage.frame = CGRectMake((width - imgWidth) / 2, SUCCESS_TOP_MARGINE, imgWidth, imgHeight);
    //        _contentLabel.frame = CGRectMake((width - contentSize.width) / 2, SUCCESS_LABEL_IMAGE_MARGINE + SUCCESS_TOP_MARGINE + imgHeight, contentSize.width, contentSize.height);
    //
    //    }else {
    float width = MAX(contentSize.width, imgWidth) + 40.0f;
    float height = contentSize.height + TOP_MARGINE * 3 + imgHeight;
    
    _backgroundView.frame = CGRectMake((size.width - width) / 2,  (size.height - height) / 3 + self.yOffset, width, height);
    _alertImage.frame = CGRectMake((width - imgWidth) / 2, TOP_MARGINE, imgWidth, imgHeight);
    _contentLabel.frame = CGRectMake((width - contentSize.width) / 2, TOP_MARGINE*2 + imgHeight, contentSize.width, contentSize.height);
    //    }
}

- (void)show:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (self.content.length > 20) {
        [self performSelector:@selector(hide:)
                   withObject:[NSNumber numberWithBool:YES]
                   afterDelay:3.0f];
    } else {
        [self performSelector:@selector(hide:)
                   withObject:[NSNumber numberWithBool:YES]
                   afterDelay:2.0f];
    }
    
    self.userInteractionEnabled = YES;
    
    if (!animated) {
        
        self.alpha = 1.0f;
        
        return;
    }
    
    [UIView beginAnimations:@"ZHAlertViewShow" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    self.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)show:(NSString *)content animated:(BOOL)animated
{
    [self show:content animated:animated type:ZHAlertViewTypeNote];
}

- (void)show:(NSString *)content animated:(BOOL)animated type:(ZHAlertViewType)type
{
    self.content = content;
    
    if(_type != type) {
        _type = type;
        switch (_type) {
            case ZHAlertViewTypeNote:
            {
                _alertImage.image = [UIImage imageNamed:@"prompt_alert"];
                _contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            }
                break;
            case ZHAlertViewTypeSuccess:
            {
                _alertImage.image = [UIImage imageNamed:@"alert_success_icon"];
                _contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            }
                break;
            default:
                break;
        }
        [self setNeedsLayout];
    }
    
    [self show:animated];
}

- (void)hide:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.userInteractionEnabled = NO;
    
    if (!animated) {
        
        self.alpha = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewHidden:)]) {
            
            [self.delegate alertViewHidden:self];
        }
        
        return;
    }
    
    [UIView beginAnimations:@"ZHAlertViewHide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:isfinished:)];
    
    self.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID isfinished:(NSNumber *)finished
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewHidden:)]) {
        [self.delegate alertViewHidden:self];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [_content release];
    
    [super dealloc];
}

@end
