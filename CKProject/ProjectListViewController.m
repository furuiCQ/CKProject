
//
//  ProjectListViewController.m
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

#import "RJUtil.h"
#import "ProjectTableCell.h"
#import "ProjectListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DemotionControl.h"
#import "JZLocationConverter.h"
#import "OrderRecordCell.h"
#import "SortProjectListTableCell.h"
#import "CustomLabel.h"
@interface ProjectListViewController ()<UITableViewDataSource,UITableViewDelegate,ECDrawerLayoutDelegate,TreeTableCellDelegate,CLLocationManagerDelegate>{
    NSArray *local1Array;
    NSArray *local2Array;
    NSArray *local3Array;
    
    
    NSString *addressString;
    UILabel *localNowLabel;
    UILabel *typeNowLabel;
    UILabel *gradeNowLabel;
    CLLocationManager *locationManager;
    NSMutableArray *typeArray;
    NSArray *gradeArray;
    
    UILabel *allSortLabel;
    UILabel *allGradeLabel;
    NSString *typeString;
    NSString *gradeString;
    
    NSNumber *aid;
    NSNumber *cid;
    NSNumber *pid;
    NSNumber *gid;
    
    NSNumber *selectSuperId;
    
    double localLat;
    double localLng;
    
    NSMutableArray *imageViewArray;
    NSMutableArray *timeSortArray;
    
    
    NSString *selectCity1String;
    NSString *selectCity2String;
    NSString *selectCity3String;
    int select1Id;
    int select2Id;
    int select3Id;
    CLLocation *neloct;
    int std;
    UILabel *bi;
    NSString *lt;
    NSString *lg;
    UINib *nib;
    
    UITableView *dataTableView;
    NSMutableArray *selcedIdArray;
    
}
@property (nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation ProjectListViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize projectTableView;
@synthesize bottomHeight;
@synthesize firstLayout;
@synthesize twoLayout;
@synthesize threeLayout;
@synthesize fourLayout;
@synthesize typeLayout;
@synthesize projectID;
@synthesize projectSubID;
@synthesize titleName;
@synthesize addTableView;
@synthesize subAddTableView;
@synthesize typeTableView;
@synthesize endAddTableView;
@synthesize gradeLayout;
@synthesize tableArray;
@synthesize gradeTableView;
@synthesize counts;
static NSString * const DEFAULT_LOCAL_AID = @"500000";
- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"加载中..."];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    if (tableArray==nil) {
        tableArray = [[NSArray alloc]init];
    }
    local1Array = [[NSArray alloc]init];
    local2Array = [[NSArray alloc]init];
    local3Array = [[NSArray alloc]init];
    
    gradeArray=[[NSArray alloc]init];
    typeArray = [[NSMutableArray alloc]init];
    imageViewArray=[[NSMutableArray alloc]init];
    timeSortArray=[[NSMutableArray alloc]init];
    selcedIdArray=[[NSMutableArray alloc]init];
    aid=[[NSNumber alloc]init];
    cid=[NSNumber numberWithInt:0];
    gid=[NSNumber numberWithInt:0];
    pid=[[NSNumber alloc]initWithInt:-1];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    localLat=myDelegate.latitude;
    localLng=myDelegate.longitude;
    //    localLat=29.6515600000;
    //    localLng=106.5849920000;
    //百度地图：29.6515600000,106.5849920000
    //    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    //    tableArray=[st objectForKey:@"kay"]
    
    addressString=@"";
    selectCity1String=@"";
    selectCity2String=@"";
    selectCity3String=@"";
    
    //        NSUserDefaults *sd=[NSUserDefaults standardUserDefaults];
    //        NSNumber *artid=[sd objectForKey:@"nid"];
    //        NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?instid=%@",artid];
    //        NSURL *url=[NSURL URLWithString:str];
    //        NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //
    //            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //
    //            NSDictionary *db=[obj objectForKey:@"result"];
    //            tableArray=[db objectForKey:@"lesson"];
    //
    //            NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",tableArray);
    //            [self initTitle];
    //            [self initSelectView];
    //            [self initTableView];
    //            [self getData];
    //            [self getAllType];
    //        }];
    //将这个试着写入下方打包成一个方法，解决初次进入问题
    [self initTitle];
    [self initSelectView];
    //shuju，
    [self initTableView];
    if (std==1) {
        NSLog(@"123");
        [self tit];
    }
    if (std==2) {
        NSLog(@"234");
        [self jp];
    }
    else
    {
        NSLog(@"345----------");
        [self getData];
    }
    // [self getAllType];
    locationManager = [[CLLocationManager alloc] init];
    //    定位的数据
    locationManager.delegate = self;
    
    // 设置定位精度grayNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    [locationManager startUpdatingLocation];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)tit
{
    NSUserDefaults *sd=[NSUserDefaults standardUserDefaults];
    NSNumber *artid=[sd objectForKey:@"nid"];
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?instid=%@",artid];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *db=[obj objectForKey:@"result"];
        tableArray=[db objectForKey:@"lesson"];
        
        NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",tableArray);
        [projectTableView reloadData];
    }];
    
    
    
}
-(void)jp
{
    NSUserDefaults *src=[NSUserDefaults standardUserDefaults];
    NSString *bt1=[src objectForKey:@"kp"];
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?date=%@",bt1];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *db=[obj objectForKey:@"result"];
        tableArray=[db objectForKey:@"lesson"];
        
        NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",tableArray);
        [projectTableView reloadData];
    }];
    
    
    
}





