//
//  WebToolViewController.h
//  商海通
//
//  Created by Liv on 14-3-23.
//  Copyright (c) 2014年 LivH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SDURLCache.h"
#import "WXApi.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

typedef NS_ENUM(NSUInteger,SHTLoadWebPage){
    SHTLoadWebPagePro,
    SHTLoadWebPageHouse,
    SHTLoadWebPageWelfare,
    SHTLoadWebPageResource,
    SHTLoadWebPageMessage,
    SHTLoadWebPageMySelf
};
@interface WebViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,WXApiDelegate,PopupSmallViewDelegate>
{
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
    BOOL _isRefresh;

}

-(void)onReq:(BaseReq *)req;
-(void)onResp:(BaseResp *)resp;

@property (nonatomic,assign) SHTLoadWebPage pageType;

@property (nonatomic,strong) ASIDownloadCache *myCache;
@property (strong,nonatomic) NSString *urlstring;
@property (strong,nonatomic) UIWebView *webView;
@property (nonatomic,strong) NSString * customUserAgent;
@property (nonatomic,strong) SDURLCache * urlCache;
@property (nonatomic,strong) NSString * projectLeftUrl;
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)PopupSmallView *p;
+(WebViewController *) shareWebViewController;
-(id) initWithURLString : (NSString *) urlString andType:(SHTLoadWebPage)type;
-(NSURLRequest *) makeRequestWithURLString:(NSString *) urlString;
-(void) loadPage;

@end
