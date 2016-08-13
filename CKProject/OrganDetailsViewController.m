//
//  OrganDetailsViewController.m
//  CKProject
//
//  Created by furui on 15/12/18.
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


#import "OrganDetailsViewController.h"
#import "HttpHelper.h"
#import "ProjectTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MapKit/MapKit.h>
#import "ProjectListViewController.h"
#import "JZLocationConverter.h"
#import "TopBar.h"
#import "RJUtil.h"
#import "OrderRecordCell.h"
@interface OrganDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSArray *tableArray;
    NSString *phone;
    NSDictionary *data1;
    UILabel *phoneLabel;
    NSArray *aiy;
    
    UIView *tableHeaderView;
    UIView *headerView;
    NSMutableArray *projectTableArray;
    
    CLLocationManager *locationManager;
    CLLocation *neloct;
    NSString *lt;
    NSString *lg;
    UINib *nib;
    UILabel *distanceLabel;
    UITextView *detailContentLabel;
    
}
@property (nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation OrganDetailsViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize projectTableView;
@synthesize aritcleId;
@synthesize imageScrollview;
@synthesize pageControl;
@synthesize timer;
@synthesize totalCount;
@synthesize  logoImage;
@synthesize  organNamelabel;
@synthesize  numbLabel;
@synthesize  ratingBar;
@synthesize  projectAddLabel;
@synthesize  contentLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    data1=[[NSDictionary alloc]init];
    tableArray = [[NSArray alloc]init];
    
    [ProgressHUD show:@"加载中..."];
    
//    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    localLat=myDelegate.latitude;
//    localLng=myDelegate.longitude;
    
    
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
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [self getsavetab];
    [self initTitle];
    [self initContent];
    
    [self getOrgInfo];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}




