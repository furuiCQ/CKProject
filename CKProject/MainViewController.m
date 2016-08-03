//
//  ViewController.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)
#import "MainViewController.h"
#import "HttpHelper.h"
#import "HttpModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
#import "AppDelegate.h"
#import "RJUtil.h"
#import "LoginRegViewController.h"
#import "ProgressHUD/ProgressHUD.h"
#import "CharesectionView.h"
#import "DayModel.h"
#import "JZLocationConverter.h"
#import "teseCell.h"
#import "MationViewController.h"
#import "ViewController.h"
//
//HttpHelper.m
@interface MainViewController ()<CLLocationManagerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ECDrawerLayoutDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationmanager;
    NSArray *tableArray;
    BOOL _isLoading;
    UIImageView *aimageView;
    int connectCount;
    int mainConnectCount;
    UITableView *addTableView;
    ECDrawerLayout *twoLayout;
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
    NSArray *localArray;
    NSNumber *localNumber;
    UIScrollView *sb;
    UIView *xinwen;
    int selectId;
    double *latt;
    double *logg;
    CLLocation *neloct;
    double localLat;
    double localLng;
    CLLocationManager *locationManager;
    NSArray *list;
    NSMutableArray *chasetArray;
    NSString *customServiceNumber;
    //修改
    UIScrollView   *sc;
    UICollectionView *acollectionView;
    NSNumber *lat3;
    NSNumber *lng3;
    NSArray *xws;
    int kscount;
    UIScrollView *st;
    int tok;
    UIPageControl *pag;
    NSTimer *timer3;
    //
    NSMutableArray *projectTableArray;
    
}

@end

@implementation MainViewController
@synthesize db;
@synthesize cityLabel;
@synthesize searchField;
@synthesize msgLabel;
@synthesize scrollview;
@synthesize pageControl;
@synthesize timer;
@synthesize totalCount;
@synthesize mainTableView;
@synthesize textLabel;
@synthesize titleHeight;
@synthesize bottomHeight;
@synthesize searchView;
@synthesize keyText;
@synthesize pointView;
static NSString * const DEFAULT_LOCAL_AID = @"500100";
- (void)viewDidLoad {
    [super viewDidLoad];
    db=[[NSMutableArray alloc]init];
    [self getnews];
    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sc.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*4.3);
    [self.view addSubview:sc];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    localLat=myDelegate.latitude;
    localLng=myDelegate.longitude;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenPoint) name:@"hiddenpoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPoint) name:@"showpoint" object:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription  打开定位信息
        locationmanager.delegate = self;
    }
    connectCount=3;
    mainConnectCount=3;
    [self initTitle];
    tableArray = [[NSArray alloc]init];
    
    localArray=[[NSArray alloc]init];
    localNumber=[[NSNumber alloc]init];
    [ProgressHUD show:@"加载中..."];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    locationManager.distanceFilter = 100.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    [locationManager startUpdatingLocation];
    
    [self getHotLesson];
    [self creatAlertView];
    [self getMainSlider];
    [self initImageScrollView];
    [self initMainView];
    
    [self getCity];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    neloct=newLocation;
    
    //    NSLog(@"纬度:%f",oldLocation.coordinate.latitude);
    //    NSLog(@"经度:%f",oldLocation.coordinate.longitude);
    [manager stopUpdatingLocation];
    //    CLLocationCoordinate2D wgsPt = newLocation.coordinate;
    
    //    CLLocationCoordinate2D bdPt = [JZLocationConverter bd09ToGcj02:wgsPt];
    
    //    //当使用模拟器定位在中国大陆以外地区，计算GCJ-02坐标还是返回WGS-84
    //    _pt1Lable.text = [NSString stringWithFormat:@"WGS-84(国际标准坐标)：\n %f,%f",wgsPt.latitude,wgsPt.longitude];
    //    _pt2Lable.text = [NSString stringWithFormat:@"GCJ-02(中国国测局坐标(火星坐标))：\n %f,%f",gcjPt.latitude,gcjPt.longitude];
    //    _pt3Lable.text = [NSString stringWithFormat:@"BD-09(百度坐标)：\n %f,%f",bdPt.latitude,bdPt.longitude];
    // 停止位置更新
    
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}


//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView  setUserInteractionEnabled:YES];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    UILabel *contextLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, titleHeight)];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddress)];
    [contextLabel addGestureRecognizer:gesture];
    [contextLabel setUserInteractionEnabled:YES];
    [titleView addSubview:contextLabel];
    
    
    cityLabel=[[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/7, titleHeight)];
    [cityLabel setText:@"重庆"];
    [cityLabel setFont:[UIFont systemFontOfSize:15]];
    [cityLabel setTextColor:[UIColor whiteColor]];
    [cityLabel setEnabled:NO];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    UIImageView *downView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_logn"]];
    [downView setFrame:CGRectMake(0, 0, 10, 7)];
    [cityLabel setRightView:downView];
    [cityLabel setRightViewMode:UITextFieldViewModeAlways];
    //新建右上角的图形
    msgLabel=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/32-self.view.frame.size.width/11.8, (titleHeight-self.view.frame.size.width/11.8)/2, self.view.frame.size.width/11.8, self.view.frame.size.width/11.8)];
    UITapGestureRecognizer *uITapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertView)];
    [msgLabel addGestureRecognizer:uITapGestureRecognizer];
    [msgLabel setUserInteractionEnabled:YES];
    [msgLabel setImage:[UIImage imageNamed:@"calendar"]];
    
    //新建查询视图
    searchField=[[CustomTextField alloc]initWithFrame:(CGRectMake(cityLabel.frame.size.width+cityLabel.frame.origin.x, titleHeight*2/16, self.view.frame.size.width-cityLabel.frame.size.width-cityLabel.frame.origin.x-msgLabel.frame.size.width-self.view.frame.size.width/32*2, titleHeight*3/4))];
    searchField.delegate=self;
    [searchField setBackgroundColor:[UIColor whiteColor]];
    [searchField.layer setCornerRadius:3.0f];
    [searchField setFont:[UIFont systemFontOfSize:15]];
    [searchField setPlaceholder:@"搜索你想蹭的课程"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30,titleHeight*3/4)];
    UIImageView *searchImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_logo"]];
    [searchImageView setFrame:CGRectMake(10, 10, 12, 12)];
    [view addSubview:searchImageView];
    [searchField setLeftView:view];
    [searchField setLeftViewMode:UITextFieldViewModeAlways];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchField];
    
    [self.view addSubview:titleView];
    
}

