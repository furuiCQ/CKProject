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
#import "ProjectTimePicker.h"
#import "OrderRecordCell.h"
#import "CalanderViewController.h"
@interface MainViewController ()<CLLocationManagerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationmanager;
    NSArray *tableArray;
    BOOL _isLoading;
    UIImageView *aimageView;
    int connectCount;
    int mainConnectCount;
    UITableView *addTableView;
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
    NSArray *list;
    NSMutableArray *chasetArray;
    NSString *customServiceNumber;
    //修改
    UIView   *sc;
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
    NSArray *chasetResult;
    
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
    sc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [sc setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [self.view addSubview:sc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity) name:@"changeCity" object:nil];

    //    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    localLat=myDelegate.latitude;
    //    localLng=myDelegate.longitude;
    
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
    
    [self getMainSlider];
    [self initImageScrollView];
    [self initMainView];
    
    [self getLat];
    [self getCity];
    [self getNewHotLesson];
    
}
-(void)changeCity{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![myDelegate.cityName isEqualToString:cityLabel.text]){
        TopBar *bar=[[TopBar alloc]init];
        [bar setTag:1];
        [self topBarOnClick:bar];
    }
    [cityLabel setText:myDelegate.cityName];
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
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCityViewController)];
    [contextLabel addGestureRecognizer:gesture];
    [contextLabel setUserInteractionEnabled:YES];
    [titleView addSubview:contextLabel];
    
    
    cityLabel=[[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setText:@"重庆"];
    [cityLabel setFont:[UIFont systemFontOfSize:15]];
    [cityLabel setTextColor:[UIColor whiteColor]];
    [cityLabel setEnabled:NO];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    //17 × 10
    UIImageView *downView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_down"]];
    [downView setFrame:CGRectMake(0, 0, 7, 3)];
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
    [searchImageView setFrame:CGRectMake(10, searchField.frame.size.height/2-17/2, 17, 17)];
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
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    
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
    [self addTimer];
    
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
    [youthtitleTextView setTag:101];
    [youthtitleTextView setEnabled:false];
    [youthtitleTextView setTextAlignment:NSTextAlignmentLeft];
    [youthtitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [youthView addSubview:youthtitleTextView];
    
    UITextField *youthcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   youthtitleTextView.frame.size.height+youthtitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [youthcontentTextView setText:@"德智体美全面发展"];
    [youthcontentTextView setTag:102];
    [youthcontentTextView setEnabled:false];
    [youthcontentTextView setTextColor:[UIColor grayColor]];
    [youthcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [youthView addSubview:youthcontentTextView];
    
    UIImageView *youthImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, width/2.1-width/4.5-width/16, width/2.5, width/4.5)];
    [youthImageview setImage:[UIImage imageNamed:@"youth_image"]];
    [youthImageview setTag:201];
    [youthView addSubview:youthImageview];
    [sc addSubview:youthView];
    //育儿
    UIView *childView=[[UIView alloc]initWithFrame:CGRectMake(youthView.frame.size.width+1, view_y, width-youthView.frame.size.width,width/5.5)];
    [childView setBackgroundColor:[UIColor whiteColor]];
    UITextField *childtitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                 width/21.3, width/2.5-width/32, width/21.3)];
    [childtitleTextView setText:@"育婴早教"];
    [childtitleTextView setTag:103];
    [childtitleTextView setEnabled:false];
    [childtitleTextView setTextAlignment:NSTextAlignmentLeft];
    [childtitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [childView addSubview:childtitleTextView];
    
    UITextField *childcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   childtitleTextView.frame.size.height+childtitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [childcontentTextView setText:@"给宝贝找一个放心的家"];
    [childcontentTextView setTextColor:[UIColor grayColor]];
    [childcontentTextView setTag:104];
    [childcontentTextView setEnabled:false];
    [childcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [childView addSubview:childcontentTextView];
    
    UIImageView *childimageview=[[UIImageView alloc]initWithFrame:CGRectMake(childView.frame.size.width-width/4.8,(width/5.5-width/7)/2, width/4.8, width/7)];
    [childimageview setImage:[UIImage imageNamed:@"child_image"]];
    [childimageview setTag:202];
    [childView addSubview:childimageview];
    [sc addSubview:childView];
    //技能
    UIView *skillView=[[UIView alloc]initWithFrame:CGRectMake(youthView.frame.size.width+1, view_y+childView.frame.size.height+1, width/3.2,width/2.1-childView.frame.size.height-1)];
    [skillView setBackgroundColor:[UIColor whiteColor]];
    UITextField *skilltitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                 width/35.5, width/2.5-width/32, width/21.3)];
    [skilltitleTextView setText:@"技能满分"];
    [skilltitleTextView setTag:105];
    [skilltitleTextView setEnabled:false];
    [skilltitleTextView setTextAlignment:NSTextAlignmentLeft];
    [skilltitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [skillView addSubview:skilltitleTextView];
    
    UITextField *skillcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                   skilltitleTextView.frame.size.height+skilltitleTextView.frame.origin.y+
                                                                                   width/53, width/2.5-width/32, width/27)];
    [skillcontentTextView setText:@"各种专业技能走起"];
    [skillcontentTextView setTag:106];
    [skillcontentTextView setEnabled:false];
    [skillcontentTextView setTextColor:[UIColor grayColor]];
    [skillcontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [skillView addSubview:skillcontentTextView];
    
    UIImageView *skillimageview=[[UIImageView alloc]initWithFrame:CGRectMake((skillView.frame.size.width-width/4)/2,skillView.frame.size.height-width/6.3, width/4, width/6.3)];
    [skillimageview setImage:[UIImage imageNamed:@"skill_image"]];
    [skillimageview setTag:203];
    [skillView addSubview:skillimageview];
    [sc addSubview:skillView];
    
    //育儿
    UIView *girlView=[[UIView alloc]initWithFrame:CGRectMake(skillView.frame.size.width+skillView.frame.origin.x+1, skillView.frame.origin.y, width-skillView.frame.size.width-skillView.frame.origin.x-1,width/2.1-childView.frame.size.height-1)];
    [girlView setBackgroundColor:[UIColor whiteColor]];
    UITextField *girltitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                width/35.5, width/2.5-width/32, width/21.3)];
    [girltitleTextView setText:@"女生专区"];
    [girltitleTextView setTag:107];
    [girltitleTextView setEnabled:false];
    [girltitleTextView setTextAlignment:NSTextAlignmentLeft];
    [girltitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [girlView addSubview:girltitleTextView];
    
    
    UIImageView *girlimageview=[[UIImageView alloc]initWithFrame:CGRectMake(girlView.frame.size.width-width/6.9,girlView
                                                                            .frame.size.height-width/4.8, width/6.9, width/4.8)];
    [girlimageview setImage:[UIImage imageNamed:@"girl_image"]];
    [girlimageview setTag:204];
    [girlView addSubview:girlimageview];
    
    UITextField *girlcontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                  girltitleTextView.frame.size.height+girltitleTextView.frame.origin.y+
                                                                                  width/53, width/2.5-width/32, width/27)];
    [girlcontentTextView setText:@"点我变女神"];
    [girlcontentTextView setTag:108];
    [girlcontentTextView setEnabled:false];
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
    [k12edutitleTextView setTag:109];
    [k12edutitleTextView setEnabled:false];
    [k12edutitleTextView setTextAlignment:NSTextAlignmentLeft];
    [k12edutitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [k12eduView addSubview:k12edutitleTextView];
    
    UITextField *k12educontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                    k12edutitleTextView.frame.size.height+k12edutitleTextView.frame.origin.y+
                                                                                    width/53, width/2.5-width/32, width/27)];
    [k12educontentTextView setText:@"基础教育一点通"];
    [k12educontentTextView setTextColor:[UIColor grayColor]];
    [k12educontentTextView setTag:110];
    [k12educontentTextView setEnabled:false];
    [k12educontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [k12eduView addSubview:k12educontentTextView];
    
    UIImageView *k12eduimageview=[[UIImageView alloc]initWithFrame:CGRectMake(k12eduView.frame.size.width-width/5.6-width/24,width/5.3-width/5.8, width/5.6, width/5.8)];
    [k12eduimageview setImage:[UIImage imageNamed:@"k12edu_image"]];
    [k12eduimageview setTag:205];
    [k12eduView addSubview:k12eduimageview];
    [sc addSubview:k12eduView];
    //生活体验
    UIView *lifeView=[[UIView alloc]initWithFrame:CGRectMake(k12eduView.frame.size.width+1, youthView.frame.size.height+youthView.frame.origin.y+width/40,  width/2,width/5.3)];
    [lifeView setBackgroundColor:[UIColor whiteColor]];
    UITextField *lifetitleTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                width/21.3, width/2.5-width/32, width/21.3)];
    [lifetitleTextView setText:@"生活体验"];
    [lifetitleTextView setTextAlignment:NSTextAlignmentLeft];
    [lifetitleTextView setTag:111];
    [lifetitleTextView setEnabled:false];
    [lifetitleTextView setFont:[UIFont systemFontOfSize:width/21.3]];
    [lifeView addSubview:lifetitleTextView];
    
    UITextField *lifecontentTextView=[[UITextField alloc]initWithFrame:CGRectMake(width/32,
                                                                                  lifetitleTextView.frame.size.height+lifetitleTextView.frame.origin.y+
                                                                                  width/53, width/2.5-width/32, width/27)];
    [lifecontentTextView setText:@"精彩生活从这里开始"];
    [lifecontentTextView setTextColor:[UIColor grayColor]];
    [lifecontentTextView setTag:112];
    [lifecontentTextView setEnabled:false];
    [lifecontentTextView setFont:[UIFont systemFontOfSize:width/32]];
    [lifeView addSubview:lifecontentTextView];
    //83 × 111
    UIImageView *lifeimageview=[[UIImageView alloc]initWithFrame:CGRectMake(lifeView.frame.size.width-width/8-width/24,(width/5.5-width/5.7)/2, width/8, width/5.7)];
    [lifeimageview setImage:[UIImage imageNamed:@"life_image"]];
    [lifeimageview setTag:206];
    [lifeView addSubview:lifeimageview];
    [sc addSubview:lifeView];
    
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
    [sc setFrame:CGRectMake(0, 0, width, xinwen.frame.size.height+xinwen.frame.origin.y)];
    [self initHotProjectTableView:xinwen];
    [self getCharsection];
    
    
}
//新闻头条的数据
-(void)getslid:(UIView *)subView{
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
                        pag=[[UIPageControl alloc]init];
                        pag.numberOfPages=xws.count;
                        tok=xws.count;
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
    [ma showBack];
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
                        chasetResult=(NSArray *)model.result;
                        for(UIView *view in [sc subviews]){
                            if([[view subviews]count]>0){
                                for(UIView *subview in [view subviews]){
                                    if([subview isKindOfClass:[UITextField class]]){
                                        if(subview.tag>=101){
                                            [view setTag:(subview.tag-101)/2];
                                            UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuGesture:)];
                                            [view setUserInteractionEnabled:YES];
                                            [view addGestureRecognizer:gestureRecognizer];
                                            NSDictionary *dic=[chasetResult objectAtIndex:((subview.tag-101)/2)];
                                            UITextField *textfield=(UITextField *)subview;
                                            if(subview.tag%2==0){
                                                [textfield setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"smalltitle"]]];
                                            }else{
                                                [textfield setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
                                            }
                                        }
                                    }
                                    if([subview isKindOfClass:[UIImageView class]]){
                                        if(subview.tag>=201){
                                            NSLog(@"subview.tag%ld",(long)subview.tag);
                                          
                                        }
                                    }
                                }
                            }
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
-(void)menuGesture:(UITapGestureRecognizer *)sender{
    //    NSLog(@"menuGesture");
    UIView *view=(UIView *)sender.view;
    NSDictionary *dic=[chasetResult objectAtIndex:view.tag];
    NSString *title=[dic objectForKey:@"title"];
    NSString *sqlString=[dic objectForKey:@"sqlstring"];
    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    [projectListViewController setTitleName:title];
    [self presentViewController:projectListViewController animated:YES completion:nil];
    [projectListViewController setHotModel:sqlString];
}
-(void)initHotProjectTableView:(UIView *)view{
    bottomHeight=49;
    
    int width=self.view.frame.size.width;
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               titleHeight+20,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height-titleHeight-20-titleHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.dataSource                        = self;
    mainTableView.delegate                          = self;
    mainTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    mainTableView.separatorStyle=NO;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, sc.frame.size.height+2, width, 36)];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [self initSwitchBtn:headerView];
    [sc addSubview:headerView];
    [sc setFrame:CGRectMake(0, 0, width, headerView.frame.size.height+headerView.frame.origin.y)];
    [mainTableView setTableHeaderView:sc];
    
    [self.view addSubview:mainTableView];
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=mainTableView;
    [refreshHeader header];
    refreshHeader.beginRefreshingBlock=^(){
    };
    
}
-(void)initSwitchBtn:(UIView *)superView{
    int width=self.view.frame.size.width;
    
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
    switch (topBar.tag) {
        case 0:
        {
            [self getNewHotLesson];
        }
            break;
        case 1:
        {
            [self getHotLesson];
        }
            break;
        case 2:
        {
            [self getNewLesson];
        }
            break;
        case 3:
        {
            [self getNearByLesson];
        }
            break;
            
        default:
            break;
    }
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
//加载下条新闻
-(void)nextxinwen
{
    int page = (int)pag.currentPage;
   // NSLog(@"nextxinwen page----%i",page);
    if (page == tok-1) {
        page = 0;
    }else
    {
        page++;
    }
    CGFloat x = page*st.frame.size.height;
    st.contentOffset = CGPointMake(0, x);
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
    CGFloat x = page * scrollview.frame.size.width;
    scrollview.contentOffset = CGPointMake(x, 0);
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
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
        pag.currentPage = page;
    }
    if (!_isLoading && uiScrollView.tag==0) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        
        //    如果内容高度大于UITableView高度，就取TableView高度
        
        //    如果内容高度小于UITableView高度，就取内容的实际高度
        
        float height = uiScrollView.contentSize.height > mainTableView.frame.size.height ?mainTableView.frame.size.height : uiScrollView.contentSize.height;
        
        
        
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.2) {
            
          //  NSLog(@"上拉加载");
            
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
static NSString *identy = @"OrderRecordCell";

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell ==nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([tableArray count]>0 && tableView.tag==0) {
        static NSString *identy = @"CustomCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identy];
        if(cell==nil){
            cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderRecordCell"owner:self options:nil]lastObject];
        }
        OrderRecordCell *porjectCell=(OrderRecordCell *)cell;
        
        
        //int width=self.view.frame.size.width;
        // cell=[[ProjectTableCell alloc]initWithStyle:UITableViewCellStyleDefault //reuseIdentifier:nil];
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [porjectCell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"insttitle"] && ![[dic objectForKey:@"insttitle"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"insttitle"];
            [porjectCell.authorLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSString *people=[dic objectForKey:@"people"];
            NSString *str=[NSString stringWithFormat:@"已报%@人",people];
            [porjectCell.orderNumbLabel setText:str];
            
        }
        
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            if (![logo isEqualToString:@""]) {
                [porjectCell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }
            
        }
        if ([dic objectForKey:@"range"] && ![[dic objectForKey:@"range"] isEqual:[NSNull null]]) {
            NSNumber *range=[dic objectForKey:@"range"];
            double distance=[range doubleValue];
            if(distance>0.0){
                if (distance/1000>1) {
                    [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
                }else if (distance/1000<1 && distance/1000>0.5){
                    [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                    
                }else if (distance/1000<0.5){
                    [porjectCell.distanceLabel setText:@"<500m"];
                }
            }
        }
        if ([dic objectForKey:@"grade"] && ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
            NSString *grade=[dic objectForKey:@"grade"];
            [porjectCell.ageLabel setText:[NSString stringWithFormat:@"适应年龄段:%@",grade]];
        }
        if ([dic objectForKey:@"btime"] && ![[dic objectForKey:@"btime"] isEqual:[NSNull null]]) {
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
            [porjectCell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
        }
        
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
        
        // NSLog(@"db----------------\n\n\n\n\n\n\n\\n\n\n\n%@",db);
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
            [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中


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
            // [twoLayout closeDrawer];
            [self getMainData];
            
            
            
        }
            break;
        default:
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}
//监听输入框焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   // [self showAlertView];
    SearchViewController *searchViewController=[[SearchViewController alloc]init];
    if (localNumber!=nil && ![localNumber isEqual:[NSNull null]]) {
        [searchViewController setAid:localNumber];
        
    }else{
        [searchViewController setAid:[NSNumber numberWithInt:500000]];
    }
    [self presentViewController: searchViewController animated:YES completion:nil];

}

-(NSString *) compareCurrentTime:(NSDate*) date{
    
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

-(void)showBorder:(UIButton *)sender{
    sender.layer.borderColor=[UIColor redColor].CGColor;
    sender.layer.borderWidth=0.5;
    sender.layer.cornerRadius = 8;
    
}

-(void)getLat
{
   // __block __weak MainViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myDelegate.latitude=locationCorrrdinate.latitude;
            myDelegate.longitude=locationCorrrdinate.longitude;
            localLat= myDelegate.latitude;
            localLng=myDelegate.longitude;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:[NSNumber numberWithDouble:localLat] forKey:@"lttt"];
            [user setObject:[NSNumber numberWithDouble:localLng]  forKey:@"nggg"];

        }];
    }
    
}

-(void)getCity
{
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"当前城市:%@",cityString);
            if(cityString!=nil){
                if([cityString length]>=2){
                    [cityLabel setText:[cityString substringToIndex:2]];
                }else{
                    [cityLabel setText:cityString];
                }
                NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
                NSError *error = [[NSError alloc]init];
                NSString *_localData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
                NSRange rang  = [_localData rangeOfString:cityString];
                NSLog(@"%@",NSStringFromRange(rang));
                if(rang.location>_localData.length){
                    return;
                }
                NSString *str=[_localData substringWithRange:NSMakeRange(rang.location-10, rang.length+18)];
                NSArray *dataArray=[str componentsSeparatedByString:NSLocalizedString(@",", nil)];
                NSString *cityStr=[dataArray objectAtIndex:0];
                cityStr=[cityStr substringWithRange:NSMakeRange(1, cityStr.length-2)];
                NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                NSNumber *_selectCityId=[formater numberFromString:cityStr];
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.localNumber=_selectCityId;
                myDelegate.cityName=cityString;
                [[CCLocationManager shareLocation]getAddress:^(NSString *address) {
                    NSLog(@"地区:%@",address);
                    myDelegate.areaName=address;
                }];

            }else{
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                myDelegate.localNumber=[formater numberFromString:DEFAULT_LOCAL_AID];
                [cityLabel setText:@"重庆"];
                myDelegate.cityName=@"重庆市";
            }
            
        }];
        
    }
    
}
-(void)getHotLesson{
    NSNumber *userId=[NSNumber numberWithInt:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
        NSNumber *ar=[stand objectForKey:@"lttt"];
        NSNumber *ngg=[stand objectForKey:@"nggg"];
        if (ar==NULL&&ngg==NULL) {
            ar=[NSNumber numberWithDouble:localLat];
            ngg=[NSNumber numberWithDouble:localLng];
        }
        if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        [HttpHelper getHotLesson:userId withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
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
-(void)getNewHotLesson{
    NSNumber *userId=[NSNumber numberWithInt:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
        NSNumber *ar=[stand objectForKey:@"lttt"];
        NSNumber *ngg=[stand objectForKey:@"nggg"];
        if (ar==NULL&&ngg==NULL) {
            ar=[NSNumber numberWithDouble:localLat];
            ngg=[NSNumber numberWithDouble:localLng];
        }
        if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        [HttpHelper getNewHotLesson:userId withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
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
-(void)getNewLesson{
    NSNumber *userId=[NSNumber numberWithInt:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
        
        NSNumber *ar=[stand objectForKey:@"lttt"];
        NSNumber *ngg=[stand objectForKey:@"nggg"];
        if (ar==NULL&&ngg==NULL) {
            ar=[NSNumber numberWithDouble:localLat];
            ngg=[NSNumber numberWithDouble:localLng];
        }
        if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        [HttpHelper getNewLesson:userId withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
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
-(void)getNearByLesson{
    NSNumber *userId=[NSNumber numberWithInt:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
        
        NSNumber *ar=[stand objectForKey:@"lttt"];
        NSNumber *ngg=[stand objectForKey:@"nggg"];
        if (ar==NULL&&ngg==NULL) {
            ar=[NSNumber numberWithDouble:localLat];
            ngg=[NSNumber numberWithDouble:localLng];
        }
        if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            ar=[NSNumber numberWithDouble:29.5];
            ngg=[NSNumber numberWithDouble:106.5];
        }
        [HttpHelper getNearByLesson:userId withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
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
    
    CalanderViewController *searchViewController=[[CalanderViewController alloc]init];
    if (localNumber!=nil && ![localNumber isEqual:[NSNull null]]) {
        [searchViewController setAid:localNumber];
        
    }else{
        [searchViewController setAid:[NSNumber numberWithInt:500000]];
        
    }
    [self presentViewController: searchViewController animated:YES completion:nil];
}
-(void)getMainSlider{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getSlider:self success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                    customServiceNumber=[formater stringFromNumber: model.custom_tel ];
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
                            
                            
                            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, scrollview.frame.origin.y+scrollview.frame.size.height-30, bounds.size.width, 30)];
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
        
        if ([url rangeOfString:@"http://"].location !=NSNotFound) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else
        {
            NSString *sur=[NSString stringWithFormat:@"http://211.149.190.90/%@",url];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sur]];
        }
    }
    
}
-(void)goMsgViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    MyMsgViewController *myMsgViewController=[[MyMsgViewController alloc]init];
    [self presentViewController: myMsgViewController animated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}
-(void)goCityViewController{
    CityViewController *cityViewController=[[CityViewController alloc]init];
    [self presentViewController: cityViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
