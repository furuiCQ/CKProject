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
#import <JGProgressHUD/JGProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "RJShareView.h"
#import "ScaleImgViewController.h"
#import "NewsCommentCell.h"

#import <QuartzCore/QuartzCore.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WeiboSDK.h"
#import "ShareTools.h"
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
    UITextField *editTextView;
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
    UIView *sendControl;
    
    UIView *commetTitleView;
    //share
    NSDictionary* popJson;
    UIView *allShowView;
    BOOL isShow;
    UITapGestureRecognizer *sendGesutre;
    //key
    
    UIView *keyView;
    UITapGestureRecognizer *keyTap;
    
    //progress
    JGProgressHUD *HUD;
    //
    BOOL inThisPage;
}

@end

@implementation xindetailViewController
@synthesize aritcleId;
@synthesize data;
@synthesize alertView;

@synthesize imageScrollview;
@synthesize pageControl;
@synthesize timer;
@synthesize totalCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tableArray=[[NSArray alloc]init];
    [self initTitle];
    [self mainview];
    [self initBottomView];
    [self getCommectsList];
    [self getArticleInfo];
    [self initShareView];
    inThisPage=YES;
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"加载中...";
    [HUD showInView:self.view];
    
    // Do any additional setup after loading the view.
}


-(void)sendeCommects{
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    if([editTextView.text isEqualToString:@""]){
        [alertView setMessage:@"请输入评论内容！"];
        [alertView show];
        return;
    }
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    HUD.textLabel.text = @"提交评论中...";
    [HUD showInView:self.view];
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
                                       [alertView setMessage:model.message];
                                       [alertView show];
                                       [HUD dismiss];
                                   });
                               }failure:^(NSError *error){
                                   if (error.userInfo!=nil) {
                                       NSLog(@"%@",error.userInfo);
                                   }
                                   [HUD dismiss];

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
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [msgLabel addGestureRecognizer:shareGesutre];
    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/16.8/2, titleHeight/2-self.view.frame.size.width/16.8/2, self.view.frame.size.width/16.8, self.view.frame.size.width/16.8)];
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
    lab.font=[UIFont systemFontOfSize:swidth/20];
    lab.textAlignment=NSTextAlignmentLeft;
    
    writer=[[UILabel alloc]initWithFrame:CGRectMake(swidth/32, lab.frame.size.height+lab.frame.origin.y+swidth/26.7, swidth/24.6*5, swidth/24.6)];
    writer.text=@"新闻作者";
    writer.font=[UIFont systemFontOfSize:swidth/24.6];
    timers=[[UILabel alloc]initWithFrame:CGRectMake(writer.frame.origin.x+writer.frame.size.width+swidth/20,writer.frame.origin.y, swidth/4, swidth/24.6)];
    timers.font=[UIFont systemFontOfSize:swidth/24.6];
    timers.text=@"07-22";
    timers.textColor=[UIColor grayColor];
    
    zanNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(swidth-swidth/26.7*4-swidth/40, writer.frame.origin.y, swidth/26.7*4, swidth/26.7)];
    [zanNumberLabel setText:@"50"];
    [zanNumberLabel setFont:[UIFont systemFontOfSize:swidth/26.7]];
    [zanNumberLabel setTextAlignment:NSTextAlignmentLeft];
    [zanNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [sb addSubview:zanNumberLabel];
    
    zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(swidth-swidth/26.7*4-swidth/40-zanNumberLabel.frame.size.width, writer.frame.origin.y-5, swidth/16, swidth/16)];
    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
    [zanImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianZanNews)];
    [zanImageView addGestureRecognizer:gesutre];
    [sb addSubview:zanImageView];
    
    lt=[[UILabel alloc]initWithFrame:CGRectMake(0, writer.frame.size.height+writer.frame.origin.y+swidth/40, swidth, 0)];
    lt.backgroundColor=[UIColor grayColor];
    
    //图片
    // mg=[[UIImageView alloc]initWithFrame:CGRectMake(0, lt.frame.size.height+lt.frame.origin.y+4, swidth, swidth/1.3)];
    // [mg setImage:[UIImage imageNamed:@""]];
    [self initImageScrollView:lt];
    
    //新闻内容
    tv=[[UITextView alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.origin.y+imageScrollview.frame.size.height+5 , swidth , sheight)];
    tv.text=@"新闻内容";
    tv.editable=NO;
    tv.scrollEnabled=NO;
    tv.backgroundColor=[UIColor whiteColor];
    tv.textAlignment=NSTextAlignmentLeft;
    [tv setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [tv setFont:[UIFont systemFontOfSize:swidth/26.7]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    tv.attributedText = [[NSAttributedString alloc] initWithString:@"新闻内容" attributes:attributes];
    
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
    tab.separatorStyle = NO;
    
//    //下拉刷新
//    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
//    [_refreshControl setTintColor:[UIColor grayColor]];
//    
//    [_refreshControl addTarget:self
//                        action:@selector(refreshView:)
//              forControlEvents:UIControlEventValueChanged];
//    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
//    [tab addSubview:_refreshControl];
    
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
//轮播图片
-(void)initImageScrollView:(UIView *)topView{
    //    图片中数
    int width=self.view.frame.size.width;
    
    totalCount = 1;
    imageScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y+4, width, width/1.3)];
    //    图片的宽
    CGFloat imageW = imageScrollview.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = imageScrollview.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    
    //   1.添加5张图片
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = @"banner_default";
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        imageScrollview.showsHorizontalScrollIndicator = NO;
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
    [sb addSubview:imageScrollview];
    
    
}
//底部视图
-(void)initBottomView{
    
    
    int width=self.view.frame.size.width;
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-width/6.5, width, width/6.5-0.5)];
    [bottomView setTag:1000];
    [bottomView setBackgroundColor:[UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.0]];
    editTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/26.7, (bottomView.frame.size.height-width/10)/2, width-width/6.4-width/26.7*2, width/10)];
    [editTextView setPlaceholder:@"输入您的精彩评论"];
    [editTextView setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    editTextView.layer.masksToBounds=YES;
    [editTextView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
    [editTextView.layer setCornerRadius:5.0f];
    //  editTextView.delegate=self;
    [bottomView addSubview:editTextView];
    //100x60
    
    
    UILabel *sendDisLabel=[[UILabel alloc]initWithFrame:CGRectMake(editTextView.frame.size.width+editTextView.frame.origin.x+swidth/64, (bottomView.frame.size.height-width/10)/2, width/6.4, width/10)];
    [sendDisLabel setBackgroundColor:[UIColor colorWithRed:30.f/255.f green:169.f/255.f blue:240.f/255.f alpha:1.0]];
    sendGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendeCommects)];
    [sendDisLabel addGestureRecognizer:sendGesutre];
    [sendDisLabel setUserInteractionEnabled:YES];
    [sendDisLabel setText:@"发送"];
    [sendDisLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [sendDisLabel setTextColor:[UIColor whiteColor]];
    [sendDisLabel setTextAlignment:NSTextAlignmentCenter];
    [sendDisLabel.layer setCornerRadius:5.0f];
    sendDisLabel.clipsToBounds = YES;
    [bottomView addSubview:sendDisLabel];
    sendControl=[[UIView alloc]initWithFrame:CGRectMake(editTextView.frame.size.width+editTextView.frame.origin.x+swidth/64, 0, width/6.4, width/6.5-0.5)];
    [sendControl setTag:1001];
    [sendControl addGestureRecognizer:sendGesutre];
    [sendControl setUserInteractionEnabled:YES];
    [bottomView addSubview:sendControl];
    
    [self.view addSubview:bottomView];
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [editTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
            NSString *logo=[dic objectForKey:@"uimg"];
            if([logo length]>0){
                [cell.im sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }
            [cell.im.layer setCornerRadius:cell.im.frame.size.width/2];
            [cell.im.layer setMasksToBounds:YES];
            [cell.im setBackgroundColor:[UIColor clearColor]];
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
        inThisPage=NO;
        [self hidKeyBord];
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
-(void)dianZanNews{
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
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
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
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
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
                    
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                
            }];
            
            
        });
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getArticleCommectsList:aritcleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5]  success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        tableArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [tab reloadData];
                        });
                        
                    }else{
                        
                    }
                    
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                
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
                            
                            if ([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
                                [lab setText:[dic objectForKey:@"title"]];
                                [lab sizeToFit];
                                
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
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                                [writer setFrame:CGRectMake(swidth/32, lab.frame.size.height+lab.frame.origin.y+swidth/26.7, swidth/24.6*(int)[writer.text length], swidth/24.6)];
                                [timers setFrame:CGRectMake(writer.frame.origin.x+writer.frame.size.width+swidth/20,writer.frame.origin.y, swidth/4, swidth/24.6)];
                            }
                            
                            if([dic objectForKey:@"zan"]){
                                NSString *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                                [zanNumberLabel setFrame:CGRectMake(swidth-(swidth/32*(int)[zanNumberLabel.text length])-swidth/42.6,lab.frame.size.height+lab.frame.origin.y+swidth/23, swidth/32*(int)[zanNumberLabel.text length], swidth/32)];
                                [zanImageView removeFromSuperview];
                                zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(swidth-zanNumberLabel.frame.size.width-swidth/16-swidth/20, writer.frame.origin.y-5, swidth/16, swidth/16)];
                                [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
                                [zanImageView setUserInteractionEnabled:YES];
                                UIControl *zanControl=[[UIControl alloc]initWithFrame:CGRectMake(swidth*2/3, lab.frame.size.height, swidth/3, swidth/6.5)];
                                
                                [zanControl addTarget:self action:@selector(dianZanNews) forControlEvents:UIControlEventTouchUpInside];
                                [sb addSubview:zanImageView];
                                [sb addSubview:zanControl];
                            }
                            if([dic objectForKey:@"iszan"] && ![[dic objectForKey:@"iszan"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"iszan"];
                                if ([zanStaues intValue]==0) {
                                    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
                                    
                                }else{
                                    [zanImageView setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateNormal];
                                }
                            }
                            if([dic objectForKey:@"read"]){
                                NSNumber *number=[dic objectForKey:@"read"];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                [self loadImages:dic];
                                [lt setFrame:CGRectMake(0, writer.frame.size.height+writer.frame.origin.y+swidth/40, swidth, 0)];
                                [imageScrollview setFrame:CGRectMake(0, lt.frame.size.height+lt.frame.origin.y+4, swidth, swidth/1.3)];
                                
                            }
                            if([dic objectForKey:@"content"]){
                                //[tv setText:[dic objectForKey:@"content"]];
                                NSString *str=[dic objectForKey:@"content"];
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                paragraphStyle.lineSpacing = 5;// 字体的行间距
                                
                                NSDictionary *attributes = @{
                                                             NSFontAttributeName:[UIFont systemFontOfSize:swidth/26.7],
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             };
                                tv.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
                                CGRect frame = tv.frame;
                                CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
                                CGSize size = [tv sizeThatFits:constraintSize];
                                frame.size.height=size.height;
                                frame.origin.y=imageScrollview.frame.origin.y+imageScrollview.frame.size.height+5;
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
                        });
                        
                    }else{
                        
                    }
                    [HUD dismiss];
                    [self.view setHidden:NO];

                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [HUD dismiss];
                [self.view setHidden:NO];

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
                                [lab sizeToFit];
                                
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
                            if ([dic objectForKey:@"author"]) {
                                writer.text=[dic objectForKey:@"author"];
                                [writer setFrame:CGRectMake(swidth/32, lab.frame.size.height+lab.frame.origin.y+swidth/26.7, swidth/24.6*(int)[writer.text length], swidth/24.6)];
                                [timers setFrame:CGRectMake(writer.frame.origin.x+writer.frame.size.width+swidth/20,writer.frame.origin.y, swidth/4, swidth/24.6)];
                            }
                            
                            if([dic objectForKey:@"zan"]){
                                NSString *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                                [zanNumberLabel setFrame:CGRectMake(swidth-(swidth/32*(int)[zanNumberLabel.text length])-swidth/42.6,lab.frame.size.height+lab.frame.origin.y+swidth/23, swidth/32*(int)[zanNumberLabel.text length], swidth/32)];
                                
                                
                                [zanImageView removeFromSuperview];
                                zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(swidth-zanNumberLabel.frame.size.width-swidth/16-swidth/20, writer.frame.origin.y-5, swidth/16, swidth/16)];
                                [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
                                [zanImageView setUserInteractionEnabled:YES];
                                UIControl *zanControl=[[UIControl alloc]initWithFrame:CGRectMake(swidth*2/3, lab.frame.size.height, swidth/3, swidth/6.5)];
                                [zanControl addTarget:self action:@selector(dianZanNews) forControlEvents:UIControlEventTouchUpInside];
                            
                                [sb addSubview:zanImageView];
                                [sb addSubview:zanControl];

                            }
                            if([dic objectForKey:@"read"]){
                                NSNumber *number=[dic objectForKey:@"read"];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                [self loadImages:dic];
                                [lt setFrame:CGRectMake(0, writer.frame.size.height+writer.frame.origin.y+swidth/40, swidth, 0)];
                                [imageScrollview setFrame:CGRectMake(0, lt.frame.size.height+lt.frame.origin.y+4, swidth, swidth/1.3)];
                                
                            }
                            if([dic objectForKey:@"content"]){
                                //[tv setText:[dic objectForKey:@"content"]];
                                NSString *str=[dic objectForKey:@"content"];
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                paragraphStyle.lineSpacing = 5;// 字体的行间距
                                
                                NSDictionary *attributes = @{
                                                             NSFontAttributeName:[UIFont systemFontOfSize:swidth/26.7],
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             };
                                tv.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
                                CGRect frame = tv.frame;
                                CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
                                CGSize size = [tv sizeThatFits:constraintSize];
                                frame.size.height=size.height;
                                frame.origin.y=imageScrollview.frame.origin.y+imageScrollview.frame.size.height+5;
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
                            
                            
                        });
                        
                    }else{
                        
                    }
                    [HUD dismiss];
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [HUD dismiss];
                
            }];
            
            
        });
        
    }
    
}
-(void)loadImages:(NSDictionary *)dic{
    NSString *images=[dic objectForKey:@"img"];
    NSArray *array = [images componentsSeparatedByString:@","];
    //  NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
    //  [de setObject:array forKey:@"pictures"];
    if ([array count]>0) {
        totalCount=[array count];
        pageControl.numberOfPages=totalCount;
        NSArray *views = [imageScrollview subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
        
        //    图片的宽
        CGFloat imageW = imageScrollview.frame.size.width;
        //    CGFloat imageW = 300;
        //    图片高
        CGFloat imageH = imageScrollview.frame.size.height;
        //    图片的Y
        CGFloat imageY = 0;
        
        //   1.添加5张图片
        for (int i = 0; i < [array count]; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setUserInteractionEnabled:YES];
            //        图片X
            CGFloat imageX = i * imageW;
            //        设置frame
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            //        设置图片
            NSString *logo=[array objectAtIndex:i];
            
            [imageView setImage:[UIImage imageNamed:@"banner_default"]];
            [imageView setTag:i];
            //  UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
            //  [imageView addGestureRecognizer:openChorme];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
            
            
            //        隐藏指示条
            imageScrollview.showsHorizontalScrollIndicator = NO;
            [imageScrollview addSubview:imageView];
            CGFloat contentW = totalCount *imageW;
            //不允许在垂直方向上进行滚动
            imageScrollview.contentSize = CGSizeMake(contentW, 0);
            
            //    3.设置分页
            imageScrollview.pagingEnabled = YES;
            
            //    4.监听scrollview的滚动
            imageScrollview.delegate = self;
        }
        
        CGRect bounds = imageScrollview.frame;  //获取界面区域
        
        
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.size.height+imageScrollview.frame.origin.y-30, bounds.size.width, 30)];
        pageControl.numberOfPages = totalCount;//总的图片页数
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:75.f/255.f blue:75.f/255.f  alpha:1.0];
        [sb addSubview:pageControl];
    }
}
//动画时间
#define kAnimationDuration 0.2
//view高度
#define kViewHeight 56
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    //调整放置有textView的view的位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    if(inThisPage){
        if(keyView!=nil){
            [keyView removeFromSuperview];
            keyView=nil;
        }
        keyView=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight+20, self.view.frame.size.width, self.view.frame.size.height-curkeyBoardHeight-(self.view.frame.size.width/6.5-0.5)-(titleHeight+20))];
        [keyView setBackgroundColor:[UIColor redColor]];
        keyTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBord)];
        [keyView setUserInteractionEnabled:YES];
        [keyView addGestureRecognizer:keyTap];
        [self.view addSubview:keyView];
    }
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-curkeyBoardHeight-(self.view.frame.size.width/6.5-0.5), self.view.frame.size.width, self.view.frame.size.width/6.5-0.5)];
    [UIView commitAnimations];
    [sendControl removeFromSuperview];
    sendControl=[[UIView alloc]initWithFrame:CGRectMake(swidth-(swidth/6.4), self.view.frame.size.height-curkeyBoardHeight-(self.view.frame.size.width/6.5-0.5), swidth/6.4, swidth/6.5-0.5)];
    [sendControl setTag:1001];
    [sendControl addGestureRecognizer:sendGesutre];
    [sendControl setUserInteractionEnabled:YES];
    [self.view addSubview:sendControl];
    
}
-(void)hidKeyBord{
    if(keyView!=nil){
        [keyView removeGestureRecognizer:keyTap];
        [keyView removeFromSuperview];
        [editTextView resignFirstResponder];
        keyView=nil;
    }
 
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self hidKeyBord];
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-(self.view.frame.size.width/6.5-0.5), self.view.frame.size.width, self.view.frame.size.width/6.5-0.5)];
    [UIView commitAnimations];
    [sendControl removeFromSuperview];
    sendControl=[[UIView alloc]initWithFrame:CGRectMake(swidth-(swidth/6.4), self.view.frame.size.height-(self.view.frame.size.width/6.5-0.5), swidth/6.4, swidth/6.5-0.5)];
    [sendControl setTag:1001];
    [sendControl addGestureRecognizer:sendGesutre];
    [sendControl setUserInteractionEnabled:YES];
    [self.view addSubview:sendControl];
    
}
-(void)initShareView{
    int width=self.view.frame.size.width;
    allShowView=[[UIView alloc]initWithFrame:CGRectMake(width-width/9.1-width/64+width/160, titleHeight+20, width/9.1, width)];
    
    NSArray *imageArray=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"qq"],[UIImage imageNamed:@"weixin"],[UIImage imageNamed:@"wx_circle"],[UIImage imageNamed:@"qzone"],[UIImage imageNamed:@"weibo"], nil];
    int y=0;
    int paddingHeight=width/35.6;
    for (int i=0; i<[imageArray count]; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (y+paddingHeight+width/9.1)*i, width/9.1, width/9.1)];
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:gesture];
        [imageView setTag:i];
        [imageView setImage:[imageArray objectAtIndex:i]];
        [imageView setHidden:YES];
        imageView.frame = CGRectMake(imageView.frame.origin.x, -titleHeight, imageView.frame.size.width,imageView.frame.size.height);
        [allShowView addSubview:imageView];
    }
    //[allShowView setHidden:YES];
    [self.view addSubview:allShowView];
}
#pragma mark - UIView animation
//Spring Animation
- (void)dismisAnimation{
    for (UIView *view in allShowView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *btn=(UIImageView *)view;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
                [UIView animateWithDuration:1.f delay:0.02*(btn.tag) usingSpringWithDamping:0.6f initialSpringVelocity:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    btn.frame = CGRectMake(btn.frame.origin.x, -titleHeight, btn.frame.size.width,btn.frame.size.height);
                } completion:^(BOOL finished) {
                    [btn setHidden:YES];
                }];
            });
        }
    }
}
-(void)showAnimation{
    int width=self.view.frame.size.width;
    int y=0;
    int paddingHeight=width/35.6;
    for (UIView *view in allShowView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *btn=(UIImageView *)view;
            [btn setHidden:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
                [UIView animateWithDuration:1.f delay:(0.2-0.02*(btn.tag)) usingSpringWithDamping:1.0f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    btn.frame = CGRectMake(btn.frame.origin.x, (y+paddingHeight+width/9.1)*(btn.tag), btn.frame.size.width,btn.frame.size.height);
                } completion:^(BOOL finished) {
                }];
            });
        }
    }
}
-(void)share{
    if(!isShow){
        isShow=YES;
        [self showAnimation];
    }else{
        [self dismisAnimation];
        isShow=NO;
    }    NSString *title=lab.text;
    NSString *txt;
    if ([tv.text length]>30) {
        txt=[tv.text substringToIndex:30];
    }else{
        txt=tv.text;
    }
    NSString *description=txt;
    NSString *imageurl=[[NSString alloc]init];
    NSString *url=@"http://211.149.190.90/m/20160126/index.html";
    
    
    popJson=[NSDictionary  dictionaryWithObjectsAndKeys:title,@"title",
             description,@"description",imageurl,@"imageurl",url,@"url",nil];
}
//通过网络地址获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
//通过
- (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image toSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    NSLog(@"%f",scaledWidth);
    NSLog(@"%f",scaledHeight);
    
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 0://qq好友
            if ([TencentOAuth iphoneQQInstalled]) {
                [self shareToQQFriend];
            }
            break;
        case 1://微信好友
            if ([WXApi isWXAppInstalled]) {
                [self shareToWxFriend];
            }
            
            break;
        case 2: //微信朋友圈
            if ([WXApi isWXAppInstalled]) {
                [self shareToWxTimeLine];
            }
            break;
        case 3://qq空间
            if ([TencentOAuth iphoneQQInstalled]) {
                [self shareToQQZone];
            }
            break;
        case 4://微博
            if ([WeiboSDK isWeiboAppInstalled]) {
                [self shareToWeiBo];
            }
            break;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![editTextView isExclusiveTouch]) {
        [editTextView resignFirstResponder];
    }
}
//分享给好友
-(void)shareToWxFriend
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [popJson valueForKey:@"title"];  //@"Web_title";
    message.description = [popJson valueForKey:@"description"];
    //UIImage * result;
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
    //  NSString *imageurl=[popJson valueForKey:@"imageurl"];
    // result = [self getImageFromURL:imageurl];
    
    // UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
    // if(image==nil || [image isEqual:0]){
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    // }else{
    //    [message setThumbImage:image];
    //  }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [popJson valueForKey:@"url"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
