//
//  xindetailViewController.m
//  CKProject
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "xindetailViewController.h"
#import "InvitaitionTabelCell.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginRegViewController.h"
#import "RJShareView.h"
#import "ScaleImgViewController.h"
#import "ProgressHUD.h"
#define swidth self.view.frame.size.width
#define sheight self.view.frame.size.height
@interface xindetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *lt;
    UILabel *read;
    CGFloat titleHeight;
    UILabel *cityLabel;
    UILabel *searchLabel;
    UILabel *msgLabel;
    UIView *titleView;
    UIScrollView *sb;
    UITextView *editTextView;
    UITextView *tv;
    UILabel *zanNumberLabel;
    UILabel *disNumberLabel;
    UITableView *tab;
    NSArray *tableArray;
    UILabel *lab;
    UILabel *writer;
    UILabel *timers;
    UIImageView *mg;
    UIButton *zanImageView;
    UILabel *lb;
    UIView *bottomView;
    UILabel *lp;
}

@end

@implementation xindetailViewController
@synthesize aritcleId;
@synthesize alertView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableArray=[[NSArray alloc]init];
    [self initTitle];
    [self mainview];
    [self initBottomView];
    [self getCommectsList];
    [self getArticleInfo];

  
    // Do any additional setup after loading the view.
}


-(void)sendeCommects{
    [ProgressHUD show:@"评论提交中..."];
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper sendXinwenComments:aritcleId withContext:editTextView.text withModel:myDelegate.model
                               success:^(HttpModel *model){
                                   
                                   NSLog(@"%@",model.message);
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self getCommectsList];
                                           });
                                           
                                       }else{
                                           
                                       }
                                       [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
                                       [ProgressHUD dismiss];
                                       [alertView setMessage:model.message];
                                       [alertView show];
                                       
                                   });
                               }failure:^(NSError *error){
                                   if (error.userInfo!=nil) {
                                       NSLog(@"%@",error.userInfo);
                                   }
                               }];
        
        
    });
    
}

//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
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
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"新闻详情"];
    //分享
        //新建右上角的图形
        msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
        msgLabel.userInteractionEnabled=YES;///
//        UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
//        [msgLabel addGestureRecognizer:shareGesutre];
        UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
        [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/12.3/2, titleHeight/2-self.view.frame.size.width/12.3/2, self.view.frame.size.width/12.3, self.view.frame.size.width/12.3)];
        [msgLabel addSubview:shareView];
        [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
        [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)mainview{
    sb=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height+titleView.frame.origin.y, swidth, sheight/1.2)];
    sb.contentSize=CGSizeMake(swidth,sb.frame.size.height*5);
    sb.backgroundColor=[UIColor clearColor];
    lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, swidth, sheight/10)];
    lab.numberOfLines=0;
    lab.text=@"";
    lab.font=[UIFont systemFontOfSize:swidth/18];
    lab.textAlignment=NSTextAlignmentCenter;
    
    writer=[[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.size.height+lab.frame.origin.y, swidth/5, swidth/14)];
    writer.text=@"";
    writer.font=[UIFont systemFontOfSize:swidth/25];
    timers=[[UILabel alloc]initWithFrame:CGRectMake(writer.frame.origin.x+writer.frame.size.width+swidth/9,lab.frame.size.height+lab.frame.origin.y, swidth/4, swidth/14)];
    timers.font=[UIFont systemFontOfSize:swidth/25];
    timers.text=@"";
    timers.textColor=[UIColor grayColor];
   lt=[[UILabel alloc]initWithFrame:CGRectMake(0, writer.frame.size.height+writer.frame.origin.y, swidth, 0.2)];
    lt.backgroundColor=[UIColor grayColor];
    //图片
   mg=[[UIImageView alloc]initWithFrame:CGRectMake(0, lt.frame.size.height+lt.frame.origin.y+4, swidth, sb.frame.size.height/4)];
    
    [mg setImage:[UIImage imageNamed:@""]];
    
    //新闻内容
    tv=[[UITextView alloc]initWithFrame:CGRectMake(0, mg.frame.origin.y+mg.frame.size.height+5 , swidth , sheight)];
//    NSUserDefaults *kp=[NSUserDefaults standardUserDefaults];
//    NSString *st=[kp objectForKey:@"cpn"];
    tv.text=@"";
//    tv.scrollEnabled=NO;
    tv.editable=NO;
    tv.backgroundColor=[UIColor whiteColor];
    tv.textAlignment=NSTextAlignmentLeft;
    tv.font=[UIFont systemFontOfSize:swidth/25];
