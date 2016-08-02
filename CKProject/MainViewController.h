//
//  ViewController.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLocationManager.h"
#import "MainCustomTableCell.h"
#import "CustomTextField.h"
#import "MyMsgViewController.h"
#import "FVCustomAlertView.h"
#import "NSString+Extension.h"
#import "SearchViewController.h"

@interface MainViewController : UIViewController

@property(strong,nonatomic)CustomTextField *cityLabel;
@property(strong,nonatomic)CustomTextField *searchField;
@property(strong,nonatomic)UILabel *msgLabel;
@property(strong,nonatomic)UIScrollView *scrollview;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)NSTimer *timer;
@property(nonatomic)NSInteger totalCount;
@property(strong,nonatomic)UIView *searchView ;
@property(strong,nonatomic)UITextField *keyText;
@property(strong,nonatomic)UITableView *mainTableView;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UIView *pointView;
@property int titleHeight;
@property int bottomHeight;
@property(strong,nonatomic)NSMutableArray *db;

@end

