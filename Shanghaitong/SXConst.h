//
//  SXConst.h
//  shangxin
//
//  Created by jianping on 14-1-26.
//  Copyright (c) 2014年 ZHIsland. All rights reserved.
//

#ifndef shangxin_SXConst_h
#define shangxin_SXConst_h

#ifdef DEBUG
#define NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define NSLog(format, ...)
#endif


#define iPhone5Srceen [UIScreen mainScreen].bounds.size.height > 480 ? YES : NO
#define STATUS_HEIGHT (IOS_VERSION>=7.0?20:0)
#define TabBarViewHeight 49
#define kUIViewRadius   5   // 程序中所有需要圆角的view的圆角值
#define kChatMessageFontSize 16.0
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAccessToken        @"aToken"
#define kDeviceToken        @"dToken"
#define kAccessProtocal     @"protocal"
#define kAccessAccount      @"user_name_key"
#define kAccessPassword     @"user_pwd_key"
#define kGuidBtnSide 40
#define kUserNickName       @"nickname"
#define kUserPortraitURL    @"portrait_url"

#define kProjectAreaFileName        @"areafile"
#define kProjectIndFileName         @"indfile"
#define kProjectDemandFileName      @"demandfile"
#define kHotTagFileName             @"hotTag"
#define kCacheTimeout               (60 * 60 * 24 * 1000)    //24小时缓存超时
#define kReachbilityAdd             @"115.29.137.228"

#define AJUST_HEIGHT 20
#define SHTError_Code @"warning_code"
#define SHTError_desc @"warning_desc"

#define kLogin @"index.php/User/Public/login"

#define kCircleList @"circle/msg_list.json"//圈子列表
#define kCircleDetail @"circle/msg_detail.json"
#define kCircleCreate @"circle/apply.json"//创建圈子
#define kCirckeMembers @"circle/members.json"//获取圈子成员
#define kUserCircleList @"circle/user_circle_list.json" //用户所在圈子列表
#define kUploadImage @"circle/pic_upload.json"//上传图片
#define kContributeToCircle @"circle/msg_add.json" //向圈子发主题
#define kCatUserInfo @"user/load_light.json" //查用户信息
#define kCircleTheme @"circle/all_msg.json"//圈子内的所有主题
#define kCheckUpdate @"/service/version_check.json" //检查最新版本
#define kHotTag @"/tag/hotest_tag.json"
#pragma mark - Socket Connect -

//#define NSLog(...)  NSLog(__VA_ARGS__)
//#define NSLog(...)

#define kDataID             @"dID"
#define kUserID             @"userID"
#define kSubjectID          @"subjectID"
#define kChatMsgContent     @"chatMSgContent"
#define kSendTimeInterval   @"sendtime"

#define kSendHeartBeatInterval  20

#pragma mark - 发布版本时，需要修改的地方 -

//#define kBaseUrl @"http://zyy.vriteam.com/"
//#define kBaseUrl @"http://api.jushang.biz/"

//正式
#define kBaseUrl @"http://api.shanghaitong.biz/"
//正式测试
//#define kBaseUrl @"http://api.jushang.biz/"
//测试
//#define kBaseUrl @"http://tapi.jushang.biz/"
//开发
//#define kBaseUrl @"http://api.wp.jushang.biz/"

//#define kBaseUrl @"http://zhouling.shangxin.vriteam.com/"

#define     GW_HOST     @"chat.shanghaitong.biz"
#define     GW_PORT     6300

//#define GW_HOST @"10.0.8.74"
//#define GW_PORT 4433

//MQTT
//测试
//#define kMQTTServerHost @"10.0.8.75"
//正式
#define kMQTTServerHost @"115.28.146.78"

