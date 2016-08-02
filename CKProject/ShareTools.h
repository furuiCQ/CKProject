//
//  ShareTools.h
//  CKProject
//
//  Created by furui on 16/1/3.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareTools : NSObject

+(void)loginWeibo;
+(void)shareButtonPressed;
+(void)shareToWxFriend;
+(void)shareToWxTimeLine;
+(void)shareToWxTimeLine:(UIImage *)contentImage withContentTitle:(NSString *)title;
+(void)shareToQQ;
@end