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
#import <SDWebImage/UIImageView+WebCache.h>
#import "YiRefreshFooter.h"
#import "YiRefreshHeader.h"
#define swidth self.view.frame.size.width
#define sheight self.view.frame.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *vi;
    CGFloat titleHeight;
    UILabel *cityLabel;
    UILabel *searchLabel;
    UILabel *msgLabel;
    UIScrollView *sc;
    UIView *titleView;
    
    NSMutableArray *selectArray;
   

    
    UINib *nib;
    
    NSNumber *newsType;
    NSNumber *pn;
    NSNumber *pc;

    YiRefreshFooter *refreshFooter;
    YiRefreshHeader *refreshHeader;
    BOOL _isLoading;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    newsType=[NSNumber numberWithInt:2];
    pn=[NSNumber numberWithInt:1];
    pc=[NSNumber numberWithInt:10];
    _isLoading=NO;
    [self initTitle];
    [self getsj:0
     ];
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
    
    vi=[[UITableView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height+_topView.frame.origin.y+5, swidth, sheight-(_topView.frame.size.height+_topView.frame.origin.y+5)-titleHeight)];
    vi.delegate=self;
    vi.dataSource=self;
    vi.separatorStyle=UITableViewCellSeparatorStyleNone;
    [vi registerNib:[UINib nibWithNibName:@"okCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:vi];
    
    //添加刷新
//    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
//    [_refreshControl setTintColor:[UIColor grayColor]];
//    
//    [_refreshControl addTarget:self
//                        action:@selector(refreshView:)
//              forControlEvents:UIControlEventValueChanged];
//    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
//    [vi addSubview:_refreshControl];
    
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=vi;
    [refreshFooter footer];
    refreshFooter.beginRefreshingBlock=^(){
        NSLog(@"上拉加载");
        _isLoading=true;
        int numb=[pn intValue];
        numb++;
        pn=[NSNumber numberWithInt:numb];
        [self getsj:1];
    };
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=vi;
    [refreshHeader header];
    refreshHeader.beginRefreshingBlock=^(){
        _isLoading=true;
        [self getsj:0];
    };
    
    
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
            newsType=[NSNumber numberWithInt:2];
            break;
        case 1:
            newsType=[NSNumber numberWithInt:3];
            break;
        case 2:
            newsType=[NSNumber numberWithInt:4];
            break;
        case 3:
            newsType=[NSNumber numberWithInt:5];
            break;
        case 4:
            newsType=[NSNumber numberWithInt:6];
            break;
        case 5:
            newsType=[NSNumber numberWithInt:7];
            break;
    }
    pn=[NSNumber numberWithInt:1];
    [self getsj:0];
}
-(void)getsj:(int)add{
    [ProgressHUD show:@"加载中..."];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getNewsList:newsType andPn:pn andPc:pc success:^(HttpModel *model){
                           
                           NSLog(@"%@",model.result);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               _isLoading=NO;
                               if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                   if(add==0){
                                       selectArray=[model.result mutableCopy];
                                       [refreshHeader endRefreshing];

                                    }else{
                                        NSMutableArray *data=[model.result mutableCopy];
                                        [refreshFooter endRefreshing];
                                        if([data count]>0){
                                            [selectArray addObjectsFromArray:data];
                                        }else{
                                            //初始化提示框；
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有更多的数据了..." preferredStyle:  UIAlertControllerStyleAlert];
                                            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                //点击按钮的响应事件；
                                            }]];
                                            //弹出提示框；
                                            [self presentViewController:alert animated:true completion:nil];
                                        }
                                    }
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
    
    return selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identy = @"okCell";
    okCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"okCell"owner:self options:nil]lastObject];
    }
    NSDictionary *bic=[selectArray objectAtIndex:indexPath.row];
    NSUserDefaults *kp=[NSUserDefaults standardUserDefaults];
    [kp setObject:[bic objectForKey:@"content"] forKey:@"cpn"];
    cell.titles.text=[bic objectForKey:@"title"];
    cell.writers.text=[bic objectForKey:@"author"];
    cell.nums.text=[NSString stringWithFormat:@"%i",[[bic objectForKey:@"read"]intValue]]  ;
    NSNumber *btime=[bic objectForKey:@"created"];
    NSString *str1=[NSString stringWithFormat:@"http://211.149.190.90%@",[bic objectForKey:@"img"]];
    [cell.im sd_setImageWithURL:[NSURL URLWithString:str1]];
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
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)uiScrollView
{
    if (!_isLoading && uiScrollView.tag==0) { // 判断是否处于刷新状态，刷新中就不执行
        float height = uiScrollView.contentSize.height > vi.frame.size.height ? vi.frame.size.height : uiScrollView.contentSize.height;
        if ((height - uiScrollView.contentSize.height + uiScrollView.contentOffset.y) / height > 0.2) {
            // 调用上拉刷新方法
            [refreshFooter beginRefreshing];
        }
        if (- uiScrollView.contentOffset.y / vi.frame.size.height > 0.2) {
            // 调用下拉刷新方法
            NSLog(@"刷新");
            [refreshHeader beginRefreshing];
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    xindetailViewController  *bt=[[xindetailViewController alloc]init];
    NSDictionary *dic=[selectArray objectAtIndex:indexPath.row];
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
