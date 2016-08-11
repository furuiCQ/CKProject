//
//  SearchViewController.h
//  CKProject
//
//  Created by furui on 16/1/14.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "ProjectListViewController.h"
#import "BaseViewController.h"
@interface SearchViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)CustomTextField *cityLabel;
@property(strong,nonatomic)CustomTextField *searchField;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UIImageView *chooseImageView;
@property UITextView *contentView;
@property NSNumber *aid;
@end