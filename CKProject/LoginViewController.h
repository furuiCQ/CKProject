//
//  LoginViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
@interface LoginViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property(strong,nonatomic)UILabel *loginLabel;
@property(strong,nonatomic)UITextField *userTextFiled;
@property(strong,nonatomic)UITextField *pasTextFiled;
@property int bottomHeight;
@property(strong,nonatomic)UIAlertView *alertView;

@end
