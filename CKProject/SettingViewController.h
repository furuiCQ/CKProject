//
//  SettingViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MsgTableCell.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "BaseViewController.h"
@interface SettingViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic)UIAlertView *alertView;


@end
