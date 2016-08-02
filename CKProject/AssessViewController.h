//
//  AssessViewController.h
//  CKProject
//
//  Created by 凌甫 刘pro on 16/1/13.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MsgTableCell.h"
#import "RatingBar.h"
#import "AppDelegate.h"
#import "HttpHelper.h"
@interface AssessViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property NSNumber *projectId;


@end
