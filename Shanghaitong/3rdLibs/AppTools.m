//
//  AppTools.m
//  iSport
//
//  Created by Steve Wang on 13-5-13.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//
#include <sys/socket.h>
#include <sys/sysctl.h>

#import "AppTools.h"

@implementation AppTools

+(UIColor *) colorWithHexString: (NSString *) stringToConvert  //@"#5a5a5a"
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}

+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

#pragma mark - Private Method -


#pragma mark - Date and Time -

+ (NSDate *)dateFromString:(NSString *)dateString withFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入的日期字符串形如：@"1992-05-21 13:08:08"  @"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setDateFormat:formatter];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:formatter];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)timeStampsWithDateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString * stamp = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    return stamp;
}
+ (NSString *)timeStringFromNumber:(NSUInteger)number
{
    int hours, minutes, seconds;
    hours = (int)(number / 3600);
    minutes = (int)((number - hours * 3600) / 60);
    seconds = (int)((number - hours * 3600) - minutes * 60);
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSArray *)timeComponentFromNumber:(NSUInteger)number
{
    int hours, minutes, seconds;
    hours = (int)(number / 3600);
    minutes = (int)((number - hours * 3600) / 60);
    seconds = (int)((number - hours * 3600) - minutes * 60);
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:seconds], nil];
}

+ (void)cleanupSubViewsWithCell:(UITableViewCell *)cell
{
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - Sport Unit -

+ (NSString *)sportDisStringWithDouble:(double)distance
{
    NSString *distanceStr = @"";
    if (distance < 1000) {
        distanceStr = [NSString stringWithFormat:@"%.1f m", distance];
    }else {
        distanceStr = [NSString stringWithFormat:@"%.1f km", distance/1000];
    }
    
    return distanceStr;
}

+ (NSString *)sportDurStringWithDouble:(double)duration
{
    NSString *durationStr = nil;
    if (duration < 60 && duration >= 0) {
        durationStr = [NSString stringWithFormat:@"%02d''", (int)duration];
    }else if (duration < 3600 && duration >= 60) {
        durationStr = [NSString stringWithFormat:@"%02d'%d''", (int)duration/60, (int)duration%60];
    }else if (duration >= 3600 && duration < 86400) {
        durationStr = [NSString stringWithFormat:@"%02dh%d'", (int)duration/3600, (int)duration%3600];
    }else if (duration >= 86400) {
        durationStr = [NSString stringWithFormat:@"%3.0f天", duration/3600/24];
    }
    
    return durationStr;
}

+ (NSString *)sportDurCNStringWithDouble:(double)duration
{
    NSString *durationStr = nil;
    if (duration < 60 && duration >= 0) {
        durationStr = [NSString stringWithFormat:@"%d秒", (int)duration];
    }else if (duration < 3600 && duration >= 60) {
        durationStr = [NSString stringWithFormat:@"%d分钟%d秒", (int)duration/60, (int)duration%60];
    }else if (duration >= 3600 && duration < 86400) {
        durationStr = [NSString stringWithFormat:@"%d小时%d分钟", (int)duration/3600, (int)duration%3600];
    }else if (duration >= 86400) {
        durationStr = [NSString stringWithFormat:@"%3.0f天", duration/3600/24];
    }
    
    return durationStr;
}


+ (NSString *)sportCalorieStringFromFloat:(double)calorie
{
    if (calorie < 1000 && calorie >= 0) {
        return [NSString stringWithFormat:@"%5.1f cal", calorie];
    }else {
        return [NSString stringWithFormat:@"%5.1f kcal", calorie/1000];
    }
}

#pragma mark - Sandbox and Folder -

+ (NSString *)getSandboxOfDocuments
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)getSandboxOfCache
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cache objectAtIndex:0];
    return cachePath;
}

