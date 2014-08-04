//
//  UserGuidViewController.m
//  UserGuid
//
//  Created by Durban on 14-1-3.
//  Copyright (c) 2014年 WalkerFree. All rights reserved.
//

#import "StartPageViewController.h"
#import "SXLoginViewController.h"
@interface StartPageViewController ()
@property (nonatomic) NSInteger canPresent;
@end
@implementation StartPageViewController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSString *img1 = [[NSBundle mainBundle] pathForResource:@"start_1"
                                                     ofType:@"jpg"];
    NSString *img2 = [[NSBundle mainBundle] pathForResource:@"start_2"
                                                     ofType:@"jpg"];
    NSString *img3 = [[NSBundle mainBundle] pathForResource:@"start_3"
                                                     ofType:@"jpg"];
    self.photoList = [[NSMutableArray alloc] initWithObjects:
                  [UIImage imageWithContentsOfFile:img1],
                  [UIImage imageWithContentsOfFile:img2],
                 [UIImage imageWithContentsOfFile:img3],
                      [self getEmptyUIImage],
			  nil];
    NSString *img11 = [[NSBundle mainBundle] pathForResource:@"start_11"
                                                     ofType:@"jpg"];
    NSString *img22 = [[NSBundle mainBundle] pathForResource:@"start_22"
                                                     ofType:@"jpg"];
    NSString *img33 = [[NSBundle mainBundle] pathForResource:@"start_33"
                                                     ofType:@"jpg"];
    self.photoList2 = [[NSMutableArray alloc] initWithObjects:
                      [UIImage imageWithContentsOfFile:img11],
                      [UIImage imageWithContentsOfFile:img22],
                      [UIImage imageWithContentsOfFile:img33],
                      [self getEmptyUIImage],
                      nil];
    self.pageScroll.delegate = self;
    if (iPhone5Srceen) {
           [self addImgs:self.photoList toScrollView:self.pageScroll];
    }else {
            [self addImgs:self.photoList2 toScrollView:self.pageScroll];
    }
}

	//将图片添加到一个UIScrollView
-(void)addImgs:(NSMutableArray *)imgs toScrollView:(UIScrollView *)scorllView
{
    CGRect rect = CGRectZero;
    CGRect scrollViewRect = CGRectZero;
    for (UIImage *img in imgs) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        if (iPhone5Srceen) {
                 rect.size  = CGSizeMake(320, 568);
        }else {
            if (IOS_VERSION >= 7.0) {
                 rect.size  = CGSizeMake(320, 480);
            }else{
              rect.size  = CGSizeMake(320, 460);
            }
        }
        imgView.frame = rect;
        rect.origin.x += imgView.frame.size.width;
        scrollViewRect.size.width += imgView.frame.size.width;
        scrollViewRect.size.height = imgView.frame.size.height;
        [scorllView addSubview:imgView];
    }
    scorllView.contentSize = scrollViewRect.size;
}

-(void) viewWillAppear:(BOOL)animated
{
    CGSize pageScrollViewSize = self.pageScroll.frame.size;
    self.pageScroll.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, pageScrollViewSize.height);
    if (iPhone5Srceen) {
        self.pageScroll.frame = CGRectMake(0, 0, 320, 568);
    }else {
        self.pageScroll.frame =  CGRectMake(0, 0, 320, 480);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _pageScroll.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_pageScroll.contentOffset.x + pageWidth/2)/pageWidth) ;
    //这里可以判断是否跳转到主页
   
    if (page >= 3)
    {
        //点击登陆按钮后切换到storyboard界面
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboardIOS7Iphone5" bundle:nil];
//        [self presentViewController:[storyboard instantiateInitialViewController]
//                           animated:YES
//                         completion:nil];
        if (!self.canPresent) {
            self.canPresent = YES;
            SXLoginViewController *lvc = [[SXLoginViewController alloc] init];
            [self presentViewController:lvc animated:YES completion:nil];
        }
    }
}

-(UIImage *)getEmptyUIImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_pageScroll.frame.size.width,
                                                      _pageScroll.frame.size.height), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}
@end