-(void)shareToWxTimeLine
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [popJson valueForKey:@"title"];  //@"Web_title";
    message.description =[popJson valueForKey:@"description"];
    
    //UIImage * result;
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
    //    NSString *imageurl=[popJson valueForKey:@"imageurl"];
    //    result = [self getImageFromURL:imageurl];
    
    // UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
    // if(image==nil || [image isEqual:0]){
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    //  }else{
    //  [message setThumbImage:image];
    //}
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [popJson valueForKey:@"url"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}
static NSString * const WeiboKey=@"2850266283";
static NSString * const WeiboRedirectURI =@"http://www.sina.com";
-(void)shareToWeiBo{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = WeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
-(WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    
    message.text = [[popJson valueForKey:@"title"]stringByAppendingString:[popJson valueForKey:@"url"]];
    
    
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(image);
    message.imageObject = imageObject;
    
    
    //    WBWebpageObject *webpage = [WBWebpageObject object];
    //
    //    webpage.objectID = @"identifier1";
    //    webpage.title =[popJson valueForKey:@"title"];
    //    webpage.description = [popJson valueForKey:@"description"];
    //    webpage.thumbnailData = UIImagePNGRepresentation(image);
    //    webpage.webpageUrl = @"http://www.baidu.com";
    //    message.mediaObject = webpage;
    //
    return message;
}

-(void)shareToQQZone{
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    NSString *title=[popJson valueForKey:@"title"];
    NSString *description=[popJson valueForKey:@"description"];
    NSString *url=[popJson valueForKey:@"url"];
    
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]  title:title description:description previewImageData:UIImagePNGRepresentation(image)];
    
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if ([TencentOAuth iphoneQQInstalled]) {
        [self handleSendResult:sent];
    }
}
-(void)shareToQQFriend{
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    NSString *title=[popJson valueForKey:@"title"];
    NSString *description=[popJson valueForKey:@"description"];
    NSString *url=[popJson valueForKey:@"url"];
    
    QQApiURLObject *imObj=[[QQApiURLObject alloc]initWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image) targetContentType:QQApiURLTargetTypeNews];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [self handleSendResult:sent];
    }
}
-(void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
