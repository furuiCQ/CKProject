
//
//  MyRegistrationRecordViewController.h
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "RegistrationRecordTableCell.h"
#import "AppDelegate.h"
#import "AssessViewController.h"
#import "ProjectDetailsViewController.h"
@interface MyRegistrationRecordViewController : UITabBarController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic) NSMutableArray *tabArray;
@property(strong,nonatomic)UITableView *recordTableView;
-(void)clickNumber:(int)number;

@end
