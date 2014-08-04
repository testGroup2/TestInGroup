//
//  CircleDatabase.m
//  Shanghaitong
//
//  Created by xuqiang on 14-5-8.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "CircleDatabase.h"
#import "CircleAbstractInfo.h"
#import "CircleDetailInfo.h"
#import "MemberInfo.h"
#import "ChatMessageInfo.h"
#import "userItemInformation.h"
#import "FMDatabaseQueue.h"
#define PATH [NSString stringWithFormat:@"%@/Documents/data.db",NSHomeDirectory()]
@implementation CircleDatabase
static CircleDatabase *database = nil;
+(instancetype)shareDatabase
{
    @synchronized(self) {
        if (database == nil) {
            database = [[self alloc] init];
        }
    }
    return database;
}
- (id)init{
    if (self = [super init]) {
        self.circleDB = [[FMDatabase alloc]initWithPath:PATH];
        NSLog(@"%@",PATH);
    }
    return self;
}
-(NSString *)uid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
}
- (void)openDatabase{
    [self.circleDB open];
}
- (void)closeDatabase{
    [self.circleDB close];
}
- (void)removeAllTables{
    [self.circleDB executeUpdate:@"drop table ThemeDetailTable"];
    [self.circleDB executeUpdate:@"drop table MemberListTable"];
}
#pragma mark - 圈子主题表
#define CIRCLE_THEME @"CircleThemeTable"
#define CIRCLE_ID @"circleId"
#define CIRCLE_THEMEID @"themeId"
#define TITLE @"title"
#define DETAIL @"detail"
#define COMEFROM @"comefrom"
#define IMAGE_URL @"imageUrl"
#define TIME @"time"
#define IS_READ @"isRead"
#define LAST_CHAT @"lastChat"
#define ADMINID @"adminId"
#define LASTCHATUSERNAME @"lastChatUsername"
#define USER_ID @"uid"

- (BOOL)creatCircleThemeTable
{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        return NO;
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"canRemoveTable"]) {
        NSLog(@"不存在");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gloable_uptime"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"canRemoveTable"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        NSLog(@"存在");
    }
    ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"create table if not exists CircleThemeTable(%@ VARCHAR(32),%@ VARCHAR(32),%@ VARCHAR(32) ,%@ text,%@ text,%@ VARCHAR(32),%@ text,%@ VARCHAR(32),%@ VARCHAR(32),%@ text,%@ VARCHAR(32),%@ VARCHAR(32))",USER_ID,CIRCLE_ID,CIRCLE_THEMEID,TITLE,DETAIL,COMEFROM,IMAGE_URL,TIME,IS_READ,LAST_CHAT,ADMINID,LASTCHATUSERNAME]];
    
    if (ret == NO) {
        //创建表失败
        NSLog(@"创建表失败");
        return NO;
    }
    NSLog(@"创建表成功");
    return YES;
}

//增入主题到主题列表中
- (BOOL)insertCircleThemeWithThemeInfo:(NSMutableArray *)infoArray{
    __block BOOL ret = NO;
    for (int i = 0; i < infoArray.count; i++) {
        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
        info = [infoArray objectAtIndex:i];
        ret = [self.circleDB executeUpdate:@"insert into CircleThemeTable values(?,?,?,?,?,?,?,?,?,?,?,?)",self.uid,info.circleID,info.circleDetailID,info.circleTopic,info.themeSimple,info.circleName,info.circleImage,info.date,info.isRead,info.lastChat,info.adminId,info.lastChatUserName];
    }
    if (ret == NO) {
        NSLog(@"插入数据失败");
        return NO;
    }
    NSLog(@"插入成功");
    return YES;
}

- (BOOL)insertCircleThemeWithTheme:(CircleAbstractInfo *)info{
    BOOL ret = [self.circleDB executeUpdate:@"insert into CircleThemeTable values(?,?,?,?,?,?,?,?,?,?,?,?)",self.uid,info.circleID,info.circleDetailID,info.circleTopic,info.themeSimple,info.circleName,info.circleImage,info.date,info.isRead,info.lastChat,info.adminId,info.lastChatUserName];
    if (ret == NO) {
        NSLog(@"插入数据失败");
        return NO;
    }
    NSLog(@"插入成功");
    return YES;
}

