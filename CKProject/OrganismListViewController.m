//
//  OrganismListView.m
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)

#import "OrganTableCell.h"
#import <CoreLocation/CoreLocation.h>
#import "OrganismListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DemotionControl.h"
#import "JZLocationConverter.h"
@interface OrganismListViewController ()<UITableViewDataSource,UITableViewDelegate,ECDrawerLayoutDelegate,RatingBarDelegate,CLLocationManagerDelegate>{
    NSArray *tableArray;
    NSArray *local1Array;
    NSArray *local2Array;
    NSArray *local3Array;
     CLLocationManager *locationManager;
    NSString *addressString;
    UILabel *localNowLabel;
    UILabel *typeNowLabel;
    UILabel *gradeNowLabel;
    NSString *lt;
    NSString *lg;
     CLLocation *neloct;
    NSMutableArray *typeArray;
    UILabel *allSortLabel;
   
    NSString *typeString;
    
    RatingBar *ratingBar1;
    RatingBar *ratingBar2;
    UILabel *starNowLabel;
    NSString *starString;

    
    NSNumber *cid;
    NSNumber *aid;
    NSNumber *lv1;
    NSNumber *lv2;
    
    NSMutableArray *timeSortArray;
    
    
    NSString *selectCity1String;
    NSString *selectCity2String;
    NSString *selectCity3String;
    int select1Id;
    int select2Id;
    int select3Id;
    UILabel *place1;

}
@property (nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation OrganismListViewController
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
@synthesize starLayout;
@synthesize projectID;
@synthesize titleName;
@synthesize addTableView;
@synthesize subAddTableView;
@synthesize typeTableView;
@synthesize endAddTableView;
static NSString * const DEFAULT_LOCAL_AID = @"500100";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中"];
    tableArray = [[NSArray alloc]init];
    local1Array = [[NSArray alloc]init];
    local2Array = [[NSArray alloc]init];
    local3Array = [[NSArray alloc]init];

    typeArray = [[NSMutableArray alloc]init];
    timeSortArray=[[NSMutableArray alloc]init];
    lv1=[NSNumber numberWithInt:0];
    lv2=[NSNumber numberWithInt:5];

    addressString=@"";
    typeString=@"";
    starString=@"";
    selectCity1String=@"";
    selectCity2String=@"";
    selectCity3String=@"";
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

    [self initTitle];
    [self initSelectView];
    [self initTableView];
    [self getData];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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

#pragma mark-懒加载
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

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
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    NSString *bt=[st objectForKey:@"biname"];
    NSString *str=[NSString stringWithFormat:@"%@类机构",bt];
    [searchLabel setText:str];
    
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
    UIView *marginview=[[UIView alloc] initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, titleHeight*3/4)];
    [marginview setUserInteractionEnabled:YES];
    [marginview setBackgroundColor:[UIColor whiteColor]];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(width/40,0,width-width/20, titleHeight*3/4)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    place1=[[UILabel alloc]initWithFrame:CGRectMake(width/11, 0,view.frame.size.width/4, marginview.frame.size.height)];
    place1.text=@"";
    place1.textColor=[UIColor redColor];
    place1.font=[UIFont systemFontOfSize:width/29];
    [view addSubview:place1];
    
    
    
