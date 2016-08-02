//
//  InvitaitionTabelCell.h
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HttpHelper.h"
@interface InvitaitionTabelCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property UIImageView *logoView;
@property UITextView *contextView;
@property UILabel *timeLabel;
@property UILabel *userName;
@property UIButton *dianZanLabel;
@property NSDictionary *data;


@end