-(void)setstd:(int)num
{
    
    std=num;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    neloct=newLocation;
    //    // 获取经纬度
    //    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    //    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    
    
    
    
    
    [manager stopUpdatingLocation];
    //
    //    CLLocationCoordinate2D wgsPt = newLocation.coordinate;
    
    //    CLLocationCoordinate2D bdPt = [JZLocationConverter bd09ToGcj02:wgsPt];
    
    //    //当使用模拟器定位在中国大陆以外地区，计算GCJ-02坐标还是返回WGS-84
    //    _pt1Lable.text = [NSString stringWithFormat:@"WGS-84(国际标准坐标)：\n %f,%f",wgsPt.latitude,wgsPt.longitude];
    //    _pt2Lable.text = [NSString stringWithFormat:@"GCJ-02(中国国测局坐标(火星坐标))：\n %f,%f",gcjPt.latitude,gcjPt.longitude];
    //    _pt3Lable.text = [NSString stringWithFormat:@"BD-09(百度坐标)：\n %f,%f",bdPt.latitude,bdPt.longitude];
    // 停止位置更新
    
}
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
//-(void)setHasData:(NSArray *)array{
//    tableArray=array;
//}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
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
    [searchLabel setText:@""];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    [msgLabel setBackgroundColor:[UIColor greenColor]];
    [msgLabel setText:@"未知"];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)initSelectView{
    int width= self.view.frame.size.width;
    UIView *marginview=[[UIView alloc] initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, width/7)];
    [marginview setUserInteractionEnabled:YES];
    [marginview setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [self.view addSubview:marginview];
    
    UILabel *localLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width/3, width/7)];
    [localLabel setText:@"正在定位.."];
    [localLabel setBackgroundColor:[UIColor whiteColor]];
    [localLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [localLabel setTextAlignment:NSTextAlignmentCenter];
    [marginview addSubview:localLabel];
    //筛选按钮
    UIControl *hotControl=[[UIControl alloc]initWithFrame:CGRectMake(localLabel.frame.size.width+0.3, 0, width/3-0.2, width/7)];
    [hotControl setTag:0];
    [hotControl setUserInteractionEnabled:YES];
    [hotControl addTarget:self action:@selector(topOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *hotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(hotControl.frame.size.width-width/11.6-width/29, width/7/2-width/45.7-1, width/29, width/45.7)];
    [hotControl setBackgroundColor:[UIColor whiteColor]];
    [hotImageView setImage:[UIImage imageNamed:@"red_up"]];
    UIImageView *hot2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(hotControl.frame.size.width-width/11.6-width/29, width/7/2+1, width/29, width/45.7)];
    [hot2ImageView setImage:[UIImage imageNamed:@"red_down"]];
    
    UILabel *hotLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8.7, 0, width/26.7*2, width/7)];
    [hotLabel setText:@"热门"];
    [hotLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [hotLabel setTextAlignment:NSTextAlignmentCenter];
    [hotControl addSubview:hotLabel];
    [hotControl addSubview:hotImageView];
    [hotControl addSubview:hot2ImageView];
    [marginview addSubview:hotControl];
    
    
    UIControl *siftCotrol=[[UIControl alloc]initWithFrame:CGRectMake(hotControl.frame.origin.x+hotControl.frame.size.width+0.2, 0, width-(hotLabel.frame.origin.x+hotLabel.frame.size.width+0.2), width/7)];
    [siftCotrol setTag:1];
    [siftCotrol setUserInteractionEnabled:YES];
    [siftCotrol addTarget:self action:@selector(topOnClick:) forControlEvents:UIControlEventTouchUpInside];
    //筛选按钮
    UIImageView *siftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/13.3, (width/7-width/17.8)/2, width/19.3, width/17.8)];
    [siftCotrol setBackgroundColor:[UIColor whiteColor]];
    [siftImageView setImage:[UIImage imageNamed:@"sift_logo"]];
    UILabel *siftLabel=[[UILabel alloc]initWithFrame:CGRectMake(siftImageView.frame.size.width+siftImageView.frame.origin.x+width/64, 0, width/26.7*2, width/7)];
    [siftLabel setText:@"筛选"];
    [siftLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [siftLabel setTextAlignment:NSTextAlignmentCenter];
    [siftCotrol addSubview:siftLabel];
    [siftCotrol addSubview:siftImageView];
    [marginview addSubview:siftCotrol];
    
    
    //    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(width/40,0,width-width/20, titleHeight*3/4)];
    //    [view setBackgroundColor:[UIColor whiteColor]];
    //    bi=[[UILabel alloc]initWithFrame:CGRectMake(width/11, 0, width/5, titleHeight*3/4)];
    //    bi.text=@"";
    //    bi.font=[UIFont systemFontOfSize:width/25];
    //    bi.textColor=[UIColor redColor];
    //    [view addSubview:bi];
    //
    //
    //    NSArray *titleArray= [NSArray arrayWithObjects:@"热门",@"筛选", nil];
    //    NSArray *imgArray=[NSArray  arrayWithObjects:@"demotion_logo",@"demotion_logo", nil];
    //    NSArray *unimgArray=[NSArray arrayWithObjects:@"undemotion_logo",@"undemotion_logo", nil];
    //
    //    for(int i=0;i<2;i++){
    //        DemotionControl *subView=[[DemotionControl alloc]initWithFrame:CGRectMake(view.frame.size.width/3*i+width/3, 0,view.frame.size.width/3, marginview.frame.size.height)];
    //        [subView setUserInteractionEnabled:YES];
    //        [subView setTag:i];
    //        [subView addTarget:self action:@selector(topOnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        CGRect frame=self.view.frame;
    //        [subView initView:&frame withTag:i];
    //        [subView setBackgroundColor:[UIColor whiteColor]];
    //        [subView.textLabel setText:[titleArray objectAtIndex:i]];
    //        [subView.userLogo setImage:[UIImage imageNamed:[unimgArray objectAtIndex:i]] forState:UIControlStateNormal];
    //        [subView.userLogo setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateSelected];
    //        [view addSubview:subView];
    //    }
    ////    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/1.5,0,self.view.frame.size.width/3, titleHeight*3/3)];
    ////    lab.text=@"渝北区";
    ////    [lab setTextColor:[UIColor redColor]];
    ////    lab.font=[UIFont systemFontOfSize:16];
    ////    [view addSubview:lab];
    //    [marginview addSubview:view];
    
    
    
    
    
}
-(void)topOnClick:(id)sender{
    DemotionControl *btn=(DemotionControl *)sender;
    
    switch (btn.tag) {
            
        case 0:
            
        {
            
            btn.userLogo.selected=!btn.userLogo.selected;//每次点击都改变按钮的状态
            
            if(btn.userLogo.selected){
                timeSortArray=[tableArray mutableCopy];
                NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"people" ascending:NO];
                NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
                NSArray *sortArray=[timeSortArray sortedArrayUsingDescriptors:sortDescriptors];
                tableArray=sortArray;
                
                [projectTableView reloadData];
                
                
            }else{
                //  [self deleteProject];
                
                
            }
            
        }
            
            break;
        case 1:
        {
            [self inPopView];
            
        }
            break;
        default:
            break;
    }
}



