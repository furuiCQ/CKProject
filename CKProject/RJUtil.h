

#import <UIKit/UIKit.h>


@interface RJUtil : NSObject
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
+(UIColor *) colorWithHexString: (NSString *)color;
+(UIImage*) createImageWithColor:(UIColor*) color;
+(NSString *) transFormChineseToEnglish:(NSString *)ch;
+(CATransition *)getAnimation:(NSInteger)mytag;
+(NSString *)getNowImageTime;
//+(NSString *)generateUuidString;
+(float)getDirDataSize;
+(void)deleteCachFileData;
@end
