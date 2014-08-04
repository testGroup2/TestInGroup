//
//  CircleDatabase.h
//  Shanghaitong
//
//  Created by xuqiang on 14-5-8.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
typedef NS_ENUM(NSInteger, SHTOpraterState) {
    SHTOpraterStateInsert,
    SHTOpraterStateUpdate
};
@class CircleAbstractInfo;
@class CircleDetailInfo;
@class MemberInfo;
@class ChatMessageInfo;
@class userItemInformation;
#define  DATABASE [CircleDatabase shareDatabase]
@interface CircleDatabase : NSObject
{
    FMDatabase *_circleDB;
}
@property (nonatomic,readonly) NSString *uid;
@property (nonatomic,strong) FMDatabase *circleDB;
+(instancetype)shareDatabase;
- (BOOL)creatCircleThemeTable;
- (void)closeDatabase;
- (void)openDatabase;
- (void)removeAllTables;
//圈子主题表
- (BOOL)insertCircleThemeWithThemeInfo:(NSMutableArray *)infoArray;
- (BOOL)insertCircleThemeWithTheme:(CircleAbstractInfo *)info;
- (NSMutableArray *)fetchCircleTheme;
- (BOOL)deleteCircleThemeListWithThemeId:(NSString *)themeId;
- (NSMutableArray *)fetchCircleThemeWith:(NSString *)themeId;
- (BOOL)updateCircleThemeListWithThemeId:(CircleAbstractInfo *)info;
- (NSInteger)fetchNotReadMessage;
- (NSInteger)fetchNotReadMessageIsNull;
- (BOOL)updateCircleThemeListWithCircleId:(NSString *)circleId circleName:(NSString *)circleName;
- (BOOL)deleteCircleThemeListWithCircleId:(NSString *)circleId;
- (BOOL)deleteCircleThemeListAllObjWithCircleId:(NSString *)circleId;
- (NSArray *)fetchCircleThemeListWithThemeId:(NSString *)themeId ;
- (BOOL)updateCircleThemeRedPointIsRead:(NSString *)isRead themeId:(NSString *)themeId;
- (BOOL)updateCircleThemeListNoTimeWithThemeId:(CircleAbstractInfo *)info;
- (BOOL)updateCircleThemeListHaveNotReadWithAbstact:(CircleAbstractInfo *)info;
//圈子详情表
- (BOOL)insertCircleDetailWithInfo:(CircleDetailInfo *)info;
- (NSMutableArray *)fetchThemeDetailWithCircleDetailId:(NSString *)circleDetailId;
- (BOOL)fetchThemeDetailCountWithCircleDetailId:(NSString *)circleDetailId;
- (void)deleteThemeList;
- (BOOL)updateThemeDetailWIthCircleDetailId:(CircleDetailInfo *)info;
//圈子成员
- (BOOL)insertMemberListWithMemberInfo:(MemberInfo *)info andCircleId:(NSString *)circleId;
- (NSMutableArray *)fetchMemberListWithCircleId:(NSString *)circleDetailId;
- (void)deleteMemberListWithCircleId:(NSString *)circleId;
- (BOOL)updateMemberListWithMemberInfo:(MemberInfo *)info;
- (BOOL)fetchMemberListWithMemberId:(NSString *)memberId;
//圈子主题聊天消息记录列表
- (BOOL)createChatRecords;
- (BOOL)insertChatRecordsWithChatInfoArray:(NSMutableArray *)infoArray;
- (NSMutableArray *)fetchChatRecordsListWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId withIndex:(NSInteger)index andAmount:(NSInteger)amount;
- (BOOL)deleteChatRecordsWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId;
- (BOOL)updateChatRecordsWithUserId:(NSString *)uId newUrl:(NSString *)newUrl;
- (BOOL)updateChatRecordsWithChatMsg:(ChatMessageInfo *)info;
- (BOOL)deleteChatRecordsWithTimeStamp:(NSString *)timeStamp;
- (NSMutableArray *)fetchChatRecordsListWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId withId:(NSInteger)aId;
- (NSInteger)fetchLastRecordIdWitThemeId:(NSString *)themeId;
- (NSInteger)fetchLastRecordIdDescWitThemeId:(NSString *)themeId;
- (BOOL)fetchChatRecordsWithMsg:(ChatMessageInfo *)msg timeStamp:(const NSString *)timestamp;
- (MemberInfo *)fetchUserNameWithUserId:(NSString *)uid;
//使用用户信息
- (BOOL)insertUserInfo:(userItemInformation *)userInfo;
- (NSMutableArray *)fetchUserList;
- (BOOL)deleteCurrentUserInfo;
//聊天的用户信息
- (BOOL)createChatUserList:(MemberInfo *)member;
- (BOOL)insertChatUserList:(MemberInfo *)info;
- (MemberInfo *)fetchChatUserListWithMemberId:(NSString *)memberId;
- (BOOL)updateChatUserListWithMember:(MemberInfo *)info;

@end
