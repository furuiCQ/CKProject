
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
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
#import <JGProgressHUD/JGProgressHUD.h>

@interface ProjectListViewController ()<UITableViewDataSource,UITableViewDelegate,ECDrawerLayoutDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *local1Array;
    NSArray *local2Array;
    NSArray *local3Array;
    
    
    NSString *addressString;
    UILabel *localNowLabel;
    UILabel *typeNowLabel;
    UILabel *gradeNowLabel;
    CLLocationManager *locationManager;
    NSMutableArray *typeArray;
    NSMutableArray *gradeArray;
    
    UILabel *allSortLabel;
    UILabel *allGradeLabel;
    NSString *typeString;
    NSString *gradeString;
    
    NSNumber *aid;
    NSNumber *cid;
    NSNumber *pid;
    NSNumber *gid;
    
    //   NSNumber *selectSuperId;
    
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
    UICollectionView * cityCollectView;
    UICollectionView * gradCollectView;
    
    int pageNumb;
    BOOL _isLoading;
    BOOL _isHeader;
    BOOL _isFooter;
    BOOL _isNoData;
    
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
    
    NSArray *selectImageArray;
    NSArray *normalImageArray;
    //
    UIImageView *hotImageView;
    UIImageView *hot2ImageView;
    //定位
    UILabel *localLabel;
    NSMutableArray *typeAllArray;
    NSMutableArray *cityAllArray;
    NSMutableArray *gradeAllArray;
    
    NSNumber *selectCid;
    NSNumber *selectPid;
    NSNumber *selectGid;
    NSNumber *selectAid;
    UIAlertView *alertView;
    
    
    BOOL isSift;
    BOOL isHot;
    //progress
    JGProgressHUD *HUD;
    //
    NSMutableArray *moreBtnArray;
    
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
@synthesize typeTableView;
@synthesize gradeLayout;
@synthesize tableArray;
@synthesize gradeTableView;
@synthesize counts;
@synthesize searchs;
static NSString * const DEFAULT_LOCAL_AID = @"500100";
- (void)viewDidLoad {
    [super viewDidLoad];
    //  [ProgressHUD show:@"加载中..."];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    if (tableArray==nil) {
        tableArray = [[NSMutableArray alloc]init];
    }
    local1Array = [[NSMutableArray alloc]init];
    local2Array = [[NSArray alloc]init];
    local3Array = [[NSArray alloc]init];
    
    gradeArray=[[NSMutableArray alloc]init];
    typeArray = [[NSMutableArray alloc]init];
    imageViewArray=[[NSMutableArray alloc]init];
    timeSortArray=[[NSMutableArray alloc]init];
    selcedIdArray=[[NSMutableArray alloc]init];
    typeAllArray=[[NSMutableArray alloc]init];
    cityAllArray=[[NSMutableArray alloc]init];
    gradeAllArray=[[NSMutableArray alloc]init];
    moreBtnArray=[[NSMutableArray alloc]init];
    
    aid=[[NSNumber alloc]init];
    cid=[NSNumber numberWithInt:0];
    gid=[NSNumber numberWithInt:0];
    pid=[[NSNumber alloc]initWithInt:-1];
    pageNumb=1;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    localLat=myDelegate.latitude;
    localLng=myDelegate.longitude;
    
    addressString=@"";
    selectCity1String=@"";
    selectCity2String=@"";
    selectCity3String=@"";
    selectImageArray=[NSArray arrayWithObjects:@"dance_pressed_ic",@"Language_pressed_ic",@"sports_pressed_ic",@"music_pressed_ic",@"Vocational-and-technical_pressed_ic",@"Wushu_pressed_ic" ,@"paint_pressed_ic" ,@"open-book_pressed_ic" ,@"Health-and-beauty_pressed_ic" ,@"classroom_pressed_ic" ,@"Study-abroad_pressed_ic",nil];
    normalImageArray=[NSArray arrayWithObjects:@"dance_nor_ic",@"Language_nor_ic",@"sports_nor_ic",@"music_nor_ic",@"Vocational-and-technical_nor_ic",@"Wushu_nor_ic" ,@"paint_nor_ic",@"open-book_nor_ic" ,@"Health-and-beauty_nor_ic" ,@"classroom_nor_ic" ,@"Study-abroad_nor_ic",nil];
    
    [self initTitle];
    [self initSelectView];
    [self initTableView];
    [self inPopView];
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"加载中...";
    [HUD showInView:self.view];
    
    if (std==1) {
        [self tit];
    }
    if (std==2) {
        [self searchData];
    }else{
        _isHeader=YES;
        [self getData];
    }
    
}

