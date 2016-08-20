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
@interface LoadingViewController ()<UIAlertViewDelegate,YBMonitorNetWorkStateDelegate,UIScrollViewDelegate>{
    NSTimer *timer;
    int count;
    UIScrollView *imageScrollview;
    UIPageControl *pageControl;
    NSInteger totalCount;
}

@end

@implementation LoadingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    count=0;
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    UIImageView *mainView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [mainView setImage:[UIImage imageNamed:@"main_loading.jpg"]];
//    [self.view addSubview:mainView];
    // 设置代理
    [YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
    // 添加网络监听
    [[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
    [self initCustomNavItem];
    [self netWorkStateChanged];
    [self initImageScrollView];
}
-(void)initCustomNavItem
{
    //自定义电池栏 可遮盖或不遮盖
    UIView *topView=[[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [topView setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:88.f/255.f blue:90.f/255.f alpha:1.0]];
    [self.view addSubview:topView];
}
//轮播图片
-(void)initImageScrollView{
    //    图片中数
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;

    // totalCount = 1;
    imageScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, height-20)];
    //  CGRect bounds = scrollview.frame;  //获取界面区域
    // pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 30)];
    // pageControl.numberOfPages = totalCount;//总的图片页数
    //    图片的宽
    CGFloat imageW = imageScrollview.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = imageScrollview.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    NSArray *imageArray=[[NSArray alloc]initWithObjects:@"loading_one",@"loading_second",@"loading_three", nil];
     totalCount =imageArray.count;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = [imageArray objectAtIndex:i];
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        imageScrollview.showsHorizontalScrollIndicator = NO;
        if(i==2){
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(imageW/2-imageW/2.6/2, imageH-imageW/9.1-imageW/7.2, imageW/2.6, imageW/9.1)];
            [label setText:@"进入首页"];
            label.layer.masksToBounds=YES;
            [label.layer setCornerRadius:5];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:imageW/21.3]];
            [label setTextColor:[UIColor colorWithRed:252.f/255.f green:88.f/255.f blue:90.f/255.f alpha:1.0]];
            [imageView addSubview:label];
            UITapGestureRecognizer *gesre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFav)];
            [imageView setUserInteractionEnabled:YES];
            [imageView addGestureRecognizer:gesre];
        }
        [imageScrollview addSubview:imageView];
        
    }
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    imageScrollview.contentSize = CGSizeMake(contentW, 0);
    //    3.设置分页
    imageScrollview.pagingEnabled = YES;
    [imageScrollview setTag:2];
    
    //    4.监听scrollview的滚动
    imageScrollview.delegate = self;
    CGRect bounds = imageScrollview.frame;  //获取界面区域

    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.size.height+imageScrollview.frame.origin.y-imageW/9.1-imageW/7.2-imageW/32-30, bounds.size.width, 30)];
    pageControl.numberOfPages=totalCount;

    [self.view addSubview:imageScrollview];
    [self.view addSubview:pageControl];

}
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    if (uiScrollView.tag==2) {
        CGFloat scrollviewW =  uiScrollView.frame.size.width;
        CGFloat x = uiScrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        pageControl.currentPage = page;
//        if(pageControl.currentPage==2){
//            count++;
//            if(count==1){
//                [self addTimer];
//            }
//            
//        }
    }
}
///**
// *  开启定时器
// */
//- (void)addTimer{
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
//}
///**
// *  关闭定时器
// */
//- (void)removeTimer
//{
//    [timer invalidate];
//}
////加载下张图片
//- (void)nextImage
//{
//    [self showFav];
//}

#pragma mark 网络监听的代理方法，当网络状态发生改变的时候触发
- (void)netWorkStateChanged{
    
    // 获取当前网络类型
    BOOL network = [[YBMonitorNetWorkState shareMonitorNetWorkState] getNetWorkState];
    // 显示当前网络类型
    if(!network){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"暂无法访问蹭课信息，请检查网络是否正常连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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
                //[self removeTimer];
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
