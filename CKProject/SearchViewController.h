//
//  SearchViewController.h
//  CKProject
//
//  Created by furui on 16/1/14.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListViewController.h"
@interface SearchViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UIImageView *chooseImageView;
@property UITextField *titleView;
@property UITextView *contentView;
@property NSNumber *aid;
@end