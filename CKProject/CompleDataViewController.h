//
//  CompleDataViewController.h
//  CKProject
//
//  Created by furui on 15/12/11.
//  Copyright © 2015年 furui. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CompleDataViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UITextField *cityTextFiled;
@property UITextField *userTextFiled;
@property UITextField *pasTextFiled;
@property UITextField *addressTextFiled;
@property NSString *phone;
@property NSString *password;
@property(strong,nonatomic)UIAlertView *alertView;


@end
