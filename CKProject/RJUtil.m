

#import "RJUtil.h"

@implementation RJUtil
#pragma mark - calculate distance  根据2个经纬度计算距离

#define PI 3.1415926
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}
// - 颜色转换 IOS中十六进制的颜色转换为UIColor
+(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//颜色转成UIImage
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//中文转英文字母
+(NSString *) transFormChineseToEnglish:(NSString *)ch
{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:ch];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO))
    {
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
    {
        return [[ms lowercaseString]stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return nil;
}
+(CATransition *)getAnimation:(NSInteger)mytag{
    CATransition *animation = [CATransition animation];
    CABasicAnimation *rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.4f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    
    rotationAnimation.duration=1.0f;
    
    switch (mytag) {
        case 0://无动画
            animation=nil;
            break;
        case 1://从左到右
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromLeft;
            break;
        case 2://从右到左
            animation.type = kCATransitionPush;
            animation.subtype=kCATransitionFromRight;
            break;
        case 3://从上到下
            animation.subtype=kCATransitionFromTop;
            break;
        case 4://从下到上
            animation.subtype=kCATransitionFromBottom;
            break;
        case 5://缩小
            rotationAnimation.fromValue = @1.0f;
            rotationAnimation.toValue = @0.0f;
            animation=(CATransition *)rotationAnimation;
            break;
        case 6://放大
            rotationAnimation.fromValue = @0.0f;
            rotationAnimation.toValue = @1.0f;
            animation=(CATransition *)rotationAnimation;
            break;
        default:
            animation=nil;
            break;
    }
    return animation;
    
}
//获取当前时间戳
+(NSString *)getNowImageTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
////获取uuid
//+(NSString *)generateUuidString
//{
//    // create a new UUID which you own
//    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
//    
//    // create a new CFStringRef (toll-free bridged to NSString)
//    // that you own
//    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
//    
//    
//    return uuidString;
//}
/**
 *  获取系统沙盒目录下文件大小
 */
+(float)getDirDataSize{
    NSString *path = NSHomeDirectory();//主目录
    
    NSLog(@"NSHomeDirectory:%@",path);
    
    NSString *userName = NSUserName();//与上面相同
    
    NSString *rootPath = NSHomeDirectoryForUser(userName);
    
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList  = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    
  //  fileList = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    
    BOOL isDir = NO;
    
    //在上面那段程序中获得的fileList中列出文件夹名
    float allSize=0;
    for (NSString *file in fileList) {
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
        
        NSLog(@"文件名称：%@  文件大小：%f (M)",file,[self fileSizeAtPath:path]);
        allSize=[self fileSizeAtPath:path]+allSize;
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        
        if (isDir) {
            [dirArray addObject:file];
            
        }
        isDir = NO;
        
    }
    
    
    
    
    return allSize;
  //  NSLog(@"Every Thing in the dir:%@",fileList);//这个数组是你所有这个文件夹的文件
    
  //  NSLog(@"All folders:%@",dirArray);
    
}

+(float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        long  dataSize=(long)[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        return dataSize/(1024.0*1024.0);
    }
    return 0;
}
+(void)deleteCachFileData{
    // 删除沙盒里的文件
    NSString *path = NSHomeDirectory();//主目录
    
    NSLog(@"NSHomeDirectory:%@",path);
    
    NSString *userName = NSUserName();//与上面相同
    
    NSString *rootPath = NSHomeDirectoryForUser(userName);
    
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList  = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    
    //  fileList = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    
    //在上面那段程序中获得的fileList中列出文件夹名
    //float allSize=0;
    for (NSString *file in fileList) {
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
        if (!blHave) {
            NSLog(@"no have");
            return ;
        }else {
            NSLog(@" have");
            BOOL blDele= [fileManager removeItemAtPath:path error:nil];
            if (blDele) {
                NSLog(@"dele success");
            }else {
                NSLog(@"dele fail");
            }
            
        }
    }
}
@end
