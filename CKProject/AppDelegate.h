//
//  AppDelegate.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//
#import "MainTabBarViewController.h"
#import "HttpModel.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ProgressHUD/ProgressHUD.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,TencentSessionDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)NSString *phoneNumber;
@property(strong,nonatomic)NSString *password;
@property(strong,nonatomic)NSString *token;
@property(strong,nonatomic)HttpModel *model;
@property(strong,nonatomic)MainTabBarViewController *mtvc;
@property NSUInteger selectIndex;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property double latitude;//纬度
@property double longitude;//经度
@property NSNumber *localNumber;//当前aid
@property NSString *cityName;//省市名称
@property NSString *areaName; //区县名
@property BOOL isLogin;
@property TencentOAuth *QQauth; 


@end

