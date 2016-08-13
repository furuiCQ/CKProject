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
#import "RJUtil.h"

#import <QuartzCore/QuartzCore.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WeiboSDK.h"
#import "ShareTools.h"
@interface ProjectDetailsViewController ()<UIScrollViewDelegate,PickerDelegate>{
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
    UIControl *contentControl;
    CLLocationManager *locationManager;
    CLLocation *neloct;
    NSString *lt;
    NSString *lg;
    UINib *nib;
    UILabel *distanceLabel;
    UIView *allShowView;
    ProjectTimePicker *picker;
    NSDictionary *timeData;
    
    UIImageView *collectImageView;
    UILabel *collectNorLabel;
    BOOL selected;
    
    //share
    NSDictionary* popJson;

}
@end

@implementation ProjectDetailsViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
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
    timeData=[[NSDictionary alloc]init];
    [self initTitle];
    [self initContent];
    [self initBootomView];
    [self initShareView];
    [self getProjectInfo];
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
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
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"课程详情"];
    
    //新建右上角的图形
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
-(void)initContent{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+0.5+20, width, hegiht-(titleHeight+0.5+20))];
    [scrollView setContentSize:CGSizeMake(width, hegiht)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    [self initImageScrollView:projectTimeLabel];
    
    UIControl *instituteControl=[[UIControl alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.size.height+imageScrollview.frame.origin.y, width, width/3.5)];
    [instituteControl setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:252.f/255.f blue:252.f/255.f alpha:1.0]];
    [scrollView addSubview:instituteControl];
    
    logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/30, width/22, width/5, width/5)];
    [logoImageView setImage:[UIImage imageNamed:@"instdetails_defalut"]];
    logoImageView.layer.cornerRadius=width/32;
    logoImageView.layer.masksToBounds=YES;
    [instituteControl addSubview:logoImageView];
    
    instituteNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x+width/27.8, logoImageView.frame.origin.y, width-(logoImageView.frame.size.width+logoImageView.frame.origin.x+width/27.8), width/21.3)];
    [instituteNameLabel setText:@"新东方英语培训中心"];
    [instituteNameLabel setFont:[UIFont systemFontOfSize:width/21.3]];
    [instituteNameLabel setTextColor:[UIColor blackColor]];
    [instituteControl addSubview:instituteNameLabel];
    //18px
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_gray"]];
    [localImageView setFrame:CGRectMake(instituteNameLabel.frame.origin.x, instituteNameLabel.frame.size.height+instituteNameLabel.frame.origin.y+width/35.6, width/35.6, width/23.7)];
    UITapGestureRecognizer *addresGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAddress)];
    [localImageView addGestureRecognizer:addresGesture];
    [localImageView setUserInteractionEnabled:YES];
    [instituteControl addSubview:localImageView];
    
    
    projectAddLabel=[[UILabel alloc]initWithFrame:CGRectMake(localImageView.frame.size.width+localImageView.frame.origin.x+width/49,  instituteNameLabel.frame.size.height+instituteNameLabel.frame.origin.y+width/37.6, width-(localImageView.frame.size.width+localImageView.frame.origin.x+width/49)-width/40, width/22.8*2)];
    [projectAddLabel setText:@"渝中区太平洋大厦3楼"];
    [projectAddLabel addGestureRecognizer:addresGesture];
    [projectAddLabel setUserInteractionEnabled:YES];
    [projectAddLabel setTextColor:[UIColor colorWithRed:85.f/255.f green:85.f/255.f blue:85.f/255.f alpha:1.0]];
    [projectAddLabel setFont:[UIFont systemFontOfSize:width/22.8]];//28px
    projectAddLabel.numberOfLines=0;
    [instituteControl addSubview:projectAddLabel];
    
    ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(instituteNameLabel.frame.origin.x, localImageView.frame.size.height+localImageView.frame.origin.y+width/35.6, width/29*6, width/20)];
    ratingBar.isIndicator=YES;
    [ratingBar setPadding:2];
    [ratingBar setImageDeselected:@"star_normal" halfSelected:nil fullSelected:@"star_light" andDelegate:nil];
    [ratingBar displayRating:4.0f];
    [instituteControl addSubview:ratingBar];
    //241,243,247)
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, instituteControl.frame.size.height+instituteControl.frame.origin.y, width, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [scrollView addSubview:lineView];
    
    UIControl *projectControl=[[UIControl alloc]initWithFrame:CGRectMake(0, lineView.frame.size.height+lineView.frame.origin.y, width, width/5.7)];
    [projectControl setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:252.f/255.f blue:252.f/255.f alpha:1.0]];
    [scrollView addSubview:projectControl];
    
    projectNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/29,  width/25.6, width*2/3, width/22.8)];
    [projectNameLabel setText:@"暑假英语酷学计划"];
    [projectNameLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [projectNameLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [projectControl addSubview:projectNameLabel];
    
    UILabel *ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/29,  projectNameLabel.frame.size.height+projectNameLabel.frame.origin.y+width/58, width*2/3, width/29)];
    [ageLabel setText:@"适合年龄段：3-16岁"];
    [ageLabel setFont:[UIFont systemFontOfSize:width/29]];
    [ageLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [projectControl addSubview:ageLabel];
    
    distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/4-width/16.8,  width/16.8, width/4, width/32)];
    [distanceLabel setText:@"500 米"];
    [distanceLabel setFont:[UIFont systemFontOfSize:width/32]];
    [distanceLabel setTextAlignment:NSTextAlignmentRight];
    [distanceLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [projectControl addSubview:distanceLabel];
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(0, projectControl.frame.size.height+projectControl.frame.origin.y+width/45.7, width, width/45.7)];
    [line2View setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [scrollView addSubview:line2View];
    
    contentControl=[[UIControl alloc]initWithFrame:CGRectMake(0, line2View.frame.size.height+line2View.frame.origin.y, width, width/3.5)];
    [contentControl setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:252.f/255.f blue:252.f/255.f alpha:1.0]];
    [scrollView addSubview:contentControl];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width/17.8*4)/2, width/20.6, width/17.8*4, width/17.8)];
    [titleLabel setText:@"课程介绍"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:width/17.8]];
    [contentControl addSubview:titleLabel];
    
    UIView *line3View=[[UIView alloc]initWithFrame:CGRectMake(width/8.9, width/12.5,  width/5.2, 0.5)];
    [line3View setBackgroundColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [contentControl addSubview:line3View];
    
    
    UIView *line4View=[[UIView alloc]initWithFrame:CGRectMake((width-width/8.9)-width/5.2, width/12.5, width/5.2, 0.5)];
    [line4View setBackgroundColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [contentControl  addSubview:line4View];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/30.4, width/33.6+titleLabel.frame.size.height+titleLabel.frame.origin.y, width/24.6*4, width/24.6)];
    [contentLabel setText:@"课程简介"];
    [contentLabel setTextAlignment:NSTextAlignmentLeft];
    [contentLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [contentControl addSubview:contentLabel];
    detailContentLabel=[[UITextView alloc]initWithFrame:CGRectMake(0, contentLabel.frame.size.height+contentLabel.frame.origin.y, width, 20)];
    [detailContentLabel setText:@"惺惺惜惺惺"];
    detailContentLabel.editable=NO;
    [detailContentLabel setTextAlignment:NSTextAlignmentLeft];
    [detailContentLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [detailContentLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    detailContentLabel.backgroundColor=[UIColor whiteColor];
    [contentControl addSubview:detailContentLabel];
    
    [self.view addSubview:scrollView];
    
}
-(void)initBootomView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    UIControl *collectControl=[[UIControl alloc]initWithFrame:CGRectMake(0,height-width/6.2, width/5.6, width/6.2)];
    [collectControl setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *collectNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width/20, width/5.6, width/32)];
    [collectNumLabel setText:@"288"];
    [collectNumLabel setFont:[UIFont systemFontOfSize:width/32]];
    [collectNumLabel setTextAlignment:NSTextAlignmentCenter];
    [collectControl addSubview:collectNumLabel];
    
    UILabel *collectDefaultLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, collectNumLabel.frame.size.height+collectNumLabel.frame.origin.y+width/64, width/5.6, width/26.7)];
    [collectDefaultLabel setText:@"收藏"];
    [collectDefaultLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [collectDefaultLabel setTextAlignment:NSTextAlignmentCenter];
    [collectControl addSubview:collectDefaultLabel];
    
    [self.view addSubview:collectControl];
    //预约
    UIControl *orderControl=[[UIControl alloc]initWithFrame:CGRectMake(collectControl.frame.size.width+collectControl.frame.origin.x,height-width/6.2, width/5.6, width/6.2)];
    [orderControl setBackgroundColor:[UIColor whiteColor]];
    
    numbLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width/20, width/5.6, width/32)];
    [numbLabel setText:@"234"];
    [numbLabel setFont:[UIFont systemFontOfSize:width/32]];
    [numbLabel setTextAlignment:NSTextAlignmentCenter];
    [orderControl addSubview:numbLabel];
    
    UILabel *orderDefaultLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, numbLabel.frame.size.height+numbLabel.frame.origin.y+width/64, width/5.6, width/26.7)];
    [orderDefaultLabel setText:@"预约"];
    [orderDefaultLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [orderDefaultLabel setTextAlignment:NSTextAlignmentCenter];
    [orderControl addSubview:orderDefaultLabel];
    
    [self.view addSubview:orderControl];
    //4.9  251 139 130
    UIControl *getCollectControl=[[UIControl alloc]initWithFrame:CGRectMake(orderControl.frame.size.width+orderControl.frame.origin.x,height-width/6.2, (width-orderControl.frame.size.width-orderControl.frame.origin.x)/2, width/6.2)];
    [getCollectControl setBackgroundColor:[UIColor colorWithRed:251.f/255.f green:139.f/255.f blue:130.f/255.f alpha:1.0]];
    [getCollectControl addTarget:self action:@selector(collectOnClick) forControlEvents:UIControlEventTouchUpInside];
    //37px高度：35px
    collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/32, getCollectControl.frame.size.height/2-width/18.2/2, width/17.3, width/18.2)];
    
    [collectImageView setImage:[UIImage imageNamed:@"start_white"]];
    [getCollectControl addSubview:collectImageView];
    
    collectNorLabel=[[UILabel alloc]initWithFrame:CGRectMake(collectImageView.frame.size.width+collectImageView.frame.origin.x+width/100, 0, (width-orderControl.frame.size.width-orderControl.frame.origin.x)/2-(collectImageView.frame.size.width+collectImageView.frame.origin.x+width/100), width/6.2)];
    [collectNorLabel setText:@"收藏课程"];
    [collectNorLabel setFont:[UIFont systemFontOfSize:width/20]];
    [collectNorLabel setTextColor:[UIColor whiteColor]];
    [collectNorLabel setTextAlignment:NSTextAlignmentLeft];
    
    [getCollectControl addSubview:collectNorLabel];
    [self.view addSubview:getCollectControl];
    
    //
    UIControl *getOrderControl=[[UIControl alloc]initWithFrame:CGRectMake(getCollectControl.frame.size.width+getCollectControl.frame.origin.x,height-width/6.2, (width-orderControl.frame.size.width-orderControl.frame.origin.x)/2, width/6.2)];
    [getOrderControl setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:80.f/255.f blue:82.f/255.f alpha:1.0]];
    [getOrderControl addTarget:self action:@selector(openTimeSelectPicker) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *orderNorLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (width-orderControl.frame.size.width-orderControl.frame.origin.x)/2, width/6.2)];
    [orderNorLabel setText:@"立即预约"];
    [orderNorLabel setFont:[UIFont systemFontOfSize:width/20]];
    [orderNorLabel setTextColor:[UIColor whiteColor]];
    [orderNorLabel setTextAlignment:NSTextAlignmentCenter];
    [getOrderControl addSubview:orderNorLabel];
    [self.view addSubview:getOrderControl];
    
}
-(void)initTimePicker{
    picker=[[ProjectTimePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width/1.8, self.view.frame.size.width, self.view.frame.size.height-self.view.frame.size.width/1.8)];
    [picker setBackgroundColor:[UIColor clearColor]];
    picker.pickerDelegate=self;
    [picker setData:timeData];
    [picker initView:nil];
    
}
-(void)openTimeSelectPicker{
    
    [self initTimePicker];
    [CustomPopView addViewAndShow:picker];
}
-(void)closePopView:(UITapGestureRecognizer *)gesutre{
    [CustomPopView disMiss:gesutre.view.superview];
}
//轮播图片
-(void)initImageScrollView:(UIView *)topView{
    //    图片中数
    int width=self.view.frame.size.width;
    
    // totalCount = 1;
    
    imageScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, width/1.6)];
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
    selected=true;
}

