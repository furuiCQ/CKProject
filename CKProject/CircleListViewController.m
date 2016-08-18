//
//  CircleListViewController.m
//  CKProject
//
//  Created by furui on 15/12/8.
//  Copyright © 2015年 furui. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)

#import "ProjectTableCell.h"
#import "CircleListViewController.h"
#import "UILabel+StringFrame.h"
#import "LoginRegViewController.h"
#import "HttpHelper.h"
@interface CircleListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableArray;
    UIImageView *addImageView;
    UIView *titleView;
    UIView *vi;
}

@end

@implementation CircleListViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize tableView;
@synthesize bottomHeight;
@synthesize circleId;
@synthesize titleName;
@synthesize topLabel;
@synthesize topLabel1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [ProgressHUD show:@"加载中..."];
   vi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,44+self.view.frame.size.width/3.5+self.view.frame.size.width/7.6*2-40)];
//    vi.backgroundColor=[UIColor greenColor];
    [self.view addSubview:vi];
//    
    
    
    tableArray = [[NSArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSuccess) name:@"send" object:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initTitle];
    [self initContentView];
    [self initTopView];
    [self initTableView];
    [self initBottomView];
    [self getTopArtcile];
    [self getArtcileList];
    
    // Do any additional setup after loading the view, typically from a nib.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
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
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setText:titleName];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    addImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                             0, self.view.frame.size.width, width/3.5)];
    [addImageView setImage:[UIImage imageNamed:@"circle_defalut"]];
    [vi addSubview:addImageView];
    
    
}
-(void)initTopView{
    int width=self.view.frame.size.width;
    
    UIControl *control=[[UIControl alloc]initWithFrame:CGRectMake(0, addImageView.frame.origin.y+addImageView.frame.size.height, width, width/7.6)];
    [control addTarget:self action:@selector(topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [control setBackgroundColor:[UIColor whiteColor]];
    [control setTag:1];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, width/22.8, width/32*3, width/22.8)];
    [label setText:@"置顶"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:width/32]];
    [label setTextColor:[UIColor colorWithRed:245.f/255.f green:63.f/255.f blue:153.f/255.f alpha:1.0]];
    label.layer.masksToBounds=YES;
    [label.layer setBorderWidth:1];
    [label.layer setCornerRadius:3];
    [label.layer setBorderColor:[UIColor colorWithRed:245.f/255.f green:63.f/255.f blue:153.f/255.f alpha:1.0].CGColor];
    [control addSubview:label];
    
    topLabel=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+width/22.8, label.frame.origin.y, width*2/3, width/22.8)];
    
    [topLabel setText:@""];
    [topLabel setTextAlignment:NSTextAlignmentLeft];
    [topLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [topLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    [control addSubview:topLabel];
    
    
    
    [vi addSubview:control];
    
    UIControl *control1=[[UIControl alloc]initWithFrame:CGRectMake(0, control.frame.origin.y+control.frame.size.height, width, width/7.6)];
    [control1 setTag:2];
    [control1 addTarget:self action:@selector(topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [control1 setBackgroundColor:[UIColor whiteColor]];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, width/22.8, width/32*3, width/22.8)];
    [label1 setText:@"置顶"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:width/32]];
    [label1 setTextColor:[UIColor colorWithRed:245.f/255.f green:63.f/255.f blue:153.f/255.f alpha:1.0]];
    label1.layer.masksToBounds=YES;
    [label1.layer setBorderWidth:1];
    [label1.layer setCornerRadius:3];
    [label1.layer setBorderColor:[UIColor colorWithRed:245.f/255.f green:63.f/255.f blue:153.f/255.f alpha:1.0].CGColor];
    [control1 addSubview:label1];
    
    topLabel1=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+width/22.8, label.frame.origin.y, width*2/3, width/22.8)];
    
    [topLabel1 setText:@""];
    [topLabel1 setTextAlignment:NSTextAlignmentLeft];
    [topLabel1 setFont:[UIFont systemFontOfSize:width/22.8]];
    [topLabel1 setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    [control1 addSubview:topLabel1];
    
    
    
    [vi addSubview:control1];
    
}
-(void)topBtn:(id)sender{
    UIControl *control=( UIControl *)sender;
    NSNumber *aritcleId;
    switch (control.tag) {
        case 1:
        {
            aritcleId=[NSNumber numberWithInt:(int)topLabel.tag];
        }
            break;
        case 2:
        {
            aritcleId=[NSNumber numberWithInt:(int)topLabel1.tag];
            
        }
            break;
        default:
            break;
    }
    InvitationDetailsViewController *detailsViewController=[[InvitationDetailsViewController alloc]init];
    [detailsViewController setAritcleId:aritcleId];
    [self presentViewController:detailsViewController animated:YES completion:nil];
    
    
}
-(void)initTableView{
    int width=self.view.frame.size.width;
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                          80,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height-(width/3.5))];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.dataSource                        = self;
    tableView.delegate                          = self;
    tableView.rowHeight                         = self.view.bounds.size.height/7;
    tableView.tableHeaderView=vi;
