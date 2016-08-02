//
//  InvitationTableCell.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainListItem.h"
@interface InvitationTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property int rowHeight;
@property UILabel *addLabel;
@property UILabel *lastDayLabel;
@property UILabel *zanLabel;
@property  UILabel *msgLabel;
@end
