//
//  FavourableViewController.m
//  CKProject
//
//  Created by furui on 16/8/5.
//  Copyright © 2016年 furui. All rights reserved.
//
#import "FavourableCell.h"
#import "CustomTextField.h"
#import "SearchViewController.h"
#import "FavourableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FavourableViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSArray *dataArray;
    CustomTextField *searchField;
}
@end
@implementation FavourableViewController
@synthesize titleHeight;
@synthesize searchLabel;
@synthesize cityLabel;
@synthesize favourTableView;
@synthesize searchs;

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"数据加载中..."];

    [self initTitle];
    [self initContentView];
    [self getData];
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView  setUserInteractionEnabled:YES];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    
    //新建查询视图
    searchField=[[CustomTextField alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/6.8, titleHeight*2/16, self.view.frame.size.width-self.view.frame.size.width/6.8*2, titleHeight*3/4))];
    searchField.delegate=self;
    [searchField setBackgroundColor:[UIColor whiteColor]];
    [searchField.layer setCornerRadius:3.0f];
    [searchField setFont:[UIFont systemFontOfSize:15]];
    [searchField setPlaceholder:@"搜索你想蹭的课程"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30,titleHeight*3/4)];
    UIImageView *searchImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_logo"]];
    [searchImageView setFrame:CGRectMake(10, searchField.frame.size.height/2-17/2, 17, 17)];
    [view addSubview:searchImageView];
    [searchField setLeftView:view];
    [searchField setLeftViewMode:UITextFieldViewModeAlways];
    
    [titleView addSubview:searchField];
    [titleView addSubview:cityLabel];

    [self.view addSubview:titleView];
    
}

-(void)initContentView{
    titleHeight=44;
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    favourTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,20+titleHeight, width, height-(20+titleHeight))];
    favourTableView.dataSource=self;
    favourTableView.delegate=self;
    favourTableView.separatorStyle=NO;
    favourTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:favourTableView];
}

//监听输入框焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    SearchViewController *searchViewController=[[SearchViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.localNumber!=nil && ![myDelegate.localNumber isEqual:[NSNull null]]) {
        [searchViewController setAid:myDelegate.localNumber];
        
    }else{
        [searchViewController setAid:[NSNumber numberWithInt:500000]];
    }
    [self presentViewController: searchViewController animated:YES completion:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"CustomCell";
    FavourableCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FavourableCell"owner:self options:nil]lastObject];
    }
    NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
    if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
        NSString *title=[dic objectForKey:@"title"];
       [cell.activityLabel setText:[NSString stringWithFormat:@"%@",title]];
    }
    if ([dic objectForKey:@"insttitle"] && ![[dic objectForKey:@"insttitle"] isEqual:[NSNull null]]) {
        NSString *title=[dic objectForKey:@"insttitle"];
       [cell.orgName setText:[NSString stringWithFormat:@"%@",title]];
    }
    if ([dic objectForKey:@"biglogo"] && ![[dic objectForKey:@"biglogo"] isEqual:[NSNull null]]) {
        NSString *logo=[dic objectForKey:@"biglogo"];
        if (![logo isEqualToString:@""]) {
            [cell.logoView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
        }
        
    }
    
    if ([dic objectForKey:@"————etime"] && ![[dic objectForKey:@"————etime"] isEqual:[NSNull null]]) {
        NSNumber *btime=[dic objectForKey:@"btime"];
        NSInteger myInteger = [btime integerValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM月 dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        [cell.time2Label setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
        [cell.time1Label setText:[NSString stringWithFormat:@"%@",confromTimespStr]];

    }
    if ([dic objectForKey:@"reduce"] && ![[dic objectForKey:@"reduce"] isEqual:[NSNull null]]) {
        NSNumber *grade=[dic objectForKey:@"reduce"];
        [cell.nowPrice setText:[NSString stringWithFormat:@"￥%@",grade]];
    }
    if ([dic objectForKey:@"pay"] && ![[dic objectForKey:@"pay"] isEqual:[NSNull null]]) {
        NSNumber *grade=[dic objectForKey:@"pay"];
        NSString *oldStr=[NSString stringWithFormat:@"￥%@",grade];
        //中划线
       NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
        [cell.lastPrice setAttributedText:attribtStr];
    }

    if ([dic objectForKey:@"usenum"] && ![[dic objectForKey:@"usenum"] isEqual:[NSNull null]] &&
        [dic objectForKey:@"totalnum"] && ![[dic objectForKey:@"totalnum"] isEqual:[NSNull null]]) {
        NSNumber *usenum=[dic objectForKey:@"usenum"];
        NSNumber *totalnum=[dic objectForKey:@"totalnum"];
        [cell.progressLabel setText:[NSString stringWithFormat:@"%@/%@",usenum,totalnum]];
        [cell.progressView  setProgress:[usenum doubleValue]/[totalnum doubleValue]];
    }
    if ([dic objectForKey:@"url"] && ![[dic objectForKey:@"url"] isEqual:[NSNull null]]) {
        NSString *url=[dic objectForKey:@"url"];
      //  [cell.progressLabel setText:[NSString stringWithFormat:@"%@/%@",usenum,totalnum]];
    }
    NSNumber *pid=[dic objectForKey:@"pid"];
    switch ([pid intValue]) {//常规：1，抢购：2，团购：3
        case 1:
        {
            [cell.progressView setHidden:YES];
            [cell.time1Label setHidden:YES];
            [cell.time2Label setHidden:YES];
            [cell.progressLabel setHidden:YES];
            [cell.typeView setHidden:YES];
        }
            break;
        case 2:
        {
            [cell.progressView setHidden:YES];
            [cell.time1Label setHidden:YES];
            [cell.time2Label setHidden:NO];
            [cell.progressLabel setHidden:YES];
            [cell.typeView setImage:[UIImage imageNamed:@"qiang_logo"]];
        }
        break;
        case 3:
        {
            [cell.progressView setHidden:NO];
            [cell.time1Label setHidden:NO];
            [cell.time2Label setHidden:YES];
            [cell.progressLabel setHidden:NO];
            [cell.typeView setImage:[UIImage imageNamed:@"tuan_logo"]];
        }
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    // NSLog(@"高度:%f",cell.frame.size.height);
    return cell.frame.size.height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//获得优惠数据
-(void)getData{
    if(searchs){
        [searchLabel setText:[NSString stringWithFormat:@"搜索%@结果",searchs]];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper searchCoupon:searchs success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                       
                        dataArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [favourTableView reloadData];
                        });
                    }else{
                        
                    }
                    [ProgressHUD dismiss];
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [ProgressHUD dismiss];
                
            }];
            
            
        });
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper getCouponList:nil success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        myDelegate.model=model;
                        dataArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [favourTableView reloadData];
                            
                        });
                    }
                    [ProgressHUD dismiss];
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                    
                }
                [ProgressHUD dismiss];
                
            }];
            
            
        });
 
    }
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

