//
//  MineViewController.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRegistrationRecordViewController.h"
#import "MyInvitationViewController.h"
#import "MyCollectViewController.h"
#import "MyMsgViewController.h"
#import "SettingViewController.h"
#import "LoginRegViewController.h"
#import "UserInfoViewController.h"
#import "HttpModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MineViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UIImageView *leftImage;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UIImageView *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UIButton *unloginControl;
@property(strong,nonatomic)UIControl *loginedControl;
@property(strong,nonatomic)UIImageView *userImageView;
@property(strong,nonatomic)UILabel *userNameLabel;
@property(strong,nonatomic)UILabel *userTelLabel;
@property(strong,nonatomic)UIView *pointView;


@property UILabel *numbLabel;
@property UILabel *sucessNumbLabel;
@property UILabel *postNumbLabel;
@property NSMutableArray *userInfoArray;
@property BOOL hasMsg;
@end
