//
//  CircleListViewController.h
//  CKProject
//
//  Created by furui on 15/12/8.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationDetailsViewController.h"
#import "SendInvitationViewController.h"
#import "HttpHelper.h" 
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
@interface CircleListViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UILabel *topLabel;
@property(strong,nonatomic)UILabel *topLabel1;

@property int bottomHeight;
@property NSString *titleName;
@property NSNumber *circleId;

@end