//轮播图片
-(void)initImageScrollView{
    //    图片中数
    
    // totalCount = 1;
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+20, self.view.frame.size.width, self.view.frame.size.width/2)];
    
    //  CGRect bounds = scrollview.frame;  //获取界面区域
    
    // pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 30)];
    // pageControl.numberOfPages = totalCount;//总的图片页数
    //    图片的宽
    CGFloat imageW = scrollview.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = scrollview.frame.size.height;
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
        scrollview.showsHorizontalScrollIndicator = NO;
        // [imageViewArray addObject:imageView];
        [scrollview addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    scrollview.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    scrollview.pagingEnabled = YES;
    [scrollview setTag:2];
    
    //    4.监听scrollview的滚动
    scrollview.delegate = self;
    
    [sc addSubview:scrollview];
    
    //  [self.view addSubview:pageControl];
    
    //  [self addTimer];
}
-(void)initMainView{
    int width=self.view.frame.size.width;
    int view_y=scrollview.frame.origin.y+scrollview.frame.size.height;
    
    //青少年专区
    UIView *youthView=[[UIView alloc]initWithFrame:CGRectMake(0, view_y, width/2.5,width/2.1)];
    [youthView setBackgroundColor:[UIColor whiteColor]];
    UITextField *youthtitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                 width/21.3, width/2.5-width/32, width/21.3)];
    [youthtitleTextView setText:@"青少年专区"];
    [youthtitleTextView setTextAlignment:NSTextAlignmentLeft];
    [youthtitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [youthView addSubview:youthtitleTextView];
    
    UITextField *youthcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   youthtitleTextView.frame.size.height+youthtitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [youthcontentTextView setText:@"德智体美全面发展"];
    [youthcontentTextView setTextColor:[UIColor grayColor]];
    [youthcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [youthView addSubview:youthcontentTextView];
    
    UIImageView *youthImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, width/2.1-width/4.5-width/16, width/2.5, width/4.5)];
    [youthImageview setImage:[UIImage imageNamed:@"youth_image"]];
    [youthView addSubview:youthImageview];
    [sc addSubview:youthView];
    //育儿
    UIView *childView=[[UIView alloc]initWithFrame:CGRectMake(youthView.frame.size.width+1, view_y, width-youthView.frame.size.width,width/5.5)];
    [childView setBackgroundColor:[UIColor whiteColor]];
    UITextField *childtitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                 width/21.3, width/2.5-width/32, width/21.3)];
    [childtitleTextView setText:@"育婴早教"];
    [childtitleTextView setTextAlignment:NSTextAlignmentLeft];
    [childtitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [childView addSubview:childtitleTextView];
    
    UITextField *childcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   childtitleTextView.frame.size.height+childtitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [childcontentTextView setText:@"给宝贝找一个放心的家"];
    [childcontentTextView setTextColor:[UIColor grayColor]];
    [childcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [childView addSubview:childcontentTextView];
    
    UIImageView *childimageview=[[UIImageView alloc]initWithFrame:CGRectMake(childView.frame.size.width-width/4.8,(width/5.5-width/7)/2, width/4.8, width/7)];
    [childimageview setImage:[UIImage imageNamed:@"child_image"]];
    [childView addSubview:childimageview];
    [sc addSubview:childView];
    //技能
    UIView *skillView=[[UIView alloc]initWithFrame:CGRectMake(youthView.frame.size.width+1, view_y+childView.frame.size.height+1, width/3.2,width/2.1-childView.frame.size.height-1)];
    [skillView setBackgroundColor:[UIColor whiteColor]];
    UITextField *skilltitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                 width/35.5, width/2.5-width/32, width/21.3)];
    [skilltitleTextView setText:@"技能满分"];
    [skilltitleTextView setTextAlignment:NSTextAlignmentLeft];
    [skilltitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [skillView addSubview:skilltitleTextView];
    
    UITextField *skillcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   skilltitleTextView.frame.size.height+skilltitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [skillcontentTextView setText:@"各种专业技能走起"];
    [skillcontentTextView setTextColor:[UIColor grayColor]];
    [skillcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [skillView addSubview:skillcontentTextView];
    
    UIImageView *skillimageview=[[UIImageView alloc]initWithFrame:CGRectMake((skillView.frame.size.width-width/4)/2,skillView.frame.size.height-width/6.3, width/4, width/6.3)];
    [skillimageview setImage:[UIImage imageNamed:@"skill_image"]];
    [skillView addSubview:skillimageview];
    [sc addSubview:skillView];
    
    //育儿
    UIView *girlView=[[UIView alloc]initWithFrame:CGRectMake(skillView.frame.size.width+skillView.frame.origin.x+1, skillView.frame.origin.y, width-skillView.frame.size.width-skillView.frame.origin.x-1,width/2.1-childView.frame.size.height-1)];
    [girlView setBackgroundColor:[UIColor whiteColor]];
    UITextField *girltitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                width/35.5, width/2.5-width/32, width/21.3)];
    [girltitleTextView setText:@"女生专区"];
    [girltitleTextView setTextAlignment:NSTextAlignmentLeft];
    [girltitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [girlView addSubview:girltitleTextView];
    
    
    UIImageView *girlimageview=[[UIImageView alloc]initWithFrame:CGRectMake(girlView.frame.size.width-width/6.9,girlView
                                                                            .frame.size.height-width/4.8, width/6.9, width/4.8)];
    [girlimageview setImage:[UIImage imageNamed:@"girl_image"]];
    [girlView addSubview:girlimageview];
    
    UITextField *girlcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                  girltitleTextView.frame.size.height+girltitleTextView.frame.origin.y+
                                                                                  width/53, width/2.5-width/32, width/27)];
    [girlcontentTextView setText:@"点我变女神"];
    [girlcontentTextView setTextColor:[UIColor grayColor]];
    [girlcontentTextView setFont:[UIFont systemFontOfSize:width/27]];
    [girlView addSubview:girlcontentTextView];
    
    [sc addSubview:girlView];
    
    //K12教育
    UIView *k12eduView=[[UIView alloc]initWithFrame:CGRectMake(0,youthView.frame.size.height+youthView.frame.origin.y+width/40, width/2-1,width/5.3)];
    [k12eduView setBackgroundColor:[UIColor whiteColor]];
    UITextField *k12edutitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                  width/21.3, width/2.5-width/32, width/21.3)];
    [k12edutitleTextView setText:@"K12教育"];
    [k12edutitleTextView setTextAlignment:NSTextAlignmentLeft];
    [k12edutitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [k12eduView addSubview:k12edutitleTextView];
    
    UITextField *k12educontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                    k12edutitleTextView.frame.size.height+k12edutitleTextView.frame.origin.y+
                                                                                    width/53, width/2.5-width/32, width/27)];
    [k12educontentTextView setText:@"基础教育一点通"];
    [k12educontentTextView setTextColor:[UIColor grayColor]];
    [k12educontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [k12eduView addSubview:k12educontentTextView];
    
    UIImageView *k12eduimageview=[[UIImageView alloc]initWithFrame:CGRectMake(k12eduView.frame.size.width-width/5.6-width/24,width/5.3-width/5.8, width/5.6, width/5.8)];
    [k12eduimageview setImage:[UIImage imageNamed:@"k12edu_image"]];
    [k12eduView addSubview:k12eduimageview];
    [sc addSubview:k12eduView];
    //生活体验
    UIView *lifeView=[[UIView alloc]initWithFrame:CGRectMake(k12eduView.frame.size.width+1, youthView.frame.size.height+youthView.frame.origin.y+width/40,  width/2,width/5.3)];
    [lifeView setBackgroundColor:[UIColor whiteColor]];
    UITextField *lifetitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                width/21.3, width/2.5-width/32, width/21.3)];
    [lifetitleTextView setText:@"生活体验"];
    [lifetitleTextView setTextAlignment:NSTextAlignmentLeft];
    [lifetitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [lifeView addSubview:lifetitleTextView];
    
    UITextField *lifecontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                  lifetitleTextView.frame.size.height+lifetitleTextView.frame.origin.y+
                                                                                  width/53, width/2.5-width/32, width/27)];
    [lifecontentTextView setText:@"精彩生活从这里开始"];
    [lifecontentTextView setTextColor:[UIColor grayColor]];
    [lifecontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [lifeView addSubview:lifecontentTextView];
    //83 × 111
    UIImageView *lifeimageview=[[UIImageView alloc]initWithFrame:CGRectMake(lifeView.frame.size.width-width/8-width/24,(width/5.5-width/5.7)/2, width/8, width/5.7)];
    [lifeimageview setImage:[UIImage imageNamed:@"life_image"]];
    [lifeView addSubview:lifeimageview];
    [sc addSubview:lifeView];
    
    
    
    
    //    int viewWidth=(width-width/640)/2;
    //    int viewHeight=width/5.3;
    //    int x=(width-width/640)/2+width/320;
    //    int y=scrollview.frame.origin.y+scrollview.frame.size.height+width/64;
    //    NSArray *imageArray=[[NSArray alloc]initWithObjects:@"teen",@"sprint",@"skill",@"girl",@"k12",@"生活体验",nil];
    //    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"青少年专区",@"育婴早教",@"技能满分",@"女生专属",@"k12",@"生活体验",nil];
    //    NSArray *contentArray=[[NSArray alloc]initWithObjects:@"德智体美全面发展",@"给宝贝找一个放心的",@"各种专业技能走起",@"点我变女神",@"基础教育一点通",@"精彩生活，从这里开始",nil];
    //
    //    chasetArray=[[NSMutableArray alloc]init];
    //    for(int i=0;i<6;i++){
    //        CharesectionView *subView=[[CharesectionView alloc]initWithFrame:CGRectMake((i%2)*x, y+(i/2)*(width/320+viewHeight),viewWidth, viewHeight)];
    //        CGRect frame=self.view.frame;
    //        [subView initView:&frame withTag:i];
    //        [subView.iconView setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
    //        [subView.titleLabel setText:[titleArray objectAtIndex:i]];
    //        [subView.contentLabel setText:[contentArray objectAtIndex:i]];
    //        [subView setUserInteractionEnabled:YES];
    //        [subView addTarget:self action:@selector(menuGesture:) forControlEvents:UIControlEventTouchUpInside];
    //        [subView setTag:i];
    //        [chasetArray addObject:subView];
    //        [sc addSubview:subView];
    //
    //    }
    [self getslid:lifeView];
    //新闻头条
    xinwen=[[UIView alloc]initWithFrame:CGRectMake(0, lifeView.frame.size.height+lifeView.frame.origin.y+1+width/26.7, width, width/8)];
    [xinwen setBackgroundColor:[UIColor whiteColor]];
    aimageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/32,0, width/5.7, width/8)];
    [aimageView setImage:[UIImage imageNamed:@"news_top"]];
    aimageView.backgroundColor=[UIColor whiteColor];
    aimageView.contentMode=UIViewContentModeScaleAspectFit;
    [xinwen addSubview:aimageView];
    st=[[UIScrollView alloc]initWithFrame:CGRectMake(aimageView.frame.origin.x+aimageView.frame.size.width, 0, width-aimageView.frame.size.width-aimageView.frame.origin.x, xinwen.frame.size.height)];
    st.pagingEnabled=YES;
    
    st.contentSize=CGSizeMake(st.frame.size.width, self.view.frame.size.width/5.5*(xws.count/2));
    st.showsVerticalScrollIndicator=false;
    // [ip addSubview:st];
    
    [xinwen addSubview:st];
    
    
    [sc addSubview:xinwen];
    
    [self initHotProjectTableView:xinwen];
    [self getCharsection];
    
    
}
//新闻头条的数据
-(void)getslid:(UIView *)subView{
    int width=self.view.frame.size.width;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getXW:self success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        xws=(NSArray *)model.result;
                        for (int i=0; i<xws.count; i++) {
                            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, i* (st.frame.size.height/2), st.frame.size.width, st.frame.size.height/2)];
                            NSDictionary *bt=[xws objectAtIndex:i];
                            lab.backgroundColor=[UIColor whiteColor];
                            lab.text=[bt objectForKey:@"title"];
                            lab.font=[UIFont systemFontOfSize:self.view.frame.size.width/23];
                            lab.textColor=[UIColor blackColor];
                            [st addSubview:lab];
                            
                        }
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tz)];
                        [st addGestureRecognizer:tap];
                        st.delegate=self;
                        timer3= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextxinwen) userInfo:nil repeats:YES];
                    });
                }else{
                    
                }
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    if (connectCount>0) {
                        connectCount--;
                        [self getMainSlider];
                    }
                    
                }
                
            }
        }];
    });
}

