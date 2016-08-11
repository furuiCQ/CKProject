//
//  ViewController.m
//  XMTopScrollView
//
//  Created by rgshio on 15/12/21.
//  Copyright © 2015年 rgshio. All rights reserved.
//

#import "ViewController.h"
#import "okCell.h"
#import "ProgressHUD.h"
#import "modetailViewController.h"
#import "xindetailViewController.h"
#import "HttpHelper.h"
#import "HttpModel.h"
#define swidth self.view.frame.size.width
#define sheight self.view.frame.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *vi;
    NSMutableArray *ary;
    NSMutableArray *ary1;
    CGFloat titleHeight;
    UILabel *cityLabel;
    UILabel *searchLabel;
    UILabel *msgLabel;
    UIScrollView *sc;
    UIView *titleView;
    UITableView *tab;
    NSArray *selectArray;
    //    UIButton *btn;
    
    NSMutableDictionary *duc;
    UINib *nib;

    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"加载中..."];
    [self initTitle];
    [self getsj];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleArray = [[NSMutableArray alloc] initWithArray:@[@"热门",@"早期教育",@"幼儿教育",@"小学教育",@"初高中教育",@"成人教育"]];
    
    _topView = [[XMTopScrollView alloc] initWithFrame:CGRectMake(0, titleHeight+20, self.view.frame.size.width, titleHeight)];
    _topView.delegate = self;
    _topView.cellCount = 4;
    _topView.showType = XMTopItemShowTypeCenter;
    _topView.separatorHidden = NO;
    _topView.textSelectedtColor = [UIColor redColor];
    [_topView reloadViewWith:_titleArray];
    [self.view addSubview:_topView];
    
    vi=[[UITableView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height+_topView.frame.origin.y+5, swidth, sheight/1.2)];
    vi.delegate=self;
    vi.dataSource=self;
    vi.separatorStyle=UITableViewCellSeparatorStyleNone;
    [vi registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:vi];
    
    UIImageView *goTopView=[[UIImageView alloc]initWithFrame:CGRectMake(swidth-swidth/8.5-swidth/40, sheight*3/4, swidth/8.5, swidth/8.5)];
    [goTopView setImage:[UIImage imageNamed:@"totop_image"]];
    UITapGestureRecognizer *goTopGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goTop)];
    [goTopView setUserInteractionEnabled:YES];
    [goTopView addGestureRecognizer:goTopGestureRecognizer];
    [self.view addSubview:goTopView];
    [self hidBack];
}
-(void)goTop{
    [vi setContentOffset:CGPointMake(0,0) animated:YES];
}
- (void)selectClickAction:(NSInteger)index {
    switch (index) {
        case 0:
            ary=[duc objectForKey:@"1"];
            break;
        case 1:
            ary=[duc objectForKey:@"2"];
            break;
        case 2:
            ary=[duc objectForKey:@"3"];
            break;
        case 3:
            ary=[duc objectForKey:@"4"];
            break;
        case 4:
            ary=[duc objectForKey:@"5"];
            break;
        default:
            ary=[duc objectForKey:@"6"];
            break;
    }
    [vi reloadData];
    
    
}
-(void)getsj{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getliebiao:self
                       success:^(HttpModel *model){
                           
                           NSLog(@"%@",model.result);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                   duc=[model.result copy] ;
                                   ary=[duc objectForKey:@"1"];
                                   [vi reloadData];
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


-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *backView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [backView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:backView];
    
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"新闻头条"];
    
    
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)hidBack{
    [cityLabel setHidden:YES];
}
-(void)showBack{
    [cityLabel setHidden:NO];
}
-(void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (vi.tag) {
        case 0:
            ary=[duc objectForKey:@"1"];
            break;
        case 1:
            ary=[duc objectForKey:@"2"];
            break;
        case 2:
            ary=[duc objectForKey:@"3"];
            break;
        case 3:
            ary=[duc objectForKey:@"4"];
            break;
        case 4:
            ary=[duc objectForKey:@"5"];
            break;
        default:
            ary=[duc objectForKey:@"6"];
            break;
    }
    return ary.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identy = @"okCell";
    okCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"okCell"owner:self options:nil]lastObject];
    }
    NSDictionary *bic=[ary objectAtIndex:indexPath.row];
    NSUserDefaults *kp=[NSUserDefaults standardUserDefaults];
    [kp setObject:[bic objectForKey:@"content"] forKey:@"cpn"];
    cell.titles.text=[bic objectForKey:@"title"];
    //    cell.details.text=[bic objectForKey:@"stitle"];
    cell.writers.text=[bic objectForKey:@"author"];
    cell.nums.text=[NSString stringWithFormat:@"%i",[[bic objectForKey:@"read"]intValue]]  ;
    NSNumber *btime=[bic objectForKey:@"created"];
    NSString *str1=[NSString stringWithFormat:@"http://211.149.190.90%@",[bic objectForKey:@"img"]];
    cell.im.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]]];
    NSInteger myInteger = [btime integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd hh:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
    NSString *str = [formatter stringFromDate:confromTimesp];
    // 修改
    NSString *sdt=[NSString stringWithFormat:@"%@",str];
    cell.times.text=sdt;
    
    // Configure the cell...
    [ProgressHUD dismiss];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //    modetailViewController *detailsViewController=[[modetailViewController alloc]init];
    //    NSDictionary *dic=[ary objectAtIndex:indexPath.row];
    //    NSNumber *aritcleId=[dic objectForKey:@"id"];
    //    [detailsViewController setAritcleId:aritcleId];
    //    [self presentViewController:detailsViewController animated:YES completion:nil];
    xindetailViewController  *bt=[[xindetailViewController alloc]init];
    NSDictionary *dic=[ary objectAtIndex:indexPath.row];
    NSNumber *aritcleId=[dic objectForKey:@"id"];
    [bt setAritcleId:aritcleId];
    [bt setData:dic];
    [self presentViewController:bt animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
