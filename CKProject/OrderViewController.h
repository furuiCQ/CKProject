//
//  OrderViewController.h
//  CKProject
//
//  Created by furui on 15/12/22.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HttpHelper.h"
@interface OrderViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property NSNumber *projectId;
@property NSString *content;
@property NSNumber *weekId;
@property NSNumber *weekNum;
@property NSString *beginTime;
@property NSNumber *advancetime;
@end