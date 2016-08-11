//
//  InvitationDetailsViewController.m
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "InvitationDetailsViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginRegViewController.h"
#import "RJShareView.h"
#import "ScaleImgViewController.h"

@interface InvitationDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSArray *tableArray;
    UIButton *collectLabel;
    UIButton *invitationzanLabel;
    UIImageView *contentImageView;
    UIImageView *imi;
    int keyBoradHeight;
    UIView *changeView;
    UIView *headarView;
    UIImage *detialsImage;
}

@end

@implementation InvitationDetailsViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize invitationTableView;
@synthesize dianZanLabel;
@synthesize aritcleId;
@synthesize autherLogoView;
@synthesize autherNameLabel;
@synthesize timeLabel;
@synthesize titleLabel;
@synthesize zanNumberLabel;
@synthesize disNumberLabel;
@synthesize detailContent;
@synthesize data;
@synthesize editTextView;
@synthesize alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [ProgressHUD show:@"加载中..."];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    tableArray = [[NSArray alloc]init];
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    [self initTitle];
    [self initContentView];
    [self initBottomView];
    [self getArticleInfo];
    [self getCommectsList];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{

    editTextView.text=nil;
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
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
    [searchLabel setText:@"帖子详情"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [msgLabel addGestureRecognizer:shareGesutre];
    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/12.3/2, titleHeight/2-self.view.frame.size.width/12.3/2, self.view.frame.size.width/12.3, self.view.frame.size.width/12.3)];
    [msgLabel addSubview:shareView];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)share{
    //[ShareTools shareToQQ];
    NSString *title=titleLabel.text;
    NSString *txt;
    if ([detailContent.text length]>30) {
        txt=[detailContent.text substringToIndex:30];
    }else{
        txt=detailContent.text;
    }
    NSString *description=txt;
    NSString *imageurl=[[NSString alloc]init];
    NSString *url=@"http://211.149.190.90/m/20160126/index.html";
    
    
    NSDictionary *jsonData=[NSDictionary  dictionaryWithObjectsAndKeys:title,@"title",
                            description,@"description",imageurl,@"imageurl",url,@"url",nil];
    [RJShareView showGridMenuWithTitle:@"分享到..."
                            itemTitles:@[@"微信好友",@"朋友圈",@"微博",@"QQ好友",@"QQ空间"]
                                images:@[[UIImage imageNamed:@"weixin"],[UIImage imageNamed:@"wx_circle"],[UIImage imageNamed:@"weibo"],[UIImage imageNamed:@"qq"],[UIImage imageNamed:@"qzone.jpg"]]
                             shareJson:jsonData
                        selectedHandle:^(NSInteger index){
                            switch (index) {
                                case 1:
                                case 2:
                                    if (![WXApi isWXAppInstalled]) {
                                        [ProgressHUD showError:@"未安装微信！"];
                                    }
                                    break;
                                    
                                case 3:
                                    if (![WeiboSDK isWeiboAppInstalled]) {
                                        [ProgressHUD showError:@"未安装微博！"];
                                    }
                                    break;
                                    
                                    
                                case 4:
                                case 5:
                                    if (![TencentOAuth iphoneQQInstalled]) {
                                        [ProgressHUD showError:@"未安装QQ！"];
                                    }
                                    break;
                                    
                            }
                        }];
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    bottomHeight=49;
    
    
    headarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    [headarView setBackgroundColor:[UIColor whiteColor]];
    
    autherLogoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/21, width/22.8, width/7, width/7)];
    autherLogoView.layer.masksToBounds = YES;
    [autherLogoView.layer setBorderColor:[UIColor whiteColor].CGColor];
    autherLogoView.layer.cornerRadius = (autherLogoView.frame.size.width) / 2;
    [autherLogoView setImage:[UIImage imageNamed:@"ordering_logo"]];
    [headarView addSubview:autherLogoView];
    autherNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21+width/7+width/15, width/15, width/2, width/26.7)];
    [autherNameLabel setText:@"我是张小哥"];
    [autherNameLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [autherNameLabel setTextColor:[UIColor colorWithRed:86.f/255.f green:86.f/255.f blue:86.f/255.f alpha:1.0]];
    [headarView addSubview:autherNameLabel];
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21+width/7+width/15,  width/15+width/26.7+width/24.6, width/2, width/32)];
    [timeLabel setText:@"2015-11-12"];
    [timeLabel setFont:[UIFont systemFontOfSize:width/32]];
    [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [headarView addSubview:timeLabel];
    
    collectLabel=[[UIButton alloc]initWithFrame:CGRectMake(width-width/13-width/21, width/15,  width/13, width/13)];
    [collectLabel setImage:[UIImage imageNamed:@"collcet_unselect"] forState:UIControlStateNormal];
    [collectLabel setImage:[UIImage imageNamed:@"collcet_select"] forState:UIControlStateSelected];
    [collectLabel addTarget:self action:@selector(collectOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headarView addSubview:collectLabel];
    
    invitationzanLabel=[[UIButton alloc]initWithFrame:CGRectMake(width-width/13-width/21, width/15+width/23+width/15,  width/13, width/13)];
    [invitationzanLabel setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
    [invitationzanLabel setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateSelected];
    [invitationzanLabel addTarget:self action:@selector(zanOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headarView addSubview:invitationzanLabel];
    
    
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, width/22.8+width/7+width/18.8, width/2, width/22.8)];
    [titleLabel setText:@"中华文学大典"];
    [titleLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [titleLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    [headarView addSubview:titleLabel];
    
    UIButton *zanImageView=[[UIButton alloc]initWithFrame:CGRectMake(width/40, titleLabel.frame.origin.y+titleLabel.frame.size.height+width/45.7, width/32, width/32)];
    [zanImageView setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
    // [zanImageView setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateSelected];
    // [zanImageView addTarget:self action:@selector(zanOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headarView addSubview:zanImageView];
    
    zanNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(zanImageView.frame.origin.x+zanImageView.frame.size.width+width/53, titleLabel.frame.origin.y+titleLabel.frame.size.height+width/45.7, width/32*2, width/32)];
    [zanNumberLabel setText:@"50"];
    [zanNumberLabel setFont:[UIFont systemFontOfSize:width/32]];
    [zanNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [headarView addSubview:zanNumberLabel];
    
    UIImageView *disImageView=[[UIImageView alloc]initWithFrame:CGRectMake(zanNumberLabel.frame.origin.x+zanNumberLabel.frame.size.width+width/20, titleLabel.frame.origin.y+titleLabel.frame.size.height+width/45.7, width/32, width/32)];
    [disImageView setImage:[UIImage imageNamed:@"discuss_logo"]];
    [headarView addSubview:disImageView];
    
    disNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(disImageView.frame.origin.x+disImageView.frame.size.width+width/53, titleLabel.frame.origin.y+titleLabel.frame.size.height+width/45.7, width/32*3, width/32)];
    [disNumberLabel setText:@"25"];
    [disNumberLabel setFont:[UIFont systemFontOfSize:width/32]];
    [disNumberLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [headarView addSubview:disNumberLabel];
    
    
//    contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, disNumberLabel.frame.origin.y+disNumberLabel.frame.size.height+width/22.8, width-width/20, width/4)];
//    [contentImageView setImage:[UIImage imageNamed:@""]];
//    [headarView addSubview:contentImageView];
    
    
 changeView=[[UIView alloc]initWithFrame:CGRectMake(0, contentImageView.frame.origin.y+contentImageView.frame.size.height+width/22.8, width, headarView.frame.size.height-(contentImageView.frame.origin.y+contentImageView.frame.size.height+width/22.8))];
    //
    
    
  
//
    UILabel *detialLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, disNumberLabel.frame.origin.y+disNumberLabel.frame.size.height+width/22.8, width, width/29)];
    [detialLabel setText:@"详情"];
    [detialLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [detialLabel setFont:[UIFont systemFontOfSize:width/29]];
    [changeView addSubview:detialLabel];
    
    detailContent=[[UITextView alloc]initWithFrame:CGRectMake(width/40, detialLabel.frame.origin.y+detialLabel.frame.size.height+width/15-20, width-width/20, 50)];
    [detailContent setText:@"感悟艺术"];
    [detailContent setEditable:false];
     [detailContent setFont:[UIFont systemFontOfSize:width/26.7]];
    [changeView addSubview:detailContent];
    imi=[[UIImageView alloc]init];
    imi.frame=CGRectMake(0, detailContent.frame.origin.y+detailContent.frame.size.height+1, width, 100);
    imi.contentMode=UIViewContentModeScaleAspectFit;
    //    NSString *sbt=[NSString stringWithFormat:@"%@",data];
    //    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"10086" message:sbt delegate:nil cancelButtonTitle:@"quxaio" otherButtonTitles:@"123", nil];
    //    [al show];
    //    NSString *stb=[NSString stringWithFormat:@"%@%@",@""];
    
    [changeView addSubview:imi];
    UILabel *pinglunlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, changeView.frame.size.height-width/64-width/29, width, width/29)];
    [pinglunlabel setText:@"评论"];
    [pinglunlabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [pinglunlabel setFont:[UIFont systemFontOfSize:width/29]];
    [changeView addSubview:pinglunlabel];
    
    [headarView addSubview:changeView];
    
    invitationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                     (titleHeight+20+0.5+titleHeight/8),
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height-(titleHeight+20+0.5+titleHeight/8)-width/6.5)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [invitationTableView setBackgroundColor:[UIColor whiteColor]];
    invitationTableView.dataSource                        = self;
    invitationTableView.delegate                          = self;
    invitationTableView.rowHeight                         = self.view.bounds.size.height/7;
    invitationTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [invitationTableView setTableHeaderView:headarView];
    [self.view addSubview:invitationTableView];
    //下拉刷新
    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor grayColor]];
    
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [invitationTableView addSubview:_refreshControl];

    
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
    [invitationTableView reloadData];
    [refresh endRefreshing];
}