//#define DOMAIN_URL @"http://jzy.shangxin.jushang.biz/"
//#define DOMAIN_URL @"http://zl.shangxin.jushang.biz/"
//#define DOMAIN_URL @"http://yangshuai.shangxin.jushang.biz/"
//正式
#define DOMAIN_URL @"http://m.shanghaitong.biz/"
//正式测试
//#define DOMAIN_URL @"http://m.jushang.biz/"
//开发
//#define DOMAIN_URL @"http://wp.shangxin.jushang.biz/"
//测试
//#define DOMAIN_URL @"http://test.jushang.biz/"

#pragma mark - HTTP URL -

//登出时删除token
#define DEVICE_TOKEN_DEL @"index.php/User/Public/logout_client"

//协议页
#define PROTOCOL_URL @"index.php/User/Index/protocol.html?nav=false"
//登陆接口
#define LOGIN_URL @"index.php/User/Public/login"
// 上传设备token用于消息推送
#define UPLOAD_DEVICETOKEN_URL @"index.php/User/Index/saveDeviceToken"

//项目主界面@@@@@@@@@@@@@@@@@@   tag值1~~~~50   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//项目接口
#define PROJECT_LIST_URL @"index.php/Project/Index/pro_list"
#define PROJECT_LIST_TYPE 0
//房地产接口  -- 参数 ind（行业，string）
#define REALTY_LIST_URL @"index.php/Project/Index/pro_list_sel/ind/1"
#define REALTY_LIST_TYPE 1
//抢福利
#define ROB_WELFARE_LIST_URL @"index.php/Welfare/Index/welfare_list"
#define ROB_WELFARE_LIST_TYPE 2
//项目左抽屉---------------------
//感兴趣的项目
#define URL_INDEX0 @"index.php/Project/Index/my_pro_list?type=coop"
//当红娘的项目
#define URL_INDEX1 @"index.php/Project/Index/my_pro_list?type=share"
////我的收藏
#define URL_INDEX2 @"index.php/Project/Index/my_pro_list?type=fav"
//我的评论
#define URL_INDEX3 @"index.php/Project/Index/my_pro_list?type=comment"
//我发布的
#define URL_INDEX4 @"index.php/Project/Index/my_pro_list?type=pub"
////我抢到的福利
#define URL_INDEX5 @"index.php/Welfare/Index/my_grab_wefare"
////我发布的福利
#define URL_INDEX6 @"index.php/Welfare/Index/my_wefare"
//项目右抽屉---------------------
////发布项目
#define URL_INDEX7 @"index.php/Project/Index/add_pro"
////委托项目
#define URL_INDEX8 @"index.php/Project/Index/add_pro_offline"
////发福利
#define URL_INDEX9 @"index.php/Welfare/Index/add_welfare"
////更新资源
#define URL_INDEX10 @"index.php/Resource/Index/update_resource"
////委托消息
#define URL_INDEX11 @"index.php/User/Index/invitation"

//项目筛选-----------------------
//最新互动
#define URL_INDEX12  @"index.php/Project/Index/pro_list?order=uptime"
//最新发布
#define URL_INDEX13  @"index.php/Project/Index/pro_list?order=publish_time"
//最感兴趣
#define URL_INDEX14  @"index.php/Project/Index/pro_list?order=coops"
//确定
#define URL_INDEX15  @"index.php/Project/Index/pro_list_sel"
//搜索
#define URL_INDEX16  @"index.php/Project/Index/pro_search"
// 资源搜索
#define URL_INDEX17  @"index.php/Resource/Index/search"

//资源@@@@@@@@@@@@@@@@@@@@@@@  tag值51~~~~100  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//资源主界面
#define URL_INDEX51 @"index.php/Resource/Index/resource_list"
//资源左抽屉----------------------
//我感兴趣的
#define URL_INDEX52  @"index.php/Resource/Index/coops_list"
//我的资源
#define URL_INDEX53  @"index.php/Resource/Index/update_resource"
//资源右抽屉----------------------
//发布项目
#define URL_INDEX54  @"index.php/Project/Index/add_pro"
//委托项目
#define URL_INDEX55  @"index.php/Project/Index/my_pro_list?type=offline"
//发福利
#define URL_INDEX56   @"index.php/Welfare/Index/add_welfare"
//更新资源
#define URL_INDEX57    @"index.php/Resource/Index/update_resource"
//邀请朋友
#define URL_INDEX58   @"index.php/User/Index/invitation"
//资源筛选————————————————————————
//最新ziyuan?
#define  URL_INDEX59  @"index.php/Resource/Index/resource_list?order=utime"
//最感兴趣
#define  URL_INDEX60  @"index.php/Resource/Index/resource_list?order=coops"
//确定
#define  URL_INDEX61  @"index.php/Resource/Index/resource_list_rel"

