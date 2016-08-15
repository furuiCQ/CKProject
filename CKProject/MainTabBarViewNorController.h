//
//  MainTaberBarViewController.h
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//
#import "BottomBtn.h"
#import <UIKit/UIKit.h>

@interface  MainTabBarViewNorController : UITabBarController

@property(strong,nonatomic) NSMutableArray *viewControllArray;
@property int bottomHeight;
@property int selectId;
@end