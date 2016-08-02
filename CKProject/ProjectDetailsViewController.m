//
//  ProjectDetailsViewController.m
//  CKProject
//
//  Created by furui on 15/12/6.
//  Copyright © 2015年 furui. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)//用来获取手机的系统，判断系统是多少

#import "ProjectDetailsViewController.h"
#import "ProjectTableCell.h"
#import "HttpHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MapKit/MapKit.h>
#import "LoginRegViewController.h"
#import "ShareTools.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "RJShareView.h"
#import "ScaleImgViewController.h"
#import "CustomPopView.h"
#import "TimeSelectItem.h"
#import "DayModel.h"
#import "JZLocationConverter.h"
@interface ProjectDetailsViewController ()<UIScrollViewDelegate>{
    NSString *phone;
    UILabel *registerLabel;
    NSDate *aDate;
    UILabel *countDownLabel;
    UILabel *line;
    UIView *bottomView;
    UIView *imagesView;
    UIImage *detialsImage;
    UIView *timeSelectView;
    UIScrollView *scrollView;
    UIView *timeSelectPicker;
    UILabel *lei;
    UILabel *tit;
    NSMutableArray *weekItemArray;
    NSMutableArray *amItemArray;
    NSMutableArray *pmItemArray;
    NSMutableArray *nightItemArray;
    UILabel *confirm;
    
    UILabel *weekLabel;
    UILabel *nextWeekLabel;
    
    NSNumber *localNumber;
    
    NSMutableArray *nowWeekArray;
    NSMutableArray *nextWeekArray;
    
    NSMutableArray *selectWeekArry;
    UILabel *nightLabel;
    UILabel *amLabel;
    UILabel *pmLabel;
    
    NSNumber *weekId;
    NSNumber *weekNum;
    NSString *beginTime;
    UILabel *timeShowLabel;//显示选择的时间
    
    UILabel *phoneLabel;//电话号码文本
    
    NSNumber *advance_time;
    UITextView *neirong;
    
//    保存图片数据
    
    NSNumber *bt;
    
    NSMutableArray *tab;

}
@end

@implementation ProjectDetailsViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize collectLabel;
@synthesize projectId;
@synthesize logoImageView;
@synthesize instituteNameLabel;
@synthesize numbLabel;
@synthesize ratingBar;
@synthesize projectNameLabel;
@synthesize projectAddLabel;
@synthesize projectTimeLabel;
@synthesize detailContentLabel;
@synthesize dateLabel;
@synthesize data;
@synthesize beginTimeLabel;
@synthesize isCancel;
@synthesize imageScrollview;
@synthesize pageControl;
@synthesize timer;
@synthesize totalCount;
@synthesize L_ID;
@synthesize WEEK_ID;
@synthesize WEEK_NUM;
@synthesize ORDER_TIME;
static NSString * const DEFAULT_LOCAL_AID = @"500100";

- (void)viewDidLoad {
   

    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中..."];
    selectWeekArry=[[NSMutableArray alloc]init];
    [self initTitle];
    [self initContent];
    [self getProjectInfo];
    NSLog(@"kechengid:%@",projectId);
    // Do any additional setup after loading the view, typically from a nib.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *backView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [backView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:backView];
    
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"课程详情"];
    
    //新建右上角的图形
//    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
//    msgLabel.userInteractionEnabled=YES;///
//    UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
//    [msgLabel addGestureRecognizer:shareGesutre];
//    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
//    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/12.3/2, titleHeight/2-self.view.frame.size.width/12.3/2, self.view.frame.size.width/12.3, self.view.frame.size.width/12.3)];
//    [msgLabel addSubview:shareView];
//    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
//    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}
-(void)initContent{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+0.5+20, width, hegiht-(titleHeight+0.5+20))];
    [scrollView setContentSize:CGSizeMake(width, hegiht)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    UIControl *instituteControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, width, width/5.3)];
    [instituteControl setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:252.f/255.f blue:252.f/255.f alpha:1.0]];
    [instituteControl addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:instituteControl];
    
    logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/32, width/8, width/8)];
    [logoImageView setImage:[UIImage imageNamed:@"instdetails_defalut"]];
    //  logoImageView.layer.cornerRadius=width/32;
    logoImageView.layer.masksToBounds=YES;
    [instituteControl addSubview:logoImageView];
    
    instituteNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x+width*11/640, logoImageView.frame.origin.y, width/2, width/21.3)];
    [instituteNameLabel setText:@""];
    [instituteNameLabel setFont:[UIFont systemFontOfSize:width/21.3]];
    [instituteNameLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    
    [instituteControl addSubview:instituteNameLabel];
    
    
    
    UILabel *bespeakLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x+width*11/640, instituteNameLabel.frame.size.height+instituteNameLabel.frame.origin.y+width/22.8, width/32*2, width/32)];
    [bespeakLabel setText:@"预约"];
    [bespeakLabel setFont:[UIFont systemFontOfSize:width/32]];
    [bespeakLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [instituteControl addSubview:bespeakLabel];
    
    numbLabel=[[UILabel alloc]initWithFrame:CGRectMake(bespeakLabel.frame.size.width+bespeakLabel.frame.origin.x+width*11/640, instituteNameLabel.frame.size.height+instituteNameLabel.frame.origin.y+width/22.8, width/20, width/32)];
    [numbLabel setText:@"15"];
    [numbLabel setFont:[UIFont systemFontOfSize:width/32]];
    [numbLabel setTextColor:[UIColor redColor]];
    [instituteControl addSubview:numbLabel];
    
    
    ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(numbLabel.frame.size.width+numbLabel.frame.origin.x+width/40, instituteNameLabel.frame.size.height+instituteNameLabel.frame.origin.y+width/23, width/29*6, width/20)];
    ratingBar.isIndicator=YES;
    [ratingBar setImageDeselected:@"star_unselect" halfSelected:nil fullSelected:@"star_select" andDelegate:nil];
    [ratingBar displayRating:4.0f];
    [instituteControl addSubview:ratingBar];
    
    
    
    collectLabel=[[UIButton alloc]initWithFrame:CGRectMake(width-width/13-width/22.8, width/23, width/13, width/13)];
    [collectLabel setImage:[UIImage imageNamed:@"collcet_unselect"] forState:UIControlStateNormal];
    [collectLabel setImage:[UIImage imageNamed:@"collcet_select"] forState:UIControlStateSelected];
    [collectLabel addTarget:self action:@selector(collectOnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:collectLabel];
    
    
    
    
    
    
    projectNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40,  instituteControl.frame.size.height+instituteControl.frame.origin.y+width/32, width-width/20-width/20, width/22.8)];
    [projectNameLabel setText:@""];
    [projectNameLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [projectNameLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [scrollView addSubview:projectNameLabel];
    
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_logo"]];
    [localImageView setFrame:CGRectMake(width/40, projectNameLabel.frame.size.height+projectNameLabel.frame.origin.y+width/40, width/21.3, width/16.8)];
    UITapGestureRecognizer *addresGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAddress)];
    [localImageView addGestureRecognizer:addresGesture];
    [localImageView setUserInteractionEnabled:YES];
    [scrollView addSubview:localImageView];
    


    
    projectAddLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/21.3+width/40,  projectNameLabel.frame.size.height+projectNameLabel.frame.origin.y+width/20, width-(width/40+width/21.3+width/40)-width/40, width/29)];
    [projectAddLabel setText:@""];
    [projectAddLabel addGestureRecognizer:addresGesture];
    [projectAddLabel setUserInteractionEnabled:YES];
    [projectAddLabel setTextColor:[UIColor colorWithRed:85.f/255.f green:85.f/255.f blue:85.f/255.f alpha:1.0]];
    [projectAddLabel setFont:[UIFont systemFontOfSize:width/29]];
    [scrollView addSubview:projectAddLabel];
    
    
    

    
    
    UIImageView *phoneImagView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [phoneImagView setFrame:CGRectMake(localImageView.frame.origin.x, localImageView.frame.size.height+localImageView.frame.origin.y+width/32, width/22, width/17)];
//    UITapGestureRecognizer *callGesuture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
//    [phoneImagView addGestureRecognizer:callGesuture];
//    [phoneImagView setUserInteractionEnabled:YES];
//    [phoneImagView setBackgroundColor:[UIColor greenColor]];
//
//    [scrollView addSubview:phoneImagView];
    
