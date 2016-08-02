//
//  RegistrationRecordTableCell.h
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainListItem.h"
@interface RegistrationRecordTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property int rowHeight;

@property UIImageView *logoImageView;
@property UILabel *projectName;
@property UILabel *tilteLabel;
@property UILabel *timeLabel;
@property UILabel *statueLabel;
@property UILabel *statue2Label;

@end
