//
//  MationViewController.m
//  CKProject
//
//  Created by user on 16/6/16.
//  Copyright © 2016年 furui. All rights reserved.
//


#import "MationViewController.h"
#import "modetailViewController.h"
#import "okCell.h"
#import "InvitationDetailsViewController.h"
#define swidth self.view.frame.size.width
#define sheight self.view.frame.size.height
@interface MationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat titleHeight;
    UILabel *cityLabel;
    UILabel *searchLabel;
    UILabel *msgLabel;
    UIScrollView *sc;
    UIView *titleView;
    UITableView *tab;
    NSArray *selectArray;
//    UIButton *btn;
    NSMutableArray *ary;
    NSMutableDictionary *duc;

}
@end

@implementation MationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tab.scrollEnabled=NO;
    selectArray =[NSArray arrayWithObjects:@"早期教育",@"幼儿教育",@"小学教育",@"初高中教育",@"成人教育",nil];
    [self initTitle];
    [self getsj];
    [self initsc];
    //    tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
//    tab.backgroundColor=[UIColor clearColor];
//    tab.delegate=self;
//    tab.dataSource=self;
//    tab.tag=0;
//    [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
//    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
//    创建头部视图
    //初始化顶部菜单栏

    
//    创建滚动视图
    
//创建表格视图
    // Dispose of any resources that can be recreated.
}
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
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
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"新闻头条"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [msgLabel addGestureRecognizer:shareGesutre];
    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/12.3/2, titleHeight/2-self.view.frame.size.width/12.3/2, self.view.frame.size.width/12.3, self.view.frame.size.width/12.3)];
    [msgLabel addSubview:shareView];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}

-(void)getsj{
    NSString *str=[NSString stringWithFormat:@"http://211.149.190.90/api/news"];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        duc=[obj objectForKey:@"result"];
          ;

        
        [tab reloadData];
      

    }];







}


-(void)initsc
{
    
    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height+titleView.frame.origin.y+20, swidth, sheight/22)];
    
     for (int i=0; i<selectArray.count; i++) {
      UIButton    *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame: CGRectMake(i*swidth/5,0 , swidth/4.5, sheight/22)];
        [btn setTitle:[selectArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTag:i];
        [btn addTarget:self action:@selector(clickon:) forControlEvents:UIControlEventTouchDown];
      
        btn.backgroundColor=[UIColor blackColor];
        [sc addSubview:btn];
    }
    sc.contentSize=CGSizeMake(swidth*1.2, sheight/22);
    [self.view addSubview:sc];


}
-(void)clickon:(UIButton *)btn
{
    
    switch (btn.tag) {
        case 0:
            

            tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
          tab.backgroundColor=[UIColor clearColor];
            tab.delegate=self;
            tab.dataSource=self;
            tab.tag=0;
            [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
            [self.view addSubview:tab];
            break;
        case 1:
            tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
            tab.backgroundColor=[UIColor clearColor];
            tab.delegate=self;
            tab.dataSource=self;
            tab.tag=1;
            [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
            [self.view addSubview:tab];
            
            break;
        case 2:
            tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
            tab.backgroundColor=[UIColor clearColor];
            tab.delegate=self;
            tab.dataSource=self;
            tab.tag=2;
            [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
            [self.view addSubview:tab];
            
            break;
        case 3:
            tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
            tab.backgroundColor=[UIColor clearColor];
            tab.delegate=self;
            tab.dataSource=self;
            tab.tag=3;
            [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
            [self.view addSubview:tab];
            
            break;
        case 4:
            tab=[[UITableView alloc]initWithFrame:CGRectMake(0,sc.frame.size.height+sc.frame.origin.y+5, swidth, sheight)];
             tab.backgroundColor=[UIColor clearColor];
            tab.delegate=self;
            tab.dataSource=self;
            tab.tag=4;
            [tab registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"ocell"];
            [self.view addSubview:tab];
           
            break;
        default:
            NSLog(@"other");
            break;
    }



}
-(void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    switch (tab.tag) {
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
            break;
    }
    return ary.count;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    okCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ocell" forIndexPath:indexPath];
   
    NSDictionary *bic=[ary objectAtIndex:indexPath.row];
   
//   http://211.149.190.90/Public/image/upload/20160711/578353c470bc8.jpg
//    cell.im.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]]];
    
    cell.titles.text=[bic objectForKey:@"title"];
    cell.im.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://211.149.190.90/Public/image/upload/20160711/578353c470bc8.jpg"]]];
    cell.nums.text=[NSString stringWithFormat:@"%i",[[bic objectForKey:@"read"]intValue]]  ;
    
    NSNumber *btime=[bic objectForKey:@"created"];
    NSInteger myInteger = [btime integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
    NSString *str = [formatter stringFromDate:confromTimesp];
    // 修改
    NSString *sdt=[NSString stringWithFormat:@"%@",str];
    cell.times.text=sdt;
    cell.im.image=[UIImage imageNamed:@"5.jpg"];
    // Configure the cell...
    
    return cell;

    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    modetailViewController *detailsViewController=[[modetailViewController alloc]init];
    NSDictionary *dic=[ary objectAtIndex:indexPath.row];
    NSNumber *aritcleId=[dic objectForKey:@"id"];
    [detailsViewController setAritcleId:aritcleId];
    [self presentViewController:detailsViewController animated:YES completion:nil];


}
/*
#pragma mark - Navigation
 
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
