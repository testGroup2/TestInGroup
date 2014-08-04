//
//  EGOViewCommon.h
//  TableViewRefresh
//
//  Created by  Abby Lin on 12-5-2.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TableViewRefresh_EGOViewCommon_h
#define TableViewRefresh_EGOViewCommon_h

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
//此为将上拉加载时的距离原来65
#define  REFRESH_REGION_HEIGHT 65
#define  AJUSTHEIGHT (65 - REFRESH_REGION_HEIGHT)

typedef enum{
	SHTOPullRefreshPulling = 0,
	SHTOPullRefreshNormal,
	SHTOPullRefreshLoading,
} SHTPullRefreshState;

typedef enum{
	EGORefreshHeader = 0,
	EGORefreshFooter	
} EGORefreshPos;

@protocol SHTRefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos;
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;
@end

#endif
