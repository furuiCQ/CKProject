//
//  OrganismListView.h
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECDrawerLayout.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "OrganDetailsViewController.h"
#import "BaseViewController.h"

@interface OrganismListViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property(strong,nonatomic)UITableView *projectTableView;
@property(strong,nonatomic)UITableView *addTableView;
@property(strong,nonatomic)UITableView *subAddTableView;
@property(strong,nonatomic)UITableView *endAddTableView;
@property(strong,nonatomic)UITableView * typeTableView;

@property int bottomHeight;
@property(strong,nonatomic) ECDrawerLayout *starLayout;
@property(strong,nonatomic) ECDrawerLayout *firstLayout;
@property(strong,nonatomic) ECDrawerLayout *twoLayout;
@property(strong,nonatomic) ECDrawerLayout *threeLayout;
@property(strong,nonatomic) ECDrawerLayout *fourLayout;
@property(strong,nonatomic)ECDrawerLayout *typeLayout;
@property NSNumber* projectID;
@property NSString *titleName;
 
@end