//查
- (NSMutableArray *)fetchCircleTheme{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    FMResultSet *set = [self.circleDB executeQuery:@"select * from CircleThemeTable where uid=? order by time desc ",self.uid];
    NSLog(@"%@",self.uid);
    while ([set next]) {
        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
        info.circleID = [set stringForColumn:CIRCLE_ID];
        info.circleDetailID = [set stringForColumn:CIRCLE_THEMEID];
        info.circleTopic = [set stringForColumn:TITLE];
        info.themeSimple = [set stringForColumn:DETAIL];
        info.circleName = [set stringForColumn:COMEFROM];
        info.circleImage = [set stringForColumn:IMAGE_URL];
        info.isRead = [set stringForColumn:IS_READ];
        info.lastChat = [set stringForColumn:LAST_CHAT];
        info.adminId = [set stringForColumn:ADMINID];
        info.lastChatUserName = [set stringForColumn:LASTCHATUSERNAME];
        [array addObject:info];
    }
    return array;
}

//查找某一主题对应的元素
- (NSMutableArray *)fetchCircleThemeWith:(NSString *)themeId{
    FMResultSet *set = [self.circleDB executeQuery:@"select * from CircleThemeTable where themeId=? and uid=?",themeId,self.uid];
    // order by time asc order by time desc
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([set next]) {
        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
        info.circleID = [set stringForColumn:CIRCLE_ID];
        info.circleDetailID = [set stringForColumn:CIRCLE_THEMEID];
        info.circleTopic = [set stringForColumn:TITLE];
        info.themeSimple = [set stringForColumn:DETAIL];
        info.circleName = [set stringForColumn:COMEFROM];
        info.circleImage = [set stringForColumn:IMAGE_URL];
        info.isRead = [set stringForColumn:IS_READ];
        info.lastChat = [set stringForColumn:LAST_CHAT];
        info.adminId = [set stringForColumn:ADMINID];
        info.lastChatUserName = [set stringForColumn:LASTCHATUSERNAME];
        [array addObject:info];
    }
    return array;

}
//更新数据库
- (BOOL)updateCircleThemeListWithThemeId:(CircleAbstractInfo *)info{
    BOOL ret = [self.circleDB executeUpdate:@"update CircleThemeTable set isRead=?,time=?,lastChat=?,lastChatUsername=? where themeId=? and uid=?",info.isRead,info.date,info.lastChat,info.lastChatUserName,info.circleDetailID,self.uid];
    if (ret == NO) {
        NSLog(@"更新失败");
        return NO;
    }
    NSLog(@"更新成功");
    return YES;

}
//更新数据库无时间操作
- (BOOL)updateCircleThemeListNoTimeWithThemeId:(CircleAbstractInfo *)info{
    BOOL ret = [self.circleDB executeUpdate:@"update CircleThemeTable set isRead=?,lastChat=?,lastChatUsername=? where themeId=? and uid=?",info.isRead,info.lastChat,info.lastChatUserName,info.circleDetailID,self.uid];
    if (ret == NO) {
        NSLog(@"更新失败");
        return NO;
    }
    NSLog(@"更新成功");
    return YES;
    
}
//更新表不更新是否可读
- (BOOL)updateCircleThemeListHaveNotReadWithAbstact:(CircleAbstractInfo *)info{
    BOOL ret = [self.circleDB executeUpdate:@"update CircleThemeTable set lastChat=?,lastChatUsername=?,title=?,detail=?,time=? where themeId=? and uid=?",info.lastChat,info.lastChatUserName,info.circleTopic,info.themeSimple,info.date,info.circleDetailID,self.uid];
    if (ret == NO) {
        NSLog(@"更新失败");
        return NO;
    }
    NSLog(@"更新成功");
    return YES;
}
//只更新此项是否已读
- (BOOL)updateCircleThemeRedPointIsRead:(NSString *)isRead themeId:(NSString *)themeId{
    BOOL ret = [self.circleDB executeUpdate:@"update CircleThemeTable set isRead=? where themeId=? and uid=?",isRead,themeId,self.uid];
    if (ret == NO) {
        NSLog(@"更新失败");
        return NO;
    }
    NSLog(@"更新成功");
    return YES;
    
}
//查找主题列表中是否有该主题
- (NSArray *)fetchCircleThemeListWithThemeId:(NSString *)themeId {
    FMResultSet *set = [self.circleDB executeQuery:@"select * from CircleThemeTable where themeId=? and uid=?",themeId,self.uid];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([set next]) {
        CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
        info.circleID = [set stringForColumn:CIRCLE_ID];
        info.circleDetailID = [set stringForColumn:CIRCLE_THEMEID];
        info.circleTopic = [set stringForColumn:TITLE];
        info.themeSimple = [set stringForColumn:DETAIL];
        info.circleName = [set stringForColumn:COMEFROM];
        info.circleImage = [set stringForColumn:IMAGE_URL];
        info.isRead = [set stringForColumn:IS_READ];
        info.lastChat = [set stringForColumn:LAST_CHAT];
        info.adminId = [set stringForColumn:ADMINID];
        info.lastChatUserName = [set stringForColumn:LASTCHATUSERNAME];
        [array addObject:info];
    }
    return array;
}
- (BOOL)updateCircleThemeListWithCircleId:(NSString *)circleId circleName:(NSString *)circleName{
    BOOL ret = [self.circleDB executeUpdate:@"update CircleThemeTable set comefrom=? where circleId=?",circleName,circleId];
    if (ret == NO) {
        NSLog(@"更新失败");
        return NO;
    }
    NSLog(@"更新成功");
    return YES;
    
}
- (BOOL)deleteCircleThemeListWithCircleId:(NSString *)circleId {
    BOOL  ret = [self.circleDB executeUpdate:@"delete from CircleThemeTable where circleId=? where uid=?",circleId,self.uid];
    if (ret == NO) {
        NSLog(@"删除失败");
        return NO;
    }
    return YES;
}
- (BOOL)deleteCircleThemeListAllObjWithCircleId:(NSString *)circleId {
    BOOL  ret = [self.circleDB executeUpdate:@"delete from CircleThemeTable where uid=? and circleId=?",self.uid,circleId];
    if (ret == NO) {
        NSLog(@"删除失败");
        return NO;
    }
    return YES;
}
//查找未读消息个数
- (NSInteger)fetchNotReadMessage{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"打开文件失败");
        return 0;
    }
    FMResultSet *set = [self.circleDB executeQuery:@"select * from CircleThemeTable where isRead=? and uid=?",@"0",self.uid];
    int i = 0;
    while ([set next]) {
        i++;
    }
    return  i;

}
- (NSInteger)fetchNotReadMessageIsNull{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"打开文件失败");
        return 0;
    }
    FMResultSet *set = [self.circleDB executeQuery:@"select * from CircleThemeTable where isRead=? and uid=?",@"",self.uid];
    int i = 0;
    while ([set next]) {
        i++;
    }
    return  i;
}
//删除表中某些行
- (BOOL)deleteCircleThemeListWithThemeId:(NSString *)themeId{
    BOOL  ret = [self.circleDB executeUpdate:@"delete from CircleThemeTable where themeId=? and uid=?",themeId,self.uid];
    if (ret == NO) {
        NSLog(@"删除失败");
        return NO;
    }
    return YES;
}


