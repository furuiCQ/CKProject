//
//  CircleViewController.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCustomTableCell.h"
#import "CircleListViewController.h"
#import "HttpHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface CircleViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;

@property int bottomHeight;
@property(strong,nonatomic)UITableView *circleTableView;



@end