//    phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(projectAddLabel.frame.origin.x, projectAddLabel.frame.size.height+projectAddLabel.frame.origin.y+width/25.6, width-(projectAddLabel.frame.origin.x)-width/40, width/26.7)];
//    [phoneLabel setText:@"联系电话：023-9523123"];
//    [phoneLabel setTextColor:[UIColor colorWithRed:85.f/255.f green:85.f/255.f blue:85.f/255.f alpha:1.0]];
//    [phoneLabel setFont:[UIFont systemFontOfSize:width/26.7]];
//    [phoneLabel setUserInteractionEnabled:YES];
//    [phoneLabel addGestureRecognizer:callGesuture];
//    [scrollView addSubview:phoneLabel];

    
    
    
    
    projectTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40,  phoneImagView.frame.size.height+phoneImagView.frame.origin.y+width/53, width, width/29)];
    [projectTimeLabel setText:@""];
    [projectTimeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];//
    //  [projectTimeLabel setBackgroundColor:[UIColor greenColor]];
    [projectTimeLabel setFont:[UIFont systemFontOfSize:width/29]];
    [scrollView addSubview:projectTimeLabel];
    
    [self initImageScrollView:projectTimeLabel];
    
    //免费或者收费
//        lei=[[UILabel alloc]initWithFrame:CGRectMake(width/2.5,  imageScrollview.frame.size.height+imageScrollview.frame.origin.y+width/20, width-(width/40+width/21.3+width/40)-width/40, width/29)];
//        [lei setText:@"免费课"];
//        [lei setTextColor:[UIColor greenColor]];
//        [lei setFont:[UIFont systemFontOfSize:width/24]];
//        [scrollView addSubview:lei];
    
    
    
    //    UILabel *beginTimeTopLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/3.3,imageScrollview.frame.size.height+imageScrollview.frame.origin.y+width/32,width/24.6*5,width/24.6)];