#pragma mark - 创建主题详情表
#define THEME_DETAIL @"ThemeDetailTable"
#define THEME_ID @"circleDetailId"
#define THEME_TITLE @"circleTitle"
#define THEME_LEARDERNAME @"circleLeaderName"
#define THEME_UPTIME @"circleUpdateTime"
#define THEME_NOTICE @"circleNotice"
#define THEME_SMALLIMAGEARRAY @"circleSmallImageArray"
#define THEME_BIGIMAGEARRAY @"circleImageArray"
- (BOOL)createThemeDetailList{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(%@ VARCHAR(32),%@ VARCHAR(64),%@ VARCHAR(32),%@ VARCHAR(32),%@ text,%@ text,%@ text)",THEME_DETAIL,THEME_ID,THEME_TITLE,THEME_LEARDERNAME,THEME_UPTIME,THEME_NOTICE,THEME_SMALLIMAGEARRAY,THEME_BIGIMAGEARRAY]];
    if (ret == NO) {
        NSLog(@"创建表失败");
        [self.circleDB close];
        return NO;
    }
    [self.circleDB close];
    return YES;
}
//增加表项
- (BOOL)insertCircleDetailWithInfo:(CircleDetailInfo *)info{
    if ([self createThemeDetailList]) {
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:@"insert into ThemeDetailTable values(?,?,?,?,?,?,?)",info.circleDetailId,info.circleTitle,info.circleLeaderName,info.circleUpdateTime,info.circleNotice,[info.circleSmallImageArray componentsJoinedByString:@"-"],[info.circleImageArray componentsJoinedByString:@"-"]];
    if (ret == NO) {
        NSLog(@"插入表失败");
        [self.circleDB close];
        return NO;
    }
    [self.circleDB close];
    NSLog(@"插入成功");
    return YES;
    }
    else{
        return NO;
    }
}
- (NSMutableArray *)fetchThemeDetailWithCircleDetailId:(NSString *)circleDetailId{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    FMResultSet *set = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ThemeDetailTable where circleDetailId=%@",circleDetailId]];
    NSMutableArray *resArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        CircleDetailInfo *info = [[CircleDetailInfo alloc]init];
        info.circleDetailId = [set objectForColumnName:THEME_ID];
        info.circleTitle = [set objectForColumnName:THEME_TITLE];
        info.circleLeaderName = [set objectForColumnName:THEME_LEARDERNAME];
        info.circleUpdateTime = [set stringForColumn:THEME_UPTIME];
        info.circleNotice = [set objectForColumnName:THEME_NOTICE];
        info.circleSmallImageArray = (NSMutableArray *)[[set objectForColumnName:THEME_SMALLIMAGEARRAY] componentsSeparatedByString:@"-"];
        
//        if ([[set objectForColumnName:THEME_BIGIMAGEARRAY] ]) {
//            info.circleImageArray =(NSMutableArray *)[[set objectForColumnName:THEME_BIGIMAGEARRAY] componentsSeparatedByString:@"-"];
//        }
        [resArray addObject:info];
    }
    [self.circleDB close];
    return resArray;
    
}
- (BOOL)fetchThemeDetailCountWithCircleDetailId:(NSString *)circleDetailId{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    FMResultSet *set = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ThemeDetailTable where circleDetailId=%@",circleDetailId]];
    while ([set next]) {
        return YES;
    }
    return NO;
}
- (BOOL)updateThemeDetailWIthCircleDetailId:(CircleDetailInfo *)info{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:@"update ThemeDetailTable set circleTitle=?,circleLeaderName=?,circleUpdateTime=?,circleNotice=?,circleSmallImageArray=?,circleImageArray=? where circleDetailId=?",info.circleTitle,info.circleLeaderName,info.circleUpdateTime,info.circleNotice,[info.circleSmallImageArray componentsJoinedByString:@"-"],[info.circleImageArray componentsJoinedByString:@"-"],info.circleDetailId];
    if (ret == NO) {
        NSLog(@"主题详情更新失败");
        [self.circleDB close];
        return NO;
    }
    [self.circleDB close];
    NSLog(@"主题详情更新成功");
    return YES;
}
- (void)deleteThemeList
{
    [self.circleDB open];
    [self.circleDB executeQuery:@"delete * from ThemeDetailTable where 1=1"];
    [self.circleDB close];
}