-(void)initBottomView{
    int width=self.view.frame.size.width;
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-width/6.5, width, width/6.5-0.5)];
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
-(void)collectOnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    NSNumber *collectionNumber;
    if(btn.selected){
        collectionNumber=[NSNumber numberWithInt:1];
    }else{
        collectionNumber=[NSNumber numberWithInt:0];
    }
    [self collectionArticle:collectionNumber];
    //在此实现不打勾时的方法
    
}
-(void)invitationZanOnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    NSNumber *zanNumber;
    if(btn.selected){
        zanNumber=[NSNumber numberWithInt:1];
    }else{
        zanNumber=[NSNumber numberWithInt:0];
    }
    [self zanAritcle:zanNumber];
}
-(void)zanOnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    NSNumber *zanNumber;
    if(btn.selected){
        [zanNumberLabel setText:[NSString stringWithFormat:@"%d",[zanNumberLabel.text intValue]+1]];
        zanNumber=[NSNumber numberWithInt:1];
    }else{
        [zanNumberLabel setText:[NSString stringWithFormat:@"%d",[zanNumberLabel.text intValue]-1]];
        zanNumber=[NSNumber numberWithInt:0];
    }
    [self zanAritcle:zanNumber  ];
    //在此实现不打勾时的方法
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    //  KCContactGroup *group1=_contacts[section];
    return [tableArray count];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:invitationTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height+15;
    
}
-(void)sendeCommects{
    [ProgressHUD show:@"评论提交中..."];
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper sendComments:aritcleId withContext:editTextView.text withModel:myDelegate.model
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

-(void)getArticleInfo{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getArticleInfo:aritcleId withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            if ([dic objectForKey:@"uimg"]&& ![[dic objectForKey:@"uimg"] isEqual:[NSNull null]]) {
                                [autherLogoView  sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"uimg"]]]];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                                [contentImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"img"]]] completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (image!=nil) {
                                        contentImageView.contentMode=UIViewContentModeScaleAspectFit;
                                        
                                        CGSize imageSize=image.size;
                                        CGRect frame=contentImageView.frame;
                                        [contentImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, imageSize.height*frame.size.width/imageSize.width)];
                                        contentImageView.contentMode=UIViewContentModeScaleAspectFill;
                                        
                                        CGRect changeFrame=changeView.frame;
                                        
                                        [changeView setFrame:CGRectMake(0, contentImageView.frame.origin.y+contentImageView.frame.size.height+changeFrame.size.width/22.8, changeFrame.size.width, changeFrame.size.height)];
                                        CGRect headerFrame=changeView.frame;
                                        
                                        [headarView setFrame:CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, changeView.frame.size.height+changeView.frame.origin.y)];
                                        
                                        [invitationTableView setTableHeaderView:headarView];
                                        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        detialsImage=image;
                                        
                                        
