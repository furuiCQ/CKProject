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
#import "LoginViewController.h"
#import "RJShareView.h"
#import "ScaleImgViewController.h"
#import "ProgressHUD.h"
#import "NewsCommentCell.h"
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
    UIView *sb;
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
    UINib *nib;
    
    UIView *commetTitleView;
}

@end

@implementation xindetailViewController
@synthesize aritcleId;
@synthesize data;
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
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    [ProgressHUD show:@"评论提交中..."];
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
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
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
    sb=[[UIView alloc]initWithFrame:CGRectMake(0, 0, swidth, sheight)];
    lab=[[UILabel alloc]initWithFrame:CGRectMake(swidth/32, swidth/24.6, swidth-swidth/16, swidth/21)];
    lab.numberOfLines=0;
    lab.text=@"";
    lab.textColor=[UIColor colorWithRed:22.f/255.f green:22.f/255.f blue:22.f/255.f alpha:1.0];
    lab.font=[UIFont systemFontOfSize:swidth/21];
    lab.textAlignment=NSTextAlignmentLeft;
    
    writer=[[UILabel alloc]initWithFrame:CGRectMake(swidth/32, lab.frame.size.height+lab.frame.origin.y+swidth/26.7, swidth/27.8*5, swidth/27.8)];
    writer.text=@"新闻作者";
    writer.font=[UIFont systemFontOfSize:swidth/27.8];
    timers=[[UILabel alloc]initWithFrame:CGRectMake(writer.frame.origin.x+writer.frame.size.width+swidth/20,writer.frame.origin.y, swidth/4, swidth/27.8)];
    timers.font=[UIFont systemFontOfSize:swidth/25];
    timers.text=@"07-22";
    timers.textColor=[UIColor grayColor];
    
    zanNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(swidth-swidth/32*4-swidth/40, writer.frame.origin.y, swidth/32*4, swidth/32)];
    [zanNumberLabel setText:@"50"];
    [zanNumberLabel setFont:[UIFont systemFontOfSize:swidth/32]];
    [zanNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [sb addSubview:zanNumberLabel];
    
    zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(swidth-swidth/32*4-swidth/40-zanNumberLabel.frame.size.width, writer.frame.origin.y-5, swidth/16, swidth/16)];
    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
    [zanImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianZanNews:)];
    [zanImageView addGestureRecognizer:gesutre];
    [sb addSubview:zanImageView];
    
    lt=[[UILabel alloc]initWithFrame:CGRectMake(0, writer.frame.size.height+writer.frame.origin.y+swidth/40, swidth, 0.2)];
    lt.backgroundColor=[UIColor grayColor];
    
    //图片
    mg=[[UIImageView alloc]initWithFrame:CGRectMake(0, lt.frame.size.height+lt.frame.origin.y+4, swidth, sb.frame.size.height/4)];
    [mg setImage:[UIImage imageNamed:@""]];
    
    //新闻内容
    tv=[[UITextView alloc]initWithFrame:CGRectMake(0, mg.frame.origin.y+mg.frame.size.height+5 , swidth , sheight)];
    tv.text=@"新闻内容";
    tv.editable=NO;
    tv.backgroundColor=[UIColor whiteColor];
    tv.textAlignment=NSTextAlignmentLeft;
    tv.font=[UIFont systemFontOfSize:swidth/25];
    [tv setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [tv setFont:[UIFont systemFontOfSize:swidth/26.7]];
    
    commetTitleView=[[UIView alloc]initWithFrame:CGRectMake(0, tv.frame.size.height+tv.frame.origin.y+2,
                                                            swidth, swidth/25.6)];
    UIView *lineView1=[[UILabel alloc]initWithFrame:CGRectMake((swidth/2-swidth/5)/2, (swidth/25.6-0.2)/2, swidth/5, 0.2)];
    lineView1.backgroundColor=[UIColor grayColor];
    
    UIView *lineView2=[[UILabel alloc]initWithFrame:CGRectMake((swidth/2-swidth/5)/2+swidth/2, (swidth/25.6-0.2)/2, swidth/5, 0.2)];
    lineView2.backgroundColor=[UIColor grayColor];
    lp=[[UILabel alloc]initWithFrame:CGRectMake((swidth-swidth/25.6*4)/2, 0, swidth/25.6*4, swidth/25.6)];
    lp.text=@"最新评论";
    [lp setTextColor:[UIColor colorWithRed:136.f/255.f green:136.f/255.f blue:136.f/255.f alpha:1.0]];
    [lp setFont:[UIFont systemFontOfSize:swidth/25.6]];
    
    [commetTitleView addSubview:lineView1];
    [commetTitleView addSubview:lineView2];
    [commetTitleView addSubview:lp];
    
    [sb addSubview:lab];
    [sb addSubview:writer];
    [sb addSubview:timers];
    [sb addSubview:lt];
    [sb addSubview:mg];
    [sb addSubview:tv];
    [sb addSubview:commetTitleView];
    // [sb addSubview:lp];
    //    [sb addSubview:tab];
    //   tab.tableHeaderView=sb;
    // [self.view addSubview:sb];
    [sb setFrame:CGRectMake(0, 0, swidth, lp.frame.size.height+lp.frame.origin.y+10)];
    
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height+titleView.frame.origin.y, swidth, sheight-(titleView.frame.size.height+titleView.frame.origin.y)-swidth/6.5)];
    tab.backgroundColor=[UIColor clearColor];
    tab.delegate=self;
    tab.dataSource=self;
    tab.rowHeight= self.view.bounds.size.height/5;
    tab.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //下拉刷新
    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor grayColor]];
    
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [tab addSubview:_refreshControl];
    
    [self.view addSubview:tab];
    
    
    
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
    [bottomView setBackgroundColor:[UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.0]];
    editTextView=[[UITextView alloc]initWithFrame:CGRectMake(width/26.7, (bottomView.frame.size.height-width/10)/2, width-width/6.4-width/26.7*2, width/10)];
    [editTextView setText:@"输入您的精彩评论"];
    [editTextView setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    editTextView.layer.masksToBounds=YES;
    [editTextView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
    [editTextView.layer setCornerRadius:5.0f];
    editTextView.delegate=self;
    [bottomView addSubview:editTextView];
    //100x60
    UILabel *sendDisLabel=[[UILabel alloc]initWithFrame:CGRectMake(editTextView.frame.size.width+editTextView.frame.origin.x+swidth/64, (bottomView.frame.size.height-width/10)/2, width/6.4, width/10)];
    [sendDisLabel setBackgroundColor:[UIColor colorWithRed:30.f/255.f green:169.f/255.f blue:240.f/255.f alpha:1.0]];
    UITapGestureRecognizer *gesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendeCommects)];
    [sendDisLabel addGestureRecognizer:gesutre];
    [sendDisLabel setUserInteractionEnabled:YES];
    [sendDisLabel setText:@"发送"];
    [sendDisLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [sendDisLabel setTextColor:[UIColor whiteColor]];
    [sendDisLabel setTextAlignment:NSTextAlignmentCenter];
    [sendDisLabel.layer setCornerRadius:5.0f];
    sendDisLabel.clipsToBounds = YES;
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
    rect8.origin.y=sheight-300;
    [bottomView setFrame:rect8];
    editTextView.text=nil;
    NSLog(@"textViewDidBeginEditing");
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
    static NSString *identy = @"NewsCommentCell";
    if (!nib) {
        [tab registerNib:[UINib nibWithNibName:@"NewsCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        nib = [UINib nibWithNibName:@"NewsCommentCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identy];
        NSLog(@"我是从nib过来的，%ld",(long)indexPath.row);
    }
    NewsCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    
    if ([tableArray count]>0) {
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        if ([dic objectForKey:@"uimg"] && ![[dic objectForKey:@"uimg"] isEqual:[NSNull null]]) {
            [cell.im.layer setCornerRadius:cell.im.frame.size.width/2];
            [cell.im sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"uimg"]]]];
        }
        if ([dic objectForKey:@"username"] && ![[dic objectForKey:@"username"] isEqual:[NSNull null]] ) {
            [cell.writers  setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]]    ];
        }
        
        if ([dic objectForKey:@"content"] && ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
            [cell.titles  setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
        }
        if([dic objectForKey:@"zan"] && ![[dic objectForKey:@"zan"] isEqual:[NSNull null]]){
            [cell.nums setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"zan"]]];

        }
        [cell.zanImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianZan:)];
        [cell.zanImage setTag:[indexPath row]];
        [cell.zanImage addGestureRecognizer:gesutre];
        if([dic objectForKey:@"iszan"] && ![[dic objectForKey:@"iszan"] isEqual:[NSNull null]]){
            NSNumber *zanStaues=[dic objectForKey:@"iszan"];
            if ([zanStaues intValue]==0) {
                [cell.zanImage setImage:[UIImage imageNamed:@"zan_logo"]];
            }else{
                [cell.zanImage setImage:[UIImage imageNamed:@"dianzan_logo"]];
            }
        }
        
        
        
    }
    return cell;
}
-(void)dianZan:(UITapGestureRecognizer *)gesutre{
    int tag=(int)gesutre.view.tag;
    NSLog(@"dianZan%d",tag);
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    NSDictionary *dic=[tableArray objectAtIndex:tag];
    NSNumber *commid=[dic objectForKey:@"id"];
    NSNumber *iszan=[dic objectForKey:@"iszan"];
    if([iszan intValue]==0){
        iszan=[NSNumber numberWithInt:1];
    }else{
        iszan=[NSNumber numberWithInt:0];
    }
    [self zanNewsComments:iszan withCommentId:commid];
}
-(void)dianZanNews:(UITapGestureRecognizer *)gesutre{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    NSNumber *iszan=[data objectForKey:@"iszan"];
    if([iszan intValue]==0){
        iszan=[NSNumber numberWithInt:1];
    }else{
        iszan=[NSNumber numberWithInt:0];
    }
    [self zanNews:iszan];
}
-(void)zanNews:(NSNumber *)zan {
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper zanNews:[data objectForKey:@"id"] withZan:zan withModel:myDelegate.model
                            success:^(HttpModel *model){
                                
                                NSLog(@"%@",model.message);
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self getArticleInfo];
                                        });
                                        
                                    }else{
                                        
                                    }
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
-(void)zanNewsComments:(NSNumber *)zan withCommentId:(NSNumber *)comId{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper zanNewsComments:comId withZan:zan withModel:myDelegate.model
                       success:^(HttpModel *model){
                           
                           NSLog(@"%@",model.message);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self getCommectsList];
                                       
                                   });
                                   
                               }else{
                                   
                               }
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
-(void)getArticleInfos{
    NSDictionary *dic=data;
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
        [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
    }
    if([dic objectForKey:@"content"]){
        [tv setText:[dic objectForKey:@"content"]];
        CGRect frame=tv.frame;
        frame.size.height=tv.contentSize.height;
        [tv setFrame:frame];
        //赞的数值
        CGRect rect4=commetTitleView.frame;
        rect4.origin.y=tv.frame.origin.y+tv.frame.size.height+8;
        [commetTitleView setFrame:rect4];

        // CGRect rect5=lp.frame;
        // rect5.origin.y=lb.frame.origin.y+lb.frame.size.height+8;
        // [lp setFrame:rect5];
        //滚动的长度
        CGRect rect7=sb.frame;

        rect7.size.height=commetTitleView.frame.origin.y+commetTitleView.frame.size.height+10;

        [sb setFrame:rect7];
        tab.tableHeaderView=sb;

    }
    if ([dic objectForKey:@"author"]) {
        writer.text=[dic objectForKey:@"author"];
    }
    if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {

        NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
        mg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];

    }

}