#pragma mark - CircleMemberList 圈子成员表
#define CIRCLEID @"circleId"
#define MEMBER_ID @"memberID"
#define MEMBERNAME @"memberName"
#define MEMBERCREDIT @"memberCredit"
#define MEMBERCOMPANY @"memberCompany"
#define MEMBERPOSITION @"memberPosition"
#define MEMBERHEADIMAGEURL @"memberHeadImageUrl"
- (BOOL)createMemberList
{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
//    ret = [self.circleDB executeUpdate:@"create table if not exists MemberList(circleId VARCHAR(16),memberID,memberName,memberCredit,memberCompany,memberPosition,memberHeadImageUrl)"];
    ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"create table if not exists MemberListTable(%@ VARCHAR(16),%@,%@,%@,%@,%@,%@)",CIRCLEID,MEMBER_ID,MEMBERNAME,MEMBERCREDIT,MEMBERCOMPANY,MEMBERPOSITION,MEMBERHEADIMAGEURL]];
    if (ret == NO) {
        NSLog(@"创建表失败");
        [self.circleDB close];
        return NO;
    }
    [self.circleDB close];
    return YES;
}
- (BOOL)insertMemberListWithMemberInfo:(MemberInfo *)info andCircleId:(NSString *)circleId{
    if ([self createMemberList]) {
        BOOL ret = [self.circleDB open];
        if (ret == NO) {
            NSLog(@"数据库打开失败");
            return NO;
        }
        ret = [self.circleDB executeUpdate:@"insert into MemberListTable values(?,?,?,?,?,?,?)",circleId,info.memberID,info.memberName,info.memberCredit,info.memberCompany,info.memberPosition,info.memberHeadImageUrl];
        if (ret == NO) {
            NSLog(@"插入表失败");
            [self.circleDB close];
            return NO;
        }
        [self.circleDB close];
        NSLog(@"插入成功");
        return YES;
    }
    else{
        return NO;
    }
}
- (NSMutableArray *)fetchMemberListWithCircleId:(NSString *)circleDetailId{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    FMResultSet *set = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from MemberListTable where circleId=%@",circleDetailId]];
    NSMutableArray *resArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        MemberInfo *info = [[MemberInfo alloc]init];
        info.memberID = [set stringForColumn:MEMBER_ID];
        info.memberName = [set stringForColumn:MEMBERNAME];
        info.memberCredit = [set stringForColumn:MEMBERCREDIT];
        info.memberCompany = [set stringForColumn:MEMBERCOMPANY];
        info.memberPosition = [set stringForColumn:MEMBERPOSITION];
        info.memberHeadImageUrl = [set stringForColumn:MEMBERHEADIMAGEURL];
        [resArray addObject:info];
    }
    
    [self.circleDB close];
    return resArray;
    
}
- (BOOL)fetchMemberListWithMemberId:(NSString *)memberId{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    FMResultSet *set = [self.circleDB executeQuery:@"select * from MemberListTable where memberID=?",memberId];
    while ([set next]) {
        [self.circleDB close];
        return YES;
    }
    [self.circleDB close];
    return NO;
}

