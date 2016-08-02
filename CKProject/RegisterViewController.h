//
//  RegisterViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleDataViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "UserDealViewController.h"
@interface RegisterViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property UITextField *userTextFiled;
@property UITextField *codeTextFiled;
@property UITextField *passTextFiled;
@property int bottomHeight;
@property NSTimer *timer;

@property UIButton *codeLabel;
@property(strong,nonatomic)UIAlertView *alertView;
@end
