//
//  msViewController.h
//  CKProject
//
//  Created by user on 16/7/20.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "ImageCompress.h"
@interface msViewController : UIViewController
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