- (BOOL)updateMemberListWithMemberInfo:(MemberInfo *)info{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    //update ChatRecords set userHeadUrl=? where userId=?
    ret = [self.circleDB executeUpdate:@"update MemberListTable set memberID=? memberName=?,memberCredit=?,memberCompany=?,memberPosition=?,memberHeadImageUrl=? where circleId=?",info.memberID,info.memberName,info.memberCredit,info.memberCompany,info.memberPosition,info.memberHeadImageUrl,info.circleId];
    
    if (ret == NO) {
        NSLog(@"圈子成员更新失败");
        [self.circleDB close];
        return NO;
    }
    NSLog(@"圈子成员更新成功");
    [self.circleDB close];
    return YES;
}
- (void)deleteMemberListWithCircleId:(NSString *)circleId
{
    [self.circleDB open];
   BOOL ret = [self.circleDB executeUpdate:@"delete from MemberListTable where circleId=?",circleId];
    if (ret == NO) {
        NSLog(@"删除失败");
    }
    NSLog(@"删除成功");
    [self.circleDB close];
}

#pragma mark - 聊天表
#define CHAT_RECORDS  @"ChatRecordsTable"
#define CIRCLE_ID  @"circleId"
#define ID @"id"
#define CIRCLE_THEME_ID  @"circleThemeId"
#define IS_MYSELF  @"isMySelf"
#define CONTENT  @"content"
#define NOW_TIME  @"nowData"
#define USER_ID_CHAT  @"userId"
#define USER_NAME  @"userName"
#define USER_HEAD_URL  @"userHeadUrl"
#define TIME_STAMP @"timestamps"
#define IS_SUCCESS @"isSuccess"
#define IS_LOADING @"isLoading"
#define U_ID @"uid"
- (BOOL)createChatRecords
{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(%@ varchar(32),%@ integer primary key autoincrement,%@ VARCHAR(64),%@ VARCHAR(64),%@ VARCHAR(32),%@ text,%@ text,%@ VARCHAR(32),%@ VARCHAR(32),%@ VARCHAR(128),%@ VARCHAR(16),%@ VARCHAR(16),%@ VARCHAR(16))",CHAT_RECORDS,U_ID,ID,CIRCLE_ID,CIRCLE_THEME_ID,IS_MYSELF,CONTENT,NOW_TIME,USER_ID_CHAT,USER_NAME,USER_HEAD_URL,TIME_STAMP,IS_SUCCESS,IS_LOADING]];  //%@ integer primary key autoincrement,
    if (ret == NO) {
        NSLog(@"创建聊天表失败");
        return NO;
    }
    NSLog(@"创建聊天表成功");
    return YES;
}
- (BOOL)insertChatRecordsWithChatInfoArray:(NSMutableArray *)infoArray
{
    __block BOOL ret = NO;
    for (int i =0 ; i < infoArray.count; i++) {
        ChatMessageInfo *info = [infoArray objectAtIndex:i];
        if (!info.userId) {
            NSLog(@"这里的用户ID是NULL");
        }
        NSString * isMySelf = nil;
        NSString * isLoad = nil;
        if (info.isMySelf == YES) {
            isMySelf = @"1";
        }
        else{
            isMySelf = @"0";
        }
        if (info.isLoading) {
            isLoad = @"1";
        }
        else{
            isLoad = @"0";
        }
        NSString * isSuccess = nil;
        if (info.isSuccess) {
            isSuccess = @"1";
        }
        else{
            isSuccess = @"0";
        }
        ret = [self.circleDB executeUpdate:@"insert into ChatRecordsTable(uid,circleId,circleThemeId,isMySelf,content,nowData,userId,userName,userHeadUrl,timestamps,isSuccess,isLoading) values(?,?,?,?,?,?,?,?,?,?,?,?)",self.uid,info.circleId,info.circleThemeId,isMySelf,info.content,info.nowDate,info.userId,info.userName,info.userHeadImageUrl,info.timeStamp,isSuccess,isLoad];
    }
    if (ret == NO) {
        NSLog(@"插入聊天表失败");
        return NO;
    }
    NSLog(@"插入聊天成功");
    return YES;
}

