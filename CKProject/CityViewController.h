//
//  FavourableViewController.h
//  CKProject
//
//  Created by furui on 16/8/5.
//  Copyright © 2016年 furui. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CityViewController : UIViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UITableView *_tableView;

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@end