//    NSArray *titleArray= [NSArray arrayWithObjects:@"区域",@"距离",@"热门",@"筛选", nil];
//    NSArray *imgArray=[NSArray arrayWithObjects:@"demotion_logo",@"demotion_logo",@"demotion_logo",@"screen_logo", nil];
//    NSArray *unimgArray=[NSArray arrayWithObjects:@"undemotion_logo",@"undemotion_logo",@"undemotion_logo",@"screen_logo", nil];
//    修改后的
    NSArray *titleArray= [NSArray arrayWithObjects:@"星级",@"热门",@"筛选", nil];
    NSArray *imgArray=[NSArray arrayWithObjects:@"demotion_logo",@"demotion_logo",@"screen_logo", nil];
    NSArray *unimgArray=[NSArray arrayWithObjects:@"undemotion_logo",@"undemotion_logo",@"screen_logo", nil];
    for(int i=0;i<3;i++){
        DemotionControl *subView=[[DemotionControl alloc]initWithFrame:CGRectMake(view.frame.size.width/4*i+width/4, 0,view.frame.size.width/4, marginview.frame.size.height)];
        [subView setUserInteractionEnabled:YES];
        [subView setTag:i];
        [subView addTarget:self action:@selector(topOnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame=self.view.frame;
        [subView initView:&frame withTag:i];
        [subView.textLabel setText:[titleArray objectAtIndex:i]];
        [subView.userLogo setImage:[UIImage imageNamed:[unimgArray objectAtIndex:i]] forState:UIControlStateNormal];
        [subView.userLogo setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateSelected];
        [view addSubview:subView];
    }
    [marginview addSubview:view];
    [self.view addSubview:marginview];
}

-(void)topOnClick:(id)sender{
    DemotionControl *btn=(DemotionControl *)sender;
    
    switch (btn.tag) {
//        case 0:
//        {
//            [self inPopView];
//            
//        }
            break;
        case 0:
        {
            btn.userLogo.selected=!btn.userLogo.selected;//每次点击都改变按钮的状态
            
            if(btn.userLogo.selected){
                timeSortArray=[tableArray mutableCopy];
                NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"created" ascending:YES];
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
        case 2:
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
    [cancelLabel setTag:0];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDrawLayout:)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [titleView addSubview:cancelLabel];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width/10)/2, width/20-1, width/20*2, width/20)];
    [titleLabel setText:@"筛选"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    [confirmLabel setText:@"确定"];
    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    [confirmLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout:)];
    [confirmLabel addGestureRecognizer:confrimGesture];
    [titleView addSubview:confirmLabel];
    
    UIView *localBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46, view.frame.size.width, width/10)];
    [localBgView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *addressGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allAddress)];
    [localBgView addGestureRecognizer:addressGestrue];
    [localBgView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:localBgView];
    
    
    UILabel *localLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (localBgView.frame.size.height-width/26)/2, width/4, width/26)];
    [localLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [localLabel setText:place1.text];
    [localLabel setFont:[UIFont systemFontOfSize:width/26]];
    [localBgView addSubview:localLabel];
    
    localNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (localBgView.frame.size.height-width/29)/2, localBgView.frame.size.width*2/3, width/29)];
    [localNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [localNowLabel setText:addressString];
    [localNowLabel setTextAlignment:NSTextAlignmentRight];
    [localNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    [localBgView addSubview:localNowLabel];
    
    UIImageView *rightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+localBgView.frame.size.width*3/4, (localBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    
    [rightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    [localBgView addSubview:rightLabel];
    
    
    UIView *allSortBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46+width/10+width/40, view.frame.size.width, width/10)];
    [allSortBgView setBackgroundColor:[UIColor whiteColor]];
    [allSortBgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *allTypeGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allType)];
    [allSortBgView addGestureRecognizer:allTypeGestrue];
    [view addSubview:allSortBgView];
    
    
    allSortLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (allSortBgView.frame.size.height-width/26)/2, width/2, width/26)];
    [allSortLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [allSortLabel setText:@"全部分类"];
    [allSortLabel setFont:[UIFont systemFontOfSize:width/26]];
    [allSortBgView addSubview:allSortLabel];
    
    typeNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (allSortBgView.frame.size.height-width/29)/2, allSortBgView.frame.size.width*2/3, width/29)];
    [typeNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [typeNowLabel setText:typeString];
    [typeNowLabel setTextAlignment:NSTextAlignmentRight];
    [typeNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    [allSortBgView addSubview:typeNowLabel];
    
    UIImageView *allrightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+allSortBgView.frame.size.width*3/4, (allSortBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    [allrightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    [allrightLabel setUserInteractionEnabled:NO];
    [allSortBgView addSubview:allrightLabel];
    
    
    
    UIView *starBgView=[[UIView alloc]initWithFrame:CGRectMake(0, width/10+2+width/40+width/46+width/10+width/40+width/10, view.frame.size.width, width/10)];
    [starBgView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *starGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showStar)];
    [starBgView addGestureRecognizer:starGestrue];
    [view addSubview:starBgView];
    
    
    UILabel *starLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, (starBgView.frame.size.height-width/26)/2, width/26*2, width/26)];
    [starLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [starLabel setText:@"星级"];
    [starLabel setFont:[UIFont systemFontOfSize:width/26]];
    [starBgView addSubview:starLabel];
    
    
    
    UIImageView *starrightLabel=[[UIImageView alloc]initWithFrame:CGRectMake(width/20+width/26*2+starBgView.frame.size.width*3/4, (starBgView.frame.size.height-width/29)/2, width/45.7, width/29)];
    [starrightLabel setImage:[UIImage imageNamed:@"right_logo"]];
    [starrightLabel setUserInteractionEnabled:NO];
    [starBgView addSubview:starrightLabel];
    
   starNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/26*2, (starBgView.frame.size.height-width/29)/2, starBgView.frame.size.width*2/3, width/29)];
    [starNowLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [starNowLabel setText:starString];
    [starNowLabel setTextAlignment:NSTextAlignmentRight];
    [starNowLabel setFont:[UIFont systemFontOfSize:width/29]];
    [starBgView addSubview:starNowLabel];
    
    
    
    
    firstLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    firstLayout.width=view.frame.size.width;
    firstLayout.contentView=view;
    firstLayout.delegate=self;
    [firstLayout setTag:0];
    [self.view addSubview:firstLayout];
    
    firstLayout.openFromRight = YES;
    [firstLayout openDrawer];
    
    
}
-(void)showStar{
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
    [titleLabel setText:@"星级"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:width/20]];
    [titleView addSubview:titleLabel];
    
    
    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    [confirmLabel setText:@"确定"];
    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    [confirmLabel setUserInteractionEnabled:YES];
    [confirmLabel setTag:5];
    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout:)];
    [confirmLabel addGestureRecognizer:confrimGesture];
    [titleView addSubview:confirmLabel];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height+titleLabel.frame.origin.y, width, width/2.2)];
    
    UIView *starBg=[[UIView alloc]initWithFrame:CGRectMake(width/26.7, width/6.4, width/2.9, width/8)];
    starBg.layer.masksToBounds=true;
    starBg.layer.borderWidth=1;
    starBg.layer.borderColor=[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0].CGColor;
    starBg.layer.cornerRadius=16;
    [bgView addSubview:starBg];
    
    ratingBar1=[[RatingBar alloc]initWithFrame:CGRectMake(width/40, (width/8-width/21.3)/2, width/2.9-width/20, width/21.3)];
    [ratingBar1 setPadding:width/49];
    [ratingBar1 setImageDeselected:@"unselect_big_star" halfSelected:nil fullSelected:@"big_star" andDelegate:self];
    [starBg addSubview:ratingBar1];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(starBg.frame.size.width+starBg.frame.origin.x, width/4.8, width/16.8, width/26.7)];
    [textLabel setText:@"至"];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [textLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [bgView addSubview:textLabel];
    
    UIView *starBg1=[[UIView alloc]initWithFrame:CGRectMake(textLabel.frame.size.width+textLabel.frame.origin.x, width/6.4, width/2.9, width/8)];
    starBg1.layer.masksToBounds=true;
    starBg1.layer.borderWidth=1;
    starBg1.layer.borderColor=[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0].CGColor;
    starBg1.layer.cornerRadius=16;
    [bgView addSubview:starBg1];
    
    ratingBar2=[[RatingBar alloc]initWithFrame:CGRectMake(width/40, (width/8-width/21.3)/2, width/2.9-width/20, width/21.3)];
    [ratingBar2 setPadding:width/49];
    [ratingBar2 setImageDeselected:@"unselect_big_star" halfSelected:nil fullSelected:@"big_star" andDelegate:self];
    [starBg1 addSubview:ratingBar2];
    
    [view addSubview: bgView];
    
    starLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    starLayout.width=view.frame.size.width;
    starLayout.contentView=view;
    starLayout.delegate=self;
    [starLayout setTag:4];
    [self.view addSubview:starLayout];
    
    starLayout.openFromRight = YES;
    [starLayout openDrawer];
    
    
}
-(void)ratingChanged:(float)newRating{
  //  lvNumber=[NSNumber numberWithFloat:newRating];
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
    
    
    //    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/10-width/40, width/20+1, width/22*2, width/23)];
    //    [confirmLabel setText:@"确定"];
    //    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    //    [confirmLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    //    [confirmLabel setFont:[UIFont systemFontOfSize:width/23]];
    //    [confirmLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *confrimGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDrawLayout)];
    //    [confirmLabel addGestureRecognizer:confrimGesture];
    //    [titleView addSubview:confirmLabel];
    
    typeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               width/10+2+width/40+width/46,
                                                               view.frame.size.width,
                                                               view.frame.size.height-(width/10+2+width/40+width/46))];
    [typeTableView setBackgroundColor:[UIColor whiteColor]];
    typeTableView.dataSource                        = self;
    typeTableView.delegate                          = self;
    [typeTableView setTag:4];
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

    typeLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    typeLayout.width=view.frame.size.width;
    typeLayout.contentView=view;
    typeLayout.delegate=self;
    [self.view addSubview:typeLayout];
    
    typeLayout.openFromRight = YES;
    [typeLayout openDrawer];
    [ProgressHUD show:@"加载中"];

    [self getAllType];
    
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

    addTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              width/10+2+width/40+width/46,
                                                              view.frame.size.width,
                                                              view.frame.size.height-(width/10+2+width/40+width/46))];
    [addTableView setBackgroundColor:[UIColor whiteColor]];
    addTableView.dataSource                        = self;
    addTableView.delegate                          = self;
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
            [starLayout closeDrawer];
        }
            break;
        default:
            break;
    }
    NSLog(@"closeDrawLayout close");
}
-(void)confirmDrawLayout:(id)sender{
    NSLog(@"confirmDrawLayout close");
    UITapGestureRecognizer *gesutre=(UITapGestureRecognizer *)sender;
    switch (gesutre.view.tag) {
        case 0:
        {
            addressString=@"";
            NSString *str=typeNowLabel.text;
            [searchLabel setText:[str stringByAppendingString:@"机构"]];
            [self searchInst];
            [firstLayout closeDrawer];
            
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
            NSString *fristStr= [NSString stringWithFormat:@"%d星",(int)ratingBar1.rating];
            lv1=[NSNumber numberWithFloat:ratingBar1.rating];
            lv2=[NSNumber numberWithFloat:ratingBar2.rating];

            NSString *twoStr= [NSString stringWithFormat:@"~%d星",(int)ratingBar2.rating];
            starString=[fristStr stringByAppendingString:twoStr];
            [starNowLabel setText:[NSString stringWithFormat:@"%@",starString]];
            
            [starLayout closeDrawer];
            
        }
            
            break;
            
            
        default:
            break;
    }
    NSLog(@"closeDrawLayout close");
}