+ (NSString *)fileSizeWithUnitFromLonglong:(unsigned long long)size
{
    NSString *sizeWithUnit = nil;
    if (size > 0 && size < 1024) {
        sizeWithUnit = [NSString stringWithFormat:@"%lld 字节", size];
    }else if (size >= 1024 && size < 1024*1024) {
        sizeWithUnit = [NSString stringWithFormat:@"%lld Kb", size/1024];
    }else if (size >= 1024*1024 && size < 1024*1024*1024) {
        sizeWithUnit = [NSString stringWithFormat:@"%lld Mb", size/1024/1024];
    }else if (size >= 1024*1024*1024) {
        sizeWithUnit = [NSString stringWithFormat:@"%lld Gb", size/1024/1024/1024];
    }
    
    return sizeWithUnit;
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 循环调用fileSizeAtPath来获取一个目录所占空间大小
+ (long long)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (NSInteger)deleteAllFileFormFolder:(NSString *)folderPath
{
    NSString *sizeStr = [AppTools fileSizeWithUnitFromLonglong:[AppTools folderSizeAtPath:folderPath]];
    if (!sizeStr) {        
        return -1; // 目录为空
    }

    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
    NSString *fileName;
    while (fileName = [dirEnum nextObject]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", folderPath, fileName] error:nil];
    }
    
    if ([[dirEnum allObjects] count] == 0) {
        return 0; // 删除成功
    }
    
    return -2; // 删除失败
}

#pragma mark - Array Handle -

+ (NSMutableArray *)getPlanarArrayFromUnidimensionalArray:(NSArray *)oldArray withUInteger:(NSUInteger)integer
{
    // constrate 2维数组
    NSMutableArray *newArray = [NSMutableArray array];
    int numberOfGroups = [oldArray count] / integer; // 按integer的倍数分组
    int numberOfElements = [oldArray count] % integer; // 最后剩下的元素个数
    int temp = 0; // 记录最后一组数组的第一个元素下标
    // 将4的倍数的所有元素进行拆分，并添加到二维数组里
    for (int i = 0; i < numberOfGroups; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = i * integer, m = j; j < m + integer; j++) {
            [array addObject:[oldArray objectAtIndex:j]];
            if ([array count] > (integer-1)) {
                [newArray addObject:array];
            }
            temp = m + integer;
        }
    }
    if (numberOfElements > 0) {
        // 将最后一组元素封装成一个数组，添加到二维数组里
        NSMutableArray *array = [NSMutableArray array];
        for (int i = temp; i < temp + numberOfElements; i++) {
            [array addObject:[oldArray objectAtIndex:i]];
        }
        [newArray addObject:array];
    }
    
    return newArray;
}

#pragma mark - Image Handle -

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

// 绘制圆形UIImage
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    int w = size.width;
    int h = size.height;
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, rect, img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

+ (UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f , image.size.height - inset * 2.0f);;
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset + width/2, inset +  width/2, image.size.width - width- inset * 2.0f, image.size.height - width - inset * 2.0f));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)imageByScalingToSize:(CGSize)targetSize image:(UIImage*)image
{
    
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage ;
}

+ (UIImage *)cutImageWithRect:(CGRect)rect fromImage:(UIImage *)oldImage
{
    CGImageRef cgImageRef = CGImageCreateWithImageInRect([oldImage CGImage], rect);
    UIImage *newImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    return newImage;
}
#pragma mark - Number String Format -
//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *expression = [NSString stringWithFormat:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (match) {
        NSLog(@"right");
        return YES;
    }else {
        NSLog(@"wrong");
        return NO;
    }
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
//获取当时时间
+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}
+ (NSString *)getDateFormatterWithTimestamp:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
     NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSString * currentTime = [formatter stringFromDate:confromTimesp];
    return currentTime;
}
+ (NSString *)getShortDateWithTimestamp:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timestamps = [timestamp substringWithRange:NSMakeRange(0, 10)];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:[timestamps integerValue]];
    NSString *nowDateStr = [formatter stringFromDate:nowDate];
    return nowDateStr;
}
+ (NSString *)getNowDateTimeStamp{
    NSString *timestamp = [NSString stringWithFormat:@"%f",([[NSDate date] timeIntervalSince1970])*1000];
    return timestamp;
}
+ (NSString *) getDeviceUuid{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}
/*
 + (NSString *)timeStampsWithDateString:(NSString *)dateString{
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *date = [dateFormatter dateFromString:dateString];
 NSString * stamp = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
 return stamp;
 }
 */
@end