-(void)getsavetab
{
    
    //   http://211.149.190.90/api/instinfo?id=6
    //    NSString *sp=[NSString stringWithFormat:@"%@",num];
    //    UIAlertView *vi=[[UIAlertView alloc]initWithTitle:@"提示" message:sp delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"123", nil];
    //    [vi show ];
    
    //    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/searchs?instid=%@",aritcleId];
    //    NSURL *url=[NSURL URLWithString:str];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //
    //        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSDictionary *db=[obj objectForKey:@"result"];
    //        aiy=[db objectForKey:@"lesson"];
    //        NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
    //        [defa setObject:aiy forKey:@"kay"];
    //        NSLog(@"----------------\n\n\n\n\n\n\n\\n\n\n\n%@",aiy);
    //
    //    }];
    
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
    [searchLabel setText:@"机构详情"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;///
    //        UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    //        [msgLabel addGestureRecognizer:shareGesutre];
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
    tableHeaderView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+20, width, hegiht-20)];
    [tableHeaderView setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    
    UIControl *instituteControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, width, width/3)];
    UIImageView *instiBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width/3)];
    [instiBg setImage:[UIImage imageNamed:@"orgin_bg"]];
    [instituteControl addSubview:instiBg];

    
    
    logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(width/30, width/22, width/5, width/5)];
    [logoImage setImage:[UIImage imageNamed:@"instdetails_defalut"]];
    logoImage.layer.cornerRadius=width/64;
    logoImage.layer.masksToBounds=YES;
    [instituteControl addSubview:logoImage];
    
    organNamelabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.size.width+logoImage.frame.origin.x+width/27.8, logoImage.frame.origin.y, width-(logoImage.frame.size.width+logoImage.frame.origin.x+width/27.8), width/21.3)];
    [organNamelabel setText:@"新东方英语培训中心"];
    [organNamelabel setFont:[UIFont systemFontOfSize:width/21.3]];
    [organNamelabel setTextColor:[UIColor blackColor]];
    [instituteControl addSubview:organNamelabel];
    //18px
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Location"]];
    [localImageView setFrame:CGRectMake(organNamelabel.frame.origin.x, organNamelabel.frame.size.height+organNamelabel.frame.origin.y+width/35.6, width/35.6, width/23.7)];
    UITapGestureRecognizer *addresGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAddress)];
    [localImageView addGestureRecognizer:addresGesture];
    [localImageView setUserInteractionEnabled:YES];
    [instituteControl addSubview:localImageView];
    
    
    projectAddLabel=[[UILabel alloc]initWithFrame:CGRectMake(localImageView.frame.size.width+localImageView.frame.origin.x+width/49,  organNamelabel.frame.size.height+organNamelabel.frame.origin.y+width/37.6, width-(localImageView.frame.size.width+localImageView.frame.origin.x+width/49)-width/40, width/22.8)];
    [projectAddLabel setText:@"渝中区太平洋大厦3楼"];
    [projectAddLabel addGestureRecognizer:addresGesture];
    [projectAddLabel setUserInteractionEnabled:YES];
    [projectAddLabel setTextColor:[UIColor colorWithRed:85.f/255.f green:85.f/255.f blue:85.f/255.f alpha:1.0]];
    [projectAddLabel setFont:[UIFont systemFontOfSize:width/22.8]];//28px
    [instituteControl addSubview:projectAddLabel];
    
    ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(organNamelabel.frame.origin.x, localImageView.frame.size.height+localImageView.frame.origin.y+width/35.6, width/29*6, width/20)];
    ratingBar.isIndicator=YES;
    [ratingBar setPadding:2];
    [ratingBar setImageDeselected:@"star_normal" halfSelected:nil fullSelected:@"star_light" andDelegate:nil];
    [ratingBar displayRating:4.0f];
    [instituteControl addSubview:ratingBar];
    
    distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/4-width/32,  ratingBar.frame.origin.y, width/4, width/20)];
    [distanceLabel setText:@"500 米"];
    [distanceLabel setFont:[UIFont systemFontOfSize:width/32]];
    [distanceLabel setTextAlignment:NSTextAlignmentRight];
    [distanceLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [instituteControl addSubview:distanceLabel];
    
    [self initImageScrollView:instituteControl];
    [tableHeaderView addSubview:instituteControl];

    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, imageScrollview.frame.origin.y+imageScrollview.frame.size.height+2, width, width/8.8)];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [tableHeaderView addSubview:headerView];
    [self initSwitchBtn:headerView];
    [self initOrginContentView:headerView];
    [self initTableView:headerView];
    [detailContentLabel setHidden:YES];

   // [self.view addSubview:tableHeaderView];
    
}
-(void)initSwitchBtn:(UIView *)superView{
    int width=self.view.frame.size.width;
    //    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, titleHeight*3/4)];
    //    [topView setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:topView];
    NSArray *array = [NSArray arrayWithObjects:@"体验课",@"机构简介", nil];
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
            [topBar setIconColor:[UIColor colorWithRed:1 green:93.f/255.f blue:93.f/255.f alpha:1.0]];
            [topBar setTextColor:[UIColor colorWithRed:1 green:93.f/255.f blue:93.f/255.f alpha:1.0]];
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
            [b setIconColor:[UIColor colorWithRed:1 green:93.f/255.f blue:93.f/255.f alpha:1.0]];
            [b setTextColor:[UIColor colorWithRed:1 green:93.f/255.f blue:93.f/255.f alpha:1.0]];
            
        }
    }
    if(topBar.tag==0){
        [detailContentLabel setHidden:YES];
        [tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.origin.y+headerView.frame.size.height)];
       // projectTableView

    }else{
        [detailContentLabel setHidden:NO];
        [tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, detailContentLabel.frame.origin.y+detailContentLabel.frame.size.height)];
        
    }
    projectTableView.tableHeaderView=tableHeaderView;

}
//轮播图片
-(void)initImageScrollView:(UIView *)topView{
    //    图片中数
    int width=self.view.frame.size.width;
    
    // totalCount = 1;
    
    imageScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,width/3.6, width, width/1.6)];
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
    [tableHeaderView addSubview:imageScrollview];
}
-(void)initOrginContentView:(UIView *)superView{
    int width=self.view.frame.size.width;

    detailContentLabel=[[UITextView alloc]initWithFrame:CGRectMake(0, superView.frame.size.height+superView.frame.origin.y, width, 20)];
    [detailContentLabel setText:@"惺惺惜惺惺"];
    detailContentLabel.editable=NO;
    [detailContentLabel setTextAlignment:NSTextAlignmentLeft];
    [detailContentLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
    [detailContentLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    detailContentLabel.backgroundColor=[UIColor whiteColor];
    [tableHeaderView addSubview:detailContentLabel];
    [detailContentLabel setHidden:YES];
    [tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.origin.y+headerView.frame.size.height)];
}
-(void)initTableView:(UIView *)view{
    int width=self.view.frame.size.width;
    
    bottomHeight=49;
    
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20,
                                                                  width,
                                                                  self.view.frame.size.height-(titleHeight+20))];
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    projectTableView.tableHeaderView=tableHeaderView;
    [self.view addSubview:projectTableView];
}
-(void)goAllPorjectList{
    //    NSLog(@"------------------artid:%@",art);
    
    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
    [defa setObject:aritcleId forKey:@"nid"];
    NSLog(@"数组元素为：%@",tableArray);
    //    [projectListViewController setHasData:aiy];
    [projectListViewController setTitleName:@"热门"];
    
    [projectListViewController setstd:1];
    [self presentViewController: projectListViewController animated:YES completion:nil];
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
    NSLog(@"数组个数：%li",tableArray.count);
    return [tableArray count];
    
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    //    ProjectSimpleTableCell *cell=[[ProjectSimpleTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //    //[cell setSelectionStyle:UITableViewCellStyleDefault];
    //    [cell setViewController:self];
    //    if (cell ==nil) {
    //        cell  = [[ProjectSimpleTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //    }
    static NSString *identy = @"CustomCell";
    OrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderRecordCell"owner:self options:nil]lastObject];
    }
    
    if ([tableArray count]>0) {
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSString *people=[dic objectForKey:@"people"];
            NSString *str=[NSString stringWithFormat:@"%@",people];
            [cell.orderNumbLabel setText:str];
        }
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            if (![logo isEqualToString:@""]) {
                [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }
        }
        if ([dic objectForKey:@"lng"] && ![[dic objectForKey:@"lng"] isEqual:[NSNull null]] &&
            [dic objectForKey:@"lat"] && ![[dic objectForKey:@"lat"] isEqual:[NSNull null]]) {
            NSNumber *lng=[dic objectForKey:@"lng"];
            NSNumber *lat=[dic objectForKey:@"lat"];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude=[lat floatValue];
            
            coordinate.longitude=[lng floatValue];
            
            CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToWgs84:coordinate];
            
            lg=[NSString stringWithFormat:@"%f",neloct.coordinate.longitude] ;
            lt=[NSString stringWithFormat:@"%f",neloct.coordinate.latitude] ;
