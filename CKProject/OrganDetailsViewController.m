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
@interface OrganDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSArray *tableArray;
    NSString *phone;
    NSDictionary *data1;
    UILabel *phoneLabel;
    NSArray *aiy;
    

}

@end

@implementation OrganDetailsViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize projectTableView;
@synthesize aritcleId;

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
//    NSString *se=[NSString stringWithFormat:@"%@",aritcleId];
//    UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"查询" message:se delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"1", nil];
//    [alt show];
//    NSUserDefaults *stb=[NSUserDefaults standardUserDefaults];
//    [stb setObject:aritcleId forKey:@"kbt"];
   
    
    
    
    
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
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *backView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [backView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:backView];
    
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;
    ///
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"机构详情"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/22, self.view.frame.size.width/20)];
    [msgLabel addSubview:shareView];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    // [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}
-(void)initContent{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+0.5+20, width, hegiht-20)];
    scrollView.contentSize=CGSizeMake(width, hegiht*1.4);
    [scrollView setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width/2.5)];
    [view setUserInteractionEnabled:YES];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(width/23, width/23, width/3, width/3)];
    [logoImage setImage:[UIImage imageNamed:@"instdetails_defalut"]];
    [view addSubview:logoImage];
    
    
    organNamelabel=[[UILabel alloc]initWithFrame:CGRectMake(width/3+width/23+width/23, width/16, width-(width/3+width/23+width/23), width/23)];
    [organNamelabel setText:@"汉昌UI培训机构"];
    [view addSubview:organNamelabel];
    
    UILabel *bespeakLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/3+width/23+width/23, width/16+width/23+width/45.7, width/15, width/32)];
    [bespeakLabel setText:@"预约"];
    [bespeakLabel setFont:[UIFont systemFontOfSize:width/32]];
    [bespeakLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [view addSubview:bespeakLabel];
    
    numbLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/15+width/60+width/3+width/23+width/23, width/16+width/23+width/45.7, width/20, width/32)];
    [numbLabel setText:@"15"];
    [numbLabel setFont:[UIFont systemFontOfSize:width/32]];
    [numbLabel setTextColor:[UIColor redColor]];
    [view addSubview:numbLabel];
    
    
    ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(width/15+width/60+width/3+width/23+width/23+width/20, width/16+width/23+width/45.7-width/320, width/29*6, width/20)];
    ratingBar.isIndicator=YES;
    [ratingBar setImageDeselected:@"star_unselect" halfSelected:nil fullSelected:@"star_select" andDelegate:nil];
    [ratingBar displayRating:4.0f];
    [view addSubview:ratingBar];
    
    
    
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_logo"]];
    [localImageView setFrame:CGRectMake(width/3+width/23+width/23, width/16+width/23+width/45.7+width/32+width/11, width/35.5, width/29)];
    [localImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *addresGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAddress)];
    [localImageView addGestureRecognizer:addresGesture];
    
    [view addSubview:localImageView];
    
    projectAddLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/3+width/23+width/23+width/35.5+width/40, width/16+width/23+width/45.7+width/32+width/11.6, width-(width/3+width/23+width/23+width/35.5+width/40)-width/40, width/10)];
    [projectAddLabel setText:@"渝中区牛角沱太平洋广场3楼"];
    projectAddLabel.numberOfLines=0;
    [projectAddLabel setUserInteractionEnabled:YES];
    [projectAddLabel addGestureRecognizer:addresGesture];
    [projectAddLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [projectAddLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [view addSubview:projectAddLabel];
    
//    UIImageView *phoneImagView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_logo"]];
//    [phoneImagView setFrame:CGRectMake(localImageView.frame.origin.x, localImageView.frame.size.height+localImageView.frame.origin.y+width/32, width/22, width/17)];
//    UITapGestureRecognizer *callGesuture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
//    [phoneImagView setUserInteractionEnabled:YES];
//    [phoneImagView addGestureRecognizer:callGesuture];
//    [view addSubview:phoneImagView];
    
    
    //    phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(projectAddLabel.frame.origin.x, projectAddLabel.frame.size.height+projectAddLabel.frame.origin.y+width/25.6, width-(projectAddLabel.frame.origin.x)-width/40, width/26.7)];
    //    [phoneLabel setText:@"联系电话：023-9523123"];
    //    [phoneLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    //    [phoneLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    //    [phoneLabel setUserInteractionEnabled:YES];
    //    [phoneLabel addGestureRecognizer:callGesuture];
    //    [view addSubview:phoneLabel];
    
    
    [scrollView addSubview:view];
    
    
    
    
    
    UIView *whiteLineview=[[UIView alloc]initWithFrame:CGRectMake(0, width/2.5+width/46, width, width/23*2)];
    [whiteLineview setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *proLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23, width/46, width/2, width/46)];
    [proLabel setText:@"体验课"];
    [proLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [proLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    [whiteLineview addSubview:proLabel];

    UIImageView *goImage=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/21.3-width/53.3, width/46, width/53.3, width/26.7)];
    [goImage setImage:[UIImage imageNamed:@"go_logo"]];
    [goImage setUserInteractionEnabled:YES];
    [whiteLineview addSubview:goImage];
    
    UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(goImage.frame.origin.x-goImage.frame.size.width-width/26.7*2, width/46, width/26.7*2, width/26.7)];
    [moreLabel setText:@"全部"];
    [moreLabel setUserInteractionEnabled:YES];
    [moreLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [moreLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    [whiteLineview addSubview:moreLabel];
    UITapGestureRecognizer *allProjectGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllPorjectList)];
    [goImage addGestureRecognizer:allProjectGesture];
    [moreLabel addGestureRecognizer:allProjectGesture];
    
    
    [scrollView addSubview:whiteLineview];
    
    
    [self initTableView:scrollView];
    
    UIView *whiteLine2view=[[UIView alloc]initWithFrame:CGRectMake(0, projectTableView.frame.origin.y+projectTableView.frame.size.height, width,hegiht-20-(projectTableView.frame.origin.y+projectTableView.frame.size.height+width/23))];
    [whiteLine2view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *companyLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23, width/23, width, width/23)];
    [companyLabel setText:@"公司简介"];
    [companyLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [companyLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    
    [whiteLine2view addSubview:companyLabel];
    
    contentLabel=[[UITextView alloc]init];
    contentLabel.frame=CGRectMake(0, width/23+width/23+width/23, self.view.frame.size.width, self.view.frame.size.height);
    
    //    WithFrame:CGRectMake(width/23, width/23+width/23+width/23, self.view.frame.size.width, self.view.frame.size.height)
    //    //修复简介键盘弹出来
     contentLabel.editable=NO;
    
    [whiteLine2view addSubview:contentLabel];
    
    
    
    
    [scrollView addSubview:whiteLine2view];
    [self.view addSubview:scrollView];
    
}
-(void)initTableView:(UIView *)view{
    int width=self.view.frame.size.width;
    
    bottomHeight=49;
    
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  width/2.5+width/23+width/23,
                                                                  self.view.frame.size.width,
                                                                  (width/16+width/53+width/23+width/32+width/53+width/22+width/46)*2)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    [view addSubview:projectTableView];
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
    ProjectSimpleTableCell *cell=[[ProjectSimpleTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //[cell setSelectionStyle:UITableViewCellStyleDefault];
    [cell setViewController:self];
    if (cell ==nil) {
        cell  = [[ProjectSimpleTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([tableArray count]>0) {
        NSDictionary *dic=[tableArray objectAtIndex:[indexPath row]];
        
        
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [cell.projectName setText:title];
        }
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSNumber *people=[dic objectForKey:@"people"];
            NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
            [cell.haveSomeOneLabel setText:[NSString stringWithFormat:@"已报%@人",[formatter stringFromNumber:people]]];
        }
        
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
        }
        
        //        if ([dic objectForKey:@"lng"] && ![[dic objectForKey:@"lng"] isEqual:[NSNull null]] &&
        //            [dic objectForKey:@"lat"] && ![[dic objectForKey:@"lat"] isEqual:[NSNull null]]) {
        //            NSNumber *lng=[dic objectForKey:@"lng"];
        //            NSNumber *lat=[dic objectForKey:@"lat"];
        //            //NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        //            [cell.listItem.typelabel3 setText:@"<500m"];
        //        }
        
        if ([dic objectForKey:@"instsort"] && ![[dic objectForKey:@"instsort"] isEqual:[NSNull null]]) {
            NSString *addr=[dic objectForKey:@"instsort"];
            [cell.addressLabel setText:[NSString stringWithFormat:@"%@",addr]];
        }
//        if ([dic objectForKey:@"pname"] && ![[dic objectForKey:@"pname"] isEqual:[NSNull null]]) {
//            NSString *pname=[dic objectForKey:@"pname"];
//            [cell.typelabel setText:[NSString stringWithFormat:@"%@",pname]];
//        }
        if ([dic objectForKey:@"grade"] && ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
            NSString *grade=[dic objectForKey:@"grade"];
            [cell.typelabel1 setText:[NSString stringWithFormat:@"%@",grade]];
        }
        int mon=[[dic objectForKey:@"price"]intValue];
        if (mon==0) {
            cell.typelabel3.text=@"免费课";
        }
        else
        {
        cell.typelabel3.text=[NSString stringWithFormat:@"¥ %i",mon];
            cell.typelabel3.textColor=[UIColor orangeColor];
        }
            
//        if ([dic objectForKey:@"btime"] && ![[dic objectForKey:@"btime"] isEqual:[NSNull null]]) {
//            NSNumber *btime=[dic objectForKey:@"btime"];
//            NSInteger myInteger = [btime integerValue];
//            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateStyle:NSDateFormatterMediumStyle];
//            [formatter setTimeStyle:NSDateFormatterShortStyle];
//            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//            [formatter setTimeZone:timeZone];
//            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
//            CGRect frame=cell.typelabel2.frame;
//            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//            NSString *str=[self compareCurrentTime:confromTimespStr];
//            frame.origin.x=frame.origin.x+frame.size.width-[str length]*frame.size.height;
//            frame.size.width=[str length]*frame.size.height;
//            [cell.typelabel2 setFrame:frame];
//            [cell.typelabel2 setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
//        }
        
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
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
    [projectTableView setFrame:CGRectMake(projectTableView.frame.origin.x, projectTableView.frame.origin.y, projectTableView.frame.size.width, cell.frame.size.height*2)];
    
    
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
                        NSDictionary *dic=model.result;
                        data1=dic;
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
                            [contentLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
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