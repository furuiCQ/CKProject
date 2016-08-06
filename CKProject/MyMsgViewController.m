//
//  MyMsgViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MyMsgViewController.h"

@interface MyMsgViewController ()<UITableViewDelegate>
{
    NSArray *dataArray;
    
}
@end

@implementation MyMsgViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize tabArray;
@synthesize tableView;
@synthesize hasMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self visibleTabBar];
    //[self initTopBar];
    [self initCotentView];
    
    dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                 nil];
    
    // Do any additional setup after loading the view, typically from a nib.
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;//
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"消息"];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}

-(void)initCotentView{
    
    int width=self.view.frame.size.width;
    //  int height=self.view.frame.size.height;
    
    NSArray *tableArray = [NSArray arrayWithObjects:@"系统消息",@"课程提醒", nil];
    
    for(int i=0;i<[tableArray count];i++){
        //我的报名记录
        UIControl *myRecord=[[UIControl alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5+width/6.5*i+i*0.5, width, width/6.5)];
        [myRecord setTag:i];
        [myRecord addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [myRecord setBackgroundColor:[UIColor whiteColor]];
        
        
        UILabel *recordLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, (width/6.5-width/22)/2, width/4, width/22)];
        [recordLabel setText:[tableArray objectAtIndex:i]];
        [recordLabel setTextColor:[UIColor grayColor]];
        [recordLabel setFont:[UIFont systemFontOfSize:width/22.8]];
        
        [myRecord addSubview:recordLabel];
        
        UIImageView *recordRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/45.7-width/21, (width/6.5-width/29)/2, width/45.7, width/29)];
        [recordRight setImage:[UIImage imageNamed:@"right_logo"]];
        [myRecord addSubview:recordRight];
        if (hasMsg && i==[tableArray count]-1) {
            UIView *pointView=[[UIView alloc]initWithFrame:CGRectMake(width-width/45.7-width/21-width/42-8, (width/6.5-8)/2, 8, 8)];
            
            [pointView setBackgroundColor:[UIColor redColor]];
            pointView.layer.masksToBounds = YES;
            pointView.layer.cornerRadius = (pointView.frame.size.width + 10) / 4;
            [myRecord addSubview:pointView];
        }
        
        
        [self.view addSubview:myRecord];
    }
}
-(void)onClick:(id)sender{
    UIControl *control=(UIControl*)sender;
    NSLog(@"个人中心列表点击中.....%ld",(long)control.tag);
    MsgViewController *msgViewControlle=[[MsgViewController alloc]init];
    switch (control.tag)
    {
        
        case 0:
        {
            [msgViewControlle setTopTitle:@"评论"];
            [msgViewControlle setFlag:0];
            
        }
            break;
        case 1:
        {
            [msgViewControlle setTopTitle:@"收藏的帖子"];
            [msgViewControlle setFlag:1];


        }
            break;
            
        case 2:
        {
            [msgViewControlle setTopTitle:@"系统消息"];
            [msgViewControlle setFlag:2];

            
        }
            break;

    }
    [self presentViewController:msgViewControlle animated:YES completion:nil];

}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}



@end