//    tableView.tableHeaderView=
    [self.view addSubview:tableView];
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    return [tableArray count];
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    int width=self.view.frame.size.width;
    if ([tableArray count]>0) {
        NSLog(@"indexPath.row%ld",(long)indexPath.row);
        NSDictionary *dic=[tableArray objectAtIndex:indexPath.row];
        NSString *title=[dic objectForKey:@"title"];
        NSString *stitle=[dic objectForKey:@"stitle"];
        NSNumber *people=[dic objectForKey:@"people"];
        NSNumber *created=[dic objectForKey:@"created"];
        NSString *username=[dic objectForKey:@"username"];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, width/23, width, width/22.8)];
        [titleLabel setText:@"中国文学大典"];
        if (title) {
            [titleLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        
        [titleLabel setFont:[UIFont systemFontOfSize:width/22.8]];
        [titleLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
        
        [cell addSubview:titleLabel];
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, width/23+width/22.8+width/45.7, width, width/29)];
        [contentLabel setText:@"热爱文学，四书五经，中国文学大典"];
        if (stitle!=nil && ![stitle isEqual:[NSNull null]]) {
            [contentLabel setText:[NSString stringWithFormat:@"%@",stitle]];
        }
        [contentLabel setFont:[UIFont systemFontOfSize:width/29]];
        [contentLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
        [cell addSubview:contentLabel];
        
        
        UILabel *autherLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, width/23+width/22.8+width/45.7+width/29+width/35.6, width/32*3, width/32)];
        [autherLabel setText:@"云蒙蒙"];
        if (username!=nil && ![username isEqual:[NSNull null]]) {
            [autherLabel setText:[NSString stringWithFormat:@"%@",username]];
            CGSize strSize=[username sizeWithFont:[UIFont systemFontOfSize:width/32] maxSize:CGSizeMake(width, 0)];
            [autherLabel setFrame:CGRectMake(width/14.5, width/23+width/22.8+width/45.7+width/29+width/35.6, strSize.width, width/32)];
            
        }
        [autherLabel setFont:[UIFont systemFontOfSize:width/32]];
        [autherLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [cell addSubview:autherLabel];
        
        UIImageView *pinglunImageView=[[UIImageView alloc]initWithFrame:CGRectMake(autherLabel.frame.origin.x+autherLabel.frame.size.width+width/35.6, autherLabel.frame.origin.y, width/32, width/32)];
        [pinglunImageView setImage:[UIImage imageNamed:@"discuss_logo"]];
        [cell addSubview:pinglunImageView];
        
        UILabel *discussLabel=[[UILabel alloc]initWithFrame:CGRectMake(pinglunImageView.frame.origin.x+pinglunImageView.frame.size.width+width/128, pinglunImageView.frame.origin.y, width/32*3, width/32)];
        [discussLabel setText:@"150"];
        if (people) {
            [discussLabel setText:[NSString stringWithFormat:@"%d",[people intValue]]];
        }
        [discussLabel setFont:[UIFont systemFontOfSize:width/32]];
        [discussLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [cell addSubview:discussLabel];
        
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/32*5-width/14, pinglunImageView.frame.origin.y, width/32*5, width/32)];
        [timeLabel setText:@"30分钟前"];
        if(created!=nil && ![created isEqual:[NSNull null]]){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSString *timeString=[f stringFromNumber:created];
            NSString *time=[self compareCurrentTime:timeString];
            CGSize strSize=[time sizeWithFont:[UIFont systemFontOfSize:width/32] maxSize:CGSizeMake(width, 0)];
            [timeLabel setFrame:CGRectMake(width-strSize.width-width/14, pinglunImageView.frame.origin.y, strSize.width, width/32)];
            
            [timeLabel setText:[NSString stringWithFormat:@"%@",time]];
        }
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont systemFontOfSize:width/32]];
        [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [cell addSubview:timeLabel];
        
        
        
        CGRect frame=cell.frame;
        frame.size.height=width/4;
        [cell setFrame:frame];
        
        
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    InvitationDetailsViewController *detailsViewController=[[InvitationDetailsViewController alloc]init];
    NSDictionary *dic=[tableArray objectAtIndex:indexPath.row];
    NSNumber *aritcleId=[dic objectForKey:@"id"];
    [detailsViewController setAritcleId:aritcleId];
    [self presentViewController:detailsViewController animated:YES completion:nil];
}
-(void)initBottomView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIImageView *addView=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/8.4-width/8.9, hegiht-width/8.4-width/13.3, width/8.4, width/8.4)];
    UITapGestureRecognizer *geuseture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSendInvitation)];
    [addView addGestureRecognizer:geuseture];
    [addView setUserInteractionEnabled:YES];
    [addView setImage:[UIImage imageNamed:@"add_logo"]];
    [self.view addSubview:addView];
}
-(void)goSendInvitation
{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    SendInvitationViewController*sendInvitationViewController=[[SendInvitationViewController alloc]init];
    [sendInvitationViewController setCircleId:circleId];
    [self presentViewController:sendInvitationViewController animated:YES completion:nil];
}
-(void)getTopArtcile{
    static NSString * const DEFAULT_LOCAL_AID = @"500000";
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getTopArticle:aid withCircleId:circleId success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *result=(NSDictionary *)model.result;
                        NSString *img=[result objectForKey:@"img"];
                        if (![img isEqual:@""] && img!=nil && ![img isEqual:[NSNull null]]) {
                            [addImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:img]]];
                            UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openChorme:)];
                            [addImageView addGestureRecognizer:openChorme];
                        }
                        NSArray *arry=[result objectForKey:@"top"];
                        NSDictionary *dict1=nil;
                        if ([arry count]>0) {
                            NSDictionary *dict0=[arry objectAtIndex:0];
                            if([arry count]>1){
                            dict1=[arry objectAtIndex:1];
                            }
                            
                            if (dict0) {
                                NSString *title=[dict0 objectForKey:@"title"];
                                NSString *number=[dict0 objectForKey:@"id"];

                                [topLabel setTag:[number intValue]];
                                [topLabel setText:[NSString stringWithFormat:@"%@",title]];
                            }
                            if (dict1) {
                                NSString *title=[dict1 objectForKey:@"title"];
                                NSString *number=[dict0 objectForKey:@"id"];
                                [topLabel1 setTag:[number intValue]];
                                [topLabel1 setText:[NSString stringWithFormat:@"%@",title]];
                            }
                            
                            
                        }
                        
                    });
                    
                    
                    
                }else{
                    
                }
              //  [ProgressHUD dismiss];
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
           // [ProgressHUD dismiss];

        }];
        
        
    });
}
-(void)openChorme:(UITapGestureRecognizer *)gesutre{
  //  int index=(int)gesutre.view.tag;
//   NSDictionary *dic=[list objectAtIndex:index];
//    NSString *url=[dic objectForKey:@"url"];
//   if (![url isEqual:@""] && url!=nil && ![url isEqual:[NSNull null]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://"stringByAppendingString:url ]]];
//    }
    
}
-(void)getArtcileList{
    static NSString * const DEFAULT_LOCAL_AID = @"500000";
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getArticleList:aid withCircleId:circleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    tableArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [tableView reloadData];
                    });
                    
                    
                }else{
                    
                }
             //   [ProgressHUD dismiss];

                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        //    [ProgressHUD dismiss];

        }];
        
        
    });
}

-(NSString *) compareCurrentTime:(NSString*) compareString
//
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSNumberFormatter *fomate=[[NSNumberFormatter alloc]init];
    NSNumber *number=[fomate numberFromString:compareString];
    NSInteger myInteger = [number integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
    
    
    NSTimeInterval  lastInterval = [confromTimesp timeIntervalSince1970];
    NSTimeInterval  nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval=nowInterval-lastInterval;
    long temp = 0;
    NSString *result;
   
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%ld秒前",temp];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else {
        NSNumberFormatter *fomate=[[NSNumberFormatter alloc]init];
        NSNumber *number=[fomate numberFromString:compareString];
        NSInteger myInteger = [number integerValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        result=confromTimespStr;
      
    }
    
    
    return  result;
}
-(void)sendSuccess{
    [self getArtcileList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end