-(void)tz{
    
    ViewController *ma=[[ViewController alloc]init];
    [self presentViewController:ma animated:YES completion:nil];
    
    
    
}

-(void)nextxinwen
{
    int page = (int)pag.currentPage;
    //    NSLog(@"page----%i",page);
    if (page == tok-1) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    
    
    
    CGFloat x = page*st.frame.size.height;
    st.contentOffset = CGPointMake(0, x);
    
    
}
-(void)getCharsection{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    if (localNumber==nil) {
        localNumber=[formatter numberFromString:DEFAULT_LOCAL_AID];
        
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCharsection:localNumber success:^(HttpModel *model){
            //            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *chasetResult=(NSArray *)model.result;
                        for (int i=0; i<[chasetResult count]; i++) {
                            CharesectionView *subView=(CharesectionView *)[chasetArray objectAtIndex:i];
                            NSDictionary *dic=[chasetResult objectAtIndex:i];
                            NSString *logoUrl=[dic objectForKey:@"logo"];
                            if ([logoUrl length]>0) {
                                [subView.iconView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logoUrl]]];
                            }
                            [subView.titleLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                            [subView.contentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"smalltitle"]]];
                            [subView setSqlString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sqlstring"]]];
                        }
                        
                        
                    });
                    
                    
                }
                
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                
            }
            [refreshHeader endRefreshing];
            [ProgressHUD dismiss];
            
        }];
        
        
    });
    
}
-(void)menuGesture:(id)sender{
    //    NSLog(@"menuGesture");
    CharesectionView *view=(CharesectionView *)sender;
    if (view.sqlString!=nil && ![view.sqlString isEqual:[NSNull null]] && ![view.sqlString isEqualToString:@""] ) {
        ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
        [projectListViewController setTitleName:view.titleLabel.text];
        [self presentViewController:projectListViewController animated:YES completion:nil];
        [projectListViewController setHotModel:view.sqlString];
        
    }else{
        NSLog(@"功能暂未开通");
    }
}
//拨打电话按钮的功能实现
-(void)callCustomerService{
    NSLog(@"callCustomerService");
    if(customServiceNumber){
        NSLog(@"%@",customServiceNumber);
        //        NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
        //        NSString *phone=[formater stringFromNumber:customServiceNumber];
        
        NSString *ipone=[NSString stringWithFormat:@"tel://%@",customServiceNumber];
        NSURL *url=[NSURL URLWithString:ipone];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)initHotProjectTableView:(UIControl *)view{
    bottomHeight=49;
    
    int width=self.view.frame.size.width;
    //  CharesectionView *subView=(CharesectionView *)[chasetArray lastObject];
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               view.frame.size.height+view.frame.origin.y,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height*3.8)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.dataSource                        = self;
    mainTableView.delegate                          = self;
    mainTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height+2, width, width/8.8)];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [self initSwitchBtn:headerView];
    //    [headerView setBackgroundColor:[UIColor whiteColor]];
    //    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width/40, width/16, width/3, 1)];
    //    [lineView setBackgroundColor:[UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0]];
    //    UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(lineView.frame.size.width+lineView.frame.origin.x+width/26, width/26, width/21, width/21)];
    //    [logoImageView setImage:[UIImage imageNamed:@"hot"]];
    //    [headerView addSubview:logoImageView];
    //    mainTableView.scrollEnabled=NO;
    //    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x+width/160
    //                                                            , width/22.8, width/26.7*6, width/26.7)];
    //    [label setText:@"热门体验课"];
    //    [label setTextColor:[UIColor colorWithRed:230.f/255.f green:0.f/255.f blue:18.f/255.f alpha:1.0]];
    //    [label setFont:[UIFont systemFontOfSize:width/26.7]];
    //    [headerView addSubview:label];
    //
    //    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+width/26, width/16, width/3, 1)];
    //    [line1View setBackgroundColor:[UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0]];
    //
    //    [headerView addSubview:lineView];
    //    [headerView addSubview:line1View];
    [mainTableView setTableHeaderView:headerView];
    
    
    [sc addSubview:mainTableView];
    //    //添加刷新
    //    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    //    [_refreshControl setTintColor:[UIColor grayColor]];
    //
    //    [_refreshControl addTarget:self
    //                        action:@selector(refreshView:)
    //              forControlEvents:UIControlEventValueChanged];
    //    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    //    [mainTableView addSubview:_refreshControl];
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=mainTableView;
    [refreshHeader header];
    refreshHeader.beginRefreshingBlock=^(){
    };
    //    refreshFooter=[[YiRefreshFooter alloc] init];
    //    refreshFooter.scrollView=mainTableView;
    //    [refreshFooter footer];
    //    refreshFooter.beginRefreshingBlock=^(){
    //    };
    
    
    //
    
}
-(void)initSwitchBtn:(UIView *)superView{
    int width=self.view.frame.size.width;
    //    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, titleHeight*3/4)];
    //    [topView setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:topView];
    NSArray *array = [NSArray arrayWithObjects:@"推荐",@"热门",@"最新",@"附近", nil];
    projectTableArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[array count]; i++) {
        TopBar *topBar=[[TopBar alloc]initWithFrame:CGRectMake(width/[array count]*i, 0, width/[array count], titleHeight)];
        [topBar addTarget:self action:@selector(topBarOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBar setTag:i];
        [topBar setText:[array objectAtIndex:i]];
        [topBar initView];
        if(i==[array count]-1){
            [topBar setIsEnd:YES];
        }
        if(i==0){
            [topBar setChecked:YES];
            [topBar setIconColor:[UIColor redColor]];
            [topBar setTextColor:[UIColor redColor]];
        }else{
            [topBar setChecked:NO];
            [topBar setIconColor:[UIColor blackColor]];
            [topBar setTextColor:[UIColor blackColor]];
            
        }
        [topBar setLabelFont:[UIFont systemFontOfSize:width/22.8]];
        [topBar setLineViewFill];
        [superView addSubview:topBar];
        [projectTableArray addObject:topBar];
    }
}
-(void)topBarOnClick:(id)sender{
    TopBar *topBar=(TopBar *)sender;
    for (NSObject *object in projectTableArray) {
        TopBar *b=(TopBar *)object;
        if(b.tag!=topBar.tag){
            [b setChecked:NO];
            [b setIconColor:[UIColor blackColor]];
            [b setTextColor:[UIColor blackColor]];
        }else{
            [b setChecked:YES];
            [b setIconColor:[UIColor redColor]];
            [b setTextColor:[UIColor redColor]];
            
        }
    }
}
-(void)showAddress{
    UIAlertView  *at=[[UIAlertView alloc]initWithTitle:@"提示" message:@"现未开通其他城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [at show];
    
    
}
//-(void)showAddress{
//
//
//    int width=self.view.frame.size.width;
//    int hegiht=self.view.frame.size.height;
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
//    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
//    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
//    [titleView setBackgroundColor:[UIColor whiteColor]];
//    [view addSubview:titleView];
//
//    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
//    [cancelLabel setText:@"取消"];
//    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
//    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
//    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
//    [cancelLabel setUserInteractionEnabled:YES];
//    [cancelLabel setTag:1];
//    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
//    [cancelLabel addGestureRecognizer:cancelGesture];
//    [titleView addSubview:cancelLabel];
//
//
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
//    [titleLabel setText:@"区域"];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
//    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
//    [titleView addSubview:titleLabel];
//
//
//    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
//    //    [confirmLabel setText:@"确定"];
//    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
//    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
//    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
//    //    [confirmLabel setUserInteractionEnabled:YES];
//    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
//    //    [confirmLabel addGestureRecognizer:confrimGesture];
//    //    [titleView addSubview:confirmLabel];
//
//
//
//    addTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
//                                                              width/10+2+width/40+width/46,
//                                                              view.frame.size.width,
//                                                              view.frame.size.height-(width/10+2+width/40+width/46))];
//    [addTableView setBackgroundColor:[UIColor whiteColor]];
//    addTableView.dataSource                        = self;
//    addTableView.delegate                          = self;
//    [addTableView setTag:1];
//    [view addSubview:addTableView];
//
//   	twoLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
//    twoLayout.width=view.frame.size.width;
//    twoLayout.contentView=view;
//    twoLayout.delegate=self;
//    [self.view addSubview:twoLayout];
//    twoLayout.openFromRight = YES;
//    [twoLayout openDrawer];
//    if ([localArray count]<=0) {
//        [self getAllCity];
//    }else{
//        [addTableView reloadData];
//        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:selectId inSection:0];//定位到第8行
//        [addTableView scrollToRowAtIndexPath:idxPath
//                            atScrollPosition:UITableViewScrollPositionTop
//                                    animated:NO];
//
//    }
//
//
//
//}
#pragma mark - ECDrawerLayoutDelegate
- (void) drawerLayoutDidOpen:(id)sender
{
    
    NSLog(@"drawerLayout open");
}
- (void) drawerLayoutDidClose:(id)sender
{
    NSLog(@"drawerLayout close");
}
-(void)closeDrawLayout:(id)sender{
    UITapGestureRecognizer *gesutre=(UITapGestureRecognizer *)sender;
    switch (gesutre.view.tag) {
        case 1:
        {
            [twoLayout closeDrawer];
            
        }
            
            
            
            break;
            
        default:
            break;
    }
    NSLog(@"closeDrawLayout close");
}
-(void)confirmDrawLayout{
    NSLog(@"confirmDrawLayout close");
    //   [layout closeDrawer];
    
}

-(void)getAllCity{
    NSNumber *aid=[NSNumber numberWithInt:0];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCity:aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    localArray=(NSArray *)[result objectForKey:@"content"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [addTableView reloadData];
                        
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:selectId inSection:0];//定位到第8行
                        [addTableView scrollToRowAtIndexPath:idxPath
                                            atScrollPosition:UITableViewScrollPositionTop
                                                    animated:NO];
                        
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

//加载下张图片
- (void)nextImage
{
    int page = (int)pageControl.currentPage;
    NSLog(@"pppppppp:%i",page);
    if (page == totalCount-1) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * scrollview.frame.size.width;
    scrollview.contentOffset = CGPointMake(x, 0);
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    //NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    if (uiScrollView.tag==2) {
        CGFloat scrollviewW =  uiScrollView.frame.size.width;
        CGFloat x = uiScrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        pageControl.currentPage = page;
    }
    if (st) {
        CGFloat scrollviewW =  st.frame.size.height;
        CGFloat x = st.contentOffset.y;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        NSLog(@"页数； %i",page);
        pag.currentPage = page;
    }
    
    if (!_isLoading && uiScrollView.tag==0) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        
        //    如果内容高度大于UITableView高度，就取TableView高度
        
        //    如果内容高度小于UITableView高度，就取内容的实际高度
        
        float height = uiScrollView.contentSize.height > mainTableView.frame.size.height ?mainTableView.frame.size.height : uiScrollView.contentSize.height;
        
        
        
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.2) {
            
            // 调用上拉刷新方法
            NSLog(@"上拉加载");
            //[refreshFooter beginRefreshing];
            
        }
        
        if (- uiScrollView.contentOffset.y / mainTableView.frame.size.height > 0.2) {
            
            // 调用下拉刷新方法
            NSLog(@"刷新");
            [refreshHeader beginRefreshing];
            
            [self getHotLesson];
            [self getMainSlider];
            
            _isLoading=true;
        }
        
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
    [self addTimer];
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


-(void)initTableView{
    bottomHeight=49;
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               titleHeight+20+self.view.frame.size.width/2.8,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height-self.view.frame.size.width/2.8-titleHeight-20-bottomHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.dataSource                        = self;
    mainTableView.delegate                          = self;
    mainTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    [self.view addSubview:mainTableView];
    
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=mainTableView;
    [refreshHeader header];
    refreshHeader.beginRefreshingBlock=^(){
        
    };
    //    refreshFooter=[[YiRefreshFooter alloc] init];
    //    refreshFooter.scrollView=mainTableView;
    //    [refreshFooter footer];
    //    refreshFooter.beginRefreshingBlock=^(){
    //    };
    
    
    //
    
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
    switch ( tableView.tag) {
        case 0:
            
        {
            return [tableArray count];
        }
            break;
        default:
            
        {
            return [localArray count];
        }
            
            break;
            
    }
    return 0;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell ==nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([tableArray count]>0 && tableView.tag==0) {
        NSDictionary *str=[tableArray objectAtIndex:[indexPath row]];
        NSNumber *projectId=[str objectForKey:@"id"];
        NSString *logoUrl=[str objectForKey:@"logo"];
        CGRect frame = [cell frame];
        CGRect rx = [ UIScreen mainScreen ].bounds;
        int width=rx.size.width;
        UIView *subview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width/3.6+width/16)];
        [subview setBackgroundColor:[UIColor whiteColor]];
        //287x178
        UIImageView *proejctImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/32,width/32, width/2.2, width/3.6)];
        [proejctImageView setImage:[UIImage imageNamed:@"instlist_defalut"]];
        if ([logoUrl length]>0) {
            [proejctImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logoUrl]]];
        }
        [subview setTag:[projectId intValue]];
        
        
        [subview addSubview:proejctImageView];
        
        
        UILabel *projectName=[[UILabel alloc]initWithFrame:CGRectMake(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/45.7, proejctImageView.frame.origin.y, width-(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/128+width/42.7), width/25.6)];
        [projectName setText:[NSString stringWithFormat:@"%@",[str objectForKey:@"title"]]];
        [projectName setTextColor:[UIColor blackColor]];
        [projectName setFont:[UIFont systemFontOfSize:width/25.6]];
        [subview addSubview:projectName];
        
        UILabel *organName=[[UILabel alloc]initWithFrame:CGRectMake(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/45.7, projectName.frame.origin.y+projectName.frame.size.height+width/21.3, width-(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/128+width/42.7), width/29)];
        [organName setText:[NSString stringWithFormat:@"%@",[str objectForKey:@"insttitle"]]];
        [organName setTextColor:[UIColor colorWithRed:165.f/255.f green:165.f/255.f blue:165.f/255.f alpha:2.0]];
        [organName setFont:[UIFont systemFontOfSize:width/29]];
        [subview addSubview:organName];
        
        
        
        
        UIImageView *freeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/45.7,
                                                                                organName.frame.size.height+organName.frame.origin.y+width/26.7, width/26.7, width/18.8)];
        [freeImageView setImage:[UIImage imageNamed:@"free_image"]];
        
        [subview addSubview:freeImageView];
        
        UILabel *sut=[[UILabel alloc]initWithFrame:CGRectMake(freeImageView.frame.size.width+freeImageView.frame.origin.x+width/80,
                                                              organName.frame.size.height+organName.frame.origin.y+width/26.7, width/15, width/18.8)];
        
        double price=[[str objectForKey:@"price"]doubleValue];
        if (price==0) {
            [sut setText:@"免费"];
            [sut setTextColor:[UIColor colorWithRed:90.f/255.f green:201.f/255.f blue:170.f/255.f alpha:1.0]];
            [sut  setFont:[UIFont systemFontOfSize:width/32]];
        }
        else
        {
            [sut setText:[NSString stringWithFormat:@"¥%@",[str objectForKey:@"price"]]];
            [sut setTextColor:[UIColor orangeColor]];
            [sut  setFont:[UIFont systemFontOfSize:width/32]];
            
        }
        
        [subview addSubview:sut];
        
        
        UILabel *openLabel=[[UILabel alloc]initWithFrame:CGRectMake(sut.frame.size.width+sut.frame.origin.x+width/18, sut.frame.origin.y, width/32*5.5, width/18.8)];
        [openLabel setText:@"适应年龄段:"];
        [openLabel setTextColor:[UIColor colorWithRed:165.f/255.f green:165.f/255.f blue:165.f/255.f alpha:1.0]];
        [openLabel setFont:[UIFont systemFontOfSize:width/32]];
        [subview addSubview:openLabel];
        
        UILabel *openTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(openLabel.frame.size.width+openLabel.frame.origin.x, sut.frame.origin.y, width/32*5, width/18.8)];
        [openTimeLabel setTextColor:[UIColor colorWithRed:165.f/255.f green:165.f/255.f blue:165.f/255.f alpha:1.0]];
        [openTimeLabel setFont:[UIFont systemFontOfSize:width/32]];
        [openTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [subview addSubview:openTimeLabel];
        if([str objectForKey:@"grade"] && ![[str objectForKey:@"grade"] isEqual:[NSNull null]]){
            NSString *created=[str objectForKey:@"grade"];
            [openTimeLabel setText:created];
        }
        
        
        //21 × 29
        UIImageView *orderImageView=[[UIImageView alloc]initWithFrame:CGRectMake(proejctImageView.frame.size.width+proejctImageView.frame.origin.x+width/45.7,
                                                                                freeImageView.frame.size.height+freeImageView.frame.origin.y+width/32, width/30, width/22)];
        [orderImageView setImage:[UIImage imageNamed:@"order_image"]];
        [subview addSubview:orderImageView];
       
        UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(orderImageView.frame.size.width+orderImageView.frame.origin.x+width/64, orderImageView.frame.origin.y, width/35.5*6, width/20)];
        [imageTitle setTextAlignment:NSTextAlignmentLeft];
        [imageTitle setFont:[UIFont systemFontOfSize:width/35.5]];
        [imageTitle setTextColor:[UIColor grayColor]];
        [imageTitle setText:[NSString stringWithFormat:@"已报%@人",[str objectForKey:@"ordernum"]]];
        [subview addSubview:imageTitle];
        
        UILabel *distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/35.5-width/35.5*6,imageTitle.frame.origin.y, width/35.5*6, width/20)];
        [distanceLabel setText:@"2km"];
        [distanceLabel setTextAlignment:NSTextAlignmentRight];
        [distanceLabel setTextColor:[UIColor colorWithRed:165.f/255.f green:165.f/255.f blue:165.f/255.f alpha:1.0]];
        [distanceLabel setFont:[UIFont systemFontOfSize:width/35.5]];
        [subview addSubview:distanceLabel];
        
        if ([str objectForKey:@"lng"] && ![[str objectForKey:@"lng"] isEqual:[NSNull null]] &&
            [str objectForKey:@"lat"] && ![[str objectForKey:@"lat"] isEqual:[NSNull null]]) {
            NSNumber *lng=[str objectForKey:@"lng"];
            NSNumber *lat=[str objectForKey:@"lat"];
            //转化为坐标
            
            NSLog(@"得到的纬度:%f",neloct.coordinate.latitude);
            NSLog(@"经度:%f",neloct.coordinate.longitude);
            NSNumber *at=[NSNumber numberWithDouble:neloct.coordinate.latitude];
            NSNumber *ng=[NSNumber numberWithDouble:neloct.coordinate.longitude];
            NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
            [stand setObject: at forKey:@"lttt"];
            [stand setObject:ng forKey:@"nggg"];
            //            + (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;
            CLLocationCoordinate2D coordinate;
            coordinate.latitude=[lat floatValue];
            
            coordinate.longitude=[lng floatValue];
            
            CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToWgs84:coordinate];
            //               CLLocationCoordinate2D wgsPt = newLocation.coordinate;
            //
            //               CLLocationCoordinate2D bdPt = [JZLocationConverter bd09ToGcj02:wgsPt];
            
            
            double distance=[RJUtil LantitudeLongitudeDist:coords3.longitude other_Lat:coords3.latitude self_Lon:neloct.coordinate.longitude self_Lat:neloct.coordinate.latitude];
            
            NSLog(@"---------\n\n\n lng:%f\n %f ",coords3.longitude,coords3.latitude);
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
        
        
        [cell addSubview:subview];
        frame.size.height=width/3.6+width/16;
        [subview setFrame:frame];
        cell.frame = frame;
        
    }else if ([localArray count]>0 && tableView.tag==1) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[localArray objectAtIndex:[indexPath row]];
        [label setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:cityLabel.text].location!=NSNotFound) {
            [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*3/4, self.view.frame.size.width/22.8, self.view.frame.size.width/20, self.view.frame.size.width/22.8)];
            [rightView setImage:[UIImage imageNamed:@"select_logo"]];
            [cell addSubview:rightView];
            selectId=(int)[indexPath row];
        }
        
    }
    return cell;
}
//获取新闻头条
-(void)getnews
{
    //http://211.149.190.90:90/api/indexnews
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/indexnews"];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        db=[obj objectForKey:@"result"];
        //       NSLog(@"-------------")
        
        NSLog(@"db----------------\n\n\n\n\n\n\n\\n\n\n\n%@",db);
        //        [acollectionView reloadData];
        [self.view setNeedsDisplay];
    }];
    
    
}