-(void)inPopView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width/1.3, hegiht-titleHeight-15)];
    [view setBackgroundColor:[UIColor whiteColor]];
    //RGB(56,71,79)
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width/1.3, width/4)];
    [topView setBackgroundColor:[UIColor colorWithRed:56.f/255.f green:71.f/255.f blue:79.f/255.f alpha:1.0]];
    [view addSubview:topView];
    
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.2, width/23.7, width/2, width/24.6)];
    [topLabel setText:@"你想找哪些?"];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [topLabel setTextAlignment:NSTextAlignmentLeft];
    [topView addSubview:topLabel];
    allSortLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.2, topLabel.frame.size.height+topLabel.frame.origin.y
                                                          +width/26.7, width/5.7, width/12.3)];
    [allSortLabel setTextColor:[UIColor whiteColor]];
    [allSortLabel setText:@"分类"];
    [allSortLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *allTypeGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allType)];
    [allSortLabel addGestureRecognizer:allTypeGestrue];
    [allSortLabel setFont:[UIFont systemFontOfSize:width/35.6]];
    [allSortLabel setTextAlignment:NSTextAlignmentCenter];
    [allSortLabel setBackgroundColor:[UIColor colorWithRed:1 green:84.f/255.f blue:84.f/255.f alpha:1.0]];
    [allSortLabel.layer setCornerRadius:2];
    [allSortLabel.layer setMasksToBounds:true];
    [topView addSubview:allSortLabel];
    
    
    localNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/22+allSortLabel.frame.size.width+allSortLabel.frame.origin.x
                                                           , topLabel.frame.size.height+topLabel.frame.origin.y
                                                           +width/26.7, width/5.7, width/12.3)];
    [localNowLabel setTextColor:[UIColor whiteColor]];
    [localNowLabel setText:@"地区"];
    [localNowLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *addressGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allAddress)];
    [localNowLabel addGestureRecognizer:addressGestrue];
    [localNowLabel setFont:[UIFont systemFontOfSize:width/35.6]];
    [localNowLabel setTextAlignment:NSTextAlignmentCenter];
    [localNowLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [localNowLabel.layer setCornerRadius:2];
    [localNowLabel.layer setMasksToBounds:true];
    [topView addSubview:localNowLabel];
    
    
    allSortLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/22+localNowLabel.frame.size.width+localNowLabel.frame.origin.x
                                                          , topLabel.frame.size.height+topLabel.frame.origin.y
                                                          +width/26.7, width/5.7, width/12.3)];
    [allSortLabel setTextColor:[UIColor whiteColor]];
    [allSortLabel setText:@"年龄段"];
    [allSortLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *allGraGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allGrade)];
    [allSortLabel addGestureRecognizer:allGraGestrue];
    [allSortLabel setFont:[UIFont systemFontOfSize:width/35.6]];
    [allSortLabel setTextAlignment:NSTextAlignmentCenter];
    [allSortLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [allSortLabel.layer setCornerRadius:2];
    [allSortLabel.layer setMasksToBounds:true];
    [topView addSubview:allSortLabel];
    
    
    bottomHeight=49;
    
    dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               topView.frame.size.height+topView.frame.origin.y,
                                                               width/1.3,
                                                               view.frame.size.height-(topView.frame.size.height+topView.frame.origin.y))];
    [dataTableView setBackgroundColor:[UIColor whiteColor]];
    dataTableView.dataSource                        = self;
    dataTableView.delegate                          = self;
    dataTableView.separatorStyle = NO;
    dataTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    [dataTableView setTag:4];
    [view addSubview:dataTableView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height, width/1.3/2, width/8)];
    [cancelLabel setText:@"重置"];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor whiteColor]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/20]];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel setBackgroundColor:[UIColor colorWithRed:1 green:138.f/255.f blue:128.f/255.f alpha:1.0]];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [view addSubview:cancelLabel];
    
    
    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/1.3/2, view.frame.size.height, width/1.3/2, width/8)];
    [confirmLabel setText:@"完成"];
    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    [confirmLabel setTextColor:[UIColor whiteColor]];
    [confirmLabel setFont:[UIFont systemFontOfSize:width/20]];
    [confirmLabel setUserInteractionEnabled:YES];
    [confirmLabel setBackgroundColor:[UIColor colorWithRed:1 green:83.f/255.f blue:83.f/255.f alpha:1.0]];
    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    [confirmLabel addGestureRecognizer:confrimGesture];
    [view addSubview:confirmLabel];
    
    [self getAllType];
    
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
    //    [cancelLabel setTag:0];
    //    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    //    [cancelLabel addGestureRecognizer:cancelGesture];
    //    [titleView addSubview:cancelLabel];
    //
    //
    //    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    //    [titleLabel setText:@"筛选"];
    //    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    //    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    //    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    //    [titleView addSubview:titleLabel];
    //
    //
    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    //    [confirmLabel setText:@"确定"];
    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    //    [confirmLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    //    [confirmLabel addGestureRecognizer:confrimGesture];
    //    [titleView addSubview:confirmLabel];
    //
    //
    //
    //    UIView *localBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46, view.frame.size.width, width/10)];
    //    [localBgView setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *addressGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allAddress)];
    //    [localBgView addGestureRecognizer:addressGestrue];
    //    [localBgView setBackgroundColor:[UIColor whiteColor]];
    //    [view addSubview:localBgView];
    //    //-------------------//------------//
    //    UILabel *localLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (localBgView.frame.size.height-width/26)/2, width/2, width/26)];
    //    [localLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    //    [localLabel setText:bi.text];
    //    [localLabel setFont:[UIFont systemFontOfSize:width/26]];
    //    [localBgView addSubview:localLabel];
    //
    //    localNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (localBgView.frame.size.height-width/29)/2, localBgView.frame.size.width*2/3, width/29)];
    //    [localNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    //    [localNowLabel setText:addressString];
    //    [localNowLabel setTextAlignment:NSTextAlignmentRight];
    //    [localNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    //    [localBgView addSubview:localNowLabel];
    //
    //    UIImageView *rightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+localBgView.frame.size.width*3/4, (localBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    //
    //    [rightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    //    [localBgView addSubview:rightLabel];
    //
    //
    //
    //
    //
    //    UIView *allSortBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46+width/10+width/40, view.frame.size.width, width/10)];
    //    [allSortBgView setBackgroundColor:[UIColor whiteColor]];
    //    [allSortBgView setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *allTypeGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allType)];
    //    [allSortBgView addGestureRecognizer:allTypeGestrue];
    //    [view addSubview:allSortBgView];
    //
    //
    //    allSortLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (allSortBgView.frame.size.height-width/26)/2, width/2, width/26)];
    //    [allSortLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    //    [allSortLabel setText:@"全部分类"];
    //    [allSortLabel setFont:[UIFont systemFontOfSize:width/26]];
    //    [allSortBgView addSubview:allSortLabel];
    //
    //
    //    typeNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (allSortBgView.frame.size.height-width/29)/2, allSortBgView.frame.size.width*2/3, width/29)];
    //    [typeNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    //    [typeNowLabel setText:typeString];
    //    [typeNowLabel setTextAlignment:NSTextAlignmentRight];
    //    [typeNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    //    [allSortBgView addSubview:typeNowLabel];
    //
    //
    //    UIImageView *allrightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+allSortBgView.frame.size.width*3/4, (allSortBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    //    //[allrightLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    //    [allrightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    //    [allrightLabel setUserInteractionEnabled:NO];
    //    //[allrightLabel setTextAlignment:NSTextAlignmentRight];
    //    //[allrightLabel setFont:[UIFont systemFontOfSize:width/22]];
    //    [allSortBgView addSubview:allrightLabel];
    //
    //
    //
    //
    //
    //
    //
    //    UIView *allGradeBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46+width/10+width/40+width/10+width/40, view.frame.size.width, width/10)];
    //    [allGradeBgView setBackgroundColor:[UIColor whiteColor]];
    //    [allGradeBgView setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *allGraGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allGrade)];
    //    [allGradeBgView addGestureRecognizer:allGraGestrue];
    //    [view addSubview:allGradeBgView];
    //
    //
    //    allGradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (allGradeBgView.frame.size.height-width/26)/2, width/2, width/26)];
    //    [allGradeLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    //    [allGradeLabel setText:@"年龄段"];
    //    [allGradeLabel setFont:[UIFont systemFontOfSize:width/26]];
    //    [allGradeBgView addSubview:allGradeLabel];
    //
    //
    //    gradeNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (allGradeBgView.frame.size.height-width/29)/2, allGradeBgView.frame.size.width*2/3, width/29)];
    //    [gradeNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    //    [gradeNowLabel setText:gradeString];
    //    [gradeNowLabel setTextAlignment:NSTextAlignmentRight];
    //    [gradeNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    //    [allGradeBgView addSubview:gradeNowLabel];
    //
    //
    //    UIImageView *allGraderightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+allGradeBgView.frame.size.width*3/4, (allGradeBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    //    [allGraderightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    //    [allGraderightLabel setUserInteractionEnabled:NO];
    //    [allGradeBgView addSubview:allGraderightLabel];
    //
    
    
    
    
    
    firstLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    firstLayout.width=view.frame.size.width;
    firstLayout.contentView=view;
    firstLayout.delegate=self;
    [firstLayout setTag:0];
    [self.view addSubview:firstLayout];
    
    firstLayout.openFromRight = YES;
    [firstLayout openDrawer];
    
    
}
-(void)allGrade{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:titleView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
    [cancelLabel setText:@"取消"];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel setTag:5];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"年龄"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    
    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    //    [confirmLabel setText:@"确定"];
    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    //    [confirmLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    //    [confirmLabel addGestureRecognizer:confrimGesture];
    //    [titleView addSubview:confirmLabel];
    
    gradeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                width/10+2+width/40+width/46,
                                                                view.frame.size.width,
                                                                view.frame.size.height-(width/10+2+width/40+width/46))];
    [gradeTableView setBackgroundColor:[UIColor whiteColor]];
    gradeTableView.dataSource                        = self;
    gradeTableView.delegate                          = self;
    [gradeTableView setTag:5];
    [view addSubview:gradeTableView];
    
    
    gradeLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    gradeLayout.width=view.frame.size.width;
    gradeLayout.contentView=view;
    gradeLayout.delegate=self;
    [self.view addSubview:gradeLayout];
    
    gradeLayout.openFromRight = YES;
    [gradeLayout openDrawer];
    [ProgressHUD show:@"加载中..."];
    
    [self getAllGrade];
    
}
-(void)allType{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:titleView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
    [cancelLabel setText:@"取消"];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel setTag:4];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"分类"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    NSMutableArray *mutableArray=[[NSMutableArray alloc]init];
    if([typeArray count]>0){
        for (NSDictionary *dic in typeArray) {
            NSNumber *superId=[dic objectForKey:@"id"];
            
            NSString *title=[dic objectForKey:@"title"];
            
            NSArray *lessonGroup=[dic objectForKey:@"lesson_group"];
            
            Node *superData=[[Node alloc]initWithParentId:-1 nodeId:[superId intValue] name:title depth:0 expand:YES withSuperId:[superId intValue] withSubId:[superId intValue]];
            [mutableArray addObject:superData];
            for (int i=0; i<[lessonGroup count]; i++) {
                NSDictionary *d=[lessonGroup objectAtIndex:i];
                NSNumber *subId=[d objectForKey:@"id"];
                NSString *subtitle=[d objectForKey:@"title"];
                BOOL expend=NO;
                if ([selectSuperId isEqualToNumber:superId]) {
                    expend=YES;
                }
                Node *subData=[[Node alloc]initWithParentId:[superId intValue] nodeId:[subId intValue] name:subtitle depth:1 expand:expend withSuperId:[superId intValue]withSubId:[subId intValue]];
                [mutableArray addObject:subData];
            }
        }
        
    }
    
    
    
    typeTableView=[[TreeTableView alloc]initWithFrame:CGRectMake(0,
                                                                 width/10+2+width/40+width/46,
                                                                 view.frame.size.width,
                                                                 view.frame.size.height-(width/10+2+width/40+width/46))withData:[mutableArray copy]];
    [typeTableView setBackgroundColor:[UIColor whiteColor]];
    typeTableView.treeTableCellDelegate=self;
    [typeTableView setSelecetTitle:typeNowLabel.text];
    //[typeTableView setTag:6];
    [view addSubview:typeTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, endAddTableView.frame.size.width, width/29*3)];//创建一个视图（v_headerView）
    
    UILabel *textlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21, width/29, typeTableView.frame.size.width, width/29)];
    [textlabel setText:@"全部分类"];
    [textlabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
    [textlabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width/21, width/29*3-1, typeTableView.frame.size.width-width/21, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:215.f/255.f green:215.f/255.f blue:215.f/255.f alpha:1.0]];
    [headerView addSubview:lineView];
    
    
    UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(typeTableView.frame.size.width*4/5, self.view.frame.size.width/22.8, self.view.frame.size.width/22, self.view.frame.size.width/26.7)];
    [rightView setImage:[UIImage imageNamed:@"select_logo"]];
    
    // [headerView addSubview:rightView];
    
    //   [headerView addSubview:textlabel];
    
    //    if (typeString==nil) {
    //        typeTableView.tableHeaderView=headerView;
    //    }
    
    
    typeLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    typeLayout.width=view.frame.size.width;
    typeLayout.contentView=view;
    typeLayout.delegate=self;
    [self.view addSubview:typeLayout];
    
    typeLayout.openFromRight = YES;
    [typeLayout openDrawer];
    
    
}
-(void)allAddress{
    
    
    
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:titleView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
    [cancelLabel setText:@"取消"];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel setTag:1];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"区域"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    
    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    //    [confirmLabel setText:@"确定"];
    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    //    [confirmLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    //    [confirmLabel addGestureRecognizer:confrimGesture];
    //    [titleView addSubview:confirmLabel];
    
    //全部地区
    //    UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height+titleView.frame.origin.y+1, width, width/7)];
    //    UILabel *li=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, width/7)];
    //    li.text=@"全部地区";
    //
    //    [vi addSubview:li];
    //
    //
    //    [view addSubview:vi];
    
    addTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              width/10+2+width/40+width/46,
                                                              view.frame.size.width,
                                                              view.frame.size.height-(width/10+2+width/40+width/46))];
    [addTableView setBackgroundColor:[UIColor whiteColor]];
    addTableView.dataSource                        = self;
    addTableView.delegate                          = self;
    //    addTableView.tableHeaderView=vi;
    [addTableView setTag:1];
    [view addSubview:addTableView];
    
   	twoLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    twoLayout.width=view.frame.size.width;
    twoLayout.contentView=view;
    twoLayout.delegate=self;
    [self.view addSubview:twoLayout];
    
    twoLayout.openFromRight = YES;
    [twoLayout openDrawer];
    if ([local1Array count]<=0) {
        [ProgressHUD show:@"加载中..."];
        [self getAllCity];
    }else{
        [addTableView reloadData];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:select1Id inSection:0];//定位到第8行
        [addTableView scrollToRowAtIndexPath:idxPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:NO];
        
    }
    
    
}
-(void)subAddress:(NSString *)selectString{
    
    
    
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:titleView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
    [cancelLabel setText:@"取消"];
    [cancelLabel setTag:2];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
    [cancelLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"区域"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    
    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    //    [confirmLabel setText:@"确定"];
    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    //    [confirmLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    //    [confirmLabel addGestureRecognizer:confrimGesture];
    //    [titleView addSubview:confirmLabel];
    //
    
    
    subAddTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                 width/10+2+width/40+width/46,
                                                                 view.frame.size.width,
                                                                 view.frame.size.height-(width/10+2+width/40+width/46))];
    [subAddTableView setBackgroundColor:[UIColor whiteColor]];
    subAddTableView.dataSource                        = self;
    subAddTableView.delegate                          = self;
    [subAddTableView setTag:2];
    [view addSubview:subAddTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, subAddTableView.frame.size.width, width/29*3)];//创建一个视图（v_headerView）
    UILabel *textlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21, width/29, subAddTableView.frame.size.width, width/29)];
    [textlabel setText:selectString];
    [textlabel setFont:[UIFont systemFontOfSize:width/29]];
    [textlabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [headerView addSubview:textlabel];
    subAddTableView.tableHeaderView=headerView;
    
   	threeLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    threeLayout.width=view.frame.size.width;
    threeLayout.contentView=view;
    threeLayout.delegate=self;
    [self.view addSubview:threeLayout];
    
    threeLayout.openFromRight = YES;
    [threeLayout openDrawer];
    if ([local2Array count]>0) {
        [subAddTableView reloadData];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:select2Id inSection:0];//定位到第8行
        [subAddTableView scrollToRowAtIndexPath:idxPath
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:NO];
        
    }
    
}