- (NSMutableArray *)fetchChatRecordsListWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId withIndex:(NSInteger)index andAmount:(NSInteger)amount
{
    //取出数据按时间排序的最后10位
    FMResultSet *result = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ChatRecordsTable where circleThemeId=%@ and uid=%@ order by id desc limit 10*%d,%d",themeId,self.uid,index-1,amount]];//timestamps desc
    NSMutableArray *resArray = [[NSMutableArray alloc]init];
    while ([result next]) {
        ChatMessageInfo *info = [[ChatMessageInfo alloc]init];
        info.circleId = [result stringForColumn:CIRCLE_ID];
        info.circleThemeId = [result stringForColumn:CIRCLE_THEME_ID];
        info.content = [result stringForColumn:CONTENT];
        if([[result stringForColumn:IS_MYSELF] isEqualToString:@"1"]){
            info.isMySelf = YES;
        }
        else{
            info.isMySelf = NO;
        }
        if ([[result stringForColumn:IS_LOADING] isEqualToString:@"1"]) {
            info.isLoading = YES;
        }
        else{
            info.isLoading = NO;
        }
        if ([[result stringForColumn:IS_SUCCESS] isEqualToString:@"1"]) {
            info.isSuccess = YES;
        }
        else{
            info.isSuccess = NO;
        }
        info.nowDate = [result stringForColumn:NOW_TIME];
        info.userId = [result stringForColumn:USER_ID_CHAT];
        info.userName = [result stringForColumn:USER_NAME];
        info.userHeadImageUrl = [result stringForColumn:USER_HEAD_URL];
        info.timeStamp = [result stringForColumn:TIME_STAMP];
        info.msgId = [result intForColumn:ID];
        [resArray addObject:info];
    }
    return resArray;
}