-(void)goOrderViewController{
    if ([timeShowLabel.text isEqualToString:@""]) {
        [self openTimeSelectPicker];
    }
    
    if ([timeShowLabel.text isEqualToString:@"本周日"]||[timeShowLabel.text isEqualToString:@"本周六"]||[timeShowLabel.text isEqualToString:@"本周五"]||[timeShowLabel.text isEqualToString:@"本周四"]||[timeShowLabel.text isEqualToString:@"本周三"]||[timeShowLabel.text isEqualToString:@"本周二"]||[timeShowLabel.text isEqualToString:@"本周一"]||[timeShowLabel.text isEqualToString:@"下周一"]||[timeShowLabel.text isEqualToString:@"下周二"]||[timeShowLabel.text isEqualToString:@"下周三"]||[timeShowLabel.text isEqualToString:@"下周四"]||[timeShowLabel.text isEqualToString:@"下周五"]||[timeShowLabel.text isEqualToString:@"下周六"]||[timeShowLabel.text isEqualToString:@"下周日"]) {
        UIAlertView * vi=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择具体时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [vi show];
    }else{
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
            
        }
    }
}
-(void)cancelProject{
    
}
-(void)collectOnClick{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    selected=!selected;//每次点击都改变按钮的状态
    
    if(selected){
        [self collectionProject];
    }else{
        [self deleteProject];
    }
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
                                             
                                             [collectNorLabel setText:@"已收藏"];
                                             
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
    NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
    NSNumber *ar=[stand objectForKey:@"lttt"];
    NSNumber *ngg=[stand objectForKey:@"nggg"];
    if (ar==NULL&&ngg==NULL) {
        ar=[NSNumber numberWithDouble:myDelegate.latitude];
        ngg=[NSNumber numberWithDouble:myDelegate.longitude];
    }
    if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
        ar=[NSNumber numberWithDouble:29.5];
        ngg=[NSNumber numberWithDouble:106.5];
    }
    if (myDelegate.isLogin) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper getLessonInfo:projectId withLng:ngg withLat:ar  withModel:myDelegate.model success:^(HttpModel *model){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            advance_time=[dic objectForKey:@"advancetime"];
                            
                            if ([dic objectForKey:@"range"] && ![[dic objectForKey:@"range"] isEqual:[NSNull null]]) {
                                NSNumber *range=[dic objectForKey:@"range"];
                                double distance=[range doubleValue];
                                if(distance>0.0){
                                    if (distance/1000>1) {
                                        [distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
                                    }else if (distance/1000<1 && distance/1000>0.5){
                                        [distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                                        
                                    }else if (distance/1000<0.5){
                                        [distanceLabel setText:@"<500m"];
                                    }
                                }
                            }
                            
                            if (![[dic objectForKey:@"img"] isEqualToString:@""]) {
                                NSString *images=[dic objectForKey:@"img"];
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
                                        UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        [imageView addGestureRecognizer:openChorme];
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
                                    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
                                    pageControl.pageIndicatorTintColor = [UIColor redColor];
                                    [scrollView addSubview:pageControl];
                                }
                            }
                            //NSString *st=[dic objectForKey:@"logo"];
                            if ([dic objectForKey:@"logo"]&& ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
                                NSString *logo=[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo"]];
                                [logoImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                            }
                            if ([dic objectForKey:@"content"]&& ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                                [detailContentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                                CGRect frame=detailContentLabel.frame;
                                frame.size.height=detailContentLabel.contentSize.height;
                                [detailContentLabel setFrame:frame];
                                //                                frame=timeSelectView.frame;
                                int width=self.view.frame.size.width;
                                frame=contentControl.frame;
                                frame.size.height=detailContentLabel.frame.size.height+detailContentLabel.frame.origin.y+width/23.7;
                                [contentControl setFrame:frame];
                                [detailContentLabel setScrollEnabled:NO];

                                [scrollView setContentSize:CGSizeMake(width, contentControl.frame.size.height+contentControl.frame.origin.y+width/6.2)];
                                
                                
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
                            if([dic objectForKey:@"title"]&& ![[dic objectForKey:@"title"] isEqual:[NSNull null]]){
                                [projectNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            }
                            if([dic objectForKey:@"addr"]&& ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]){
                                [projectAddLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]]];
                                [projectAddLabel sizeToFit];

                            }
                            
                            if([dic objectForKey:@"isfavorite"] && ![[dic objectForKey:@"isfavorite"] isEqual:[NSNull null]]){
                                NSNumber *zanStaues=[dic objectForKey:@"isfavorite"];
                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                    selected=false;
                                    [collectNorLabel setText:@"收藏课程"];
                                }else{
                                    selected=true;
                                    [collectNorLabel setText:@"已收藏"];
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
            
            [HttpHelper getLessonInfo:projectId withLng:ngg withLat:ar success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=model.result;
                            data=dic;
                            bt=[dic objectForKey:@"btime"];
                            
                            if ([dic objectForKey:@"range"] && ![[dic objectForKey:@"range"] isEqual:[NSNull null]]) {
                                NSNumber *range=[dic objectForKey:@"range"];
                                double distance=[range doubleValue];
                                if(distance>0.0){
                                    if (distance/1000>1) {
                                        [distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
                                    }else if (distance/1000<1 && distance/1000>0.5){
                                        [distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                                        
                                    }else if (distance/1000<0.5){
                                        [distanceLabel setText:@"<500m"];
                                    }
                                }
                            }
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
                                        UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
                                        [imageView addGestureRecognizer:openChorme];
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
                                    [scrollView addSubview:pageControl];
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
                                int width=self.view.frame.size.width;
                                
                                frame=contentControl.frame;
                                frame.size.height=detailContentLabel.frame.size.height+detailContentLabel.frame.origin.y+width/23.7;
                                [contentControl setFrame:frame];
                                [detailContentLabel setScrollEnabled:NO];
                                
                                [scrollView setContentSize:CGSizeMake(width, contentControl.frame.size.height+contentControl.frame.origin.y+width/6.2)];
                                
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
                            
                            if([dic objectForKey:@"addr"]&& ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]){
                                [projectAddLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]]];
                                [projectAddLabel sizeToFit];
                            }
                            //                            if([dic objectForKey:@"isfavorite"] && ![[dic objectForKey:@"isfavorite"] isEqual:[NSNull null]]){
                            //                                NSNumber *zanStaues=[dic objectForKey:@"isfavorite"];
                            //                                if ([zanStaues isEqualToNumber:[NSNumber numberWithInt:0]]) {
                            //                                   selected=false;
                            //                                }else{
                            //                                    collectLabel.selected=true;
                            //                                }
                            //                            }
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

//点击进入大图片
-(void)imageGesture:(UITapGestureRecognizer *)gesutre{
    UIImageView *imageView=(UIImageView *)gesutre.view;
    ScaleImgViewController *scaleImgViewController=[[ScaleImgViewController alloc]init];
    [scaleImgViewController setLoadImage:imageView.image];
    [scaleImgViewController reloadImage];
    [self presentViewController:scaleImgViewController animated:YES completion:nil];
    
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
        [allShowView addSubview:imageView];
    }
    [allShowView setHidden:YES];
    [self.view addSubview:allShowView];
}
-(void)share{
    if(allShowView.hidden){
        [allShowView setHidden:NO];
    }else{
        [allShowView setHidden:YES];
        
    }
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
    
    
    popJson=[NSDictionary  dictionaryWithObjectsAndKeys:title,@"title",
                            description,@"description",imageurl,@"imageurl",url,@"url",nil];
}
-(void)getTimeList:(NSNumber *)lid andBTime:(NSNumber *)btime{
    // AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    HttpModel *model=myDelegate.model;
    //    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getTimeList:lid withBeginTime:btime withAid:[NSNumber numberWithInteger:500100] success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        timeData=model.result;
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
-(void)orderClick:(NSNumber *)_weekId withWeekNum:(NSNumber *)_weekNum withBegintime:(NSString *)_beginTime{
    NSLog(@"orderClick");
    [CustomPopView disMiss:picker];
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (myDelegate.isLogin) {
        OrderViewController *orderViewController=[[OrderViewController alloc]init];
        [orderViewController setProjectId:[data objectForKey:@"id"]];
        [orderViewController setWeekId:_weekId];
        [orderViewController setWeekNum:_weekNum];
        [orderViewController setBeginTime:_beginTime];
        if (advance_time==nil) {
            [orderViewController setAdvancetime: [NSNumber numberWithInteger:1]];
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
        
    }else{
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -分享
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