//
//  ShareView.h
//  RJInvestor
//
//  Created by furui on 15/1/14.
//
//
#import <UIKit/UIKit.h>

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, SGActionViewStyle){
    SGActionViewStyleLight = 0,
    // 浅色背景，深色字体
    SGActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^SGMenuActionHandler)(NSInteger index);

@interface RJShareView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) SGActionViewStyle style;

/**
 *  获取单例
 */
+ (RJShareView *)sharedActionView;

+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
                    shareJson:(NSDictionary*)shareJson
               selectedHandle:(SGMenuActionHandler)handler;


@end