- (NSMutableArray *)fetchChatRecordsListWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId withId:(NSInteger)aId{
    FMResultSet *result = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ChatRecordsTable where circleThemeId=%@ and id < %d and uid=%@ order by id desc limit 10",themeId,aId,self.uid]];//timestamps
    NSMutableArray *resArray = [[NSMutableArray alloc]init];
    while ([result next]) {
        ChatMessageInfo *info = [[ChatMessageInfo alloc]init];
        info.circleId = [result stringForColumn:CIRCLE_ID];
        info.circleThemeId = [result stringForColumn:CIRCLE_THEME_ID];
        info.content = [result stringForColumn:CONTENT];
        if([[result stringForColumn:IS_MYSELF] isEqualToString:@"1"]){
            info.isMySelf = YES;
        }
        else{
            info.isMySelf = NO;
        }
        if ([[result stringForColumn:IS_LOADING] isEqualToString:@"1"]) {
            info.isLoading = YES;
        }
        else{
            info.isLoading = NO;
        }
        if ([[result stringForColumn:IS_SUCCESS] isEqualToString:@"1"]) {
            info.isSuccess = YES;
        }
        else{
            info.isSuccess = NO;
        }
        info.nowDate = [result stringForColumn:NOW_TIME];
        info.userId = [result stringForColumn:USER_ID_CHAT];
        info.userName = [result stringForColumn:USER_NAME];
        info.userHeadImageUrl = [result stringForColumn:USER_HEAD_URL];
        info.timeStamp = [result stringForColumn:TIME_STAMP];
        info.msgId = [result intForColumn:ID];
        [resArray addObject:info];
    }
    return resArray;
}
- (NSInteger)fetchLastRecordIdWitThemeId:(NSString *)themeId{
    FMResultSet *result = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ChatRecordsTable where circleThemeId=%@ and uid=%@ order by id asc limit 1",themeId,self.uid]];
    NSInteger aId = 0 ;
    while ([result next]) {
        aId = [result intForColumn:@"id"];
    }
    return aId;
}
- (NSInteger)fetchLastRecordIdDescWitThemeId:(NSString *)themeId{
    FMResultSet *result = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from ChatRecordsTable where circleThemeId=%@ and uid=%@ order by id desc limit 1",themeId,self.uid]];
    NSInteger aId = 0 ;
    while ([result next]) {
        aId = [result intForColumn:@"id"];
    }
    return aId;
}
//更新头像
- (BOOL)updateChatRecordsWithUserId:(NSString *)uId newUrl:(NSString *)newUrl{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:@"update ChatRecordsTable set userHeadUrl=? where userId=? and uid=?",newUrl,uId,self.uid];
    if (ret == NO) {
        NSLog(@"更新聊天头像记录失败");
        return  NO;
    }
    NSLog(@"更新聊天头像成功");
    return YES;
}
- (BOOL)updateChatRecordsWithChatMsg:(ChatMessageInfo *)info{
    NSString *isSuccess = nil;
    if (info.isSuccess) {
        isSuccess = @"1";
    }
    else{
        isSuccess = @"0";
    }
    NSString *isLoading = nil;
    if (info.isLoading) {
        isLoading = @"1";
    }
    else{
        isLoading = @"0";
    }
    BOOL ret = [self.circleDB executeUpdate:@"update ChatRecordsTable set isSuccess=?,isLoading=? where timestamps=? and uid=?",isSuccess,isLoading,info.timeStamp,self.uid];
    
    if (ret) {
        NSLog(@"发送成功 更新消息成功");
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)fetchChatRecordsWithMsg:(ChatMessageInfo *)msg timeStamp:(const NSString *)timestamp{
    FMResultSet *set = [self.circleDB executeQuery:@"select * from ChatRecordsTable where timestamps=? and uid=?",timestamp,self.uid];
    while ([set next]) {
        return YES;
    }
    return NO;
}

- (MemberInfo *)fetchUserNameWithUserId:(NSString *)uid{
    FMResultSet *set = [self.circleDB executeQuery:@"select * from ChatRecordsTable where userId=? and uid=?",uid,self.uid];
    MemberInfo *info = [[MemberInfo alloc] init];
    while ([set next]) {
        info.memberName = [set stringForColumn:@"userName"];
        info.memberHeadImageUrl = [set stringForColumn:@"userHeadUrl"];
        break;
    }
    return info;
}
- (BOOL)deleteChatRecordsWithCircleId:(NSString *)circleId andCircleThemeId:(NSString *)themeId
{
    
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        [self.circleDB close];
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=%@ and %@=%@ and uid=%@",CHAT_RECORDS,CIRCLE_ID,circleId,CIRCLE_THEME_ID,themeId,self.uid]];
    if (ret == NO) {
        [self.circleDB close];
        NSLog(@"删除聊天记录失败");
        return  NO;
    }
    [self.circleDB close];
    return YES;
}
- (BOOL)deleteChatRecordsWithTimeStamp:(NSString *)timeStamp{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        [self.circleDB close];
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:@"delete from ChatRecordsTable where timestamps=? and uid=?",timeStamp,self.uid];
    if (ret == NO) {
        [self.circleDB close];
        NSLog(@"删除聊天记录失败");
        return  NO;
    }
    NSLog(@"删除记录成功");
    [self.circleDB close];
    return YES;
}

#pragma mark - 用户表
#define USER_TABLE @"UserInfoTable"
#define USER_ID @"userId"
#define USER_NAME @"userName"
#define USER_TOKEN @"userToken"

