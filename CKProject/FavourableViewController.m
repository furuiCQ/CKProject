//
//  FavourableViewController.m
//  CKProject
//
//  Created by furui on 16/8/5.
//  Copyright © 2016年 furui. All rights reserved.
//
#import "FavourableCell.h"
#import "FavourableViewController.h"
@interface FavourableViewController(){
    NSArray *dataArray;
}
@end
@implementation FavourableViewController
@synthesize titleHeight;
@synthesize searchLabel;
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
    [self initContentView];
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];

    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"聚优惠"];
    [searchLabel setTextColor:[UIColor whiteColor]];
   
    
        [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}
-(void)initContentView{
    titleHeight=44;
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    //
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width/2.3)];
    [headerView setBackgroundColor:[UIColor colorWithRed:240.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    //限时抢购
    UIControl *control=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, width/2-0.2, width/3.5)];
    [control setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/32, width/12.8, control.frame.size.width/2, width/21.3)];
    [titleLabel setText:@"限时抢购"];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont systemFontOfSize:width/21.3]];
    [control addSubview:titleLabel];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/32, titleLabel.frame.size.height+titleLabel.frame.origin.y+width/32, control.frame.size.width/2, width/32)];
    [contentLabel setText:@"学习资料疯抢"];
    [contentLabel setTextColor:[UIColor grayColor]];
    [contentLabel setTextAlignment:NSTextAlignmentLeft];
    [contentLabel setFont:[UIFont systemFontOfSize:width/32]];
    [control addSubview:contentLabel];
    //4.9
    UIImageView *titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(control.frame.size.width-width/4.9, control.frame.size.height/2-width/4.9/2, width/4.9, width/4.9)];
    [titleImage setImage:[UIImage imageNamed:@"logo"]];
    [control addSubview:titleImage];
    [headerView addSubview:control];
    
    
    //优惠团购
    UIControl *control2=[[UIControl alloc]initWithFrame:CGRectMake(control.frame.origin.x+control.frame.size.width+0.2, 0, width/2-0.2, width/3.5)];
    [control2 setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *title2Label=[[UILabel alloc]initWithFrame:CGRectMake(width/32, width/12.8, control2.frame.size.width/2, width/27.8)];
    [title2Label setText:@"优惠团购"];
    [title2Label setTextAlignment:NSTextAlignmentLeft];
    [title2Label setFont:[UIFont systemFontOfSize:width/27.8]];
    [control2 addSubview:title2Label];
    
    UILabel *content2Label=[[UILabel alloc]initWithFrame:CGRectMake(width/32, title2Label.frame.size.height+title2Label.frame.origin.y+width/32, control2.frame.size.width/2, width/32)];
    [content2Label setText:@"约上闺蜜一起学"];
    [content2Label setTextColor:[UIColor grayColor]];
    [content2Label setTextAlignment:NSTextAlignmentLeft];
    [content2Label setFont:[UIFont systemFontOfSize:width/32]];
    [control2 addSubview:content2Label];
    //4.9
    UIImageView *title2Image=[[UIImageView alloc]initWithFrame:CGRectMake(control2.frame.size.width-width/4.9, control2.frame.size.height/2-width/4.9/2, width/4.9, width/4.9)];
    [title2Image setImage:[UIImage imageNamed:@"logo"]];
    [control2 addSubview:title2Image];
    [headerView addSubview:control2];
    
    
    //26.7
    //优惠团购
    UIControl *control3=[[UIControl alloc]initWithFrame:CGRectMake(0, control.frame.size.height+control.frame.origin.y+width/26.7, width, width/9.1)];
    [control3 setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *title3Label=[[UILabel alloc]initWithFrame:CGRectMake(width/32, control3.frame.size.height/2-width/29/2, control3.frame.size.width/2, width/29)];
    [title3Label setText:@"热门优惠"];
    [title3Label setTextAlignment:NSTextAlignmentLeft];
    [title3Label setFont:[UIFont systemFontOfSize:width/29]];
    [control3 addSubview:title3Label];
    
    UIImageView *clearRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/45.7-width/26, ( control3.frame.size.height-width/17.8)/2, width/26, width/17.8)];
    [clearRight setImage:[UIImage imageNamed:@"right_logo"]];
    [control3 addSubview:clearRight];
    
    UILabel *content3Label=[[UILabel alloc]initWithFrame:CGRectMake(width-width/29*2-clearRight.frame.size.width-width/45.7*2, ( control3.frame.size.height-width/29)/2,  width/29*2, width/29)];
    [content3Label setText:@"更多"];
    [content3Label setTextAlignment:NSTextAlignmentLeft];
    [content3Label setFont:[UIFont systemFontOfSize:width/29]];
    [control3 addSubview:content3Label];
    //4.9
    [headerView addSubview:control3];

    
    
    

    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,20+titleHeight, width, height-(20+titleHeight)) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource=self;
    tableView.delegate=self;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    tableView.showsVerticalScrollIndicator=NO;
    [tableView setTableHeaderView:headerView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"CustomCell";
    FavourableCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FavourableCell"owner:self options:nil]lastObject];
    }
   // [cell.titleLabel setText:[dataArray objectAtIndex:[indexPath row]]];
    [cell.titleLabel setText:@"123"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    // NSLog(@"高度:%f",cell.frame.size.height);
    return cell.frame.size.height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end