-(void)endAddress:(NSString *)selectString{
    
    
    
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, hegiht)];
    [view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*6/7, width/10+2+width/40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:titleView];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/20+1, width/22*2, width/23)];
    [cancelLabel setText:@"取消"];
    [cancelLabel setTag:3];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/23]];
    [cancelLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"区域"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    
    
    
    endAddTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                 width/10+2+width/40+width/46,
                                                                 view.frame.size.width,
                                                                 view.frame.size.height-(width/10+2+width/40+width/46))];
    [endAddTableView setBackgroundColor:[UIColor whiteColor]];
    endAddTableView.dataSource                        = self;
    endAddTableView.delegate                          = self;
    [endAddTableView setTag:3];
    [view addSubview:endAddTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, endAddTableView.frame.size.width, width/29*3)];//创建一个视图（v_headerView）
    UILabel *textlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21, width/29, endAddTableView.frame.size.width, width/29)];
    //    headerView.backgroundColor=[UIColor whiteColor]
    [textlabel setText:selectString];
    [textlabel setFont:[UIFont systemFontOfSize:width/29]];
    [textlabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [headerView addSubview:textlabel];
    endAddTableView.tableHeaderView=headerView;
    
    fourLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    fourLayout.width=view.frame.size.width;
    fourLayout.contentView=view;
    fourLayout.delegate=self;
    [self.view addSubview:fourLayout];
    
    fourLayout.openFromRight = YES;
    [fourLayout openDrawer];
    if ([local3Array count]>0) {
        [endAddTableView reloadData];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:select3Id inSection:0];//定位到第8行
        [endAddTableView scrollToRowAtIndexPath:idxPath
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:NO];
        
    }
    
    
}

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
        case 0:
        {
            [firstLayout closeDrawer];
            addressString=@"";
        }
            
            break;
        case 1:
        {
            [twoLayout closeDrawer];
            
        }
            
            break;
        case 2:
        {
            [threeLayout closeDrawer];
            
        }
            
            break;
        case 3:
        {
            [fourLayout closeDrawer];
            
        }
            
            break;
        case 4:
        {
            [typeLayout closeDrawer];
            
        }
            
            break;
        case 5:
        {
            [gradeLayout closeDrawer];
            
        }
            
            break;
            
        default:
            break;
    }
    NSLog(@"closeDrawLayout close");
}
-(void)confirmDrawLayout{
    NSLog(@"confirmDrawLayout close");
    NSString *str=typeNowLabel.text;
    [searchLabel setText:[str stringByAppendingString:@"课程"]];
    [firstLayout closeDrawer];
    [self setData];
    
    
}

