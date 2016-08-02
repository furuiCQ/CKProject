//
//  modetailViewController.h
//  CKProject
//
//  Created by user on 16/6/29.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitaitionTabelCell.h"
#import "HttpHelper.h"
@interface modetailViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UITableView  *invitationTableView;
@property UIButton *dianZanLabel;
@property NSNumber *aritcleId;

@property UIImageView *autherLogoView;
@property UILabel *autherNameLabel;
@property UILabel *timeLabel;
@property UILabel *titleLabel;
@property UILabel *zanNumberLabel;
@property UILabel *disNumberLabel;
@property UITextView *detailContent;
@property NSDictionary *data;
@property(strong,nonatomic)UIAlertView *alertView;

@property UITextView *editTextView;

@end
