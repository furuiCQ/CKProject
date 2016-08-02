
//
//  ProjectDetailsViewController.h
//  CKProject
//
//  Created by furui on 15/12/6.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "OrganDetailsViewController.h"
#import "OrderViewController.h"
#import "AppDelegate.h"
//http://www.abcdll.cn/api/hotlesson
@interface ProjectDetailsViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UIButton *collectLabel;
@property NSNumber *projectId;

@property NSDictionary *data;
@property UIImageView *logoImageView;
@property UILabel *instituteNameLabel;
@property UILabel *numbLabel;
@property RatingBar *ratingBar;
@property UILabel *projectNameLabel;
@property UILabel *projectAddLabel;
@property UILabel *projectTimeLabel;
@property UIImageView *imageView;
@property UITextView *detailContentLabel;
@property UILabel *dateLabel;
@property UILabel *beginTimeLabel;

@property(strong,nonatomic)UIScrollView *imageScrollview;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)NSTimer *timer;
@property(nonatomic)NSInteger totalCount;


@property BOOL isCancel;
@property NSNumber *L_ID;
@property NSNumber *WEEK_ID;
@property NSNumber *WEEK_NUM;
@property NSString *ORDER_TIME;
-(void)setSelect;
@end
