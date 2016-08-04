//
//  SortProjectListTableCell.h
//  CKProject
//
//  Created by furui on 15/12/15.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListItem.h"
@interface SortProjectListTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property UILabel *titleLabel;
@property UILabel *moreLabel;
@property UIImageView *logoImage;
@property UIImageView *goImage;
@property NSMutableArray *controlArray;
@property BOOL isSelected;
@end
