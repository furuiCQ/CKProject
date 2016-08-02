//
//  ForgetViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface ForgetViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;

@property UITextField *userTextFiled;
@property UITextField *codeTextFiled;
@property UITextField *pasTextFiled;
@property UILabel *sendLabel;
@property NSTimer *timer;
@property int secondsCountDown; //倒计时总时长
@property(strong,nonatomic)UIAlertView *alertView;
@end