-(void)initTableView{
    
    bottomHeight=49;
    
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20+0.5+titleHeight,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height-titleHeight-20-0.5-titleHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    [self.view addSubview:projectTableView];
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
            
        default:
            break;
    }
    return 0;
    
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell;
    
    if ([tableArray count]>0 && tableView.tag==0) {
        cell  = [[OrganTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        OrganTableCell *porjectCell=(OrganTableCell *)cell;
        
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
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
                    place1.text=@"你的地址没找到，可能在月球上";
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
                        place1.text=place.subLocality;
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

        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [porjectCell.listItem.orgName setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"stitle"] && ![[dic objectForKey:@"stitle"] isEqual:[NSNull null]]) {
            NSString *stitle=[dic objectForKey:@"stitle"];
            [porjectCell.listItem.logoTitle setText:[NSString stringWithFormat:@"%@",stitle]];
        }
        
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            [porjectCell.listItem.logoView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
        }
        
        if ([dic objectForKey:@"lv"] && ![[dic objectForKey:@"lv"] isEqual:[NSNull null]]) {
            NSNumber *lv=[dic objectForKey:@"lv"];
            [porjectCell.listItem.ratingBar displayRating:[lv floatValue]];
        }
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSNumber *orders=[dic objectForKey:@"people"];
            NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
            [porjectCell.listItem.numberLabel setText:[NSString stringWithFormat:@"%@",orders]];
        }
        
        if ([dic objectForKey:@"addr"] && ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]) {
            NSString *addr=[dic objectForKey:@"addr"];
            [porjectCell.listItem.addLabel setText:[NSString stringWithFormat:@"%@",addr]];
        }
    }else if ([local1Array count]>0 && tableView.tag==1) {
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[local1Array objectAtIndex:[indexPath row]];
        [label setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
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
        
        cell=[[UITableViewCell alloc]init];
        CGRect frame=cell.frame;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/22.8, self.view.frame.size.width/22.8, frame.size.width/2, self.view.frame.size.width/26.7)];
        NSDictionary *dic=[typeArray objectAtIndex:[indexPath row]];
        [label setText:[dic objectForKey:@"title"]];
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
        [cell addSubview:label];
        if ([[dic objectForKey:@"title"]rangeOfString:allSortLabel.text].location!=NSNotFound) {
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
        OrganDetailsViewController *projectDetailsViewController=[[OrganDetailsViewController alloc]init];
        NSDictionary *dic=[tableArray objectAtIndex:indexPath.row];
        NSNumber *aritcleId=[dic objectForKey:@"id"];
        [projectDetailsViewController setAritcleId:aritcleId];
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
        [localNowLabel setText:[NSString stringWithFormat:@"%@",addressString]];
        [twoLayout closeDrawer];
        [threeLayout closeDrawer];
        [fourLayout closeDrawer];
        addressString=@"";
      //  localArray=[[NSArray alloc]init];
        
    }else if(tableView.tag==4){
        NSDictionary *dic=[typeArray objectAtIndex:[indexPath row]];
        NSString *str=[dic objectForKey:@"title"];
        cid=[dic objectForKey:@"id"];
        [typeNowLabel setText:[NSString stringWithFormat:@"%@",str]];
        typeString=str;
        [typeLayout closeDrawer];
        [typeTableView.tableHeaderView setHidden:YES];
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
        cell = [self tableView:typeTableView cellForRowAtIndexPath:indexPath];
    }
    return cell.frame.size.height;
    
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
                        
                        [typeTableView reloadData];
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
            NSLog(@"2333333333333----%@",model.message);
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
-(void)getData{
    if (projectID!=0) {
        NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
        NSNumber *Aid=[fomaterr numberFromString:DEFAULT_LOCAL_AID];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper siftOrgList:Aid withTypeId:projectID withCornerId:nil withLv:nil  success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        tableArray=(NSArray *)model.result;
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
}
-(void)searchInst{
    if (aid==nil && cid==nil) {
        return;
    }
    if(aid==nil){
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    }
    if (cid==nil) {
        cid=[NSNumber numberWithInt:0];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper searchInst:cid withAid:aid withStartLv:lv1 withEndLv:lv2 success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    tableArray=(NSArray *)model.result;
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
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
//    tableArray=nil;
//    local1Array=nil;
//    local2Array=nil;
//    local3Array=nil;
//    typeArray=nil;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end