//
//  MsgViewController.h
//  CKProject
//
//  Created by furui on 15/12/26.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MsgTableCell.h"
#import "HttpHelper.h"
#import "MsgContentViewController.h"
#import "AppDelegate.h"

@interface MsgViewController : UITabBarController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(nonatomic)int flag;
@property(strong,nonatomic) NSString *topTitle;
@property(strong,nonatomic) NSMutableArray *tabArray;
@property(strong,nonatomic)UITableView *msgTableView;


@end
