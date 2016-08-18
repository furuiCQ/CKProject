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
#import "FavourableViewController.h"
#import "MineViewController.h"
#import "YBMonitorNetWorkState.h"
#import "MainTabBarViewNorController.h"
@interface LoadingViewController ()<UIAlertViewDelegate,YBMonitorNetWorkStateDelegate>{
    NSTimer *timer;
    int count;
}

@end

@implementation LoadingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *mainView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mainView setImage:[UIImage imageNamed:@"main_loading.jpg"]];
    [self.view addSubview:mainView];
    // 设置代理
    [YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
    // 添加网络监听
    [[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
    
    [self netWorkStateChanged];
  //  [self showFav];
}
#pragma mark 网络监听的代理方法，当网络状态发生改变的时候触发
- (void)netWorkStateChanged{
    
    // 获取当前网络类型
    BOOL network = [[YBMonitorNetWorkState shareMonitorNetWorkState] getNetWorkState];
    // 显示当前网络类型
    if(!network){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"暂无法访问蹭课信息，请检查网络是否正常连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        if(count==0){
            [self showFav];
 
        }
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}

-(void)showFav{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper showCoupon:nil success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=model.result;
                NSString *str=[NSString stringWithFormat:@"%@",result];
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

                if([str isEqualToString:@"0"]){
                    [myDelegate setIsHasCoupon:NO];
                    [self goMainViewNormalController];
                }else{
                    [myDelegate setIsHasCoupon:YES];
                    [self goMainViewController];
                }
                count++;

            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
    });
}

-(void)goMainViewController{
    MainTabBarViewController *mtvc;
    NSArray *viewControllerArray =[NSArray arrayWithObjects:[[MainViewController alloc]init],[[ViewController alloc]init],[[SortViewController alloc]init],[[FavourableViewController alloc]init],[[MineViewController alloc]init],nil];
    mtvc=[[MainTabBarViewController alloc]init];
    [mtvc setViewControllers:[viewControllerArray copy]];
    [self presentViewController:mtvc animated:YES completion:nil];
}
-(void)goMainViewNormalController{
        MainTabBarViewNorController *mtvc;
    
        NSArray *selectArray =[NSArray arrayWithObjects:@"main_select",@"news",@"sort_select",@"mine_select",nil];
        NSArray *unselectArray =[NSArray arrayWithObjects:@"main_unselect",@"news_normal",@"sort_unselect",@"mine_unselect",nil];
        NSArray *textArray =[NSArray arrayWithObjects:@"首页",@"新闻",@"分类",
                         @"我",nil];
        NSArray *viewControllerArray =[NSArray arrayWithObjects:[[MainViewController alloc]init],[[ViewController alloc]init],[[SortViewController alloc]init],[[MineViewController alloc]init],nil];
    
        mtvc=[[MainTabBarViewNorController alloc]init];
        NSMutableArray *vcArray=[[NSMutableArray alloc]init];
    
        for (int i=0; i<[textArray count]; i++) {
            UIViewController *vc=[viewControllerArray objectAtIndex:i];
            vc.tabBarItem.title=[textArray objectAtIndex:i];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:1 green:99.f/255.f blue:99.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
            vc.tabBarItem.image=[UIImage imageNamed:[unselectArray objectAtIndex:i]];
            vc.tabBarItem.selectedImage=[UIImage imageNamed:[selectArray objectAtIndex:i]];
            [vcArray addObject:vc];
        }
        [mtvc.tabBar setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
        mtvc.tabBar.selectedImageTintColor=[UIColor colorWithRed:1 green:99.f/255.f blue:99.f/255.f alpha:1.0];
        [mtvc setViewControllers:[vcArray copy]];
    [self presentViewController:mtvc animated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
