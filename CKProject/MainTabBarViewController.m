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
    [self visibleTabBar];
    [self initCustomTabBar];
    self.delegate=self;
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.selectIndex!=5) {
        self.selectedIndex=appDelegate.selectIndex;
    }else{
        self.selectedIndex=0;
        
    }
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}
- (IBAction) tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self selectedIndex];
    
    NSArray *aryViewController = self.viewControllers;
    
    if (selectedIndex < aryViewController.count - 1) {
        
        UIView *fromView = [self.selectedViewController view];
        UIView *toView = [[self.viewControllers objectAtIndex:selectedIndex + 1] view];
        
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            if (finished) {
                [self setSelectedIndex:selectedIndex + 1];
                [self setBarCheck:(int)(selectedIndex+1) ];

            }
        }];
    }
}

- (IBAction) tappedLeftButton:(id)sender
{
    
    NSUInteger selectedIndex = [self selectedIndex];
    
    if (selectedIndex > 0) {
        UIView *fromView = [self.selectedViewController view];
        
        UIView *toView = [[self.viewControllers objectAtIndex:selectedIndex - 1] view];
        
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            if (finished) {
                [self setSelectedIndex:selectedIndex - 1];
                [self setBarCheck:(int)(selectedIndex-1)];
            }
        }];
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
    [topView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [self.view addSubview:topView];
    
}
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectIndex = selectedIndex;
    _lastSelectedIndex=selectedIndex;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectIndex = tabIndex;
    
}
-(void)setBarCheck:(int)tag{
    for (NSObject *object in viewControllArray) {
        BottomBtn *b=(BottomBtn *)object;
        if(b.tag!=tag){
            [b unCheck];
        }else{
            [b isCheck];
        }
    }
}
-(void)onClick:(id)sender
{
    BottomBtn *btn=(BottomBtn *)sender;
    self.selectedIndex=btn.tag;
    if([btn.text isEqualToString:@""]){
        NSLog(@"点击按钮%ld",(long)btn.tag);
    }else{
        NSLog(@"点击底部按钮%ld",(long)btn.tag);
        for (NSObject *object in viewControllArray) {
            BottomBtn *b=(BottomBtn *)object;
            if(b.tag!=btn.tag){
                [b unCheck];
            }
        }
        [btn isCheck];
        [self setSelectedIndex:btn.tag];
        _lastSelectedIndex=btn.tag;

    }
    
}
-(void)initCustomTabBar
{
    [self initBottomBtn:self.tabBar.frame.size itemNumb:5];
}
-(void)initBottomBtn:(CGSize)size itemNumb:(int)numb

{
    NSArray *selectArray =[NSArray arrayWithObjects:@"main_select",@"news",@"junyouhui",@"sort_select",@"mine_select",nil];
    NSArray *unselectArray =[NSArray arrayWithObjects:@"main_unselect",@"news_normal",@"junyouhui_normal",@"sort_unselect",@"mine_unselect",nil];
    NSArray *textArray =[NSArray arrayWithObjects:@"首页",@"新闻",@"聚优惠",@"分类",
                         @"我",nil];
    
    
    
    bottomHeight=49;
    
    UIView *tabBarBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, bottomHeight)];
    [tabBarBackgroundView setBackgroundColor:[UIColor colorWithRed:242.f/255.f green:242.f/255.f  blue:242.f/255.f  alpha:1.0]];
    [self.view addSubview:tabBarBackgroundView];
    
    CGFloat btnwidth=size.width;
    CGFloat btnhegiht=size.height;
    
    UIFont *font=[UIFont fontWithName:@"iconfont" size:23];
    for (int i=0; i<numb; i++) {
        BottomBtn *btnView=[[BottomBtn alloc]initWithFrame:CGRectMake(btnwidth*i/numb+1, 1, btnwidth/numb, btnhegiht-2)];
        [btnView addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView setTag:i];
        [btnView setSelectIcon:[selectArray objectAtIndex:i]];
        [btnView setUnSelectIcon:[unselectArray objectAtIndex:i]];
        [btnView setText:[textArray objectAtIndex:i]];
        [btnView setSelectColor:[UIColor colorWithRed:1 green:99.f/255.f blue:99.f/255.f alpha:1.0]];
        [btnView setUnSelectColor:[UIColor blackColor]];
        
        
        [btnView setIconFont:font];
        [btnView setTextFont:[UIFont systemFontOfSize:self.view.frame.size.width/32]];
        [btnView initView];
        if(i==2){
            CGRect frame=btnView.iconLabel.frame;
            frame.size.width=self.view.frame.size.width/5.6;
            frame.size.height=frame.size.width;
            frame.origin.x=btnView.frame.size.width/2-frame.size.width/2;
            frame.origin.y=-self.view.frame.size.width/16;
            [btnView.iconLabel setFrame:frame];
        }
        if(i==_lastSelectedIndex){
            [btnView isCheck];
        }else{
            [btnView unCheck];
        }
        [tabBarBackgroundView addSubview:btnView];
        [viewControllArray addObject:btnView];
    }
    
}

@end