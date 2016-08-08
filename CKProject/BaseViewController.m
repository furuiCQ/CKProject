//
//  BaseViewController.m
//  CKProject
//
//  Created by furui on 16/8/8.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController(){
    NSArray *dataArray;
}
@end
@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomNavItem];
}
/**
 *自定义标题栏
 */
-(void)initCustomNavItem
{
    //自定义电池栏 可遮盖或不遮盖
    UIView *topView=[[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [topView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [self.view addSubview:topView];
    
}
@end

