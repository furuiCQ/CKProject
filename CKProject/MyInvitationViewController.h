//
//  MyInvitationViewController.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "MyInvitationViewController.h"
#import "InvitationTableCell.h"
#import "InvitationDetailsViewController.h"
@interface MyInvitationViewController : UITabBarController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic) NSMutableArray *tabArray;
@property(strong,nonatomic)UITableView *invitationTableView;
@property(strong) NSMutableArray *dataArray;


@end
