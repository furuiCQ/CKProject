//
//  FavourableViewController.m
//  CKProject
//
//  Created by furui on 16/8/5.
//  Copyright © 2016年 furui. All rights reserved.
//
#import "HttpHelper.h"
#import "FavourableCell.h"
#import "CityViewController.h"
#import "AppDelegate.h"
#import "ProjectTimePicker.h"
@interface CityViewController()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataArray;
}
@end
@implementation CityViewController
@synthesize titleHeight;
@synthesize searchLabel;
@synthesize cityLabel;
@synthesize _tableView;
@synthesize nowCity;
- (id)init
{
    self = [super init];
    if (self) {
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"北京",@"重庆",@"成都",@"杭州",@"南京",@"武汉",@"厦门", nil];
        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(myDelegate.openCityArray){
            [self.arrayHotCity removeAllObjects];
            for(int i=0;i<[myDelegate.openCityArray count];i++){
                NSDictionary *dic=[myDelegate.openCityArray objectAtIndex:i];
                NSString *str=[dic objectForKey:@"cityname"];
                [self.arrayHotCity addObject:str];
            }
        }
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self initCustomNavItem];
    [self getCityData];
    [self initTitle];
    [self initContentView];
}


/**
 *自定义标题栏
 */
-(void)initCustomNavItem
{
    //自定义电池栏 可遮盖或不遮盖
    UIView *topView=[[UIView alloc]init];
    [topView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [topView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [self.view addSubview:topView];
    
}
#pragma mark - 获取城市数据
-(void)getCityData
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];

    strHot = @"当";
    [self.keys insertObject:strHot atIndex:0];
    if(!myDelegate.cityName){
        myDelegate.cityName=@"重庆";
    }
    [self.cities setObject:[NSMutableArray arrayWithObjects:myDelegate.cityName, nil]forKey:strHot];
        
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
    [searchLabel setText:@"城市选择"];
    [searchLabel setTextColor:[UIColor whiteColor]];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initContentView{
    titleHeight=44;
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,20+titleHeight, width, height-(20+titleHeight)) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _tableView.showsVerticalScrollIndicator=NO;
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 38.0;
}
//76
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int width=self.view.frame.size.width;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width/8.4)];
    bgView.backgroundColor = [UIColor colorWithRed:245.f/255.f green:246.f/255.f blue:247.f/255.f alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/20, 0, width-width/20, width/8.4)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:width/22.8];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"已开通城市";
    }else if ([key rangeOfString:@"当"].location != NSNotFound) {
        titleLabel.text = @"当前城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    cell.textLabel.text = [[_cities objectForKey:key]  objectAtIndex:indexPath.row];
    return cell;
}
static NSString * const DEFAULT_LOCAL_AID = @"500100";

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSString *cityString=[[_cities objectForKey:key]  objectAtIndex:indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSError *error = [[NSError alloc]init];
    NSString *_localData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSRange rang  = [_localData rangeOfString:cityString];
    NSLog(@"%@",NSStringFromRange(rang));
    if(rang.location>_localData.length){
        return;
    }
    NSString *str=[_localData substringWithRange:NSMakeRange(rang.location-10, rang.length+18)];
    NSArray *cityArray=[str componentsSeparatedByString:NSLocalizedString(@",", nil)];
    NSString *cityStr=[cityArray objectAtIndex:0];
    cityStr=[cityStr substringWithRange:NSMakeRange(1, cityStr.length-2)];
    NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
    NSNumber *_selectCityId=[formater numberFromString:cityStr];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSRange cqRange=[cityString rangeOfString:@"重庆"];
    if(cqRange.length>0){
        myDelegate.localNumber=[formater numberFromString:DEFAULT_LOCAL_AID];
    }
    myDelegate.localNumber=_selectCityId;
    myDelegate.cityName=cityString;
    NSNotification *notification =[NSNotification notificationWithName:@"changeCity" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end

