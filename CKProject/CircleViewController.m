//
//  CircleViewController.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//


#import "CircleViewController.h"
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
#import "ProgressHUD/ProgressHUD.h"
#import "MationViewController.h"
#import "ViewController.h"
@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableArray;
    NSArray *imageArray;
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
    UIButton *vi;
}

@end

@implementation CircleViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize circleTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中..."];
    [self initTitle];
    
    tableArray = [[NSArray alloc]init];
    imageArray=[[NSArray alloc]initWithObjects:@"zaojiao",@"music",@"language",
                @"sport",@"syc",@"beikao",@"design",@"talk",nil];
    
    
//     vi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/7)];
//     [vi setImage:[UIImage imageNamed:@"新闻banner2"]];
   vi=[UIButton buttonWithType:UIButtonTypeCustom];
    vi.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/7);
    [vi setImage:[UIImage imageNamed:@"新闻banner2"] forState:UIControlStateNormal];
//    vi.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:<#(nonnull NSString *)#>]]
    [self.view addSubview:vi];
    [vi addTarget:self action:@selector(tizhuan) forControlEvents:UIControlEventTouchDown];
    
    [self initTableView];
    [self getInterGroup];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)tizhuan
{
    ViewController *ma=[[ViewController alloc]init];
    [self presentViewController:ma animated:YES completion:nil];
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //    //新建左上角Label
    //    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    //    [cityLabel setBackgroundColor:[UIColor greenColor]];
    //    [cityLabel setText:@"未知"];
    //    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"圈子"];
    
    //    //新建右上角的图形
    //    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    //    [msgLabel setBackgroundColor:[UIColor greenColor]];
    //    [msgLabel setText:@"未知"];
    //    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    //    [titleView addSubview:cityLabel];
    //    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initTableView{
    bottomHeight=49;
    
    circleTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                 titleHeight+20+self.view.frame.size.width/40
                                                                 ,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height-titleHeight-20-self.view.frame.size.width/40-bottomHeight)];
    circleTableView.dataSource                        = self;
    
    circleTableView.delegate                          = self;
    circleTableView.rowHeight                         = self.view.bounds.size.height/7;
    circleTableView.tableHeaderView=vi;
    [self.view addSubview:circleTableView];
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=circleTableView;
    [refreshHeader header];
    refreshHeader.beginRefreshingBlock=^(){
    };
}
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    
    
    if ( uiScrollView.tag==0) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        
        //    如果内容高度大于UITableView高度，就取TableView高度
        
        //    如果内容高度小于UITableView高度，就取内容的实际高度
        
        float height = uiScrollView.contentSize.height > circleTableView.frame.size.height ?circleTableView.frame.size.height : uiScrollView.contentSize.height;
        
        
        
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.2) {
            
            // 调用上拉刷新方法
            NSLog(@"上拉加载");
            //[refreshFooter beginRefreshing];
            
        }
        
        if (- uiScrollView.contentOffset.y / circleTableView.frame.size.height > 0.2) {
            
            // 调用下拉刷新方法
            NSLog(@"刷新");
            [refreshHeader beginRefreshing];
            
            [self getInterGroup];
        }
        
    }
    
    
}


#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    return [tableArray count];
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    CircleCustomTableCell *cell=[[CircleCustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setViewController:self];
    if (cell ==nil) {
        cell  = [[CircleCustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([tableArray count]>0) {
        NSDictionary *data=[tableArray objectAtIndex:[indexPath row]];
        if (data) {
            [self setData:data withItem:cell.listItem withNumber:[indexPath row]];
        }
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
}
-(void)setData:(NSDictionary *)data withItem:(CircleListItem *)item withNumber:(NSUInteger)number{
    NSString *title=[data objectForKey:@"title"];
    NSString *logo=[data objectForKey:@"logo"];
    NSNumber *orders=[data objectForKey:@"internum"];
    NSString *stitle=[data objectForKey:@"stitle"];
    
    if (![title isEqual:@""] && title!=nil && ![title isEqual:[NSNull null]]) {
        [item.titleName setText:title];
    }
    if (![logo isEqual:@""] && logo!=nil && ![logo isEqual:[NSNull null]] && [logo length]>0) {
        [item.logoView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
    }else{
        [item.logoView setImage:[UIImage imageNamed:[imageArray objectAtIndex:number]]];
    }
    
    if (![orders isEqual:@""] && orders!=nil && ![orders isEqual:[NSNull null]]) {
        [item.pepoleLabel setText:[NSString stringWithFormat:@"%@", orders]];
    }
    
    if (![stitle isEqual:@""] && stitle!=nil && ![stitle isEqual:[NSNull null]]) {
        [item.contentLabel setText:stitle];
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *data=[tableArray objectAtIndex:[indexPath row]];
    NSString *title=[data objectForKey:@"title"];
    NSNumber *circleId=[data objectForKey:@"id"];
    CircleListViewController *circleListViewController=[[CircleListViewController alloc]init];
    [circleListViewController setCircleId:circleId];
    [circleListViewController setTitleName:title];
    [self presentViewController: circleListViewController animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:circleTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
-(void)getInterGroup{
    static NSString * const DEFAULT_LOCAL_AID = @"500100";
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getInterGroup:aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    tableArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [circleTableView reloadData];
                        
                    });
                    
                    
                }else{
                    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end