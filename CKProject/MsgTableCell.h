//
//  MsgTableCell.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MsgTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property int rowHeight;
@property UILabel *titleLabel;
@property UILabel *contentLabel;
@property UILabel *timeLabel;
@property UIView *pointView;
@end