//获取前方数据
-(void)getArticleInfo{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getXinwenInfo:aritcleId withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            if([dic objectForKey:@"iszan"] && ![[dic objectForKey:@"iszan"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"iszan"];
                                if ([zanStaues intValue]==0) {
                                    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];

                                }else{
                                    [zanImageView setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateNormal];
                                }
                            }
                            
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
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"content"]){
                                [tv setText:[dic objectForKey:@"content"]];
                                CGRect frame=tv.frame;
                                frame.size.height=tv.contentSize.height;
                                [tv setFrame:frame];
                                //赞的数值
                                CGRect rect4=commetTitleView.frame;
                                rect4.origin.y=tv.frame.origin.y+tv.frame.size.height+8;
                                [commetTitleView setFrame:rect4];
                                
                                // CGRect rect5=lp.frame;
                                // rect5.origin.y=lb.frame.origin.y+lb.frame.size.height+8;
                                // [lp setFrame:rect5];
                                //滚动的长度
                                CGRect rect7=sb.frame;
                                
                                rect7.size.height=commetTitleView.frame.origin.y+commetTitleView.frame.size.height+10;
                                
                                [sb setFrame:rect7];
                                tab.tableHeaderView=sb;
                                
                            }
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                                NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
                                mg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                                
                            }
                            
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
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"content"]){
                                [tv setText:[dic objectForKey:@"content"]];
                                CGRect frame=tv.frame;
                                frame.size.height=tv.contentSize.height;
                                [tv setFrame:frame];
                                //赞的数值
                                CGRect rect4=commetTitleView.frame;
                                rect4.origin.y=tv.frame.origin.y+tv.frame.size.height+8;
                                [commetTitleView setFrame:rect4];
                                
                                // CGRect rect5=lp.frame;
                                // rect5.origin.y=lb.frame.origin.y+lb.frame.size.height+8;
                                // [lp setFrame:rect5];
                                //滚动的长度
                                CGRect rect7=sb.frame;
                                
                                rect7.size.height=commetTitleView.frame.origin.y+commetTitleView.frame.size.height+10;
                                
                                [sb setFrame:rect7];
                                tab.tableHeaderView=sb;
                                
                            }
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                                NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
                                mg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                                
                            }
                            
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