//            NSString *longtitudeText=lg;
//            NSString *latitudeText=lt;;
            
//            CLLocationDegrees latitude=[latitudeText doubleValue];
//            CLLocationDegrees longitude=[longtitudeText doubleValue];
            
            double distance=[RJUtil LantitudeLongitudeDist:coords3.longitude other_Lat:coords3.latitude self_Lon:neloct.coordinate.longitude self_Lat:neloct.coordinate.latitude];
            if(distance>0.0){
                if (distance/1000>1) {
                    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
                }else if (distance/1000<1 && distance/1000>0.5){
                    [cell.distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                    
                }else if (distance/1000<0.5){
                    [cell.distanceLabel setText:@"<500m"];
                }
            }
            
        }
        
        
        if ([dic objectForKey:@"addr"] && ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]) {
           // NSString *addr=[dic objectForKey:@"addr"];
            //            CGRect frame=cell.listItem.addressLabel.frame;
            //            CGSize strSize=[addr sizeWithFont:cell.listItem.addressLabel.font maxSize:CGSizeMake(width, 0)];
            //            frame.origin.x=cell.listItem.joinLabel.frame.size.width+cell.listItem.joinLabel.frame.origin.x+width/40;
            //            frame.size.width=width/3;
            //            [cell.listItem.addressLabel setFrame:frame];
            // [cell.listItem.addressLabel setText:[NSString stringWithFormat:@"%@",addr]];
        }
        //        if ([dic objectForKey:@"pname"] && ![[dic objectForKey:@"pname"] isEqual:[NSNull null]]) {
        //            NSString *pname=[dic objectForKey:@"pname"];
        //            CGRect frame=cell.listItem.typelabel.frame;
        //            CGSize strSize=[pname sizeWithFont:cell.listItem.typelabel.font maxSize:CGSizeMake(width, 0)];
        //            frame.size.width= strSize.width+frame.size.height/2;
        //            [cell.listItem.typelabel setFrame:frame];
        ////            [cell.listItem.typelabel setText:[NSString stringWithFormat:@"%@",pname]];
        //        }
        if ([dic objectForKey:@"grade"] && ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
            NSString *grade=[dic objectForKey:@"grade"];
            [cell.ageLabel setText:[NSString stringWithFormat:@"%@",grade]];
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
            [cell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
        }
        
        
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
    NSDictionary *dic=[tableArray objectAtIndex:indexPath.row];
    NSNumber *projectId=[dic objectForKey:@"id"];
    [projectDetailsViewController setProjectId:projectId];
    [self presentViewController:projectDetailsViewController animated:YES completion:nil];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:projectTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}
