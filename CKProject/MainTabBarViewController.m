//
//  MainTabBarViewController.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)
#import "MainTabBarViewController.h"
#import "AppDelegate.h"
@interface MainTabBarViewController()<UITabBarControllerDelegate>
{
    NSUInteger _lastSelectedIndex;

}
@end

@implementation MainTabBarViewController

@synthesize viewControllArray;
@synthesize bottomHeight;
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    viewControllArray=[[NSMutableArray alloc]init];
    [self initCustomNavItem];
    self.delegate=self;
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.selectIndex!=5) {
        self.selectedIndex=appDelegate.selectIndex;
    }else{
        self.selectedIndex=0;

    }

}

/**
 *  隐藏系统tabbar
 */
-(void)visibleTabBar
{
    for (UIView *view  in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]){
            [view setHidden:YES];
            break;
        }
    }
}
/**
 *自定义标题栏
 */
-(void)initCustomNavItem
{
    //自定义电池栏 可遮盖或不遮盖
    UIView *topView=[[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
}
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectIndex = selectedIndex;
   
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectIndex = tabIndex;
    
}

//-(void)onClick:(id)sender
//{
//    BottomBtn *btn=(BottomBtn *)sender;
//    self.selectedIndex=btn.tag;
//    if([btn.text isEqualToString:@""]){
//        NSLog(@"点击按钮%ld",(long)btn.tag);
//    }else{
//        NSLog(@"点击底部按钮%ld",(long)btn.tag);
//        for (NSObject *object in viewControllArray) {
//            BottomBtn *b=(BottomBtn *)object;
//            if(b.tag!=btn.tag){
//                [b unCheck];
//            }
//        }
//        [btn isCheck];
//    }
//
//}
//-(void)initCustomTabBar
//{
//    [self initBottomBtn:self.tabBar.frame.size itemNumb:4];
//}
//-(void)initBottomBtn:(CGSize)size itemNumb:(int)numb
//
//{
//    NSArray *selectArray =[NSArray arrayWithObjects:@"main_select",@"sort_select",@"circle_select",@"mine_select",nil];
//    NSArray *unselectArray =[NSArray arrayWithObjects:@"main_unselect",@"sort_unselect",@"circle_unselect",@"mine_unselect",nil];
//    NSArray *textArray =[NSArray arrayWithObjects:@"首页",@"分类",@"圈子",
//                         @"我",nil];
//    
//    
//    
//    bottomHeight=49;
//    
//    UIView *tabBarBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, bottomHeight)];
//    NSLog(@"======%f",self.navigationController.view.frame.size.height);
//    [tabBarBackgroundView setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:tabBarBackgroundView];
//    
//    CGFloat btnwidth=size.width;
//    CGFloat btnhegiht=size.height;
//   
//    UIFont *font=[UIFont fontWithName:@"iconfont" size:23];
//    UIColor *textColor=[UIColor blackColor];
//    
//    for (int i=0; i<numb; i++) {
//        BottomBtn *btnView=[[BottomBtn alloc]initWithFrame:CGRectMake(btnwidth*i/numb+1, 1, btnwidth/numb-2, btnhegiht-2)];
//        [btnView addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btnView setTag:i];
//        [btnView setSelectIcon:[selectArray objectAtIndex:i]];
//        [btnView setUnSelectIcon:[unselectArray objectAtIndex:i]];
//        [btnView setText:[textArray objectAtIndex:i]];
//        [btnView setSelectColor:[UIColor orangeColor]];
//        [btnView setUnSelectColor:[UIColor blackColor]];
//
//        
//        [btnView setIconFont:font];
//        [btnView setTextFont:[UIFont systemFontOfSize:15]];
//        [btnView initView];
//        if(i==0){
//            [btnView isCheck];
//        }else{
//            [btnView unCheck];
//        }
//        [tabBarBackgroundView addSubview:btnView];
//        [viewControllArray addObject:btnView];
//    }
//    
//}

@end