//    detailContentLabel=[[UITextView alloc]initWithFrame:CGRectMake(width/40, detailLabel.frame.size.height+detailLabel.frame.origin.y+width/35.5,  width-width/40-width/40, hegiht/5)];
//    [detailContentLabel setText:@""];
//    detailContentLabel.editable=NO;
//    [detailContentLabel setTextAlignment:NSTextAlignmentLeft];
    [tv setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [tv setFont:[UIFont systemFontOfSize:swidth/26.7]];
   
    zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(swidth/40, tv.frame.origin.y+tv.frame.size.height+swidth/45.7, swidth/32, swidth/32)];
    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
    // [zanImageView setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateSelected];
    // [zanImageView addTarget:self action:@selector(zanOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sb addSubview:zanImageView];
    
    zanNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(zanImageView.frame.origin.x+zanImageView.frame.size.width+swidth/53, tv.frame.origin.y+tv.frame.size.height+swidth/45.7, swidth/32*2, swidth/32)];
    [zanNumberLabel setText:@"50"];
    [zanNumberLabel setFont:[UIFont systemFontOfSize:swidth/32]];
    [zanNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [sb addSubview:zanNumberLabel];
    
    
    read=[[UILabel alloc]initWithFrame:CGRectMake(zanNumberLabel.frame.origin.x+zanNumberLabel.frame.size.width+swidth/20, tv.frame.origin.y+tv.frame.size.height+swidth/45.7, swidth/8, swidth/32)];
    read.text=@"阅读数：";
    [read setFont:[UIFont systemFontOfSize:swidth/32]];
//    UIImageView *disImageView=[[UIImageView alloc]initWithFrame:CGRectMake(zanNumberLabel.frame.origin.x+zanNumberLabel.frame.size.width+swidth/20, tv.frame.origin.y+tv.frame.size.height+swidth/45.7, swidth/32, swidth/32)];
//    [disImageView setImage:[UIImage imageNamed:@"discuss_logo"]];
    [sb addSubview:read];
    
    disNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(read.frame.origin.x+read.frame.size.width+swidth/53, tv.frame.origin.y+tv.frame.size.height+swidth/45.7, swidth/32*3, swidth/32)];
    [disNumberLabel setText:@"25"];
    [disNumberLabel setFont:[UIFont systemFontOfSize:swidth/32]];
    [disNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [sb addSubview:disNumberLabel];
  
    lb=[[UILabel alloc]initWithFrame:CGRectMake(0, disNumberLabel.frame.size.height+disNumberLabel.frame.origin.y+2, swidth, 0.2)];
    lb.backgroundColor=[UIColor grayColor];
    lp=[[UILabel alloc]initWithFrame:CGRectMake(swidth/33, lb.frame.origin.y+lb.frame.size.height+5, swidth/5, swidth/28)];
    lp.text=@"评价";
    [lp setFont:[UIFont systemFontOfSize:swidth/22]];
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, lp.frame.size.height+lp.frame.origin.y+3, swidth, sheight)];
    tab.backgroundColor=[UIColor clearColor];
    tab.delegate=self;
    tab.dataSource=self;
    tab.rowHeight                         = self.view.bounds.size.height/5;
    tab.separatorStyle = UITableViewCellSelectionStyleNone;
    //下拉刷新
    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor grayColor]];
    
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [tab addSubview:_refreshControl];
    
    
    [sb addSubview:lab];
    [sb addSubview:writer];
    [sb addSubview:timers];
    [sb addSubview:lt];
    [sb addSubview:mg];
    [sb addSubview:tv];
    [sb addSubview:lb];
    [sb addSubview:lp];
    [sb addSubview:tab];
    [self.view addSubview:sb];




} 
- (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    CGSize textViewSize = [tv sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    
    
    return textViewSize;
}






-(void) refreshView:(UIRefreshControl *)refresh
{
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新日期 %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [self getArticleInfo];
    [self getCommectsList];
    [tab reloadData];
    [refresh endRefreshing];
}

//底部视图
-(void)initBottomView{
    
  
    int width=self.view.frame.size.width;
    
   bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-width/6.5, width, width/6.5-0.5)];
    [bottomView setTag:1000];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *disImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/18, width/20, width/22.8)];
    [disImageView setImage:[UIImage imageNamed:@"discuss_logo"]];
    [bottomView addSubview:disImageView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/20+width/53, width/17.8, width/24.6*2, width/24.6)];
    [label setText:@"评论"];
    [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:width/24.6]];
    [bottomView addSubview:label];
    
    editTextView=[[UITextView alloc]initWithFrame:CGRectMake(width/40+width/20+width/53+width/24.6*2
                                                             +width/22.8, width/29, width*5/8, width/10)];
    [editTextView setText:@"说点什么吧"];
    [editTextView setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    editTextView.layer.masksToBounds=YES;
    [editTextView setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
    editTextView.layer.cornerRadius=3.f;
    editTextView.delegate=self;
    [bottomView addSubview:editTextView];
    
    UILabel *sendDisLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/22.8-width/24.6*2, width/17.8, width/24.6*2, width/24.6)];
    UITapGestureRecognizer *gesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendeCommects)];
    [sendDisLabel addGestureRecognizer:gesutre];
    [sendDisLabel setUserInteractionEnabled:YES];
    [sendDisLabel setText:@"发布"];
    [sendDisLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [sendDisLabel setTextColor:[UIColor colorWithRed:233.f/255.f green:106.f/255.f blue:71.f/255.f alpha:1.0]];
    [sendDisLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:sendDisLabel];
    
    
    [self.view addSubview:bottomView];
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self];
    }];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect8=bottomView.frame;
    rect8.origin.y=sheight-350;
    [bottomView setFrame:rect8];
    editTextView.text=nil;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [editTextView resignFirstResponder];
    CGRect rect8=bottomView.frame;
    rect8.origin.y=self.view.frame.size.height-swidth/6.5;
    [bottomView setFrame:rect8];
    

}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tab cellForRowAtIndexPath:indexPath];
    
    return 100;
    
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    //  KCContactGroup *group1=_contacts[section];
    return [tableArray count];
}
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}
#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    InvitaitionTabelCell *cell=[[InvitaitionTabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([tableArray count]>0) {
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        [cell setData:dic];
        if ([dic objectForKey:@"uimg"] && ![[dic objectForKey:@"uimg"] isEqual:[NSNull null]]) {
            [cell.logoView  sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"uimg"]]]];
        }
        if ([dic objectForKey:@"username"] && ![[dic objectForKey:@"username"] isEqual:[NSNull null]] ) {
            [cell.userName  setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]]    ];
        }
        if ([dic objectForKey:@"created"] && ![[dic objectForKey:@"created"] isEqual:[NSNull null]]) {
            NSNumber *number=[dic objectForKey:@"created"];
            NSInteger myInteger = [number integerValue];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            [cell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
            
        }
      
        
        if ([dic objectForKey:@"content"] && ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
            [cell.contextView  setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
        }
        
        
        if([dic objectForKey:@"zan"] && ![[dic objectForKey:@"zan"] isEqual:[NSNull null]]){
            NSNumber *zanStaues=[dic objectForKey:@"zan"];
            if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                cell.dianZanLabel.selected=false;
            }else{
                cell.dianZanLabel.selected=true;
            }
        }
        
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123456789");


}
-(void)getCommectsList{
    [editTextView resignFirstResponder];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getArticleCommectsList:aritcleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        tableArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //    imi.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"   "]]];
                            
                            
                            
                            
                            [tab reloadData];
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
            
            [HttpHelper getArticleCommectsList:aritcleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        tableArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //    imi.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"   "]]];
                            
                            
                            
                            
                            [tab reloadData];
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
    }
    
    
}
//获取前方数据
-(void)getArticleInfo{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getXinwenInfo:aritcleId success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
//                            data=dic;
                            
                            
                            if ([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
                                [lab setText:[dic objectForKey:@"title"]];
                            }
                            if ([dic objectForKey:@"created"]&& ![[dic objectForKey:@"created"] isEqual:[NSNull null]]) {
                                NSNumber *number=[dic objectForKey:@"created"];
                                NSInteger myInteger = [number integerValue];
                                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateStyle:NSDateFormatterMediumStyle];
                                [formatter setTimeStyle:NSDateFormatterShortStyle];
                                [formatter setDateFormat:@"YYYY-MM-dd"];
                                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                                [formatter setTimeZone:timeZone];
                                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
                                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                                [timers setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                                
                            }
                     
                            
                            if([dic objectForKey:@"zan"]){
                                NSString *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"read"]){
                                NSNumber *number=[dic objectForKey:@"read"];
                                NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"content"]){
                                [tv setText:[dic objectForKey:@"content"]];
                                CGRect frame=tv.frame;
                                frame.size.height=tv.contentSize.height+30;
                                [tv setFrame:frame];
                                //赞的数值
                                CGRect rect=zanImageView.frame;
                                rect.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [zanImageView setFrame:rect];
                                //
//                                zanNumberLabel
                                CGRect rect1=zanNumberLabel.frame;
                                rect1.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [zanNumberLabel setFrame:rect1];
//                                read
                                CGRect rect2=read.frame;
                                rect2.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [read setFrame:rect2];
//                                阅读数
                             
                                CGRect rect3=disNumberLabel.frame;
                                rect3.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [disNumberLabel setFrame:rect3];
//                                lb，lp
                                CGRect rect4=lb.frame;
                                rect4.origin.y=disNumberLabel.frame.origin.y+disNumberLabel.frame.size.height+8;
                                [lb setFrame:rect4];
//                                lppingjia
                                
                                CGRect rect5=lp.frame;
                                rect5.origin.y=lb.frame.origin.y+lb.frame.size.height+8;
                                [lp setFrame:rect5];
//                                
                                CGRect rect6=tab.frame;
                                rect6.origin.y=lp.frame.origin.y+lp.frame.size.height+4;
                                [tab setFrame:rect6];
                                //滚动的长度
                                CGRect rect7=sb.frame;
                                
                                rect7.size.height=tab.frame.origin.y+tab.frame.size.height;
                                //                                [sb setFrame:rect7];
                                [sb setContentSize:CGSizeMake(swidth, rect7.size.height-swidth/2)];
                            }
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                                NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
                                mg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                                
                            }
                            //                              NSString *sb=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90", [dic objectForKey:@"img"]];
                            //                            NSURL *url=[NSURL URLWithString:sb];
                            //
                            //
                            //                            [imi setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
                            //
                            

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
            
            [HttpHelper getXinwenInfo:aritcleId success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
//                            data=dic;
                            
                            
                            
                            
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                                NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
                                mg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                                mg.contentMode=UIViewContentModeScaleToFill;
                                CGRect rect=mg.frame;
                               rect.origin.y=lt.frame.origin.y+lt.frame.size.height+2;
                                rect.size.height=mg.intrinsicContentSize.height;
////                              rect.size.height=sb.frame.size.height/3;
                                [mg setFrame:rect];
                                //
                                CGRect rect1=tv.frame;
                                rect1.origin.y=mg.frame.origin.y+mg.frame.size.height;
                              rect1.size.height=  tv.contentSize.height;
                                [tv setFrame:rect1];
                                
                            }
                            
                            