-(void)tit
{
    //  [ProgressHUD show:@"加载中..."];
    
    NSUserDefaults *sd=[NSUserDefaults standardUserDefaults];
    NSNumber *artid=[sd objectForKey:@"nid"];
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?instid=%@",artid];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *db=[obj objectForKey:@"result"];
        NSArray *dataArray=[db objectForKey:@"lesson"];
        [tableArray addObjectsFromArray:dataArray];
        
        NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",tableArray);
        [projectTableView reloadData];
        [HUD dismiss];
    }];
}
-(void)searchData
{
    //  [ProgressHUD show:@"加载中..."];
    
    NSUserDefaults *src=[NSUserDefaults standardUserDefaults];
    NSString *bt1=[src objectForKey:@"kp"];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?date=%@&lng=%f&lat=%f&status=2&pn=%d&pc=20",bt1,myDelegate.longitude,myDelegate.latitude,pageNumb];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *db=[obj objectForKey:@"result"];
        NSArray *dataArray=[db objectForKey:@"lesson"];
        if([dataArray count]>0){
            _isNoData=NO;
            if(_isHeader){
                tableArray =[dataArray mutableCopy];
            }else{
                [tableArray addObjectsFromArray:dataArray];
            }
        }else{
            if(!_isNoData){
                if (alertView==nil) {
                    alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertView.delegate=self;
                }
                [alertView setMessage:@"没有更多的课程了"];
                [alertView show];
                _isNoData=YES;
            }
        }
        
        [projectTableView reloadData];
        [refreshFooter endRefreshing];
        [refreshHeader endRefreshing];
        
        _isLoading=NO;
        [HUD dismiss];
        
    }];
}
-(void)setstd:(int)num
{
    std=num;
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
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:titleName];
    
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
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    localLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width/3, width/7)];
    [localLabel setText:@"正在定位.."];
    if(myDelegate.cityName){
        [localLabel setText:myDelegate.cityName];
    }else{
        [localLabel setText:@"重庆"];
    }
    [localLabel setBackgroundColor:[UIColor whiteColor]];
    [localLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [localLabel setTextAlignment:NSTextAlignmentCenter];
    [marginview addSubview:localLabel];
    //筛选按钮
    UIControl *hotControl=[[UIControl alloc]initWithFrame:CGRectMake(localLabel.frame.size.width+0.3, 0, width/3-0.2, width/7)];
    [hotControl setTag:0];
    [hotControl setUserInteractionEnabled:YES];
    [hotControl addTarget:self action:@selector(sortData) forControlEvents:UIControlEventTouchUpInside];
    hotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(hotControl.frame.size.width-width/11.6-width/29, width/7/2-width/45.7-1, width/29, width/45.7)];
    [hotControl setBackgroundColor:[UIColor whiteColor]];
    [hotImageView setImage:[UIImage imageNamed:@"red_up"]];
    hot2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(hotControl.frame.size.width-width/11.6-width/29, width/7/2+1, width/29, width/45.7)];
    [hot2ImageView setImage:[UIImage imageNamed:@"red_down"]];
    
    UILabel *hotLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8.7, 0, width/24.6*2, width/7)];
    [hotLabel setText:@"热门"];
    [hotLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [hotLabel setTextAlignment:NSTextAlignmentCenter];
    [hotControl addSubview:hotLabel];
    [hotControl addSubview:hotImageView];
    [hotControl addSubview:hot2ImageView];
    [marginview addSubview:hotControl];
    
    
    UIControl *siftCotrol=[[UIControl alloc]initWithFrame:CGRectMake(hotControl.frame.origin.x+hotControl.frame.size.width+0.2, 0, width-(hotLabel.frame.origin.x+hotLabel.frame.size.width+0.2), width/7)];
    [siftCotrol setTag:1];
    [siftCotrol setUserInteractionEnabled:YES];
    [siftCotrol addTarget:self action:@selector(openSildingMenu) forControlEvents:UIControlEventTouchUpInside];
    //筛选按钮
    UIImageView *siftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/13.3, (width/7-width/17.8)/2, width/19.3, width/17.8)];
    [siftCotrol setBackgroundColor:[UIColor whiteColor]];
    [siftImageView setImage:[UIImage imageNamed:@"sift_logo"]];
    UILabel *siftLabel=[[UILabel alloc]initWithFrame:CGRectMake(siftImageView.frame.size.width+siftImageView.frame.origin.x+width/64, 0, width/24.6*2, width/7)];
    [siftLabel setText:@"筛选"];
    [siftLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [siftLabel setTextAlignment:NSTextAlignmentCenter];
    [siftCotrol addSubview:siftLabel];
    [siftCotrol addSubview:siftImageView];
    [marginview addSubview:siftCotrol];
}

