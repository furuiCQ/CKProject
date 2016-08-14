//
//  FavourableViewController.h
//  CKProject
//
//  Created by furui on 16/8/5.
//  Copyright © 2016年 furui. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FavourableViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UITableView *favourTableView;
@property NSString *searchs;

@end