//消息@@@@@@@@@@@@@@@@@@@@@@@@  tag值101~~~~150  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//消息主界面
#define URL_INDEX101 @"index.php/User/AboutMe/lists"
//消息左抽屉------------------------
//谁对我的项目感兴趣
#define  URL_INDEX102  @"index.php/User/AboutMe/lists?type=3"
//谁对我的项目当红娘
#define  URL_INDEX103   @"index.php/User/AboutMe/lists?type=7"
//谁评论了我的项目
#define  URL_INDEX104   @"index.php/User/AboutMe/lists?type=5"
//谁对我的资源感兴趣
#define URL_INDEX105  @"index.php/User/AboutMe/lists?type=8"
//谁信任了我
#define URL_INDEX106  @"index.php/User/AboutMe/lists?type=11"
//我的私信
#define URL_INDEX107  @"index.php/User/AboutMe/lists?type=10"
//圈子通知
#define URL_INDEX108  @"index.php/User/AboutMe/lists?type=9"
//系统消息
#define URL_INDEX109  @"index.php/User/AboutMe/lists?type=4"

//圈子@@@@@@@@@@@@@@@@@@@@@@  tag值151~~~~200   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//圈子主界面
#define URL_INDEX151  @"index.php/Circle/Index/msg_list"
//圈子导航右侧编辑链接
#define URL_CIRCLE_EDIT @"index.php/Circle/Index/add_msg"

//我@@@@@@@@@@@@@@@@@@@@@@@@@  tag值201~~~~250   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//我主界面
#define URL_INDEX201  @"index.php/User/Index/user_info"
#define URL_INDEX_USER_SHOW @"index.php/User/Index/user_show/id/"


enum PushMessageType
{
    PushMessageProject = 1,                 //查看我的项目
    PushMessageInfo,                        //查看我的资料
    PushMessageInterest,                    //项目感兴趣
    PushMessageSystem,                      //系统消息
    PushMessageDiscussProject,              //评论了我的项目
    PushMessageVisitorProjectInterest,      //游客对我的项目感兴趣
    PushMessageIntermediary,                //为我的项目当红娘
    PushMessageResourceInterest,            //对我的资源感兴趣
    PushMessageCircleNotification,          //圈子通知
    PushMessagePrivateLetter,               //发来了私信
    PushMessageTrustMe,                     //信任了我
    PushMessagePublishSubject,              //在圈子里发布了主题
    PushMessageInviteCircle,                //邀请你加入了圈子
    PushMessageRemoveCircle,                //将你请出了圈子
    PushMessageProjectCheckNotification,    //项目审核通知
    PushMessageProjectCooperation,          //项目合作
    PushMessageSubjectCheckPass,            //投稿审核通过
    PushMessageProjectOffline,               //18
    PushMessageUpdateAvatar,
    PushMessageCircleMumberDele,            //自己被T出圈子
    PushMessageCircleUpdateCircleName,       //更新圈子名称
    PushMessageCircleCircleAddPeople,       //将本用户加入圈子
    PushMessageLogout,
    PushMessageDeleCircleTheme,               //圈子下线后24
    PushMessageRemoveRedpoint,
    PushMessagePushOfflineMsg
};

typedef NS_ENUM(NSInteger,ButtonIndex){
    ButtonIndexPro = 0,
    ButtonIndexResourc,
    ButtonIndexCircle,
    ButtonIndexMy
};



#endif