//    [beginTimeTopLabel setText:@"开课时间："];
//    [beginTimeTopLabel setTextColor:[UIColor colorWithRed:76.f/255.f green:76.f/255.f blue:76.f/255.f alpha:1.0]];
//    [beginTimeTopLabel setFont:[UIFont systemFontOfSize:width/24.6]];
//    [scrollView addSubview:beginTimeTopLabel];
//    
//    beginTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(beginTimeTopLabel.frame.size.width+beginTimeTopLabel.frame.origin.x,imageScrollview.frame.size.height+imageScrollview.frame.origin.y+width/32,width/29*10,width/29)];
//    [beginTimeLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
//    [beginTimeLabel setFont:[UIFont systemFontOfSize:width/24.6]];
//    [scrollView addSubview:beginTimeLabel];
  
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width/40, imageScrollview.frame.size.height+imageScrollview.frame.origin.y+width/26.7, width-width/20, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0]];
    
    [scrollView addSubview:lineView];
    
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.frame.size.height+lineView.frame.origin.y+width/32, width, width/26.7+width/35.5+hegiht/5+width/16+width/9)];
    //  [bottomView setBackgroundColor:[UIColor redColor]];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, 0,width-width/40-width/40, width/26.7)];
    [detailLabel setText:@"详情:"];
    [detailLabel setTextColor:[UIColor blackColor]];
    [detailLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [bottomView addSubview:detailLabel];
    detailContentLabel=[[UITextView alloc]initWithFrame:CGRectMake(width/40, detailLabel.frame.size.height+detailLabel.frame.origin.y+width/35.5,  width-width/40-width/40, hegiht/5)];
    [detailContentLabel setText:@""];
    detailContentLabel.editable=NO;
    [detailContentLabel setTextAlignment:NSTextAlignmentLeft];
    [detailContentLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [detailContentLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [bottomView addSubview:detailContentLabel];
    
    
   line=[[UILabel alloc]initWithFrame:CGRectMake(0, detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height+3, width, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [bottomView addSubview:line];
    tit=[[UILabel alloc]initWithFrame:CGRectMake(0, line.frame.origin.y+5, width/2, width/10)];
    tit.text=@"＊体验课预约规则";
    tit.font=[UIFont systemFontOfSize:width/22];
    tit.textColor=[UIColor redColor];
    [bottomView addSubview:tit];
    neirong=[[UITextView alloc]initWithFrame:CGRectMake(width/20, tit.frame.origin.y+tit.frame.size.height+2, width-width/28, 20)];
//    neirong.text=@"";
//    [neirong setTextColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    
    [neirong setText:@""];
    neirong.editable=NO;
    [neirong setTextAlignment:NSTextAlignmentLeft];
    [neirong setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [neirong setFont:[UIFont systemFontOfSize:width/26.7]];
    neirong.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:neirong];
    
    
    
//    //规则
    //规则详情显示
//    UILabel *lbe=[[UILabel alloc]initWithFrame:CGRectMake(0, guize.frame.origin.y+guize.frame.size.height+width/32, width, width/12)];
//    
//    lbe.text=[data objectForKey:@"lesson_rule"];
//
//    lbe.numberOfLines=0;
//    [bottomView addSubview: lbe];
//    上课时间选择按钮
    timeSelectView=[[UIView alloc]initWithFrame:CGRectMake(0, detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height+width/32, width, width/12.8)];
    [timeSelectView setUserInteractionEnabled:YES];
    [timeSelectView setBackgroundColor:[UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0]];
    UITapGestureRecognizer *timeSelectGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openTimeSelectPicker)];
    [timeSelectView addGestureRecognizer:timeSelectGesture];
    UILabel *timeSelectLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, width/40, width/26*7, width/26.7)];
    [timeSelectLabel setText:@"上课时间选择"];
    [timeSelectLabel setTextColor:[UIColor colorWithRed:77.f/255.f green:77.f/255.f blue:77.f/255.f alpha:1.0]];
    [timeSelectLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    UIImageView *timeSelectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(timeSelectLabel.frame.size.width+timeSelectLabel.frame.origin.x+width/80, timeSelectLabel.frame.origin.y, width/26.7*9/16, width/26.7)];
    [timeSelectImageView setImage:[UIImage imageNamed:@"go_logo"]];
    
    [timeSelectView addSubview:timeSelectLabel];
    [timeSelectView addSubview:timeSelectImageView];
    timeShowLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeSelectImageView.frame.size.width+timeSelectImageView.frame.origin.x+width/80, width/40, width/2, width/26.7)];
    [timeShowLabel setText:@""];
    [timeShowLabel setTextColor:[UIColor colorWithRed:77.f/255.f green:77.f/255.f blue:77.f/255.f alpha:1.0]];
    [timeShowLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    
    [timeSelectView addSubview:timeShowLabel];
    [bottomView addSubview:timeSelectView];
    
//    UILabel *guize=[[UILabel alloc]initWithFrame:CGRectMake(0,timeSelectView.frame.origin.y+timeSelectView.frame.size.height+100, width, width/12.8)];
//    [guize setText:@"*体验课预约规则"];
//    guize.textColor=[UIColor redColor];
//    [guize setFont:[UIFont systemFontOfSize:width/22]];
//    [bottomView addSubview:guize];
    
    
    registerLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/10, timeSelectView.frame.origin.y+timeSelectView.frame.size.height+width/9, width*8/10, width/9)];
    registerLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goOrderViewController)];
    [registerLabel addGestureRecognizer:registerRecognizer];
    if (isCancel) {
        [registerLabel setText:@"取消蹭课"];
    }else{
        [registerLabel setText:@"我想蹭她"];
        
    }
    [registerLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [registerLabel setTextAlignment:NSTextAlignmentCenter];
    [registerLabel setTextColor:[UIColor whiteColor]];
    [registerLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    registerLabel.layer.cornerRadius=7.0;
    registerLabel.layer.masksToBounds=YES;
    
    
    
    
    [bottomView addSubview:registerLabel];
    
    
    [scrollView addSubview:bottomView];
    
    [self.view addSubview:scrollView];
    
}

-(void)initTimePicker{
    selectWeekArry=nowWeekArray;
    int width=self.view.frame.size.width;
    timeSelectPicker=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width*10/6)];
    [timeSelectPicker setBackgroundColor:[UIColor whiteColor]];
    UIImageView *closeButton=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/24.6-width/14.2, width/42.7, width/14.2, width/14.2)];
    [closeButton setImage:[UIImage imageNamed:@"close_btn"]];
    [closeButton setUserInteractionEnabled:YES];
    UITapGestureRecognizer *closegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePopView:)];
    [closeButton addGestureRecognizer:closegesture];
    [timeSelectPicker addSubview:closeButton];
    
    //星期
    weekLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, width/18.3, width/22.8*2, width/22.8)];
    [weekLabel setText:@"本周"];
    [weekLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [weekLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [weekLabel setUserInteractionEnabled:YES];
    [weekLabel setTag:0];
    UITapGestureRecognizer *weekLabelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectWeekClick:)];
    [weekLabel addGestureRecognizer:weekLabelGesture];
    [timeSelectPicker addSubview:weekLabel];
    
    nextWeekLabel=[[UILabel alloc]initWithFrame:CGRectMake(weekLabel.frame.size.width+weekLabel.frame.origin.x+width/11.4, width/18.3, width/22.8*2, width/22.8)];
    [nextWeekLabel setText:@"下周"];
    [nextWeekLabel setTextColor:[UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1.0]];
    [nextWeekLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [nextWeekLabel setUserInteractionEnabled:YES];
    [nextWeekLabel setTag:1];
    UITapGestureRecognizer *nextWeekLabelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectWeekClick:)];
    [nextWeekLabel addGestureRecognizer:nextWeekLabelGesture];
    [timeSelectPicker addSubview:nextWeekLabel];
    
    //初始化参数
    weekId=[NSNumber numberWithInt:0];
    weekNum=[NSNumber numberWithInt:0];
    
    weekItemArray=[[NSMutableArray alloc]init];
    NSArray *weekArray=[NSArray arrayWithObjects:@"天",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    for (int i=0; i<[weekArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+weekLabel.frame.size.height+weekLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/9, width/14.5)];
        NSString *str=[weekArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        DayModel *dayModel=(DayModel *)[nowWeekArray objectAtIndex:i];
        
        NSLog(@"---------------\n\n\n daymodel:%@:%@:%@:%@",dayModel.day,dayModel.am,dayModel.pm,dayModel.night);
        
        if ([dayModel.am isEqualToString:@""] && [dayModel.pm isEqualToString:@""] &&[dayModel.night isEqualToString:@""] ) {
            [item setTextColor:[UIColor whiteColor]];
            [item setFocused:NO];
        }else{
            [item setTextColor:[UIColor blackColor]];
            [item setFocused:YES];
            
        }
        if (i==0) {
            [item setSelected:YES];
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
        }else{
            [item setSelected:NO];
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        }
        [item setTag:i];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [weekItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    //上午
    DayModel *dayModel=(DayModel *)[nowWeekArray objectAtIndex:0];
    
    NSArray *amArray = [dayModel.am componentsSeparatedByString:@","];
    NSMutableArray *mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[amArray count]; i++) {
        if (![[amArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[amArray objectAtIndex:i]];
        }
    }
    amArray=[mutAmArray copy];
//    item = amItemArray.count > 0 ? (TimeSelectItem *)[amItemArray lastObject]: (TimeSelectItem *)amLabel;
//    TimeSelectItem *item=(TimeSelectItem *)[weekItemArray lastObject];
    TimeSelectItem *item=weekItemArray.count>0?(TimeSelectItem *)[weekItemArray lastObject]:(TimeSelectItem *)weekLabel;
    amLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [amLabel setText:@"上午"];
    [amLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [amLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:amLabel];
    amItemArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[amArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+amLabel.frame.size.height+amLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[amArray objectAtIndex:i];
        
        
        NSLog(@"---------------------\n\n\n%@",str);
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        [item setTextColor:[UIColor blackColor]];
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(amOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [amItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    
    NSArray *pmArray = [dayModel.pm componentsSeparatedByString:@","];
    mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[pmArray count]; i++) {
        if (![[pmArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[pmArray objectAtIndex:i]];
        }
    }
    pmArray=[mutAmArray copy];
    //下午
#warning  修改位置 1
    item = amItemArray.count > 0 ? (TimeSelectItem *)[amItemArray lastObject]: (TimeSelectItem *)amLabel;
    pmLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [pmLabel setText:@"下午"];
    [pmLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [pmLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:pmLabel];
    pmItemArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[pmArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+pmLabel.frame.size.height+pmLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[pmArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        [item setTextColor:[UIColor blackColor]];
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pmOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [pmItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    //晚上
    NSArray *nightArray = [dayModel.night componentsSeparatedByString:@","];
    mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[nightArray count]; i++) {
        if (![[nightArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[nightArray objectAtIndex:i]];
        }
    }
    nightArray=[mutAmArray copy];
    
#warning  修改位置 2
    item = pmItemArray.count > 0 ? (TimeSelectItem *)[pmItemArray lastObject]: (TimeSelectItem *)pmLabel;
    nightLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [nightLabel setText:@"晚上"];
    [nightLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [nightLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:nightLabel];
    nightItemArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[nightArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+nightLabel.frame.size.height+nightLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[nightArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        if (true) {
            [item setTextColor:[UIColor whiteColor]];
        }else{
            [item setTextColor:[UIColor blackColor]];
        }
        if (true) {
            
        }else{
            
        }
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nightOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [nightItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    //确定按钮
    if ([nightItemArray count]>0) {
//       item = pmItemArray.count > 0 ? (TimeSelectItem *)[pmItemArray lastObject]: (TimeSelectItem *)pmLabel;
        item=(TimeSelectItem *)[nightItemArray lastObject];
        confirm=[[UILabel alloc]initWithFrame:CGRectMake(width/5.3, item.frame.size.height+item.frame.origin.y+width/14.5, width/1.6, width/9.1)];
    }else{
        item=(TimeSelectItem *)nightLabel;
        confirm=[[UILabel alloc]initWithFrame:CGRectMake(width/5.3, nightLabel.frame.size.height+nightLabel.frame.origin.y+width/14.5, width/1.6, width/9.1)];
    }
     
    [confirm setText:@"确定"];
    [confirm setTextAlignment:NSTextAlignmentCenter];
    [confirm setFont:[UIFont systemFontOfSize:width/21.3]];
    [confirm setTextColor:[UIColor whiteColor]];
    [confirm setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    confirm.layer.masksToBounds=YES;
    confirm.layer.cornerRadius=width/40;
    [confirm setUserInteractionEnabled:YES];
    UITapGestureRecognizer *cofirmGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timePickerConfirm)];
    [confirm addGestureRecognizer:cofirmGesture];
//    -------------------
    [timeSelectPicker addSubview:confirm];
    CGRect frame=timeSelectPicker.frame;
    frame.size.height=600;
    [timeSelectPicker setFrame:frame];
    
    
    
    
    
    
    
}
-(void)initWeekDay:(int)number{
    for (int i=0; i<[weekItemArray count]; i++) {
        TimeSelectItem *item=(TimeSelectItem *)[weekItemArray objectAtIndex:i];
        [item removeFromSuperview];
    }
    [weekItemArray removeAllObjects];
    
    int width=self.view.frame.size.width;
    NSArray *dataArray;
    if (number==0) {
        dataArray=[nowWeekArray copy];
    }else{
        dataArray=[nextWeekArray copy];
    }
    weekItemArray=[[NSMutableArray alloc]init];
    NSArray *weekArray=[NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    for (int i=0; i<[weekArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+weekLabel.frame.size.height+weekLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[weekArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        DayModel *dayModel=(DayModel *)[dataArray objectAtIndex:i];
        if ([dayModel.am isEqualToString:@""] && [dayModel.pm isEqualToString:@""] &&[dayModel.night isEqualToString:@""] ) {
            [item setTextColor:[UIColor whiteColor]];
            [item setFocused:NO];
        }else{
            [item setTextColor:[UIColor blackColor]];
            [item setFocused:YES];
            
        }
        if (i==0) {
            [item setSelected:YES];
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
        }else{
            [item setSelected:NO];
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        }
        [item setTag:i];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [weekItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    [self initAmPmNightView:0];
}
-(void)initAmPmNightView:(int)number{
    for (int i=0; i<[amItemArray count]; i++) {
        TimeSelectItem *item=(TimeSelectItem *)[amItemArray objectAtIndex:i];
        [item removeFromSuperview];
    }
    [amItemArray removeAllObjects];
    
    for (int i=0; i<[pmItemArray count]; i++) {
        TimeSelectItem *item=(TimeSelectItem *)[pmItemArray objectAtIndex:i];
        [item removeFromSuperview];
    }
    [pmItemArray removeAllObjects];
    
    for (int i=0; i<[nightItemArray count]; i++) {
        TimeSelectItem *item=(TimeSelectItem *)[nightItemArray objectAtIndex:i];
        [item removeFromSuperview];
    }
    [nightItemArray removeAllObjects];
    [confirm removeFromSuperview];
    [amLabel removeFromSuperview];
    [pmLabel removeFromSuperview];
    [nightLabel removeFromSuperview];
    
    int width=self.view.frame.size.width;
    //上午
    DayModel *dayModel=[[DayModel alloc]init];
    for (int i=0; i<[selectWeekArry count]; i++) {
        DayModel *model=[selectWeekArry objectAtIndex:i];
        if ([model.day intValue]==number) {
            dayModel=model;
        }
    }
    NSArray *amArray = [dayModel.am componentsSeparatedByString:@","];
    NSMutableArray *mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[amArray count]; i++) {
        if (![[amArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[amArray objectAtIndex:i]];
        }
    }
    amArray=[mutAmArray copy];
    TimeSelectItem *item=(TimeSelectItem *)[weekItemArray lastObject];
    amLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [amLabel setText:@"上午"];
    [amLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [amLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:amLabel];
    amItemArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[amArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+amLabel.frame.size.height+amLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[amArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        [item setTextColor:[UIColor blackColor]];
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(amOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [amItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    
    NSArray *pmArray = [dayModel.pm componentsSeparatedByString:@","];
    mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[pmArray count]; i++) {
        if (![[pmArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[pmArray objectAtIndex:i]];
        }
    }
    pmArray=[mutAmArray copy];
    //下午
    item = amItemArray.count > 0 ? (TimeSelectItem *)[amItemArray lastObject]: (TimeSelectItem *)amLabel;
//    item=(TimeSelectItem *)[amItemArray lastObject];
    pmLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [pmLabel setText:@"下午"];
    [pmLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [pmLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:pmLabel];
    pmItemArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[pmArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+pmLabel.frame.size.height+pmLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[pmArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        [item setTextColor:[UIColor blackColor]];
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pmOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [pmItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    //晚上
    NSArray *nightArray = [dayModel.night componentsSeparatedByString:@","];
    mutAmArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[nightArray count]; i++) {
        if (![[nightArray objectAtIndex:i] isEqualToString:@""]) {
            [mutAmArray addObject:[nightArray objectAtIndex:i]];
        }
    }
    nightArray=[mutAmArray copy];
      item = pmItemArray.count > 0 ? (TimeSelectItem *)[pmItemArray lastObject]: (TimeSelectItem *)pmLabel;
//    item=(TimeSelectItem *)[pmItemArray lastObject];
    nightLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, item.frame.origin.y+item.frame.size.height+width/32, width/22.8*2, width/22.8)];
    [nightLabel setText:@"晚上"];
    [nightLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [nightLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [timeSelectPicker addSubview:nightLabel];
    nightItemArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[nightArray count]; i++) {
        int paddingheight=width/35.5;//每组的高度
        int paddingwidth=width/22.8;//item横向距离
        float y=0;
        float x=0;
        x=width/21.3+width/8*(i%5)+paddingwidth*(i%5);
        y=(paddingheight+width/14.5)*(i/5)+nightLabel.frame.size.height+nightLabel.frame.origin.y+width/22.8;
        TimeSelectItem *item=[[TimeSelectItem alloc]initWithFrame:CGRectMake(x,y, width/8, width/14.5)];
        NSString *str=[nightArray objectAtIndex:i];
        [item setText:str];
        [item setTextAlignment:NSTextAlignmentCenter];
        [item setFont:[UIFont systemFontOfSize:width/26.7]];
        if (true) {
            [item setTextColor:[UIColor whiteColor]];
        }else{
            [item setTextColor:[UIColor blackColor]];
        }
        if (true) {
            
        }else{
            
        }
        [item setTag:i];
        [item setFocused:YES];
        [item setSelected:NO];
        [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
        item.layer.masksToBounds=YES;
        item.layer.cornerRadius=width/80;
        
        [item setUserInteractionEnabled:YES];
        UITapGestureRecognizer *weekGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nightOnClick:)];
        [item addGestureRecognizer:weekGesture];
        [nightItemArray addObject:item];
        [timeSelectPicker addSubview:item];
    }
    //确定按钮
    if ([nightItemArray count]>0) {
        item=(TimeSelectItem *)[nightItemArray lastObject];
        confirm=[[UILabel alloc]initWithFrame:CGRectMake(width/5.3, item.frame.size.height+item.frame.origin.y+width/14.5, width/1.6, width/9.1)];
    }else{
        confirm=[[UILabel alloc]initWithFrame:CGRectMake(width/5.3, nightLabel.frame.size.height+nightLabel.frame.origin.y+width/14.5, width/1.6, width/9.1)];
    }
    [confirm setText:@"确定"];
    [confirm setTextAlignment:NSTextAlignmentCenter];
    [confirm setFont:[UIFont systemFontOfSize:width/21.3]];
    [confirm setTextColor:[UIColor whiteColor]];
    [confirm setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    confirm.layer.masksToBounds=YES;
    confirm.layer.cornerRadius=width/40;
    [confirm setUserInteractionEnabled:YES];
    UITapGestureRecognizer *cofirmGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timePickerConfirm)];
    [confirm addGestureRecognizer:cofirmGesture];
    
    [timeSelectPicker addSubview:confirm];
    CGRect frame=timeSelectPicker.frame;
    frame.size.height=600;
    [timeSelectPicker setFrame:frame];
    
}

-(void)timePickerConfirm{
    NSLog(@"timePickerConfirm");
    NSString *str=@"";
    if ([weekId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        str=[str stringByAppendingFormat:@"%@",@"本周"];
    }else{
        str=[str stringByAppendingFormat:@"%@",@"下周"];
    }
    NSArray *weekArray=[NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    str=[str stringByAppendingFormat:@"%@",[weekArray objectAtIndex:[weekNum intValue]]];
    if (beginTime) {
        str=[str stringByAppendingFormat:@"%@",beginTime];
    }
    [timeShowLabel setText:str];
    NSLog(@"9999999999999999-%@",str);
    [CustomPopView disMiss:timeSelectPicker];
    
}
//选择本周还是下周
-(void)selectWeekClick:(UITapGestureRecognizer *)gesutre{
    if (gesutre.view.tag==0) {
        [weekLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
        [nextWeekLabel setTextColor:[UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1.0]];
    }else{
        [nextWeekLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
        [weekLabel setTextColor:[UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1.0]];
    }
    [self initWeekDay:(int)gesutre.view.tag];
    if (gesutre.view.tag==0) {
        selectWeekArry=nowWeekArray;
    }else{
        selectWeekArry=nextWeekArray;
    }
    weekId=[NSNumber numberWithInt:(int)gesutre.view.tag];

}
-(void)amOnClick:(UITapGestureRecognizer *)gesutre{
    NSLog(@"amOnClick");
    TimeSelectItem *item=(TimeSelectItem *)gesutre.view;
    if (item.focused) {
        item.selected=!item.selected;
        if (item.selected) {
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor whiteColor]];
            beginTime=item.text;
            for(int i=0;i<[amItemArray count];i++){
                TimeSelectItem *subitem=[amItemArray objectAtIndex:i];
                if (subitem.tag!=item.tag) {
                    subitem.selected=NO;
                    [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                    if(subitem.focused){
                        [subitem setTextColor:[UIColor blackColor]];
                    }else{
                        [subitem setTextColor:[UIColor whiteColor]];
                    }
                    
                }
            }
            for(int i=0;i<[nightItemArray count];i++){
                TimeSelectItem *subitem=[nightItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
                
            }
            for(int i=0;i<[pmItemArray count];i++){
                TimeSelectItem *subitem=[pmItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
                
                
            }
        }else{
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor blackColor]];
        }
        
    }
}
-(void)nightOnClick:(UITapGestureRecognizer *)gesutre{
    NSLog(@"nightOnClick");
    TimeSelectItem *item=(TimeSelectItem *)gesutre.view;
    if (item.focused) {
        item.selected=!item.selected;
        if (item.selected) {
            beginTime=item.text;
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor whiteColor]];
            for(int i=0;i<[nightItemArray count];i++){
                TimeSelectItem *subitem=[nightItemArray objectAtIndex:i];
                if (subitem.tag!=item.tag) {
                    subitem.selected=NO;
                    [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                    if(subitem.focused){
                        [subitem setTextColor:[UIColor blackColor]];
                    }else{
                        [subitem setTextColor:[UIColor whiteColor]];
                    }
                    
                }
            }
            for(int i=0;i<[pmItemArray count];i++){
                TimeSelectItem *subitem=[pmItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
                
                
            }
            for(int i=0;i<[amItemArray count];i++){
                TimeSelectItem *subitem=[amItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
            }
            
        }else{
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor blackColor]];
        }
        
    }
}
-(void)pmOnClick:(UITapGestureRecognizer *)gesutre{
    NSLog(@"pmOnClick");
    TimeSelectItem *item=(TimeSelectItem *)gesutre.view;
    if (item.focused) {
        item.selected=!item.selected;
        if (item.selected) {
            beginTime=item.text;
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor whiteColor]];
            for(int i=0;i<[pmItemArray count];i++){
                TimeSelectItem *subitem=[pmItemArray objectAtIndex:i];
                if (subitem.tag!=item.tag) {
                    subitem.selected=NO;
                    [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                    if(subitem.focused){
                        [subitem setTextColor:[UIColor blackColor]];
                    }else{
                        [subitem setTextColor:[UIColor whiteColor]];
                    }
                    
                }
            }
            for(int i=0;i<[amItemArray count];i++){
                TimeSelectItem *subitem=[amItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
            }
            for(int i=0;i<[nightItemArray count];i++){
                TimeSelectItem *subitem=[nightItemArray objectAtIndex:i];
                subitem.selected=NO;
                [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                if(subitem.focused){
                    [subitem setTextColor:[UIColor blackColor]];
                }else{
                    [subitem setTextColor:[UIColor whiteColor]];
                }
                
            }
        }else{
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor blackColor]];
        }
        
    }
}
-(void)weekOnClick:(UITapGestureRecognizer *)gesutre{
    NSLog(@"weekOnClick");
    TimeSelectItem *item=(TimeSelectItem *)gesutre.view;
    if (item.focused) {
        item.selected=!item.selected;
        if (item.selected) {
            [item setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor whiteColor]];
            NSLog(@"--------数组：%@",weekItemArray);
            for(int i=0;i<[weekItemArray count];i++){
                TimeSelectItem *subitem=[weekItemArray objectAtIndex:i];
                if (subitem.tag!=item.tag) {
                    subitem.selected=NO;
                    [subitem setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                    if(subitem.focused){
                        [subitem setTextColor:[UIColor blackColor]];
                    }else{
                        [subitem setTextColor:[UIColor whiteColor]];
                    }
                    
                }
            }
            [self initAmPmNightView:(int)item.tag];
           
        }else{
            [item setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
            [item setTextColor:[UIColor blackColor]];
        }
        
    }
    weekNum=[NSNumber numberWithInt:(int)item.tag];
}
-(void)openTimeSelectPicker{
    
    [self initTimePicker];
    [CustomPopView addViewAndShow:timeSelectPicker];
}
-(void)closePopView:(UITapGestureRecognizer *)gesutre{
    [CustomPopView disMiss:gesutre.view.superview];
}
//轮播图片
-(void)initImageScrollView:(UIView *)topView{
    //    图片中数
    int width=self.view.frame.size.width;
    
    // totalCount = 1;
    
    imageScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y+width/21, width, width/3)];
    //  CGRect bounds = scrollview.frame;  //获取界面区域
    
    // pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 30)];
    // pageControl.numberOfPages = totalCount;//总的图片页数
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
    [scrollView addSubview:imageScrollview];
    
    
}
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    if (uiScrollView.tag==2) {
        CGFloat scrollviewW =  uiScrollView.frame.size.width;
        CGFloat x = uiScrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        pageControl.currentPage = page;
    }
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    //  [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [timer invalidate];
}
//加载下张图片
- (void)nextImage
{
    int page = (int)pageControl.currentPage;
    if (page == totalCount-1) {
        page = 0;
    }else
    {
        page++;
    }
    

    //  滚动scrollview
    CGFloat x = page * imageScrollview.frame.size.width;
    imageScrollview.contentOffset = CGPointMake(x, 0);
}
-(void)setSelect{
    collectLabel.selected=true;
}
-(void)goOrderViewController{
    if ([timeShowLabel.text isEqualToString:@""]) {
        [self openTimeSelectPicker];
    }
    
    if ([timeShowLabel.text isEqualToString:@"本周日"]||[timeShowLabel.text isEqualToString:@"本周六"]||[timeShowLabel.text isEqualToString:@"本周五"]||[timeShowLabel.text isEqualToString:@"本周四"]||[timeShowLabel.text isEqualToString:@"本周三"]||[timeShowLabel.text isEqualToString:@"本周二"]||[timeShowLabel.text isEqualToString:@"本周一"]||[timeShowLabel.text isEqualToString:@"下周一"]||[timeShowLabel.text isEqualToString:@"下周二"]||[timeShowLabel.text isEqualToString:@"下周三"]||[timeShowLabel.text isEqualToString:@"下周四"]||[timeShowLabel.text isEqualToString:@"下周五"]||[timeShowLabel.text isEqualToString:@"下周六"]||[timeShowLabel.text isEqualToString:@"下周日"]) {
        UIAlertView * vi=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择具体时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
             [vi show];
    }
    else
    {
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (isCancel) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            //
//            +(void)deleteMyLesson:(NSNumber *)projectId withWeekId:(NSNumber *)weekid withWeekNum:(NSNumber *)weeknum withBeginTime:(NSString *) begintime withadvancetime:(NSNumber *)advancetime withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture
//        [HttpHelper deleteMyLesson:L_ID withWeekId:WEEK_ID withWeekNum:WEEK_NUM withBeginTime:ORDER_TIME withadvancetime:(NSNumber *) withModel:myDelegate.model success:^(HttpModel *model) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
            [HttpHelper deleteMyLesson:L_ID withWeekId:WEEK_ID withWeekNum:WEEK_NUM withBeginTime:ORDER_TIME withModel:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        //dataArray=[(NSMutableArray *)model.result mutableCopy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                        });
                        
                        
                    }else{
                        
                    }
                    [self dismissViewControllerAnimated:YES completion:^{
                        NSNotification *notification =[NSNotification notificationWithName:@"refresh" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        NSNotification *notification2 =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification2];
                    }];
                    
                    
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
            }];
        });
    }else{
        if (myDelegate.isLogin) {
            OrderViewController *orderViewController=[[OrderViewController alloc]init];
            [orderViewController setProjectId:[data objectForKey:@"id"]];
            [orderViewController setWeekId:weekId];
            [orderViewController setWeekNum:weekNum];
            [orderViewController setBeginTime:beginTime];
            if (advance_time==nil) {
                [orderViewController setAdvancetime: [NSNumber numberWithInteger:1]];
                NSLog(@"111111111111111111111111111111111111111111111111111111111111111111111111111111111");
            }
            else{
            
            [orderViewController setAdvancetime:advance_time];
            }
            if(detailContentLabel.text.length>30){
                [orderViewController setContent:[detailContentLabel.text substringToIndex:30]];
            }else{
                [orderViewController setContent:detailContentLabel.text];
            }
            NSLog(@"----------\n\n\n%@,%@,%@,%@,%@",[data objectForKey:@"id"],weekId,weekNum,beginTime,advance_time);
            
            [self presentViewController:orderViewController animated:YES completion:^{
                NSNotification *notification =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
            
        }
        
        
        else{
            LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
            [self presentViewController:loginRegViewController animated:YES completion:nil];
        }
    }
    }
}
-(void)cancelProject{
    
}
-(void)collectOnClick{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    collectLabel.selected=!collectLabel.selected;//每次点击都改变按钮的状态
    
    if(collectLabel.selected){
        [self collectionProject];
    }else{
        [self deleteProject];
    }
    
    //在此实现不打勾时的方法
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onClick{
    OrganDetailsViewController *organDetailsViewController=[[OrganDetailsViewController alloc]init];
    if ([data objectForKey:@"instid"]&& ![[data objectForKey:@"instid"]isEqual:[NSNull null]]) {
        [organDetailsViewController setAritcleId:[data objectForKey:@"instid"]];
        [self presentViewController:organDetailsViewController animated:YES completion:nil];
    }
    }

-(void)deleteProject{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper deleteFavoriteProject:[data objectForKey:@"id"] withModel:myDelegate.model
                                  success:^(HttpModel *model){
                                      
                                      NSLog(@"%@",model.message);
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  
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
-(void)collectionProject{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper collectionLesson:[data objectForKey:@"id"] withModel:myDelegate.model
                             success:^(HttpModel *model){
                                 
                                 NSLog(@"%@",model.message);
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             
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
-(void)getProjectInfo{
    
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getLessonInfo:projectId withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"返回的结果123:%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            advance_time=[dic objectForKey:@"advancetime"];
                            
                            
                            
                            NSLog(@"1111111111111111111111111111\n\n\n\n\n\n\n\n\n%@",advance_time);
//                            NSString *sb=[NSString stringWithFormat:@"%@",dic];
//                            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"提示" message:sb delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"你觉得呢", nil];
//                            [alt show];
                            
                                                        if (![[dic objectForKey:@"img"] isEqualToString:@""]) {
                                NSString *images=[dic objectForKey:@"img"];
                                                            
                                                            
                                                            
                                                            NSLog(@"images:98765432132154789554522------------------\n\n%@",images);
                                NSArray *array = [images componentsSeparatedByString:@","];
                                   //保存图片
                              NSUserDefaults *faut=[NSUserDefaults standardUserDefaults];
                                    [faut setObject:array forKey:@"pictures"];
                                                            
                                if ([array count]>0) {
                                    totalCount=[array count];
                                    pageControl.numberOfPages=totalCount;
                                    NSArray *views = [imageScrollview subviews];
                                    for(UIView *view in views)
                                    {
                                        [view removeFromSuperview];
                                    }
                                    
                                    //    图片的宽
                                    CGFloat imageW = imageScrollview.frame.size.width/3;
                                    //    CGFloat imageW = 300;
                                    //    图片高
                                    CGFloat imageH = imageScrollview.frame.size.height;
                                    //图片之间的间隔
                                    CGFloat paddingW=imageScrollview.frame.size.width/40;
                                    //    图片的Y
                                    CGFloat imageY = 0;
                                    
                                    //   1.添加5张图片
                                    for (int i = 0; i < [array count]; i++) {
                                        UIImageView *imageView = [[UIImageView alloc] init];
                                        [imageView setUserInteractionEnabled:YES];
                                        //        图片X
                                        CGFloat imageX = i *(imageW+paddingW);
                                        //        设置frame
                                        imageView.frame = CGRectMake(imageX+paddingW, imageY, imageW, imageH);
                                        //        设置图片
                                        NSString *logo=[array objectAtIndex:i];
                                        
//                                        tab=[[NSMutableArray alloc]init];
//                                        [tab addObject:logo];
//                                    
//                                        
//                                        NSLog(@"----------\n\n%@",tab);
                                        
                                        
                                        
                                        [imageView setImage:[UIImage imageNamed:@"banner_default"]];
                                        [imageView setTag:i];
                                        UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        [imageView addGestureRecognizer:openChorme];
                                        [imageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                                        NSLog(@"------789789789789\n\n\n\n\n%@",imageView.image);
                                      
                                        
                                        //        隐藏指示条
                                        imageScrollview.showsHorizontalScrollIndicator = NO;
                                        [imageScrollview addSubview:imageView];
                                        CGFloat contentW = totalCount *(imageW+paddingW)+paddingW;
                                        //不允许在垂直方向上进行滚动
                                        imageScrollview.contentSize = CGSizeMake(contentW, 0);
                                        
                                        //    3.设置分页
                                        imageScrollview.pagingEnabled = YES;
                                        
                                        //    4.监听scrollview的滚动
                                        imageScrollview.delegate = self;
                                    }
//                                    NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
//                                    [de setObject:tab forKey:@"tad"];
//                                    NSLog(@"---------\n\n\n\n\n\n\n\n\n\n%@",tab);
                                    CGRect bounds = imageScrollview.frame;  //获取界面区域
                                    
                                    
                                    //                                    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.size.height+imageScrollview.frame.origin.y-30, bounds.size.width, 30)];
                                    //                                    pageControl.numberOfPages = totalCount;//总的图片页数
                                    //
                                    //                                    [scrollView addSubview:pageControl];
                                }
                            }
                            
                            NSString *st=[dic objectForKey:@"logo"];
                            NSLog(@"九阴真经：、男、男、男、男、男、男、、n\n\n\n\n\n\n%@",st);
                            
                            
                            
                            if ([dic objectForKey:@"logo"]&& ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
                                NSString *logo=[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo"]];
                                [logoImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                                NSLog(@"22222222222222222\n\n\n%@",logoImageView.image);
                                
                                
                            }
                            if ([dic objectForKey:@"content"]&& ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                                [detailContentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                                CGRect frame=detailContentLabel.frame;
                                frame.size.height=detailContentLabel.contentSize.height;
                                [detailContentLabel setFrame:frame];
                                frame=timeSelectView.frame;
                                int width=self.view.frame.size.width;
                                
                                frame.origin.y=detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height+width/3;
                                
                                [timeSelectView setFrame:frame];
                                  frame.origin.y=detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height;
                                frame.size.height=1;
                                [line setFrame:frame];
//tit
                                frame.origin.y=line.frame.origin.y+line.frame.size.height+3;
                                frame.size.height=width/22;
                                [tit setFrame:frame];
                                
                                
                                //guize
                                neirong.text=[dic objectForKey:@"lesson_rule"];
                                CGRect frame1=neirong.frame;
                                frame1.origin.y=tit.frame.origin.y+tit.frame.size.height+width/20;
                                
                                frame1.size.height=neirong.contentSize.height;
                                [neirong setFrame:frame1];
                                
                                
                                
                                
                                
                                
                                
                                
                                
                               
                                [registerLabel setFrame:CGRectMake(width/10, timeSelectView.frame.origin.y+timeSelectView.frame.size.height+width/9, width*8/10, width/9)];
                                
                                frame=bottomView.frame;
                               
                                frame.size.height=registerLabel.frame.size.height+registerLabel.frame.origin.y+width/5.7;
                                [bottomView setFrame:frame];
                                [scrollView setContentSize:CGSizeMake(width, bottomView.frame.size.height+bottomView.frame.origin.y)];
                                
                                
                            }
                            if ([dic objectForKey:@"grade"]&& ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
                                [projectTimeLabel setText:[@"适合年龄段:"  stringByAppendingString:[dic objectForKey:@"grade"]]];
                            }
                            
                            
//                            btime=[dic objectForKey:@"btime"];
//                            NSLog(@"btime------>\n\n\n\n%@",btime);
                            if ([dic objectForKey:@"btime"]&& ![[dic objectForKey:@"btime"] isEqual:[NSNull null]]) {
                                NSNumber *number=[dic objectForKey:@"btime"];
                                NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                                NSString *timeStamp2 =[formater stringFromNumber:number];
                                long long int date1 = (long long int)[timeStamp2 intValue];
                                aDate = [NSDate dateWithTimeIntervalSince1970:date1];
                                //  aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[number integerValue]];
                                
                                
                                // NSString *str=[self compareCurrentTime:confromTimespStr];
                                
//                                //  [dateLabel setText:str];
//                                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//                                [beginTimeLabel setText:[self getBeginTime:number]];
                                
                            }
                            if([dic objectForKey:@"insttitle"]&& ![[dic objectForKey:@"insttitle"] isEqual:[NSNull null]]){
                                [instituteNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"insttitle"]]];
                            }
                            NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
                            
                            if([dic objectForKey:@"people"]&& ![[dic objectForKey:@"people"] isEqual:[NSNull null]]){
                                NSNumber *number=[dic objectForKey:@"people"];
                                [numbLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"lv"]&& ![[dic objectForKey:@"lv"] isEqual:[NSNull null]]){
                                NSNumber *number=[dic objectForKey:@"lv"];
                                [ratingBar displayRating:[number floatValue]];
                            }
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [projectNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            if([dic objectForKey:@"addr"]&& ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]){
                                [projectAddLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]]];
                            }
                            
                            if([dic objectForKey:@"isfavorite"] && ![[dic objectForKey:@"isfavorite"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"isfavorite"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    collectLabel.selected=false;
                                }else{
                                    collectLabel.selected=true;
                                }
                            }
                            if([dic objectForKey:@"tel"]&& ![[dic objectForKey:@"tel"] isEqual:[NSNull null]]){
                                phone=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
                                [phoneLabel setText:[NSString stringWithFormat:@"联系电话:%@",phone]];

                            }
//                            得到时间列表
                            NSNumber *lid=[dic objectForKey:@"id"];
                            L_ID=lid;
                            NSNumber *begtime=[dic objectForKey:@"btime"];
                            
                            
                            NSLog(@"\n\n\n\n得到 课程id ：%@得到时间：%@",lid,beginTime);
                            
                            
                            [self getTimeList:lid andBTime:begtime];
                            if([dic objectForKey:@"mylesson"] && ![[dic objectForKey:@"mylesson"] isEqual:[NSNull null]]){
                                NSArray *arry=[dic objectForKey:@"mylesson"];
                                NSDictionary *mylesson=[arry objectAtIndex:0];
                                WEEK_ID=[mylesson objectForKey:@"weekid"];
                                WEEK_NUM=[mylesson objectForKey:@"weeknum"];
                                ORDER_TIME=[mylesson objectForKey:@"ordertime"];
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
            
            [HttpHelper getLessonInfo:projectId success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                         bt=   [dic objectForKey:@"btime"];
                          
                            if (![[dic objectForKey:@"img"] isEqualToString:@""]) {
                                NSString *images=[dic objectForKey:@"img"];
                                NSArray *array = [images componentsSeparatedByString:@","];
                                NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
                                [de setObject:array forKey:@"pictures"];
                                if ([array count]>0) {
                                    totalCount=[array count];
                                    pageControl.numberOfPages=totalCount;
                                    NSArray *views = [imageScrollview subviews];
                                    for(UIView *view in views)
                                    {
                                        [view removeFromSuperview];
                                    }
                                    
                                    //    图片的宽
                                    CGFloat imageW = imageScrollview.frame.size.width/3;
                                    //    CGFloat imageW = 300;
                                    //    图片高
                                    CGFloat imageH = imageScrollview.frame.size.height;
                                    //图片之间的间隔
                                    CGFloat paddingW=imageScrollview.frame.size.width/40;
                                    //    图片的Y
                                    CGFloat imageY = 0;
                                    
                                    //   1.添加5张图片
                                    for (int i = 0; i < [array count]; i++) {
                                        UIImageView *imageView = [[UIImageView alloc] init];
                                        [imageView setUserInteractionEnabled:YES];
                                        //        图片X
                                        CGFloat imageX = i *(imageW+paddingW);
                                        //        设置frame
                                        imageView.frame = CGRectMake(imageX+paddingW, imageY, imageW, imageH);
                                        //        设置图片
                                        NSString *logo=[array objectAtIndex:i];
                                         NSLog(@"图片数据：\n\n\n\n\n\n\n%@",logo);
                                        [imageView setImage:[UIImage imageNamed:@"banner_default"]];
                                        [imageView setTag:i];
                                        UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        [imageView addGestureRecognizer:openChorme];
                                        if ([logo length]>0) {
                                            [imageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                                        }
                                       
//      http://211.149.190.90//Public/image/upload/20160607/575670b7b958f.jpg
//                 http://211.149.190.90//Public/image/upload/20160607/575670a9e7098.jpg
                                        //        隐藏指示条
                                        imageScrollview.showsHorizontalScrollIndicator = NO;
                                        [imageScrollview addSubview:imageView];
                                        CGFloat contentW = totalCount *(imageW+paddingW)+paddingW;
                                        //不允许在垂直方向上进行滚动
                                        imageScrollview.contentSize = CGSizeMake(contentW, 0);
                                        
                                        //    3.设置分页
                                        imageScrollview.pagingEnabled = YES;
                                        
                                        //    4.监听scrollview的滚动
                                        imageScrollview.delegate = self;
                                    }
                                    CGRect bounds = imageScrollview.frame;  //获取界面区域
                                    
                                    
                                    //                                    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.size.height+imageScrollview.frame.origin.y-30, bounds.size.width, 30)];
                                    //                                    pageControl.numberOfPages = totalCount;//总的图片页数
                                    //
                                    //                                    [scrollView addSubview:pageControl];
                                }
                            }
                          
                            if ([dic objectForKey:@"logo"]&& ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
                                NSString *logo=[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo"]];
                                [logoImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                            }
                            if ([dic objectForKey:@"content"]&& ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                                
                                [detailContentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                                
                                CGRect frame=detailContentLabel.frame;
                                
                                frame.size.height=detailContentLabel.contentSize.height;
                                
                                [detailContentLabel setFrame:frame];
                                frame=timeSelectView.frame;
                                int width=self.view.frame.size.width;
                                frame.origin.y=detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height+width/3;
                                [timeSelectView setFrame:frame];
                                frame.origin.y=detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height+3;
                                frame.size.height=1;
                                [line setFrame:frame];
                                
                                //tit
                                
                                frame.origin.y=line.frame.origin.y+line.frame.size.height+3;
                                frame.size.height=width/22;
                                [tit setFrame:frame];
                                
                                //guize
                                neirong.text=[dic objectForKey:@"lesson_rule"];
                                CGRect frame1=neirong.frame;
                                frame1.origin.y=tit.frame.origin.y+tit.frame.size.height+width/20;
                                
                                frame1.size.height=neirong.contentSize.height;
                                [neirong setFrame:frame1];
                                
                                
                                
                                
                               
                                [registerLabel setFrame:CGRectMake(width/10, timeSelectView.frame.origin.y+timeSelectView.frame.size.height+width/9, width*8/10, width/9)];
                                frame=bottomView.frame;
                                frame.size.height=registerLabel.frame.size.height+registerLabel.frame.origin.y+width/5.7;
                                [bottomView setFrame:frame];
                                [scrollView setContentSize:CGSizeMake(width, bottomView.frame.size.height+bottomView.frame.origin.y)];
                                
                            }
                            if ([dic objectForKey:@"grade"]&& ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
                                [projectTimeLabel setText:[@"适合年龄段:"  stringByAppendingString:[dic objectForKey:@"grade"]]];
                            }
                            if ([dic objectForKey:@"btime"]&& ![[dic objectForKey:@"btime"] isEqual:[NSNull null]]) {
                                NSNumber *number=[dic objectForKey:@"btime"];
                               
                               
                                NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                                NSString *timeStamp2 =[formater stringFromNumber:number];
                                long long int date1 = (long long int)[timeStamp2 intValue];
                                aDate = [NSDate dateWithTimeIntervalSince1970:date1];
                                
//                                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//                                
//                                [beginTimeLabel setText:[self getBeginTime:number]];
                                
                                
                            }
                            if([dic objectForKey:@"insttitle"]&& ![[dic objectForKey:@"insttitle"] isEqual:[NSNull null]]){
                                [instituteNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"insttitle"]]];
                            }
                            
                            if([dic objectForKey:@"people"]&& ![[dic objectForKey:@"people"] isEqual:[NSNull null]]){
                                NSNumber *number=[dic objectForKey:@"people"];
                                [numbLabel setText:[NSString stringWithFormat:@"%@",number]];
                            }
                            if([dic objectForKey:@"lv"]&& ![[dic objectForKey:@"lv"] isEqual:[NSNull null]]){
                                NSNumber *number=[dic objectForKey:@"lv"];
                                [ratingBar displayRating:[number floatValue]];
                            }
                            if([dic objectForKey:@"lv"]&& ![[dic objectForKey:@"lv"] isEqual:[NSNull null]]){
                                NSNumber *number=[dic objectForKey:@"lv"];
                                [ratingBar displayRating:[number floatValue]];
                            }
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [projectNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            //免费
//                            int kis=[[dic objectForKey:@"price"]intValue];
//                            if (kis==0) {
//                                [lei setText:@"免费课"];
//                                [lei setTextColor:[UIColor greenColor]];
//                            }else
//                            {
//                                [lei setText:[NSString stringWithFormat:@"¥  %i",kis]];
//                                [lei setFont:[UIFont systemFontOfSize:self.view.frame.size.width/22]];
//                                lei.textColor=[UIColor orangeColor];
//                            
//                            }
                            
                            
                            if([dic objectForKey:@"addr"]&& ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]){
                                [projectAddLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]]];
                            }
                            if([dic objectForKey:@"isfavorite"] && ![[dic objectForKey:@"isfavorite"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"isfavorite"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    collectLabel.selected=false;
                                }else{
                                    collectLabel.selected=true;
                                }
                            }
                            if([dic objectForKey:@"tel"]&& ![[dic objectForKey:@"tel"] isEqual:[NSNull null]]){
                                phone=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
                                [phoneLabel setText:[NSString stringWithFormat:@"联系电话:%@",phone]];

                            }
                            
                            NSNumber *lid=[dic objectForKey:@"id"];
                            L_ID=lid;
                            NSNumber *begtime=[dic objectForKey:@"btime"];
                            [self getTimeList:lid andBTime:begtime];
                           

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
-(NSString *)getBeginTime:(NSNumber *)created{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSString *timeString=[f stringFromNumber:created];
    
    NSNumberFormatter *fomate=[[NSNumberFormatter alloc]init];
    NSNumber *number=[fomate numberFromString:timeString];
    NSInteger myInteger = [number integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
//点击进入大图片
-(void)imageGesture:(UITapGestureRecognizer *)gesutre{
    UIImageView *imageView=(UIImageView *)gesutre.view;
    ScaleImgViewController *scaleImgViewController=[[ScaleImgViewController alloc]init];
    [scaleImgViewController setLoadImage:imageView.image];
    [scaleImgViewController reloadImage];
    [self presentViewController:scaleImgViewController animated:YES completion:nil];
    
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSTimeInterval  aTimer = [aDate timeIntervalSinceNow];
    if (aTimer>0) {
        int day=(int)(aTimer/3600/24);
        NSString *d=[NSString stringWithFormat:@"%d",day];
        int hour = (int)(aTimer - day*24*3600)/3600;
        NSString *h=[NSString stringWithFormat:@"%d",hour];
        
        int minute = (int)(aTimer- day*3600*24 - hour*3600)/60;
        NSString *m=[NSString stringWithFormat:@"%d",minute];
        
        int second = aTimer- day*3600*24 - hour*3600 - minute*60;
        NSString *s=[NSString stringWithFormat:@"%d",second];
        
        
        NSString *dural = [NSString stringWithFormat:@"离开课还剩%d天%d时%d分%d秒",day,hour,minute,second];
        NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:dural];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5,[d length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5+[d length]+1,[h length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5+[d length]+1+[h length]+1,[m length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5+[d length]+1+[h length]+1+[m length]+1,[s length])];
        
        [countDownLabel setAttributedText:str];
    }else{
        [countDownLabel setText:@"已开课"];
    }
    
}

-(void)openAddress{
    //获取当前位置
    
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    
    
    
    //当前经维度
    
    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
    
    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
    
    
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    CLLocationCoordinate2D coordinate;
    
    //目的地位置
    
    coordinate.latitude=[[data objectForKey:@"lat"] floatValue];
    
    coordinate.longitude=[[data objectForKey:@"lng"] floatValue];
    CLLocationCoordinate2D coords2 = coordinate;
    CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToGcj02:coords2];
    
//     + (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;
    
    
   
    
    
    
    // ios6以下，调用google map
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        
    {
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", coords1.latitude,coords1.longitude,coords2.latitude,coords2.longitude];
        NSURL *aURL = [NSURL URLWithString:urlString];
        
        //打开网页google地图
        
        [[UIApplication sharedApplication] openURL:aURL];
        
    }
    
    else
        
        // 直接调用ios自己带的apple map
        
    {
        
        //当前的位置
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        //起点
        
        //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        
        //目的地的位置
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords3 addressDictionary:nil]];
        
        
        
        toLocation.name = @"目的地";
        
        NSString *myname=[data objectForKey:@"addr"];
        
        
        toLocation.name =myname;
        
        
        
        
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        
        //打开苹果自身地图应用，并呈现特定的item
        
        [MKMapItem openMapsWithItems:items launchOptions:options];
        
    }
    
    
}
-(void)share{
    //[ShareTools shareToQQ];
    NSString *title=[@"这里有免费的"stringByAppendingString:searchLabel.text];
    NSString *txt;
    if ([detailContentLabel.text length]>30) {
        txt=[detailContentLabel.text substringToIndex:30];
    }else{
        txt=detailContentLabel.text;
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
                                        // [ProgressHUD showError:@"未安装微信！"];
                                    }
                                    break;
                                    
                                case 3:
                                    if (![WeiboSDK isWeiboAppInstalled]) {
                                        // [ProgressHUD showError:@"未安装微博！"];
                                    }
                                    break;
                                    
                                case 4:
                                case 5:
                                    if (![TencentOAuth iphoneQQInstalled]) {
                                        // [ProgressHUD showError:@"未安装QQ！"];
                                    }
                                    break;
                                    
                            }
                        }];
}
-(void)testTimeList{
    [self getTimeList:[NSNumber numberWithInt:0] andBTime:[NSNumber numberWithInt:0]];
}
-(void)resolvTimeList:(NSDictionary *)result{
    nowWeekArray=[[NSMutableArray alloc]init];
    nextWeekArray=[[NSMutableArray alloc]init];
    NSArray *now_week=[result objectForKey:@"now_week"];
    NSLog(@"now_week:\n\n\n\n\n%@",now_week);
    for(int j=0;j<7;j++){
        DayModel *dayModel=[[DayModel alloc]init];
        for (int i=0; i<[now_week count]; i++) {
            NSDictionary *dic=[now_week objectAtIndex:i];
            NSNumber *weeks=[dic objectForKey:@"weeks"];
            dayModel.day=[NSNumber numberWithInt:j];
            NSLog(@"291291291---%@",dayModel.pm);
            if (dayModel.am==nil) {
                dayModel.am=@"";
            }
            if (dayModel.pm==nil) {
                dayModel.pm=@"";
            }
            if (dayModel.night==nil) {
                dayModel.night=@"";
            }
            if([weeks intValue]==j){
                NSNumber *man=[dic objectForKey:@"man"];
                switch ([man intValue]) {
                    case 1://上午
                    {
                        dayModel.am=[dayModel.am stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                    }
                        break;
                    case 2://下午
                    {
                        dayModel.pm=[dayModel.pm stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                        
                    }
                        break;
                    case 3://晚上
                    {
                        dayModel.night=[dayModel.night stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        [nowWeekArray addObject:dayModel];
    }
    
    NSArray *next_week=[result objectForKey:@"next_week"];
    for(int j=0;j<7;j++){
        DayModel *dayModel=[[DayModel alloc]init];
        
        
        
        
        
        for (int i=0; i<[now_week count]; i++) {
            NSDictionary *dic=[next_week objectAtIndex:i];
            NSNumber *weeks=[dic objectForKey:@"weeks"];
            dayModel.day=[NSNumber numberWithInt:j];
            if (dayModel.am==nil) {
                dayModel.am=@"";
            }
            if (dayModel.pm==nil) {
                dayModel.pm=@"";
            }
            if (dayModel.night==nil) {
                dayModel.night=@"";
            }
            if([weeks intValue]==j){
                NSNumber *man=[dic objectForKey:@"man"];
                switch ([man intValue]) {
                    case 1://上午
                    {
                        dayModel.am=[dayModel.am stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                    }
                        break;
                    case 2://下午
                    {
                        dayModel.pm=[dayModel.pm stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                        
                    }
                        break;
                    case 3://晚上
                    {
                        dayModel.night=[dayModel.night stringByAppendingFormat:@",%@",[dic objectForKey:@"begintime"]];
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        [nextWeekArray addObject:dayModel];
    }
    NSLog(@"nowWeekArray:%@",nowWeekArray);
    NSLog(@"nextWeekArray:%@",nextWeekArray);
    
}
-(void)getTimeList:(NSNumber *)lid andBTime:(NSNumber *)btime{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HttpModel *model=myDelegate.model;
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    if (model.aid==nil) {
        model.aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getTimeList:lid withBeginTime:btime withAid:model.aid success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self resolvTimeList:model.result];
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
-(void)callPhone{
    if (phone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:%@" stringByAppendingString:phone]]];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{

    NSLog(@"87887888888888--\n\n\n%@",timeShowLabel.text);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end