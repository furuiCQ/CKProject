//
//  RJCustomTableView.h
//  RJYaCheDai
//
//  Created by furui on 15/7/24.
//  Copyright (c) 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainListItem.h"
#import "CustomTextField.h"
#import "ProjectListViewController.h"
@interface MainCustomTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property(nonatomic,strong)UILabel *topText;
@property NSMutableArray *itemArray;
@property(nonatomic,strong)NSNumber *projectId;
@property(nonatomic,strong)NSNumber *typeId;
@end
