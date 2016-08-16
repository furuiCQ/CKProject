//
//  MyCollectViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//
#import "OrderRecordCell.h"
#import "MyCollectViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    
}
@end

@implementation MyCollectViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize tabArray;
@synthesize collectTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中..."];

    [self initTitle];
    [self visibleTabBar];
    
    dataArray = [[NSMutableArray alloc]init];
    [self initTableView];
    
    if([dataArray count]>0){
        
        
    }else{
        //[self initNoData];
        [self getData];
    }
    
    
    
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
    [searchLabel setText:@"收藏的课程"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    [msgLabel setBackgroundColor:[UIColor greenColor]];
    [msgLabel setText:@"未知"];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self];
    }];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}

-(void)initTableView{
    bottomHeight=49;
    
    collectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20+0.5+titleHeight/8,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height-(titleHeight+20+0.5+titleHeight/8))];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [collectTableView setBackgroundColor:[UIColor whiteColor]];
    collectTableView.dataSource                        = self;
    collectTableView.delegate                          = self;
    collectTableView.rowHeight                         = self.view.bounds.size.height/7;
    collectTableView.separatorStyle=NO;
    [self.view addSubview:collectTableView];
    
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
    [label setText:@"亲还没有收藏的课程，去看看有啥课程吧~"];
    [label setFont:[UIFont systemFontOfSize:width/29]];
    [label setTextColor:[UIColor colorWithRed:164.f/255.f green:164.f/255.f blue:164.f/255.f alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    [self.view addSubview:view];
    
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
    static NSString *identy = @"CustomCell";
    OrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderRecordCell"owner:self options:nil]lastObject];
    }
    OrderRecordCell *porjectCell=(OrderRecordCell *)cell;
    
    if ([dataArray count]>0) {
        NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
        
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [porjectCell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"instsort"] && ![[dic objectForKey:@"instsort"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"instsort"];
            [porjectCell.authorLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
            NSString *people=[dic objectForKey:@"people"];
            NSString *str=[NSString stringWithFormat:@"已报%@人",people];
            [porjectCell.orderNumbLabel setText:str];
            
        }
        
        if ([dic objectForKey:@"biglogo"] && ![[dic objectForKey:@"biglogo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"biglogo"];
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
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
    NSDictionary *dic=[dataArray objectAtIndex:indexPath.row];
    NSNumber *projectId=[dic objectForKey:@"lid"];
    [projectDetailsViewController setProjectId:projectId];
    [self presentViewController:projectDetailsViewController animated:YES completion:nil];
    [projectDetailsViewController setSelect];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:collectTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
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
    NSNumber *interId=[dic objectForKey:@"lid"];
    
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    
    [HttpHelper deleteFavoriteProject:interId withModel:myDelegate.model success:^(HttpModel *model){
        NSLog(@"%@",model.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                //dataArray=[(NSMutableArray *)model.result mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [dataArray removeObjectAtIndex:[index row]];//删除数据
                    // Delete the row from the data source.
                    [collectTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
                    
                    NSNotification *notification =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                   

                    //  [invitationTableView reloadData];
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
-(void)getData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    AppDelegate *myDelegate=( AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
    NSNumber *ar=[stand objectForKey:@"lttt"];
    NSNumber *ngg=[stand objectForKey:@"nggg"];
    if (ar==NULL&&ngg==NULL) {
        ar=[NSNumber numberWithDouble:myDelegate.latitude];
        ngg=[NSNumber numberWithDouble:myDelegate.longitude];
    }
    if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
        ar=[NSNumber numberWithDouble:29.5];
        ngg=[NSNumber numberWithDouble:106.5];
    }
    dispatch_async(queue, ^{
    [HttpHelper getFavoriteProjectList:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:10]withLng:ngg withLat:ar  withModel:myDelegate.model success:^(HttpModel *model){
        NSLog(@"%@",model.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                dataArray=[(NSMutableArray *)model.result mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [collectTableView reloadData];
                });
                if([dataArray count]<=0){
                    [collectTableView setHidden:YES];
                    [self initNoData];
                }
                
                
            }else{
                
            }
            [ProgressHUD dismiss];
            
        });
    }failure:^(NSError *error){
        if (error.userInfo!=nil) {
            NSLog(@"%@",error.userInfo);
            [ProgressHUD dismiss];

        }
    }];
    });
    
}

@end