//                            if ([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
//                                [autherNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
//                            }
                            if ([dic objectForKey:@"created"]&& ![[dic objectForKey:@"created"] isEqual:[NSNull null]]) {
                                NSNumber *number=[dic objectForKey:@"created"];
                                NSInteger myInteger = [number integerValue];
                                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateStyle:NSDateFormatterMediumStyle];
                                [formatter setTimeStyle:NSDateFormatterShortStyle];
                                [formatter setDateFormat:@"YYYY-MM-dd"];
                                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                                [formatter setTimeZone:timeZone];
                                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
                                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                                [timers setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                                
                            }
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [lab setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            
                            if([dic objectForKey:@"zan"]){
                                NSNumber *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number  ]];
                            }
                            if([dic objectForKey:@"read"]){
                                NSNumber *number=[dic objectForKey:@"read"];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                            }
                            if([dic objectForKey:@"content"]){
                                [tv setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                                CGRect frame=tv.frame;
                                frame.size.height=tv.contentSize.height+30;
                                [tv setFrame:frame];
                                //赞的数值
                                CGRect rect=zanImageView.frame;
                                rect.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [zanImageView setFrame:rect];
                                //
                                CGRect rect1=zanNumberLabel.frame;
                                rect1.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [zanNumberLabel setFrame:rect1];
                                //                                read
                                CGRect rect2=read.frame;
                                rect2.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [read setFrame:rect2];
                                //                                阅读数
                                
                                CGRect rect3=disNumberLabel.frame;
                                rect3.origin.y=tv.frame.origin.y+tv.frame.size.height+2;
                                [disNumberLabel setFrame:rect3];
                                
                                
                                //                                lb，lp
                                CGRect rect4=lb.frame;
                                rect4.origin.y=disNumberLabel.frame.origin.y+disNumberLabel.frame.size.height+8;
                                [lb setFrame:rect4];
                                //                                lppingjia
                                
                                CGRect rect5=lp.frame;
                                rect5.origin.y=lb.frame.origin.y+lb.frame.size.height+8;
                                [lp setFrame:rect5];
                                //
                                CGRect rect6=tab.frame;
                                rect6.origin.y=lp.frame.origin.y+lp.frame.size.height+4;
                                [tab setFrame:rect6];
                                //滚动的长度
                                CGRect rect7=sb.frame;
                                
                                rect7.size.height=tab.frame.origin.y+tab.frame.size.height;
//                                [sb setFrame:rect7];
                                [sb setContentSize:CGSizeMake(swidth, rect7.size.height-swidth/2)];
                                
                                
                            }
//                            if([dic objectForKey:@"zan"] && ![[dic objectForKey:@"zan"] isEqual:[NSNull null]]){
//                                NSNumber *zanStaues=[dic objectForKey:@"zan"];
//                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                                    dianZanLabel.selected=false;
//                                }else{
//                                    dianZanLabel.selected=true;
//                                }
//                            }
                            
                            
                            
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
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
