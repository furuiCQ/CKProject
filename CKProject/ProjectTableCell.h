//
//  ProjectTableCell.h
//  CKProject
//
//  Created by furui on 15/12/4.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListItem.h"
@interface ProjectTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property  ProjectListItem *listItem;

@end