- (BOOL)createUserInfo
{
    {
        BOOL ret = [self.circleDB open];
        if (ret == NO) {
            NSLog(@"数据库打开失败");
            return NO;
        }
        ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(%@ VARCHAR(64),%@ VARCHAR(64),%@ text)",USER_TABLE,USER_ID,USER_NAME,USER_TOKEN]];
        if (ret == NO) {
            NSLog(@"创建表失败");
            [self.circleDB close];
            return NO;
        }
        NSLog(@"创建用户表成功");
        [self.circleDB close];
        return YES;
    }
}

- (BOOL)insertUserInfo:(userItemInformation *)userInfo{
    if ([self createUserInfo]) {
        BOOL ret = [self.circleDB open];
        if (ret == NO) {
            NSLog(@"数据库打开失败");
            return NO;
        }
        ret = [self.circleDB executeUpdate:[NSString stringWithFormat:@"delete * from %@",USER_TABLE]];
        if (ret == YES) {
            NSLog(@"将已有的帐号删除");
        }
        ret = [self.circleDB executeUpdate:@"insert into UserInfoTable(userId,userName,userToken) values(?,?,?)",userInfo.userID,userInfo.username,userInfo.token];
        if (ret == NO) {
            NSLog(@"插入失败");
            [self.circleDB close];
            return NO;
        }
        NSLog(@"插入成功");
        [self.circleDB close];
        return YES;
    }
    else{
        return NO;
    }
}
- (BOOL)deleteCurrentUserInfo{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        [self.circleDB close];
        NSLog(@"数据库打开失败");
        return NO;
    }
    ret = [self.circleDB executeUpdate:@"delete * from UserInfoTable"];
    if (ret == NO) {
        NSLog(@"删除用户信息失败");
    }
    return ret;
}
- (NSMutableArray *)fetchUserList{
    BOOL ret = [self.circleDB open];
    if (ret == NO) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    FMResultSet *set = [self.circleDB executeQuery:[NSString stringWithFormat:@"select * from %@",USER_TABLE]];
    NSMutableArray *resArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        userItemInformation *info = [[userItemInformation alloc]init];
        
        info.userID = [set stringForColumn:[NSString stringWithFormat:@"%@",USER_ID]];
        info.username = [set stringForColumn:[NSString stringWithFormat:@"%@",USER_NAME]];
        info.token = [set stringForColumn:[NSString stringWithFormat:@"%@",USER_TOKEN]];
        [resArray addObject:info];
    }
    [self.circleDB close];
    return resArray;
}

/*
#pragma mark - 聊天表成员表
- (BOOL)createChatUserList:(MemberInfo *)member{
    [self.circleDB open];
    BOOL ret  = [self.circleDB executeUpdate:@"create table if not exists ChatUserList(memberId VARCHAR(16),memberName VARCHAR(32),memberHeadImageUrl)"];
    if (ret == NO) {
        NSLog(@"创建聊天成员表失败");
        [self.circleDB close];
        return NO;
    }
    NSLog(@"创建聊天成员表成功");
    [self.circleDB close];
    return YES;
}
- (BOOL)insertChatUserList:(MemberInfo *)info{
    [self.circleDB open];
    
    BOOL ret = [self.circleDB executeUpdate:@"insert ChatUserList(?,?,?)",info.memberID,info.memberName,info.memberHeadImageUrl];
    if (ret == NO) {
        NSLog(@"插入聊天成员失败");
        [self.circleDB close];
        return NO;
    }
    NSLog(@"插入聊天成员表成功");
    [self.circleDB close];
    return YES;
}
- (MemberInfo *)fetchChatUserListWithMemberId:(NSString *)memberId{
    [self.circleDB open];
    FMResultSet *set = [self.circleDB executeQuery:@"select * from ChatUserList where memberId=?",memberId];
    MemberInfo *member = [[MemberInfo alloc]init];
    while ([set next]) {
        member.memberID = [set stringForColumn:@"memberId"];
        member.memberName = [set stringForColumn:@"memberName"];
        member.memberHeadImageUrl = [set stringForColumn:@"memberHeadImageUrl"];
    }
    return member;
}
- (BOOL)updateChatUserListWithMember:(MemberInfo *)info{
    [self.circleDB open];
    BOOL ret = [self.circleDB executeUpdate:@"update ChatUserList set memberHeadImageUrl=? where memberId=?",info.memberHeadImageUrl,info.memberID];
    if(ret == NO){
        NSLog(@"更新头像失败");
        [self.circleDB close];
        return NO;
    }
    NSLog(@"更新头像成功");
    [self.circleDB close];
    return YES;
}
*/
@end