-(void)sortData{
    if(isHot){
        isHot=NO;
        [hotImageView setImage:[UIImage imageNamed:@"red_up"]];
        [hot2ImageView setImage:[UIImage imageNamed:@"red_down"]];
        timeSortArray=[tableArray mutableCopy];
        NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"people" ascending:NO];
        NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
        NSArray *sortArray=[timeSortArray sortedArrayUsingDescriptors:sortDescriptors];
        tableArray=[sortArray copy];
        [projectTableView reloadData];
        
        
        
    }else{
        isHot=YES;
        [hotImageView setImage:[self image:[UIImage imageNamed:@"red_down"]rotation:UIImageOrientationDown]];
        [hot2ImageView setImage:[self image:[UIImage imageNamed:@"red_up"]rotation:UIImageOrientationDown]];
        timeSortArray=[tableArray mutableCopy];
        NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"people" ascending:YES];
        NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
        NSArray *sortArray=[timeSortArray sortedArrayUsingDescriptors:sortDescriptors];
        tableArray=[sortArray copy];
        [projectTableView reloadData];
    }
    
}
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
-(void)inPopView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width/1.3, hegiht-20)];
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
    
    
    allGradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/22+localNowLabel.frame.size.width+localNowLabel.frame.origin.x
                                                           , topLabel.frame.size.height+topLabel.frame.origin.y
                                                           +width/26.7, width/5.7, width/12.3)];
    [allGradeLabel setTextColor:[UIColor whiteColor]];
    [allGradeLabel setText:@"年龄段"];
    [allGradeLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *allGraGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allGrade)];
    [allGradeLabel addGestureRecognizer:allGraGestrue];
    [allGradeLabel setFont:[UIFont systemFontOfSize:width/35.6]];
    [allGradeLabel setTextAlignment:NSTextAlignmentCenter];
    [allGradeLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [allGradeLabel.layer setCornerRadius:2];
    [allGradeLabel.layer setMasksToBounds:true];
    [topView addSubview:allGradeLabel];
    
    
    bottomHeight=49;
    
    dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               topView.frame.size.height+topView.frame.origin.y,
                                                               width/1.3,
                                                               view.frame.size.height-(width/8+topView.frame.size.height+topView.frame.origin.y))];
    [dataTableView setBackgroundColor:[UIColor whiteColor]];
    dataTableView.dataSource                        = self;
    dataTableView.delegate                          = self;
    dataTableView.separatorStyle = NO;
    dataTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    [dataTableView setTag:4];
    [view addSubview:dataTableView];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(width/5.7, width/12.5);
    //创建collectionView 通过一个布局策略layout来创建
    cityCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(width/16,
                                                                        topView.frame.size.height+topView.frame.origin.y+width/40,
                                                                        width/1.3-width/8,
                                                                        view.frame.size.height-(width/8+topView.frame.size.height+topView.frame.origin.y)) collectionViewLayout:layout];
    //代理设置
    cityCollectView.delegate=self;
    cityCollectView.dataSource=self;
    [cityCollectView setTag:0];
    //注册item类型 这里使用系统的类型
    [cityCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [cityCollectView setHidden:YES];
    [cityCollectView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:cityCollectView];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout2 = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout2.itemSize = CGSizeMake(width/5.7, width/12.5);
    gradCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(width/16,
                                                                        topView.frame.size.height+topView.frame.origin.y+width/40,
                                                                        width/1.3-width/8,
                                                                        view.frame.size.height-(width/8+topView.frame.size.height+topView.frame.origin.y)) collectionViewLayout:layout2];
    //代理设置
    gradCollectView.delegate=self;
    gradCollectView.dataSource=self;
    [gradCollectView setTag:1];
    //注册item类型 这里使用系统的类型
    [gradCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid2"];
    [gradCollectView setHidden:YES];
    [gradCollectView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:gradCollectView];
    
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-width/8, width/1.3/2, width/8)];
    [cancelLabel setText:@"重置"];
    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelLabel setTextColor:[UIColor whiteColor]];
    [cancelLabel setFont:[UIFont systemFontOfSize:width/20]];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel setBackgroundColor:[UIColor colorWithRed:1 green:138.f/255.f blue:128.f/255.f alpha:1.0]];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restSlidingMenu)];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [view addSubview:cancelLabel];
    
    
    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width-width/1.3/2, view.frame.size.height-width/8, width/1.3/2, width/8)];
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
    [self getAllGrade];
    [self getAllCity];
    
    firstLayout=[[ECDrawerLayout alloc]initWithParentView:self.view];
    firstLayout.width=view.frame.size.width;
    firstLayout.contentView=view;
    firstLayout.delegate=self;
    [firstLayout setTag:0];

    [self.view addSubview:firstLayout];
    
    firstLayout.openFromRight = YES;
    
    
}
-(void)allGrade{
    [gradCollectView setHidden:NO];
    [dataTableView setHidden:YES];
    [cityCollectView setHidden:YES];
    [allGradeLabel setBackgroundColor:[UIColor colorWithRed:1 green:84.f/255.f blue:84.f/255.f alpha:1.0]];
    [localNowLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [allSortLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    
}
-(void)allType{
    [dataTableView setHidden:NO];
    [cityCollectView setHidden:YES];
    [gradCollectView setHidden:YES];
    [allSortLabel setBackgroundColor:[UIColor colorWithRed:1 green:84.f/255.f blue:84.f/255.f alpha:1.0]];
    [localNowLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [allGradeLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    
}
-(void)allAddress{
    [cityCollectView setHidden:NO];
    [dataTableView setHidden:YES];
    [gradCollectView setHidden:YES];
    [localNowLabel setBackgroundColor:[UIColor colorWithRed:1 green:84.f/255.f blue:84.f/255.f alpha:1.0]];
    [allGradeLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
    [allSortLabel setBackgroundColor:[UIColor colorWithRed:41.f/255.f green:53.f/255.f blue:58.f/255.f alpha:1.0]];
}
-(void)restSlidingMenu{
    pageNumb=1;
    for(CustomLabel *label in typeAllArray){
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    }
    for (UILabel *label in gradeAllArray) {
        [label setTextColor:[UIColor blackColor]];
    }
    for (UILabel *label in cityAllArray) {
        [label setTextColor:[UIColor blackColor]];
    }
    for(UILabel *label in moreBtnArray){
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    }

    selectCid=NULL;
    selectPid=NULL;
    selectGid=NULL;
    selectAid=NULL;
}
-(void)confirmDrawLayout{
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"加载中...";
    [HUD showInView:self.view];
    pageNumb=1;
    _isNoData=NO;
    [self getLessonSift];
    [firstLayout closeDrawer];
    isSift=YES;
}
-(void)openSildingMenu{
    [firstLayout openDrawer];
}
-(void)initTableView{
    
    bottomHeight=49;
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20+0.5+self.view.frame.size.width/7,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height-titleHeight-20-0.5-titleHeight)];
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    [projectTableView setTag:0];
    projectTableView.separatorStyle=NO;
    [self.view addSubview:projectTableView];
    
    //    refreshHeader=[[YiRefreshHeader alloc] init];
    //    refreshHeader.scrollView=projectTableView;
    //    [refreshHeader header];
    //    refreshHeader.beginRefreshingBlock=^(){
    //
    //    };
    //
    
    //    refreshFooter=[[YiRefreshFooter alloc] init];
    //    refreshFooter.scrollView=projectTableView;
    //    [refreshFooter footer];
    //    refreshFooter.beginRefreshingBlock=^(){
    //            };
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
}
static NSString *identy = @"OrderRecordCell";

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell;
    //NSLog(@"tableView.tag %ld",(long)tableView.tag);
    if ([tableArray count]>0 && tableView.tag==0) {
        static NSString *identy = @"CustomCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identy];
        if(cell==nil){
            cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderRecordCell"owner:self options:nil]lastObject];
        }
        OrderRecordCell *porjectCell=(OrderRecordCell *)cell;
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [porjectCell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"instsort"] && ![[dic objectForKey:@"instsort"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"instsort"];
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
        UITapGestureRecognizer *allGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllPorjectListViewController:)];
        [dataCell.moreLabel addGestureRecognizer:allGesture];
        [dataCell.moreLabel setTag:[indexPath row]];
        [moreBtnArray addObject:dataCell.moreLabel];
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
                if([selectId row] ==[indexPath row]){
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
            [typeAllArray addObject:itemLabel];
            if(isSelected==true){
                [control addSubview:itemLabel];
                [dataCell addSubview:control];
                CGRect frame=cell.frame;
                frame.size.height=control.frame.origin.y+control.frame.size.height+width/26.7;
                cell.frame=frame;
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:255.f/255.f green:82.f/255.f blue:82.f/255.f alpha:1.0]];
                [cell setBackgroundColor:[UIColor colorWithRed:234.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow_light"]];
                [dataCell.logoImage setImage:[UIImage imageNamed:[selectImageArray objectAtIndex:[indexPath row]]]];
                
                
            }else{
                [cell setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow"]];
                [dataCell.logoImage setImage:[UIImage imageNamed:[normalImageArray objectAtIndex:[indexPath row]]]];
                
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
        
    }else if(tableView.tag==4){
        pageNumb=1;
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        bool hasNumb=false;
        if([selcedIdArray count]>0){
            for (int i=0; i<[selcedIdArray count]; i++) {
                NSIndexPath *selectId=(NSIndexPath *)[selcedIdArray objectAtIndex:i];
                if([selectId row]==[indexPath row]){
                    [selcedIdArray removeObjectAtIndex:i];
                    hasNumb=true;
                }
            }
        }
        if(hasNumb==false){
            [selcedIdArray addObject:indexPath];
        }
        [dataTableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (tableView.tag==0) {
        cell = [self tableView:projectTableView cellForRowAtIndexPath:indexPath];
        
    }else if(tableView.tag==4){
        cell = [self tableView:dataTableView cellForRowAtIndexPath:indexPath];
    }else if(tableView.tag==5){
        cell = [self tableView:gradeTableView cellForRowAtIndexPath:indexPath];
    }
    return cell.frame.size.height;
}

-(NSString *) compareCurrentTime:(NSString*) compareString
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
                    NSArray *array=(NSArray *)model.result;
                    gradeArray=[array mutableCopy];
                    NSMutableDictionary * mutableDictionary = [[NSMutableDictionary alloc]init];
                    [mutableDictionary setObject:[NSNumber numberWithInt:0] forKey:@"id"];
                    [mutableDictionary setObject:@"全部" forKey:@"title"];
                    [gradeArray addObject:mutableDictionary];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [gradCollectView reloadData];
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
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
            
        }];
        
        
    });
    
}
-(void)getAllCity{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
    NSNumber *Aid= myDelegate.localNumber;
    if(Aid==NULL){
        Aid=[fomaterr numberFromString:DEFAULT_LOCAL_AID];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getCity:Aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    NSArray *array=[result objectForKey:@"content"];
                    local1Array=[array mutableCopy];
                    NSMutableDictionary * mutableDictionary = [[NSMutableDictionary alloc]init];
                    if(myDelegate.localNumber==NULL){
                        myDelegate.localNumber=Aid;
                    }
                    if(myDelegate.cityName==NULL){
                        myDelegate.cityName=@"重庆";
                    }
                    [mutableDictionary setObject:myDelegate.localNumber forKey:@"id"];
                    [mutableDictionary setObject:myDelegate.cityName forKey:@"title"];
                    [mutableDictionary setObject:myDelegate.localNumber forKey:@"pid"];

                    [local1Array addObject:mutableDictionary];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [cityCollectView reloadData];
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
-(void)selectTypeText:(UITapGestureRecognizer *)gesture{
    CustomLabel *itemLabel=(CustomLabel *)gesture.view;
    NSLog(@"selectTypeText%@",itemLabel.text);
    NSDictionary *dic=[typeArray objectAtIndex:itemLabel.superID] ;
    NSNumber *superId=[dic objectForKey:@"id"];
    NSArray *lesson=[dic objectForKey:@"lesson_group"];
    NSDictionary *data=[lesson objectAtIndex:itemLabel.subID];
    NSNumber *subId=[data objectForKey:@"id"];
    selectPid=subId;
    selectCid=superId;
    for(CustomLabel *label in typeAllArray){
        if(label.superID == itemLabel.superID && label.subID  == itemLabel.subID){
            [label setTextColor:[UIColor redColor]];
        }else{
            [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        }
    }
    for(UILabel *lb in moreBtnArray){
        [lb setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    }
    
    
}
-(void)getData{
    //   [ProgressHUD show:@"加载中..."];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
    NSNumber *Aid= myDelegate.localNumber;
    if(Aid==NULL){
        Aid=[fomaterr numberFromString:DEFAULT_LOCAL_AID];
    }
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
    if (projectID!=0 && projectID!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper getLessonList:projectID withPid:projectSubID withAID:Aid withlng:ngg withlat:ar withnums:[NSNumber numberWithInt:2] withPn:[NSNumber numberWithInt:pageNumb] withPageLine:[NSNumber numberWithInt:20]  success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        NSDictionary *result=model.result;
                        
                        NSArray *dataArray=[result objectForKey:@"lesson"];
                        if([dataArray count]>0){
                            _isNoData=NO;
                            if(_isHeader){
                                tableArray =[dataArray mutableCopy];
                            }else{
                                [tableArray addObjectsFromArray:dataArray];
                            }
                            [projectTableView reloadData];
                        }else{
                            if(!_isNoData){
                                if (alertView==nil) {
                                    alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    alertView.delegate=self;
                                }
                                [alertView setMessage:@"没有更多的课程了"];
                                [alertView show];
                                _isNoData=YES;
                            }
                        }
                        
                        
                    }else{
                        
                    }
                    
                    _isLoading=NO;
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
    if (titleName) {
        [searchLabel setText:[titleName stringByAppendingString:@"课程"]];
    }
    if (tableArray!=nil &&[tableArray count]>0) {
        [projectTableView reloadData];
    }
    if(searchs){
        [searchLabel setText:[NSString stringWithFormat:@"搜索%@结果",searchs]];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper searchProject:searchs withPageNumber:[NSNumber numberWithInt:pageNumb] withPageLine:[NSNumber numberWithInt:20]  withlgn:ngg withlat:ar withstatus:[NSNumber numberWithInt:2]  success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        NSDictionary *result=model.result;
                        
                        NSArray *dataArray=[result objectForKey:@"lesson"];
                        if([dataArray count]>0){
                            _isNoData=NO;
                            if(_isHeader){
                                tableArray =[dataArray mutableCopy];
                            }else{
                                [tableArray addObjectsFromArray:dataArray];
                            }
                            [projectTableView reloadData];
                        }else{
                            if(!_isNoData){
                                if (alertView==nil) {
                                    alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    alertView.delegate=self;
                                }
                                [alertView setMessage:@"没有更多的课程了"];
                                [alertView show];
                                _isNoData=YES;
                            }
                        }
                        
                        
                    }else{
                        
                    }
                    _isLoading=NO;
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
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setHotModel:(NSString *)sqlString{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
    NSNumber *Aid= myDelegate.localNumber;
    if(Aid==NULL){
        Aid=[fomaterr numberFromString:DEFAULT_LOCAL_AID];
    }
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper searchData:Aid withData:sqlString withlgn:ngg withlat:ar success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    tableArray=(NSMutableArray *)[result objectForKey:@"lesson"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
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
-(void)getLessonSift{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *lat=[NSNumber numberWithDouble:myDelegate.latitude];
    NSNumber *lng=[NSNumber numberWithDouble:myDelegate.longitude];
    if ([lat isEqualToNumber:[NSNumber numberWithDouble:0]]) {
        lat=[NSNumber numberWithDouble:29.5];
        lng=[NSNumber numberWithDouble:106.5];
    }
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    
    if((selectCid==NULL && selectPid==NULL) && selectGid==NULL && selectAid==NULL){
        [alertView setMessage:@"请选择至少选择一个筛选条件!"];
        [alertView show];
        [HUD dismiss];
        return;
    }
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    if((selectCid!=NULL)){
        [dataArray addObject:@{ @"name": @"cid", @"value": selectCid}];
    }
    if(selectPid!=NULL){
        [dataArray addObject:@{ @"name": @"pid", @"value": selectPid}];
    }
    if(selectGid!=NULL){
        [dataArray addObject:@{ @"name": @"gid", @"value": selectGid}];
    }
    if(selectAid!=NULL){
        [dataArray addObject:@{ @"name": @"aid", @"value": selectAid}];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper searchData:dataArray withPc:[NSNumber numberWithInt:20] withPn:[NSNumber numberWithInt:pageNumb] withlgn:lng withlat:lat withstatus:[NSNumber numberWithInt:2] success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    NSDictionary *result=model.result;
                    
                    NSArray *dataArray=[result objectForKey:@"lesson"];
                    if([dataArray count]>0){
                        _isNoData=NO;
                        if(_isHeader){
                            tableArray =[dataArray mutableCopy];
                        }else{
                            [tableArray addObjectsFromArray:dataArray];
                        }
                    }else{
                        if(!_isFooter){
                            tableArray =[dataArray mutableCopy];
                        }else{
                            [tableArray addObjectsFromArray:dataArray];
                        }
                        
                        if(!_isNoData){
                            
                            if (alertView==nil) {
                                alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alertView.delegate=self;
                            }
                            [alertView setMessage:@"没有更多的课程了"];
                            [alertView show];
                            _isNoData=YES;
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
                    });
                    
                    
                }else{
                    
                }
                
                [HUD dismiss];
                [refreshFooter endRefreshing];
                [refreshHeader endRefreshing];
                _isLoading=NO;
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                
            }
            [HUD dismiss];
            
        }];
        
        
    });
    
}
#pragma mark
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag==0){
        return [local1Array count];
    }else {
        return [gradeArray count];
    }
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"collectionView.tag%ld",(long)collectionView.tag);
    UICollectionViewCell * cell;
    NSDictionary *dic;
    if (collectionView.tag==0) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        dic=[local1Array objectAtIndex:[indexPath row]];
        NSLog(@"local1Array count%ld", [local1Array count]);
    }else if(collectionView.tag==1){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid2" forIndexPath:indexPath];
        dic=[gradeArray objectAtIndex:[indexPath row]];
        NSLog(@"gradeArray count%ld", [gradeArray count]);
    }
    [cell setBackgroundColor:[UIColor colorWithRed:234.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
    [cell.layer setCornerRadius:5];
    CGRect frame=cell.frame;
    frame.origin.x=0;
    frame.origin.y=0;
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    [label setText:[dic objectForKey:@"title"]];
    [label setTag:[indexPath row]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/35.5]];
    if (collectionView.tag==0) {
        [cityAllArray addObject:label];
    }else if(collectionView.tag==1){
        [gradeAllArray addObject:label];
    }
    [cell addSubview:label];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"collectionView.tag%ld",(long)collectionView.tag);
    switch (collectionView.tag) {
        case 0:
        {
            NSDictionary *dic=[local1Array objectAtIndex:[indexPath row]];
            NSNumber *selectId=[dic objectForKey:@"id"];
            NSLog(@"[dic objectForKey:title%@", [dic objectForKey:@"title"]);
            selectAid=selectId;
            pageNumb=1;
            [localLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
            for (UILabel *label in cityAllArray) {
                if(label.tag==[indexPath row]){
                    [label setTextColor:[UIColor redColor]];
                }else{
                    [label setTextColor:[UIColor blackColor]];
                    
                }
            }
        }
            break;
        case 1:
        {
            NSDictionary *dic=[gradeArray objectAtIndex:[indexPath row]];
            NSNumber *selectId=[dic objectForKey:@"id"];
            selectGid=selectId;
            pageNumb=1;
            for (UILabel *label in gradeAllArray) {
                if(label.tag==[indexPath row]){
                    [label setTextColor:[UIColor redColor]];
                }else{
                    [label setTextColor:[UIColor blackColor]];
                    
                }
            }
            
        }
            break;
        default:
            break;
    }
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 10;
}
-(void)goAllPorjectListViewController:(UITapGestureRecognizer *)gestrue{
    NSLog(@"goAllPorjectListViewController");
    UILabel *selectlabel=(UILabel *)gestrue.view;
    int tag=(int)selectlabel.tag;
    NSDictionary *dic=[typeArray objectAtIndex:tag] ;
    selectCid=[dic objectForKey:@"id"];
    selectPid=NULL;
    [selectlabel setTextColor:[UIColor redColor]];
    for(UILabel *lb in moreBtnArray){
        int ta=(int)lb.tag;
        if(ta!=tag){
            [lb setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        }
    }
    for (UILabel *label in typeAllArray) {
        [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    }
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    if (!_isLoading && uiScrollView.tag==0) { // 判断是否处于刷新状态，刷新中就不执行
        float height = uiScrollView.contentSize.height > projectTableView.frame.size.height?projectTableView.frame.size.height : uiScrollView.contentSize.height;
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.18) {
            HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            HUD.textLabel.text = @"加载中...";
            [HUD showInView:self.view];
            NSLog(@"上拉加载");
            _isFooter=true;
            _isHeader=false;
            pageNumb++;
            _isLoading=true;
            if(std==2){
                if(isSift)
                {
                    [self getLessonSift];
                }else{
                    
                    [self searchData];
                }
            }else{
                [self getData];
            }
            
        }
        if (- uiScrollView.contentOffset.y / projectTableView.frame.size.height > 0.2) {
            //            HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            //            HUD.textLabel.text = @"加载中...";
            //            [HUD showInView:self.view];
            //            _isHeader=true;
            //            _isFooter=false;
            //            _isLoading=true;
            //            pageNumb=1;
            //            if(std==2){
            //                if(isSift)
            //                {
            //                    [self getLessonSift];
            //                }else{
            //
            //                    [self searchData];
            //                }
            //            }else{
            //                [self getData];
            //            }
        }
        
    }
    
    
}

@end