//
//                                        NSString *bt= [NSString stringWithFormat:@"%@",image];
//                                        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"顶部" message:bt delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"1", nil];
//                                        
//                                        
//                                        [alter show];
                                        
                                        contentImageView.userInteractionEnabled = YES;
                                        [contentImageView addGestureRecognizer:gesture];
                                    }else{
                                        [contentImageView setImage:[UIImage imageNamed:@"main_defalut"]];
                                        
                                    }
                                }];
                            }
                            
                            if ([dic objectForKey:@"username"]&& ![[dic objectForKey:@"username"] isEqual:[NSNull null]]) {
                                [autherNameLabel setText:[dic objectForKey:@"username"]];
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
                                [timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                                
                            }
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [titleLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            
                            if([dic objectForKey:@"zan"]){
                                NSString *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"people"]){
                                NSNumber *number=[dic objectForKey:@"people"];
                              //  NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"content"]){
                                [detailContent setText:[dic objectForKey:@"content"]];
                            }
//                              NSString *sb=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90", [dic objectForKey:@"img"]];
//                            NSURL *url=[NSURL URLWithString:sb];
//                           
//                           
//                            [imi setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
//                            
                          
                         
                            
                            
                            
                            
                            
                            
                            
                            if([dic objectForKey:@"iszan"] && ![[dic objectForKey:@"iszan"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"iszan"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    invitationzanLabel.selected=false;
                                }else{
                                    invitationzanLabel.selected=true;
                                }
                            }
                            if([dic objectForKey:@"isfavorite"] && ![[dic objectForKey:@"isfavorite"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"isfavorite"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    collectLabel.selected=false;
                                }else{
                                    collectLabel.selected=true;
                                }
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
            
            [HttpHelper getArticleInfo:aritcleId success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            
                            
                            
                            
                            if ([dic objectForKey:@"uimg"]&& ![[dic objectForKey:@"uimg"] isEqual:[NSNull null]]) {
                                [autherLogoView  sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"uimg"]]]];
                            }
                            if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                                
                           NSString *str=[NSString stringWithFormat:@"%@%@",@"http://211.149.190.90",[dic objectForKey:@"img"]];
                                imi.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];

                                
                                
                                
                                [contentImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"img"]]] completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (image!=nil) {
                                        contentImageView.contentMode=UIViewContentModeScaleAspectFit;

                                        CGSize imageSize=image.size;
                                        CGRect frame=contentImageView.frame;
                                        [contentImageView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, imageSize.height*frame.size.width/imageSize.width)];
                                        contentImageView.contentMode=UIViewContentModeScaleAspectFill;
                                        
                                        CGRect changeFrame=changeView.frame;
                                        
                                        [changeView setFrame:CGRectMake(0, contentImageView.frame.origin.y+contentImageView.frame.size.height+changeFrame.size.width/22.8, changeFrame.size.width, changeFrame.size.height)];
                                        CGRect headerFrame=changeView.frame;
                                        
                                        [headarView setFrame:CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, changeView.frame.size.height+changeView.frame.origin.y)];
                                        
                                        [invitationTableView setTableHeaderView:headarView];
                                        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        detialsImage=image;
