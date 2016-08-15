//
//  LoadingViewController.m
//  CKProject
//
//  Created by furui on 16/1/15.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "LoadingViewController.h"
#import "MainViewController.h"
#import "SortViewController.h"
#import "ViewController.h"

#import "MineViewController.h"

@interface LoadingViewController (){
    NSTimer *timer;
}

@end

@implementation LoadingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *mainView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mainView setImage:[UIImage imageNamed:@"main_loading.jpg"]];
   
    [self.view addSubview:mainView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(goMainViewController) userInfo:nil repeats:NO];
    
}
//[btnView setSelectColor:[UIColor colorWithRed:1 green:99.f/255.f blue:99.f/255.f alpha:1.0]];
//[btnView setUnSelectColor:[UIColor blackColor]];

-(void)goMainViewController{
        MainTabBarViewController *mtvc;
    
        NSArray *selectArray =[NSArray arrayWithObjects:@"main_select",@"news",@"sort_select",@"mine_select",nil];
        NSArray *unselectArray =[NSArray arrayWithObjects:@"main_unselect",@"news_normal",@"sort_unselect",@"mine_unselect",nil];
        NSArray *textArray =[NSArray arrayWithObjects:@"首页",@"新闻",@"分类",
                         @"我",nil];
        NSArray *viewControllerArray =[NSArray arrayWithObjects:[[MainViewController alloc]init],[[ViewController alloc]init],[[SortViewController alloc]init],[[MineViewController alloc]init],nil];
    
        mtvc=[[MainTabBarViewController alloc]init];
        NSMutableArray *vcArray=[[NSMutableArray alloc]init];
    
        for (int i=0; i<[textArray count]; i++) {
            UIViewController *vc=[viewControllerArray objectAtIndex:i];
            vc.tabBarItem.title=[textArray objectAtIndex:i];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
            vc.tabBarItem.image=[UIImage imageNamed:[unselectArray objectAtIndex:i]];
            vc.tabBarItem.selectedImage=[UIImage imageNamed:[selectArray objectAtIndex:i]];
            [vcArray addObject:vc];
        }
        [mtvc.tabBar setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
        mtvc.tabBar.selectedImageTintColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0];
        [mtvc setViewControllers:[vcArray copy]];
    [self presentViewController:mtvc animated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    timer=nil;
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