-(void)onMoreClick:(id)sender{
    //    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    //    [def setObject: forKey:@"tite"];
    
    
    
    UIControl *control=(UIControl *)sender;
    int indexrow=(int)control.tag;
    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    NSDictionary *str=[tableArray objectAtIndex:indexrow];
    if ([str objectForKey:@"id"]) {
        NSNumber *number=[str objectForKey:@"id"];
        [projectListViewController setProjectID:number];
        [projectListViewController setProjectSubID:[NSNumber numberWithInt:0]];
        
    }
    if ([str objectForKey:@"title"]) {
        [projectListViewController setTitleName:[str objectForKey:@"title"]];
        
    }
    [self presentViewController: projectListViewController animated:YES completion:nil];
}
-(void)onClick:(id)sender{
    MainListItem *item=(MainListItem *)sender;
    int pJId=(int)item.tag;
    ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
    NSNumber *projectId=[NSNumber numberWithInt:pJId];
    [projectDetailsViewController setProjectId:projectId];
    [self presentViewController:projectDetailsViewController animated:YES completion:nil];
}

-(void)refreshData:(NSDictionary *)data withItem:(MainListItem *)item{
    NSString *title=[data objectForKey:@"title"];
    NSString *logo=[data objectForKey:@"biglogo"];
    NSNumber *people=[data objectForKey:@"people"];
    NSString *addr=[data objectForKey:@"addr"];
    NSString *grade=[data objectForKey:@"grade"];
    NSNumber *dateString=[data objectForKey:@"btime"];
    NSString *pname=[data objectForKey:@"pname"];
    int width=self.view.frame.size.width;
    
    if (![title isEqual:@""] && title!=nil && ![title isEqual:[NSNull null]]) {
        [item.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
    }
    if (![logo isEqual:@""] && logo!=nil && ![logo isEqual:[NSNull null]]) {
        [item.imageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
    }
    if (![people isEqual:@""] && people!=nil && ![people isEqual:[NSNull null]]) {
        NSString *str=@"已报";
        str=[str stringByAppendingFormat:@"%@人",people];
        [item.joinLabel setText:str];
        
        CGRect frame=item.joinLabel.frame;
        CGSize strSize=[str sizeWithFont:item.joinLabel.font maxSize:CGSizeMake(width, 0)];
        frame.size.width= strSize.width;
        [item.joinLabel setFrame:frame];
    }
    if (![addr isEqual:@""] && addr!=nil && ![addr isEqual:[NSNull null]]) {
        //        CGRect frame=item.addressLabel.frame;
        //        frame.origin.x=item.addressLabel.frame.size.width+item.joinLabel.frame.origin.x+width/40;
        //        CGSize strSize=[addr sizeWithFont:item.joinLabel.font maxSize:CGSizeMake(width, 0)];
        //        frame.size.width= strSize.width;
        //        [item.addressLabel setFrame:frame];
        [item.addressLabel setText:[NSString stringWithFormat:@"%@",addr]];
        
    }
    if (![pname isEqual:@""] && pname!=nil && ![pname isEqual:[NSNull null]]) {
        
        [item.typelabel setText:pname];
        CGRect frame=item.typelabel.frame;
        CGSize strSize=[pname sizeWithFont:item.joinLabel.font maxSize:CGSizeMake(width, 0)];
        frame.size.width= strSize.width+frame.size.height/2;
        [item.typelabel setFrame:frame];
        
    }
    if (![grade isEqual:@""] && grade!=nil && ![grade isEqual:[NSNull null]]) {
        CGRect frame=item.typelabel1.frame;
        frame.origin.x=item.typelabel.frame.size.width+item.typelabel.frame.origin.x+width/40;
        [item.typelabel1 setFrame:frame];
        [item.typelabel1 setText:[NSString stringWithFormat:@"%@",grade]];
        
    }
    if (![dateString isEqual:@""] && dateString!=nil && ![dateString isEqual:[NSNull null]]) {
        CGRect frame=item.typelabel2.frame;
        //        NSNumber *number=dateString;
        //        NSInteger myInteger = [number integerValue];
        //        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateStyle:NSDateFormatterMediumStyle];
        //        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        //        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        //        [formatter setTimeZone:timeZone];
        //        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
        //        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        //
        //        NSString *str=[self compareCurrentTime:confromTimespStr];
        
        
        NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
        NSString *timeStamp2 =[formater stringFromNumber:dateString];
        
        long long int date1 = (long long int)[timeStamp2 intValue];
        
        NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:date1];
        
        NSString *str=[self compareCurrentTime:aDate];
        frame.size.width=[str length]*frame.size.height;
        [item.typelabel2 setFrame:frame];
        [item.typelabel2 setText:[NSString stringWithFormat:@"%@",str]];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
    switch (tableView.tag) {
        case 0:
        {
            NSLog(@"tableview 00");
            NSDictionary *str=[tableArray objectAtIndex:[indexPath row]];
            NSNumber *projectId=[str objectForKey:@"id"];
            ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
            [projectDetailsViewController setProjectId:projectId];
            [self presentViewController:projectDetailsViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSDictionary *dic=[localArray objectAtIndex:[indexPath row]];
            if ([dic objectForKey:@"title"]) {
                NSString *str=[dic objectForKey:@"title"];
                localNumber=[dic objectForKey:@"id"];
                [cityLabel setText:[NSString stringWithFormat:@"%@",[str substringToIndex:2]]];
            }
            [twoLayout closeDrawer];
            [self getMainData];
            
            
            
        }
            break;
        default:
            break;
    }
    //    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    //    NSDictionary *str=[tableArray objectAtIndex:[indexPath row]];
    //    if ([str objectForKey:@"id"]) {
    //        NSNumber *number=[str objectForKey:@"id"];
    //        [projectListViewController setProjectID:number];
    //    }
    //    if ([str objectForKey:@"title"]) {
    //        [projectListViewController setTitleName:[str objectForKey:@"title"]];
    //
    //    }
    //    [self presentViewController: projectListViewController animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    // NSLog(@"高度:%f",cell.frame.size.height);
    return cell.frame.size.height;
    
}
//监听输入框焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showAlertView];
}

-(void)creatAlertView{
    int width=self.view.frame.size.width;
    
    searchView = [[UIView alloc] initWithFrame:CGRectMake(width/20, width/5, width-width/10, width/2)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    searchView.layer.cornerRadius=2.0f;
    
    keyText=[[UITextField alloc]initWithFrame:CGRectMake(width/20, width/20, searchView.frame.size.width-width/10, width/10)];
    [keyText setText:@"关键字"];
    [keyText setFont:[UIFont systemFontOfSize:width/26.7]];
    keyText.layer.cornerRadius=2.0f;
    [keyText setBackgroundColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [searchView addSubview:keyText];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+width/10+width/40+width/60, width/26.7*3, width/26.7)];
    [timeLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [timeLabel setText:@"时 间"];
    [searchView addSubview:timeLabel];
    
    UITextField *monthField=[[UITextField alloc]initWithFrame:CGRectMake(width/20+width/26.7*3, width/20+width/10+width/40, width/3.5, width/15)];
    [monthField setText:@"07"];
    monthField.layer.cornerRadius=3.0f;
    [monthField setTextAlignment:NSTextAlignmentCenter];
    [monthField setFont:[UIFont systemFontOfSize:width/26.7]];
    [monthField setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [monthField setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
    [searchView addSubview:monthField];
    
    UILabel *monthLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26.7*3+width/3.5+width/80, width/20+width/10+width/40+width/60, width/26, width/26.7)];
    [monthLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [monthLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [monthLabel setText:@"月"];
    [searchView addSubview:monthLabel];
    
    UITextField *dayField=[[UITextField alloc]initWithFrame:CGRectMake(width/20+width/26.7*3+width/3.5+width/26+width/40, width/20+width/10+width/40, width/3.5, width/15)];
    [dayField setText:@"07"];
    dayField.layer.cornerRadius=3.0f;
    [dayField setTextAlignment:NSTextAlignmentCenter];
    [dayField setFont:[UIFont systemFontOfSize:width/26.7]];
    [dayField setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [dayField setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
    [searchView addSubview:dayField];
    
    UILabel *dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26.7*3+width/3.5+width/26+width/3.5+width/40+width/80, width/20+width/10+width/40+width/60, width/26, width/26.7)];
    [dayLabel setFont:[UIFont systemFontOfSize:12]];
    [dayLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [dayLabel setText:@"日"];
    [searchView addSubview:dayLabel];
    
    
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:CGRectMake(searchView.frame.size.width/4,width/20+width/10+width/40+width/60+width/10, searchView.frame.size.width/2, width/9)];
    //   UITapGestureRecognizer *searchRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchData)];
    searchLabel.userInteractionEnabled=YES;
    //   [searchLabel addGestureRecognizer:searchRecognizer];
    [searchLabel setText:@"搜索"];
    [searchLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor orangeColor]];
    searchLabel.layer.borderColor=[UIColor orangeColor].CGColor;
    searchLabel.layer.cornerRadius=15.0;
    searchLabel.layer.borderWidth = 1; //要设置的描边宽
    searchLabel.layer.masksToBounds=YES;
    [searchView addSubview:searchLabel];
    
    
    
}
-(NSString *) compareCurrentTime:(NSDate*) date
//
{
    //    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *fromdate=[format dateFromString:compareString];
    //    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    //    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    //
    //    NSDate *compareDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    long temp = 0;
    NSString *result;
    if(timeInterval>0){
        if((temp = timeInterval/60) <60){
            result = [NSString stringWithFormat:@"余%ld分",temp];
        }
        
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"余%ld小",temp];
        }
        
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"余%ld天",temp];
        }
        
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"余%ld月",temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"余%ld年",temp];
        }
    }else{
        result = [NSString stringWithFormat:@"已开课"];
        
    }
    
    
    return  result;
}

