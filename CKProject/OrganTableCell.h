//
//  OrganTableCell.h
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgListItem.h"
@interface OrganTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property OrgListItem *listItem;
 
@end
