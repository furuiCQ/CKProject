//
//  MyMsgViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MyMsgViewController.h"
#import "MsgCell.h"
@interface MyMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArray;
    NSArray *imageArray;
    UITableView *msgTableView;
    
}
@end

@implementation MyMsgViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize tabArray;
@synthesize hasMsg;
- (void)viewDidLoad {
    dataArray = [NSArray arrayWithObjects:@"1",@"2",
                 nil];
    imageArray=[NSArray arrayWithObjects:@"system_msg",@"proj_msg", nil];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    
    [self initCotentView];
    
   

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    [searchLabel setText:@"通知"];
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    // NSArray *imageArray=[NSArray arrayWithObjects:@"system_msg",@"proj_msg", nil];
    
}
-(void)initCotentView{
    msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              titleHeight+20,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height-titleHeight-20)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [msgTableView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:244.f/255.f blue:247.f/255.f alpha:1.0]];

    msgTableView.dataSource                        = self;
    msgTableView.delegate                          = self;
    msgTableView.rowHeight                         = self.view.bounds.size.height/7;
    [msgTableView setTag:0];
    [self.view addSubview:msgTableView];
    //    //添加刷新
    //    UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
    //    [_refreshControl setTintColor:[UIColor grayColor]];
    //
    //    [_refreshControl addTarget:self
    //                        action:@selector(refreshView:)
    //              forControlEvents:UIControlEventValueChanged];
    //    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    //    [projectTableView addSubview:_refreshControl];
    //
    //    refreshFooter=[[YiRefreshFooter alloc] init];
    //    refreshFooter.scrollView=projectTableView;
    //    [refreshFooter footer];
    //    refreshFooter.beginRefreshingBlock=^(){
    //    };
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
    return [dataArray count];
}
//@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//@property (weak, nonatomic) IBOutlet UILabel *pointView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    static NSString *identy = @"CustomCell";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MsgCell"owner:self options:nil]lastObject];
    }
    [cell.logoImageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:[indexPath row]]]];
    [cell.pointView.layer setCornerRadius:cell.pointView.layer.frame.size.width/2];
    [cell.pointView.layer setMasksToBounds:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:msgTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
