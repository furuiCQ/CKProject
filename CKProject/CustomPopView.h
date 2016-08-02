
//
//  CustomPopView.h
//  CKProject
//
//  Created by furui on 16/4/16.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, PopActionViewStyle){
    PopActionViewStyleLight = 0,
    // 浅色背景，深色字体
    PopActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^SGMenuActionHandler)(NSInteger index);

@interface CustomPopView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) PopActionViewStyle style;

/**
 *  获取单例
 */
+ (CustomPopView *)sharedActionView;
+(void)addViewAndShow:(UIView *)view;
+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
                    shareJson:(NSDictionary*)shareJson
               selectedHandle:(SGMenuActionHandler)handler;
+(void)disMiss:(UIView *)subview;

@end