-(void)createButton{
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 60)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:self.view.frame.size.width/21.3];
    textLabel.textColor = [UIColor redColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    textLabel.text = @"测试位置";
    [self.view addSubview:textLabel];
    
    UIButton *latBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    latBtn.frame = CGRectMake(100,130 , 150, 30);
    [latBtn setTitle:@"点击获取坐标" forState:UIControlStateNormal];
    [latBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latBtn addTarget:self action:@selector(getLat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latBtn];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cityBtn.frame = CGRectMake(100,180, 150, 30);
    [cityBtn setTitle:@"点击获取城市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.frame = CGRectMake(100,230, 150, 30);
    [allBtn setTitle:@"点击获取所有信息" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    [self showBorder:latBtn];
    [self showBorder:cityBtn];
    [self showBorder:allBtn];
}

-(void)showBorder:(UIButton *)sender{
    sender.layer.borderColor=[UIColor redColor].CGColor;
    sender.layer.borderWidth=0.5;
    sender.layer.cornerRadius = 8;
    
}

-(void)getLat
{
    __block __weak MainViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
            
        }];
    }
    
}

-(void)getCity
{
    //   __block __weak MainViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"当前城市:%@",cityString);
            // [wself setLabelText:cityString];
            [cityLabel setText:cityString];
        }];
        
    }
    
}


