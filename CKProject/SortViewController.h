//
//  SortViewController.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "HttpHelper.h"
#import "SortOrganizationTabelCell.h"
#import "SortProjectListTableCell.h"
@interface SortViewController:UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property(strong,nonatomic)UITableView *projectTableView;
@property(strong,nonatomic)UITableView *orgTableView;
@property(strong,nonatomic) NSMutableArray *tabArray;


@property(strong,nonatomic)NSMutableArray *projectDictionary;
@property(strong,nonatomic)NSMutableArray *orgDictionary;
@property(strong,nonatomic)NSArray *httpProjectArray;
@property(strong,nonatomic)NSArray * httpOrgArray;
@end