//tabarray的值
-(void)getOrgInfo{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getInsetInfo:aritcleId success:^(HttpModel *model){
            NSLog(@"aritcled:--------%@",aritcleId);
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@",model.result);
                        NSDictionary *dic=model.result;
                        data1=dic;
                        tableArray=(NSArray *)[dic objectForKey:@"lesson"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [projectTableView reloadData];
                        });
                        if ([dic objectForKey:@"img"]&& ![[dic objectForKey:@"img"] isEqual:[NSNull null]]) {
                            [logoImage  sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[dic objectForKey:@"img"]]]];
                        }
                        if ([dic objectForKey:@"stitle"]&& ![[dic objectForKey:@"stitle"] isEqual:[NSNull null]]) {
                            [organNamelabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"stitle"]]];
                        }
                        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
                        
                        if([dic objectForKey:@"lv"]&& ![[dic objectForKey:@"lv"] isEqual:[NSNull null]]){
                            [ratingBar displayRating:[[dic objectForKey:@"lv"] floatValue]];
                        }
                        if([dic objectForKey:@"people"]&& ![[dic objectForKey:@"people"] isEqual:[NSNull null]]){
                            NSNumber *number=[dic objectForKey:@"people"];
                            [numbLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:number]]];
                        }
                        if([dic objectForKey:@"content"]&& ![[dic objectForKey:@"content"] isEqual:[NSNull null]]){
                            [detailContentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                            CGRect frame=detailContentLabel.frame;
                            frame.size.height=detailContentLabel.contentSize.height;
                            [detailContentLabel setFrame:frame];
                            detailContentLabel.scrollEnabled=NO;
                            [tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.origin.y+headerView.frame.size.height)];
                        }
                        if([dic objectForKey:@"addr"]&& ![[dic objectForKey:@"addr"] isEqual:[NSNull null]]){
                            [projectAddLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]]];
                        }
                        tableArray=(NSArray *)[dic objectForKey:@"lesson"];
                        [projectTableView reloadData];
                        if([dic objectForKey:@"tel"]&& ![[dic objectForKey:@"tel"] isEqual:[NSNull null]]){
                            phone=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
                            [phoneLabel setText:[NSString stringWithFormat:@"联系电话:%@",phone]];
                        }
                        if ([dic objectForKey:@"logo"]&& ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
                            NSString *images=[dic objectForKey:@"logo"];
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
                                    // UITapGestureRecognizer *openChorme=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
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
                                [tableHeaderView addSubview:pageControl];
                            }
                            
                            if ([dic objectForKey:@"lng"] && ![[dic objectForKey:@"lng"] isEqual:[NSNull null]] &&
                                [dic objectForKey:@"lat"] && ![[dic objectForKey:@"lat"] isEqual:[NSNull null]]) {
                                NSNumber *lng=[dic objectForKey:@"lng"];
                                NSNumber *lat=[dic objectForKey:@"lat"];
                                
                                CLLocationCoordinate2D coordinate;
                                coordinate.latitude=[lat floatValue];
                                
                                coordinate.longitude=[lng floatValue];
                                
                                CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToWgs84:coordinate];
                                
                                lg=[NSString stringWithFormat:@"%f",neloct.coordinate.longitude] ;
                                lt=[NSString stringWithFormat:@"%f",neloct.coordinate.latitude] ;
//                                NSString *longtitudeText=lg;
//                                NSString *latitudeText=lt;;
                                
//                                CLLocationDegrees latitude=[latitudeText doubleValue];
//                                CLLocationDegrees longitude=[longtitudeText doubleValue];
                                
                              //  CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
                                
                                double distance=[RJUtil LantitudeLongitudeDist:coords3.longitude other_Lat:coords3.latitude self_Lon:neloct.coordinate.longitude self_Lat:neloct.coordinate.latitude];
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

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onClick{
    NSLog(@"点击机构详情");
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
    
    coordinate.latitude=[[data1 objectForKey:@"lat"] floatValue];
    
    coordinate.longitude=[[data1 objectForKey:@"lng"] floatValue];
    
    
    
    
    
    CLLocationCoordinate2D coords2 = coordinate;
    CLLocationCoordinate2D coords3=[JZLocationConverter bd09ToGcj02:coords2];
    
    
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
        
        NSString *myname=[data1 objectForKey:@"addr"];
        
        
        toLocation.name =myname;
        
        
        
        
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        
        //打开苹果自身地图应用，并呈现特定的item
        
        [MKMapItem openMapsWithItems:items launchOptions:options];
        
    }
    
    
}
-(void)callPhone{
    if (phone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phone]]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end