-(void)getAllInfo
{
    __block NSString *string;
    __block __weak MainViewController *wself = self;
    
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        } withAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
            [wself setLabelText:string];
            
        }];
    }
    
}
//-(void)getHotLesson{
//    NSNumber *userId=[NSNumber numberWithInt:0];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//
//        [HttpHelper getHotLesson:userId success:^(HttpModel *model){
//            NSLog(@"%@",model.message);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
//                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    myDelegate.model=model;
//                    tableArray=(NSArray *)model.result;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [mainTableView reloadData];
//                        _isLoading=false;
//
//                    });
//
//
//                }
//                [refreshHeader endRefreshing];
//                [ProgressHUD dismiss];
//
//            });
//        }failure:^(NSError *error){
//            if (error.userInfo!=nil) {
//                NSLog(@"%@",error.userInfo);
//
//            }
//            [refreshHeader endRefreshing];
//            [ProgressHUD dismiss];
//
//        }];
//
//
//    });
//
//
//}
-(void)getHotLesson{
    NSNumber *userId=[NSNumber numberWithInt:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
        
        NSNumber *ar=[stand objectForKey:@"lttt"];
        NSNumber *ngg=[stand objectForKey:@"nggg"];
        if (ar==NULL&&ngg==NULL) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        
        NSLog(@"77777777-%f", neloct.coordinate.longitude) ;
        [HttpHelper getHotLesson:userId withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
            NSLog(@"热门课程数据：\n\n\n\n\n%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    tableArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [mainTableView reloadData];
                        _isLoading=false;
                        
                    });
                    
                    
                }
                [refreshHeader endRefreshing];
                [ProgressHUD dismiss];
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                
            }
            [refreshHeader endRefreshing];
            [ProgressHUD dismiss];
            
        }];
        
        
    });
    
    
}
-(void)getMainData{
    mainConnectCount--;
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    if (localNumber==nil) {
        localNumber=[formatter numberFromString:DEFAULT_LOCAL_AID];
        
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getMainData:localNumber success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    tableArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [mainTableView reloadData];
                        _isLoading=false;
                        
                    });
                    
                    
                }
                [refreshHeader endRefreshing];
                [ProgressHUD dismiss];
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                
            }
            [refreshHeader endRefreshing];
            [ProgressHUD dismiss];
            
        }];
        
        
    });
    
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
    textLabel.text = text;
    [cityLabel setText:text];
}

