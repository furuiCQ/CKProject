//
//  CircleCustomTableCell.h
//  CKProject
//
//  Created by furui on 15/12/8.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJUtil.h"
#import "CircleListItem.h"
#import "CircleListViewController.h"
@interface CircleCustomTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property(nonatomic,strong) CircleListItem *listItem;

@end