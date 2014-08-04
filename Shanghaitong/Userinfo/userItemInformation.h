//
//  userItemInformation.h
//  jushang
//
//  Created by Enger_sky on 14-3-10.
//  Copyright (c) 2014年 anita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userItemInformation : NSObject
{
     NSString *userID;
     NSString *username;
     NSMutableArray *area;
     NSString *duty;
     NSString *company;
     NSMutableArray *avatar_url;
     NSString *trust_num;
     NSString *trusted_num;
     NSString *token;
     NSString *level;
     NSString *score;
     NSString *gold;
}

@property(nonatomic,retain)NSMutableArray *avatar_url;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *level;
@property(nonatomic,retain)NSArray *area;
@property(nonatomic,retain)NSString *token;
@property(nonatomic,retain)NSString *duty;
@property(nonatomic,retain)NSString *company;
@property(nonatomic,retain)NSString *trusted_num;
@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *trust_num;
@property(nonatomic,retain)NSString *score;
@property(nonatomic,retain)NSString *gold;
//@property (nonatomic, retain)   UIImage     *userImage;
@property (nonatomic,assign) BOOL protocol;

@end