-(void)initTableView{
    
    bottomHeight=49;
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20+0.5+self.view.frame.size.width/7,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height-titleHeight-20-0.5-titleHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    [projectTableView setTag:0];
    [self.view addSubview:projectTableView];
    //添加刷新
    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor grayColor]];
    
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [projectTableView addSubview:_refreshControl];
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新日期 %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [self getData];
    [refresh endRefreshing];
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
        case 1:
            
        {
            return [local1Array count];
        }
            
            break;
        case 2:
            
        {
            return [local2Array count];
        }
            
            
            break;
        case 3:
            
        {
            return [local3Array count];
        }
            break;
        case 4:
        {
            return [typeArray count];
            
        }
            
            break;
        case 5:
        {
            return [gradeArray count];
        }
            break;
            
        default:
            break;
    }
    return 0;
    
    // return 3;
}
static NSString *identy = @"OrderRecordCell";

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell;
    NSLog(@"tableView.tag %ld",(long)tableView.tag);
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
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSString *people=[dic objectForKey:@"people"];
            //     NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
            NSString *str=[NSString stringWithFormat:@"%@",people];
            [porjectCell.orderNumbLabel setText:str];
            
            //            CGRect frame=porjectCell.listItem.joinLabel.frame;
            //            CGSize strSize=[str sizeWithFont:porjectCell.listItem.joinLabel.font maxSize:CGSizeMake(width, 0)];
            //            frame.size.width= strSize.width;
            //            [porjectCell.listItem.joinLabel setFrame:frame];
            
        }
        
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            if (![logo isEqualToString:@""]) {
                [porjectCell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }
            
        }
        if ([dic objectForKey:@"lng"] && ![[dic objectForKey:@"lng"] isEqual:[NSNull null]] &&
            [dic objectForKey:@"lat"] && ![[dic objectForKey:@"lat"] isEqual:[NSNull null]]) {
            NSNumber *lng=[dic objectForKey:@"lng"];
            NSNumber *lat=[dic objectForKey:@"lat"];
            
            //得到当前坐标
            
            //转化为坐标
            
            //            NSLog(@"纬度:%f",neloct.coordinate.latitude);
            //            NSLog(@"经度:%f",neloct.coordinate.longitude);
            //            + (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;
            CLLocationCoordinate2D coordinate;
            coordinate.latitude=[lat floatValue];
            
            coordinate.longitude=[lng floatValue];
            
            CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToWgs84:coordinate];
            //               CLLocationCoordinate2D wgsPt = newLocation.coordinate;
            //
            //               CLLocationCoordinate2D bdPt = [JZLocationConverter bd09ToGcj02:wgsPt];
            //1.获得输入的经纬度
            lg=[NSString stringWithFormat:@"%f",neloct.coordinate.longitude] ;
            lt=[NSString stringWithFormat:@"%f",neloct.coordinate.latitude] ;
            NSString *longtitudeText=lg;
            NSString *latitudeText=lt;;
            
            CLLocationDegrees latitude=[latitudeText doubleValue];
            CLLocationDegrees longitude=[longtitudeText doubleValue];
            
            CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
            //2.反地理编码
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error||placemarks.count==0) {
                    bi.text=@"你的地址没找到，可能在月球上";
                }else//编码成功
                {
                    //显示最前面的地标信息
                    NSLog(@"111111:%@",placemarks);
                    CLPlacemark *firstPlacemark=[placemarks firstObject];
                    
                    NSLog(@"2222-%@",firstPlacemark.name);
                    //经纬度
                    for (CLPlacemark *place in placemarks) {
                        NSDictionary *location =[place addressDictionary];
                        NSLog(@"国家：%@",[location objectForKey:@"Country"]);
                        NSLog(@"城市：%@",[location objectForKey:@"State"]);
                        NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
                        
                        NSLog(@"位置：%@", place.name);
                        NSLog(@"国家：%@", place.country);
                        NSLog(@"城市：%@", place.locality);
                        NSLog(@"区：%@", place.subLocality);
                        bi.text=place.subLocality;
                        NSLog(@"街道：%@", place.thoroughfare);
                        NSLog(@"子街道：%@", place.subThoroughfare);
                        
                    }
                    //------
                    //                    CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
                    //                    CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;
                    //                    lt=[NSString stringWithFormat:@"%.2f",latitude];
                    //                    lg=[NSString stringWithFormat:@"%.2f",longitude];
                }
            }];
            
            
            double distance=[RJUtil LantitudeLongitudeDist:coords3.longitude other_Lat:coords3.latitude self_Lon:neloct.coordinate.longitude self_Lat:neloct.coordinate.latitude];
            NSLog(@"---------\n\n\n lng:%f\n  ",distance);
            if(distance>0.0){
                if (distance/1000>1) {
                    [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
                }else if (distance/1000<1 && distance/1000>0.5){
                    [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                    
                }else if (distance/1000<0.5){
                    [porjectCell.distanceLabel setText:@"<500m"];
                }
            }
            
            //            //NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
            //            double distance=[RJUtil LantitudeLongitudeDist:[lng doubleValue] other_Lat:[lat doubleValue] self_Lon:localLng self_Lat:localLat];
            //            NSLog(@"distance:%f",distance);
            //            if(distance>0.0){
            //                if (distance/1000>1) {
            //                    [porjectCell.listItem.typelabel3 setText:[NSString stringWithFormat:@"约%dkm",(int)distance/1000]];
            //
            //                }else if (distance/1000<1 && distance/1000>0.5){
            //                    [porjectCell.listItem.typelabel3 setText:@"<1000m"];
            //                }else if (distance/1000<0.5){
            //                    [porjectCell.listItem.typelabel3 setText:@"<500m"];
            //                }
            //            }
            
        }
        
        
        if ([dic objectForKey:@"addr"] && ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]) {
            NSString *addr=[dic objectForKey:@"addr"];
            //            CGRect frame=porjectCell.listItem.addressLabel.frame;
            //            CGSize strSize=[addr sizeWithFont:porjectCell.listItem.addressLabel.font maxSize:CGSizeMake(width, 0)];
            //            frame.origin.x=porjectCell.listItem.joinLabel.frame.size.width+porjectCell.listItem.joinLabel.frame.origin.x+width/40;
            //            frame.size.width=width/3;
            //            [porjectCell.listItem.addressLabel setFrame:frame];
            // [porjectCell.listItem.addressLabel setText:[NSString stringWithFormat:@"%@",addr]];
        }
        //        if ([dic objectForKey:@"pname"] && ![[dic objectForKey:@"pname"] isEqual:[NSNull null]]) {
        //            NSString *pname=[dic objectForKey:@"pname"];
        //            CGRect frame=porjectCell.listItem.typelabel.frame;
        //            CGSize strSize=[pname sizeWithFont:porjectCell.listItem.typelabel.font maxSize:CGSizeMake(width, 0)];
        //            frame.size.width= strSize.width+frame.size.height/2;
        //            [porjectCell.listItem.typelabel setFrame:frame];
        ////            [porjectCell.listItem.typelabel setText:[NSString stringWithFormat:@"%@",pname]];
        //        }
        if ([dic objectForKey:@"grade"] && ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
            NSString *grade=[dic objectForKey:@"grade"];
            //width/40
            //            CGRect frame=porjectCell.listItem.typelabel1.frame;
            //            CGSize strSize=[grade sizeWithFont:porjectCell.listItem.typelabel1.font maxSize:CGSizeMake(width, 0)];
            //            frame.origin.x=porjectCell.listItem.typelabel.frame.size.width+porjectCell.listItem.typelabel.frame.origin.x+width/40;
            //            frame.size.width=strSize.width+frame.size.height/2;
            //            [porjectCell.listItem.typelabel1 setFrame:frame];
            [porjectCell.ageLabel setText:[NSString stringWithFormat:@"%@",grade]];
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
        
    }else if ([local1Array count]>0 && tableView.tag==1) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[local1Array objectAtIndex:[indexPath row]];
        [label setText:[dic objectForKey:@"title"]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:selectCity1String].location!=NSNotFound) {
            [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*3/4, self.view.frame.size.width/22.8, self.view.frame.size.width/22, self.view.frame.size.width/26.7)];
            [rightView setImage:[UIImage imageNamed:@"select_logo"]];
            [cell addSubview:rightView];
        }
        
    }else if ([local2Array count]>0 && tableView.tag==2) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[local2Array objectAtIndex:[indexPath row]];
        [label setText:[dic objectForKey:@"title"]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:selectCity2String].location!=NSNotFound) {
            [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*3/4, self.view.frame.size.width/22.8, self.view.frame.size.width/22, self.view.frame.size.width/26.7)];
            [rightView setImage:[UIImage imageNamed:@"select_logo"]];
            [cell addSubview:rightView];
        }
        
    }else if ([local3Array count]>0 && tableView.tag==3) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[local3Array objectAtIndex:[indexPath row]];
        [label setText:[dic objectForKey:@"title"]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:selectCity3String].location!=NSNotFound) {
            [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*3/4, self.view.frame.size.width/22.8, self.view.frame.size.width/22, self.view.frame.size.width/26.7)];
            [rightView setImage:[UIImage imageNamed:@"select_logo"]];
            [cell addSubview:rightView];
        }
        
    }else if ([typeArray count]>0 && tableView.tag==4) {
        
        cell  = [[SortProjectListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // if ([projectDictionary count]>0 ) {
        int width=dataTableView.frame.size.width;
        SortProjectListTableCell *dataCell=(SortProjectListTableCell *)cell;
        [dataCell setNewFrame:width];
        NSDictionary *projectDic=[typeArray objectAtIndex:[indexPath row]];
        if ([projectDic objectForKey:@"logo"] && ![[projectDic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[projectDic objectForKey:@"logo"];
            if(logo!=nil && ![logo isEqualToString:@""]&& ![logo isEqual:[NSNull null]])
            {
                [dataCell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }else{
                [dataCell.logoImage setImage:[UIImage imageNamed:@"instlist_defalut"]];
            }
        }else{
            [dataCell.logoImage setImage:[UIImage imageNamed:@"instlist_defalut"]];
        }
        //19px
        [dataCell.titleLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/33.6]];
        [dataCell.titleLabel setText:[NSString stringWithFormat:@"%@",[[typeArray objectAtIndex:[indexPath row]]objectForKey:@"title"]]];
        
        
        NSInteger number=0;
        if ([typeArray count]>0 && typeArray!=nil) {
            NSArray *lesson=[[typeArray objectAtIndex:[indexPath row]]objectForKey:@"lesson_group"];
            number=[lesson count];
        }else{
            number=[[typeArray objectAtIndex:[indexPath row]] count];
        }
        bool isSelected=false;
        if([selcedIdArray count]>0){
            for (int i=0; i<[selcedIdArray count]; i++) {
                NSIndexPath *selectId=(NSIndexPath *)[selcedIdArray objectAtIndex:i];
                if(selectId ==indexPath){
                    isSelected=true;
                }
            }
        }
        width=self.view.frame.size.width;
        for (int i=0; i<number; i++) {
            int paddingheight=width/45.7;//高度间距
            int offset=width/6.4;
            int paddingwidth=width/45.7;
            int controlWidth=width/5.7;
            int controlHeight=width/12.5;
            UIControl *control=[[UIControl alloc]init];
            float y=0;
            float x=0;
            x=offset+(paddingwidth+controlWidth)*(i%3);
            y=(paddingheight+controlHeight)*(i/3)+dataCell.titleLabel.frame.size.height+dataCell.titleLabel.frame.origin.y+paddingwidth;
            [control setFrame:CGRectMake(x, y, width/5.7, width/12.5)];
            NSString *str1=@"";
            if ([typeArray count]>0 && typeArray!=nil) {
                NSArray *lesson=[[typeArray objectAtIndex:[indexPath row]]objectForKey:@"lesson_group"];
                str1=[[lesson objectAtIndex:i]objectForKey:@"title"];
            }else{
                //str1=[[orgDictionary objectAtIndex:[indexPath row]]objectAtIndex:i];
                
            }
            //111*51
            CustomLabel *itemLabel=[[CustomLabel alloc]initWithFrame:CGRectMake(0, 0, width/5.7, width/12.5)];
            UITapGestureRecognizer *getsture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTypeText:)];
            [itemLabel addGestureRecognizer:getsture];
            [itemLabel setUserInteractionEnabled:YES];
            [itemLabel setSuperID:(int)[indexPath row]];
            [itemLabel setSubID:i];
            [itemLabel setText:str1];
            [itemLabel setFont:[UIFont systemFontOfSize:width/30]];
            [itemLabel setTextAlignment:NSTextAlignmentCenter];
            [itemLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
            itemLabel.layer.masksToBounds=YES;
            itemLabel.layer.cornerRadius=3;
            itemLabel.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
            itemLabel.layer.borderWidth=1;
            [itemLabel setFrame:CGRectMake((control.frame.size.width-itemLabel.frame.size.width)/2, 0, itemLabel.frame.size.width, itemLabel.frame.size.height)];
            [itemLabel setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
            if(isSelected==true){
                [control addSubview:itemLabel];
                [dataCell addSubview:control];
                CGRect frame=cell.frame;
                frame.size.height=control.frame.origin.y+control.frame.size.height+width/26.7;
                cell.frame=frame;
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:255.f/255.f green:82.f/255.f blue:82.f/255.f alpha:1.0]];
                [cell setBackgroundColor:[UIColor colorWithRed:234.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow_light"]];
                
            }else{
                [cell setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow"]];
                
            }
        }
        
        
        
    }else if ([gradeArray count]>0 && tableView.tag==5) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[gradeArray objectAtIndex:[indexPath row]];
        [label setText:[dic objectForKey:@"title"]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:allGradeLabel.text].location!=NSNotFound) {
            [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*3/4, self.view.frame.size.width/22.8, self.view.frame.size.width/22, self.view.frame.size.width/26.7)];
            [rightView setImage:[UIImage imageNamed:@"select_logo"]];
            [cell addSubview:rightView];
        }
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if (tableView.tag==0) {
        ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
        NSDictionary *dic=[tableArray objectAtIndex:indexPath.row];
        NSNumber *projectId=[dic objectForKey:@"id"];
        [projectDetailsViewController setProjectId:projectId];
        [self presentViewController:projectDetailsViewController animated:YES completion:nil];
        
    }else if(tableView.tag==1){
        NSDictionary *dic=[local1Array objectAtIndex:[indexPath row]];
        select1Id=(int)[indexPath row];
        aid=[dic objectForKey:@"id"];
        NSString *str=[dic objectForKey:@"title"];
        selectCity1String=str;
        addressString=[addressString stringByAppendingString:str];
        [self getSubCity:aid];
        [self subAddress:addressString];
    }else if(tableView.tag==2){
        NSDictionary *dic=[local2Array objectAtIndex:[indexPath row]];
        select2Id=(int)[indexPath row];
        aid=[dic objectForKey:@"id"];
        NSString *str=[dic objectForKey:@"title"];
        selectCity2String=str;
        addressString=[addressString stringByAppendingString:str];
        [self getEndCity:aid];
        [self endAddress:addressString];
    }else if(tableView.tag==3){
        NSDictionary *dic=[local3Array objectAtIndex:[indexPath row]];
        select3Id=[indexPath row];
        aid=[dic objectForKey:@"id"];
        NSString *str=[dic objectForKey:@"title"];
        selectCity3String=str;
        addressString=[addressString stringByAppendingString:str];
        [localNowLabel setText:addressString];
        [twoLayout closeDrawer];
        [threeLayout closeDrawer];
        [fourLayout closeDrawer];
        addressString=@"";
        
    }else if(tableView.tag==4){
//        NSDictionary *dic=[typeArray objectAtIndex:[indexPath row]];
//        cid=[dic objectForKey:@"id"];
//        NSString *str=[dic objectForKey:@"title"];
//        [typeNowLabel setText:[NSString stringWithFormat:@"%@",str]];
//        typeString=str;
//        [typeLayout closeDrawer];
//        [typeTableView.tableHeaderView setHidden:YES];
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        bool hasNumb=false;
        if([selcedIdArray count]>0){
            for (int i=0; i<[selcedIdArray count]; i++) {
                NSIndexPath *selectId=(NSIndexPath *)[selcedIdArray objectAtIndex:i];
                if(selectId ==indexPath){
                    [selcedIdArray removeObjectAtIndex:i];
                    hasNumb=true;
                }
            }
        }
        if(hasNumb==false){
            [selcedIdArray addObject:indexPath];
        }
        [dataTableView reloadData];
        
        
    }else if(tableView.tag==5){
        NSDictionary *dic=[gradeArray objectAtIndex:[indexPath row]];
        gid=[dic objectForKey:@"id"];
        NSString *str=[dic objectForKey:@"title"];
        [gradeNowLabel setText:[NSString stringWithFormat:@"%@",str]];
        gradeString=str;
        [gradeLayout closeDrawer];
        [gradeTableView.tableHeaderView setHidden:YES];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (tableView.tag==0) {
        cell = [self tableView:projectTableView cellForRowAtIndexPath:indexPath];
        
    }else if(tableView.tag==1){
        cell = [self tableView:addTableView cellForRowAtIndexPath:indexPath];
    }
    else if(tableView.tag==2){
        cell = [self tableView:subAddTableView cellForRowAtIndexPath:indexPath];
        
    }else if(tableView.tag==3){
        cell = [self tableView:endAddTableView cellForRowAtIndexPath:indexPath];
    }else if(tableView.tag==4){
        cell = [self tableView:dataTableView cellForRowAtIndexPath:indexPath];
    }else if(tableView.tag==5){
        cell = [self tableView:gradeTableView cellForRowAtIndexPath:indexPath];
    }
    return cell.frame.size.height;
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
-(void)getAllGrade{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getGrade:nil success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    gradeArray=(NSMutableArray *)model.result;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [gradeTableView reloadData];
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
-(void)getEndCity:(NSNumber *)Aid{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCity:Aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    local3Array=(NSArray *)[result objectForKey:@"content"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [endAddTableView reloadData];
                        
                        if ([local3Array count]>0) {
                            [endAddTableView reloadData];
                            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:select3Id inSection:0];//定位到第8行
                            [endAddTableView scrollToRowAtIndexPath:idxPath
                                                   atScrollPosition:UITableViewScrollPositionTop
                                                           animated:NO];
                            
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
-(void)getSubCity:(NSNumber *)Aid{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCity:Aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    local2Array=(NSArray *)[result objectForKey:@"content"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [subAddTableView reloadData];
                        
                        if ([local2Array count]>0) {
                            [subAddTableView reloadData];
                            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:select2Id inSection:0];//定位到第8行
                            [subAddTableView scrollToRowAtIndexPath:idxPath
                                                   atScrollPosition:UITableViewScrollPositionTop
                                                           animated:NO];
                            
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
-(void)getAllType{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getLessonGroup:self success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    typeArray=(NSMutableArray *)model.result;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [dataTableView setTag:4];
                        [dataTableView reloadData];
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
-(void)getAllCity{
    NSNumber *Aid=[NSNumber numberWithInt:0];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCity:Aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    local1Array=(NSArray *)[result objectForKey:@"content"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [addTableView reloadData];
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
-(void)selectTypeText:(UITapGestureRecognizer *)gesture{
    CustomLabel *itemLabel=(CustomLabel *)gesture.view;
    NSLog(@"selectTypeText%@",itemLabel.text);
    
}
-(void)getData{
    
    if (projectID!=0 && projectID!=nil) {
        NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
        NSNumber *Aid=[fomaterr numberFromString:DEFAULT_LOCAL_AID];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            //            withlng:[NSNumber numberWithDouble:106.5] withlat:[NSNumber numberWithDouble:29.5] withnums:[NSNumber numberWithInt:2]
            [HttpHelper getLessonList:projectID withPid:projectSubID withAID:Aid  success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        NSDictionary *result=model.result;
                        
                        tableArray=(NSArray *)[result objectForKey:@"lesson"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [projectTableView reloadData];
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
    if (titleName) {
        [searchLabel setText:[titleName stringByAppendingString:@"课程"]];
    }
    if (tableArray!=nil &&[tableArray count]>0) {
        [projectTableView reloadData];
    }
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setHotModel:(NSString *)sqlString{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    if(aid==nil){
        aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper searchData:aid withData:sqlString success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    tableArray=(NSArray *)[result objectForKey:@"lesson"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
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
-(void)setData{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date=[dateformatter stringFromDate:senddate];
    if(aid==nil){
        aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    }
    if(cid==nil){
        cid=[formatter numberFromString:@"0"];
        
    }
    NSNumber *pc=[NSNumber numberWithInt:10];
    NSNumber *pn=[NSNumber numberWithInt:1];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper searchData:aid withData:@"" withDate:date withCid:cid withPid:pid withGid:gid withPc:pc withPn:pn success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    tableArray=(NSArray *)[result objectForKey:@"lesson"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [projectTableView reloadData];
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
-(void)searchData:(NSString *)data withTime:(NSString *)date withAid:(NSNumber *)Aid{
    //    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    //    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    //    NSString *data=keyText.text;
    //    NSString *date=@"2015-03-05";
    
    
    NSNumber *pc=[NSNumber numberWithInt:10];
    NSNumber *pn=[NSNumber numberWithInt:1];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper searchData: Aid withData:data withDate:date withCid:cid withPid:pid withGid:gid withPc:pc withPn:pn success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    tableArray=(NSArray *)[result objectForKey:@"lesson"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
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
-(void)getLessonSubClasses:(NSNumber *)classesId{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getLessonSubClasses:classesId success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    tableArray=(NSArray *)[result objectForKey:@"lesson"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
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
#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    if (node.parentId!=-1) {
        NSLog(@"%@",node.name);
        [typeLayout closeDrawer];
        pid=[NSNumber numberWithInt:node.subId];
        cid=[NSNumber numberWithInt:node.superId];
        selectSuperId=[NSNumber numberWithInt:node.superId];
        typeString=node.name;
        [typeNowLabel setText:typeString];
        
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    local1Array=nil;
    local2Array=nil;
    local3Array=nil;
    
    
}




@end