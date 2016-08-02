//
//  SendInvitationViewController.h
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendInvitationViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UIImageView *chooseImageView;
@property UITextField *titleView;
@property UITextView *contentView;
@property NSNumber *circleId;
@property UIActivityIndicatorView *dicatorView;
@property(strong,nonatomic)UIAlertView *alertView;


@end