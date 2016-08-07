//
//  ProjectListViewController.h
//  CKProject
//
//  Created by furui on 15/12/6.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECDrawerLayout.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "ProjectDetailsViewController.h"
#import "NSString+Extension.h"
#import "Node.h"
#import "TreeTableView.h"
@interface ProjectListViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property(strong,nonatomic)UITableView *projectTableView;
@property(strong,nonatomic)UITableView *addTableView;
@property(strong,nonatomic)UITableView *subAddTableView;
@property(strong,nonatomic)UITableView *endAddTableView;
@property(strong,nonatomic)TreeTableView * typeTableView;
@property(strong,nonatomic)UITableView * gradeTableView;
@property int *counts;
@property int bottomHeight;
@property(strong,nonatomic) ECDrawerLayout *firstLayout;
@property(strong,nonatomic) ECDrawerLayout *twoLayout;
@property(strong,nonatomic) ECDrawerLayout *threeLayout;
@property(strong,nonatomic) ECDrawerLayout *fourLayout;
@property(strong,nonatomic)ECDrawerLayout *typeLayout;
@property(strong,nonatomic)ECDrawerLayout *gradeLayout;

@property NSNumber* projectID;
@property NSNumber* projectSubID;
@property NSMutableArray *tableArray;
@property NSString *titleName;
-(void)setHotModel:(NSString *)sqlString;
-(void)searchData:(NSString *)data withTime:(NSString *)date withAid:(NSNumber *)aid;
-(void)setHasData:(NSArray *)array;
-(void)setstd:(int)num;
@end