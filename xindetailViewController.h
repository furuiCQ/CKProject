//
//  xindetailViewController.h
//  CKProject
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface xindetailViewController : BaseViewController
@property NSNumber *aritcleId;
@property NSDictionary *data;
@property(strong,nonatomic)UIAlertView *alertView;

@property(strong,nonatomic)UIScrollView *imageScrollview;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)NSTimer *timer;
@property(nonatomic)NSInteger totalCount;
@end
