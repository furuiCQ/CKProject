//
//  InvitationDetailsViewController.h
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitaitionTabelCell.h"
#import "HttpHelper.h"
#import "BaseViewController.h"

@interface InvitationDetailsViewController : BaseViewController
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