-(void)showAlertView{
    
    SearchViewController *searchViewController=[[SearchViewController alloc]init];
    if (localNumber!=nil && ![localNumber isEqual:[NSNull null]]) {
        [searchViewController setAid:localNumber];
        
    }else{
        [searchViewController setAid:[NSNumber numberWithInt:500000]];
        
    }
    [self presentViewController: searchViewController animated:YES completion:nil];
}
//-(void)goneAlertView{
//    if (searchView!=nil) {
//        [searchView removeFromSuperview];
//        isShowing=NO;
//
//        [searchField resignFirstResponder];
//    }
//
//}
-(void)getMainSlider{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getSlider:self success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    customServiceNumber=model.custom_tel;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        connectCount=3;
                        list=(NSArray *)model.result;
                        if ([list count]>0) {
                            totalCount=[list count];
                            pageControl.numberOfPages=totalCount;
                            NSArray *views = [scrollview subviews];
                            for(UIView *view in views)
                            {
                                [view removeFromSuperview];
                            }
                            
                            //    图片的宽
                            CGFloat imageW = scrollview.frame.size.width;
                            //    CGFloat imageW = 300;
                            //    图片高
                            CGFloat imageH = scrollview.frame.size.height;
                            //    图片的Y
                            CGFloat imageY = 0;
                            
                            //   1.添加5张图片
                            for (int i = 0; i < [list count]; i++) {
                                UIImageView *imageView = [[UIImageView alloc] init];
                                [imageView setUserInteractionEnabled:YES];
                                //        图片X
                                CGFloat imageX = i * imageW;
                                //        设置frame
                                imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
                                //        设置图片
                                NSDictionary *dic=[list objectAtIndex:i];
                                
                                NSString *logo = [dic objectForKey:@"img"];
                                [imageView setImage:[UIImage imageNamed:@"banner_default"]];
                                [imageView setTag:i];
                                UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openChorme:)];
                                [imageView addGestureRecognizer:openChorme];
                                if ([logo length]>0) {
                                    [imageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                                }
                                //        隐藏指示条
                                scrollview.showsHorizontalScrollIndicator = NO;
                                [scrollview addSubview:imageView];
                                CGFloat contentW = totalCount *imageW;
                                //不允许在垂直方向上进行滚动
                                scrollview.contentSize = CGSizeMake(contentW, 0);
                                
                                //    3.设置分页
                                scrollview.pagingEnabled = YES;
                                
                                //    4.监听scrollview的滚动
                                scrollview.delegate = self;
                                
                                
                                
                                
                            }
                            CGRect bounds = scrollview.frame;  //获取界面区域
                            
                            
                            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, bounds.size.height*4/3, bounds.size.width, 30)];
                            pageControl.numberOfPages = totalCount;//总的图片页数
                            
                            [sc addSubview:pageControl];
                        }
                        
                        
                        
                    });
                    
                    
                }else{
                    
                }
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    if (connectCount>0) {
                        connectCount--;
                        [self getMainSlider];
                    }
                    
                }
                
            }
        }];
    });
    
}
-(void)openChorme:(UITapGestureRecognizer *)gesutre{
    int index=(int)gesutre.view.tag;
    NSDictionary *dic=[list objectAtIndex:index];
    NSString *url=[dic objectForKey:@"url"];
    if (![url isEqual:@""] && url!=nil && ![url isEqual:[NSNull null]]) {
        
        NSLog(@"111111111111111111111111---------\n\n\n\n%@",url);
        if ([url rangeOfString:@"http://"].location !=NSNotFound) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
        else
        {
            NSString *sur=[NSString stringWithFormat:@"http://211.149.190.90/%@",url];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sur]];
            //        http://211.149.190.90/m/20160126/index.html
        }
    }
    
}
-(void)goMsgViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    MyMsgViewController *myMsgViewController=[[MyMsgViewController alloc]init];
    [self presentViewController: myMsgViewController animated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}
