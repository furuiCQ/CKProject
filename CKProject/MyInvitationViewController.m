//
//  MyInvitationViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MyInvitationViewController.h"

@interface MyInvitationViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyInvitationViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize dataArray;
@synthesize invitationTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中..."];
    [self initTitle];
    [self visibleTabBar];
    [self initTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    [self getData];
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 *  隐藏系统tabbar
 */
-(void)visibleTabBar
{
    for (UIView *view  in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]){
            [view setHidden:YES];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;//
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    //  [searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"我的帖子"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    
    UIImageView *editView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_logo"]];
    [editView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/21/2, self.view.frame.size.width/20, self.view.frame.size.width/21)];
    [msgLabel addSubview:editView];
    UITapGestureRecognizer *editGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [msgLabel addGestureRecognizer:editGesture];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    // [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    bottomHeight=49;
    
    invitationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                     titleHeight+20+0.5+titleHeight/8,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height-(titleHeight+20+0.5+titleHeight/8))];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [invitationTableView setBackgroundColor:[UIColor whiteColor]];
    invitationTableView.dataSource                        = self;
    invitationTableView.delegate                          = self;
    invitationTableView.rowHeight                         = self.view.bounds.size.height/7;
    [self.view addSubview:invitationTableView];
    
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

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    InvitationTableCell *cell=[[InvitationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setViewController:self];
    if (cell ==nil) {
        cell  = [[InvitationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([dataArray count]>0) {
        NSDictionary *str=[dataArray objectAtIndex:[indexPath row]];
        NSString *title=[str objectForKey:@"title"];
        NSNumber *creatTime=[str objectForKey:@"created"];
        NSNumber *people=[str objectForKey:@"people"];
        NSNumber *zan=[str objectForKey:@"zan"];
        [cell.addLabel setText:[NSString stringWithFormat:@"%@",title]];
        [cell.msgLabel setText:[NSString stringWithFormat:@"%@",people]];
        [cell.zanLabel setText:[NSString stringWithFormat:@"%@",zan]];
        
        NSInteger myInteger = [creatTime integerValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        
        [cell.lastDayLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
        
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
    InvitationDetailsViewController *detailsViewController=[[InvitationDetailsViewController alloc]init];
    NSDictionary *dic=[dataArray objectAtIndex:indexPath.row];
    NSNumber *aritcleId=[dic objectForKey:@"id"];
    [detailsViewController setAritcleId:aritcleId];
    [self presentViewController:detailsViewController animated:YES completion:nil];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:invitationTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)stableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        [self deleteData:indexPath];
        //
        //        [dataArray removeObjectAtIndex:[indexPath row]];//删除数据
        //
        //        // Delete the row from the data source.
        //        [invitationTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)deleteData:(NSIndexPath *)index{
    NSDictionary *dic=[dataArray objectAtIndex:[index row]];
    NSNumber *interId=[dic objectForKey:@"id"];
    
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    [HttpHelper deleteMyInter: interId withModel:myDelegate.model success:^(HttpModel *model){
        NSLog(@"%@",model.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                //dataArray=[(NSMutableArray *)model.result mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [dataArray removeObjectAtIndex:[index row]];//删除数据
                    
                    // Delete the row from the data source.
                    [invitationTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
                    
                    NSNotification *notification =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
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
-(void)initNoData{
    int width=self.view.frame.size.width;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,
                                                         titleHeight+20+0.5+titleHeight/8,
                                                         self.view.frame.size.width,
                                                         self.view.frame.size.height-(titleHeight+20+0.5+titleHeight/8))];
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake((width-width/4.6)/2, width/5, width/4.6, width/4.6)];
    [logoView setBackgroundColor:[UIColor colorWithRed:181.f/255.f green:181.f/255.f blue:181.f/255.f alpha:1.0]];
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 16.f;
    [view addSubview:logoView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, width/5+width/4.6+width/10, width, width/29)];
    [label setText:@"亲还没有您的帖子，去圈子逛逛~"];
    [label setFont:[UIFont systemFontOfSize:width/29]];
    [label setTextColor:[UIColor colorWithRed:164.f/255.f green:164.f/255.f blue:164.f/255.f alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    [self.view addSubview:view];
    
}

-(void)getData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    AppDelegate *myDelegate=( AppDelegate *)[[UIApplication sharedApplication]delegate];
    [HttpHelper getMyInterListwithPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5]
                                   withModel:myDelegate.model success:^(HttpModel *model){
                                       NSLog(@"%@",model.message);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                               dataArray=[(NSMutableArray *)model.result mutableCopy];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [invitationTableView reloadData];
                                               });
                                               if([dataArray count]<=0){
                                                   [invitationTableView setHidden:YES];
                                                   [self initNoData];
                                               }
                                               
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

@end