//                                        imi.image=image;
                                        contentImageView.userInteractionEnabled = YES;
                                        [contentImageView addGestureRecognizer:gesture];
                                    }else{
                                        [contentImageView setImage:[UIImage imageNamed:@"main_defalut"]];
  
                                    }
                                }];
                                
                            }
                            
                            
                            if ([dic objectForKey:@"username"]&& ![[dic objectForKey:@"username"] isEqual:[NSNull null]]) {
                                [autherNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]]];
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
                                [timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                                
                            }
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [titleLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            
                            if([dic objectForKey:@"zan"]){
                                NSNumber *number=[dic objectForKey:@"zan"];
                                [zanNumberLabel setText:[NSString stringWithFormat:@"%@",number  ]];
                            }
                            if([dic objectForKey:@"people"]){
                                NSNumber *number=[dic objectForKey:@"people"];
                                [disNumberLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"content"]){
                                [detailContent setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                            }
                            if([dic objectForKey:@"zan"] && ![[dic objectForKey:@"zan"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"zan"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    dianZanLabel.selected=false;
                                }else{
                                    dianZanLabel.selected=true;
                                }
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
-(void)imageGesture:(UITapGestureRecognizer *)gesutre{
    ScaleImgViewController *scaleImgViewController=[[ScaleImgViewController alloc]init];
    [scaleImgViewController setLoadImage:detialsImage];
    
    [scaleImgViewController reloadImage];
    [self presentViewController:scaleImgViewController animated:YES completion:nil];
    
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
                      
                            
                            
                            
                            [invitationTableView reloadData];
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
            
            [HttpHelper getArticleCommectsList:aritcleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        tableArray=(NSArray *)model.result;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [invitationTableView reloadData];
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
-(void)collectionArticle:(NSNumber *)zan{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper deleteInterFavorite:aritcleId withZan:zan withModel:myDelegate.model
                                success:^(HttpModel *model){
                                    
                                    NSLog(@"%@",model.message);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                
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
-(void)zanInvitation:(NSNumber *)zan{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper zanArticle:[data objectForKey:@"id"] withZan:zan withModel:myDelegate.model
                       success:^(HttpModel *model){
                           
                           NSLog(@"%@",model.message);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       
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
-(void)zanAritcle:(NSNumber *)zan{
    
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper zanArticle:[data objectForKey:@"id"] withZan:zan withModel:myDelegate.model
                       success:^(HttpModel *model){
                           
                           NSLog(@"%@",model.message);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       
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

-(void)collectionAritcle{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getArticleCommectsList:aritcleId withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    tableArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [invitationTableView reloadData];
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

//动画时间
#define kAnimationDuration 0.2
//view高度
#define kViewHeight 56
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘高度
    NSValue *keyboardObject = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    keyBoradHeight=self.view.frame.size.height-keyboardRect.size.height-kViewHeight;
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, self.view.frame.size.width, kViewHeight)];
    
    [UIView commitAnimations];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-kViewHeight, self.view.frame.size.width, kViewHeight)];
    [UIView commitAnimations];
}

@end