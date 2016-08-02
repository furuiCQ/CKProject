//
//  OrganDetailsViewController.h
//  CKProject
//
//  Created by furui on 15/12/18.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "ProjectSimpleTableCell.h"
#import "ProjectDetailsViewController.h"
@interface OrganDetailsViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property NSNumber *aritcleId;

@property(strong,nonatomic)UITableView *projectTableView;

@property UIImageView *logoImage;
@property UILabel *organNamelabel;
@property UILabel *numbLabel;
@property RatingBar *ratingBar;
@property UILabel *projectAddLabel;
@property UITextView *contentLabel;


@end
