//
//  MyMsgViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MsgViewController.h"
#import "BaseViewController.h"
@interface MyMsgViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic) NSMutableArray *tabArray;
@property(strong,nonatomic)UITableView *tableView;

@property BOOL hasMsg;

@end
