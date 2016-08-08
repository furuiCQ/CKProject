
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

@interface ProjectListViewController ()<UITableViewDataSource,UITableViewDelegate,ECDrawerLayoutDelegate,TreeTableCellDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
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
    UICollectionView * cityCollectView;
    UICollectionView * gradCollectView;
    
    int pageNumb;
    BOOL _isLoading;
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    if (tableArray==nil) {
        tableArray = [[NSMutableArray alloc]init];
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
    pageNumb=1;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    localLat=myDelegate.latitude;
    localLng=myDelegate.longitude;
    
    addressString=@"";
    selectCity1String=@"";
    selectCity2String=@"";
    selectCity3String=@"";
    
    [self initTitle];
    [self initSelectView];
    //shuju，
    [self initTableView];
    if (std==1) {
        [self tit];
    }
    if (std==2) {
        [self searchData];
    }else{
        [self getData];
    }
}

-(void)tit
{
    [ProgressHUD show:@"加载中..."];
    
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
        [ProgressHUD dismiss];
    }];
}
-(void)searchData
{
    [ProgressHUD show:@"加载中..."];
    
    NSUserDefaults *src=[NSUserDefaults standardUserDefaults];
    NSString *bt1=[src objectForKey:@"kp"];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?date=%@&lng=%f&lat=%f&status=2&pn=%d&pc=10",bt1,
                   myDelegate.longitude,myDelegate.latitude,pageNumb];
   // http://211.149.190.90/api/searchs?date=2016-08-07&lng=106.674072&lat=29.510639&status=2&pn=1&pc=10
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *db=[obj objectForKey:@"result"];
        NSArray *dataArray=[db objectForKey:@"lesson"];
        [tableArray addObjectsFromArray:dataArray];
        
        NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",tableArray);
        [projectTableView reloadData];
        [refreshFooter endRefreshing];
        _isLoading=NO;
        [ProgressHUD dismiss];
        
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
                                                               view.frame.size.height-(topView.frame.size.height+topView.frame.origin.y))];
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
                                                                        view.frame.size.height-(topView.frame.size.height+topView.frame.origin.y)) collectionViewLayout:layout];
    //代理设置
    cityCollectView.delegate=self;
    cityCollectView.dataSource=self;
    [cityCollectView setTag:0];
    //注册item类型 这里使用系统的类型
    [cityCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [cityCollectView setHidden:YES];
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
                                                                        view.frame.size.height-(topView.frame.size.height+topView.frame.origin.y)) collectionViewLayout:layout2];
    //代理设置
    gradCollectView.delegate=self;
    gradCollectView.dataSource=self;
    [gradCollectView setTag:1];
    //注册item类型 这里使用系统的类型
    [gradCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid2"];
    [gradCollectView setHidden:YES];
    [view addSubview:gradCollectView];
    
    
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
    [self getAllGrade];
    [self getAllCity];
    
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
    projectTableView.separatorStyle=NO;
    [self.view addSubview:projectTableView];
    //添加刷新
    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor grayColor]];
    
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [projectTableView addSubview:_refreshControl];
    
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=projectTableView;
    [refreshFooter footer];
    refreshFooter.beginRefreshingBlock=^(){
    };
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
    NSLog(@"tableView.tag %ld",(long)tableView.tag);
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
                        
                        // [gradeTableView reloadData];
                        [gradCollectView reloadData];
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
                        
                        // [addTableView reloadData];
                        [cityCollectView reloadData];
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
    [ProgressHUD show:@"加载中..."];
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
        ar=[NSNumber numberWithDouble:localLat];
        ngg=[NSNumber numberWithDouble:localLng];
    }
    if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
        ar=[NSNumber numberWithDouble:29.5];
        ngg=[NSNumber numberWithDouble:106.5];
    }
    if (projectID!=0 && projectID!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper getLessonList:projectID withPid:projectSubID withAID:Aid withlng:ngg withlat:ar withnums:[NSNumber numberWithInt:2]  success:^(HttpModel *model){
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
    [ProgressHUD dismiss];
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
                    
                    tableArray=(NSMutableArray *)[result objectForKey:@"lesson"];
                    
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
    NSLog(@"collectionView.tag%ld",(long)collectionView.tag);
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
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:self.view.frame.size.width/35.5]];
    [cell addSubview:label];
    return cell;
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 10;
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
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.2) {
            
            // 调用上拉刷新方法
            [refreshFooter beginRefreshing];
            NSLog(@"上拉加载");
            pageNumb++;
            _isLoading=true;
            if(std==2){
                [self searchData];
            }
            
        }
        if (- uiScrollView.contentOffset.y / projectTableView.frame.size.height > 0.2) {
            
            // 调用下拉刷新方法
            NSLog(@"刷新");
            [refreshHeader beginRefreshing];
            _isLoading=true;
        }
        
    }
    
    
}

@end