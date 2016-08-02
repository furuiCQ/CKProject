//
//  UserInfoViewController.h
//  CKProject
//
//  Created by furui on 15/12/11.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "ImageCompress.h"
@interface UserInfoViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property NSMutableArray *userInfoArry;
@property UIAlertController *alertDialog;
@property UIActivityIndicatorView *dicatorView;
@property UIImageView *userLogo;
@property UIAlertView *customAlertView;
@property UIAlertView *warnAlertView;
@property(strong,nonatomic)UIAlertView *logAlertView;

@property NSMutableArray *controlArray;
@property int updateTag;
bool saveImageToCacheDir(NSString *directoryPath, UIImage *image, NSString *imageName, NSString *imageType);
@end