-(void)hiddenPoint{
    [pointView setHidden:YES];
}
-(void)showPoint{
    [pointView setHidden:NO];
    
}



//#pragma 集合视图
//#pragma 集合视图的协议方法
////定义展示的UICollectionViewCell的个数
//
//-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
//
//{
//
//    NSLog(@"22------------\n\n %i",db.count);
//    return db.count ;
//
//}
//
////定义展示的Section的个数
//
//-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
//
//{
//
//    return 1 ;
//
//}
//
////每个UICollectionView展示的内容
//
//-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
//
//{
//
//    teseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : @"acell" forIndexPath :indexPath];
//    NSDictionary *ary=[db objectAtIndex:indexPath.row];
//    NSLog(@"9999999999:\n\n\n\n\n\n\n%@",[ary objectForKey:@"title"]);
//    cell.tils.text=[ary objectForKey:@"title"];
//    cell.backgroundColor=[UIColor whiteColor];
//
////    cell.ima.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
////    cell.tile.text=[titleArray objectAtIndex:indexPath.row];
////    cell.deta.text=[contentArray objectAtIndex:indexPath.row];
//    return cell;
//
//}
//
//#pragma mark --UICollectionViewDelegate
//
////UICollectionView被选中时调用的方法
//
//-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
//
//{
//   ViewController *ma=[[ViewController alloc]init];
//    [self presentViewController:ma animated:YES completion:nil];
//
//
////    cell. backgroundColor = [ UIColor colorWithRed :(( arc4random ()% 255 )/ 255.0 ) green :(( arc4random ()% 255 )/ 255.0 ) blue :(( arc4random ()% 255 )/ 255.0 ) alpha : 1.0f ];
//
//}
//
////返回这个UICollectionViewCell是否可以被选择
//
//-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
//
//{
//    return YES ;
//}
//
//#pragma mark --UICollectionViewDelegateFlowLayout
//
////定义每个UICollectionView的大小
//
//- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
//
//{
//
//    return CGSizeMake ( acollectionView.frame.size.width, acollectionView.frame.size.height/5 );
//
//}
//
////定义每个UICollectionView 的边距
//
//-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
//
//{
//    
//    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
//    
//}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [timer3 invalidate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
