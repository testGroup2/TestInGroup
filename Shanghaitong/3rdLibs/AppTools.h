//
//  AppTools.h
//  iSport
//
//  Created by Steve Wang on 13-5-13.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTools : NSObject

// 字符串转换称颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (NSString *) getDeviceUuid;
// 获取当前设备的信息
+ (NSString*)getDeviceVersion;

// 将一个数字转化为运动参数字符串
+ (NSString *)sportDisStringWithDouble:(double)distance;
+ (NSString *)sportDurStringWithDouble:(double)duration;
+ (NSString *)sportDurCNStringWithDouble:(double)duration;
+ (NSString *)sportCalorieStringFromFloat:(double)calorie;

// 清除表格单元子视图
+ (void)cleanupSubViewsWithCell:(UITableViewCell *)cell;

+ (NSString *)getSandboxOfDocuments;
+ (NSString *)getSandboxOfCache;
+ (NSString *)fileSizeWithUnitFromLonglong:(unsigned long long)size;
+ (long long)folderSizeAtPath:(NSString*)folderPath;
+ (NSInteger)deleteAllFileFormFolder:(NSString *)folderPath;

// 将一个一维数组转化为二维数组
+ (NSMutableArray *)getPlanarArrayFromUnidimensionalArray:(NSArray *)oldArray withUInteger:(NSUInteger)integer; // integer表示二维数组里的子数组的个数

// 日期转化
+ (NSDate *)dateFromString:(NSString *)dateString withFormatter:(NSString *)formatter;
+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;
// 将一个数字转化为时间格式00:00:00
+ (NSString *)timeStringFromNumber:(NSUInteger)number;
// 将一个数字转化为时间格式，返回一个数组分别为小时、分钟、秒
+ (NSArray *)timeComponentFromNumber:(NSUInteger)number;
+ (NSString *)timeStampsWithDateString:(NSString *)dateString;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color;
+ (UIImage *)imageByScalingToSize:(CGSize)targetSize image:(UIImage*)image;
+ (UIImage *)cutImageWithRect:(CGRect)rect fromImage:(UIImage *)oldImage;

+ (NSString *)getCurrentTime;
//时间戳换成时间
+ (NSString *)getDateFormatterWithTimestamp:(NSString *)timestamp;
+ (NSString *)getNowDateTimeStamp;
+ (NSString *)getShortDateWithTimestamp:(NSString *)timestamp;
@end
