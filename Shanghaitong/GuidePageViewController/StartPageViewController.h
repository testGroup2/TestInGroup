//
//  UserGuidViewController.h
//  UserGuid
//
//  Created by Durban on 14-1-3.
//  Copyright (c) 2014年 WalkerFree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartPageViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (strong, nonatomic) NSMutableArray *photoList;
@property (strong, nonatomic) NSMutableArray *photoList2;
@end
