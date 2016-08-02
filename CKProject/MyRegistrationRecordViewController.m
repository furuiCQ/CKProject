//
//  MyRegistrationRecordViewController.m
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MyRegistrationRecordViewController.h"
#import "HttpHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyRegistrationRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *allArray;
    NSMutableArray *unOrderArray;
    NSMutableArray *orderArray;
    NSMutableArray *kispray;//受理失败
    
    int flag;
    int select_number;
}
@end

@implementation MyRegistrationRecordViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize tabArray;
@synthesize recordTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    select_number=-1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"refresh" object:nil];
    [ProgressHUD show:@"加载中..."];
    [self initTitle];
    [self visibleTabBar];
    [self initTopBar];
    [self initTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    allArray=[[NSMutableArray alloc]init];
    unOrderArray=[[NSMutableArray alloc]init];
    orderArray=[[NSMutableArray alloc]init];
    kispray=[[NSMutableArray alloc]init];
    
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
    //  [searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"我的报名记录"];
    
    //    //新建右上角的图形
    //    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    //    [msgLabel setBackgroundColor:[UIColor greenColor]];
    //    [msgLabel setText:@"未知"];
    //    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    //    [titleView addSubview:msgLabel];
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
-(void)initTopBar{
    int width=self.view.frame.size.width;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, titleHeight*3/4)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"全部",@"预约",@"已受理",@"受理失败", nil];
    tabArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[array count]; i++) {
        TopBar *topBar=[[TopBar alloc]initWithFrame:CGRectMake(width/[array count]*i, 0, width/[array count]-1, titleHeight)];
        [topBar addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBar setTag:i];
        [topBar setText:[array objectAtIndex:i]];
        if(i==2){
            [topBar setIsEnd:YES];
        }
        if(i==0){
            [topBar setChecked:YES];
        }else{
            [topBar setChecked:NO];
        }
        [topBar initView];
        [topBar setLabelFont:[UIFont systemFontOfSize:width/29]];
        [topView addSubview:topBar];
        [tabArray addObject:topBar];
    }
    flag=0;
}
-(void)clickNumber:(int)number{
   // TopBar *topBar=[[TopBar alloc]init];
   // topBar.tag=number;
   // [self onClick:topBar];

    select_number=number;
}
-(void)selectTopBar{
     TopBar *topBar=[[TopBar alloc]init];
     topBar.tag=select_number;
     [self onClick:topBar];
}
-(void)onClick:(id)sender{
    TopBar *topBar=(TopBar *)sender;
    for (NSObject *object in tabArray) {
        TopBar *b=(TopBar *)object;
        if(b.tag!=topBar.tag){
            [b setChecked:NO];
            [b setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        }else{
            [b setChecked:YES];
            [b setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
            
        }
    }
    flag=(int)topBar.tag;
    switch (topBar.tag) {
            
        case 0:
        {
            dataArray=allArray;
            [recordTableView reloadData];
            
        }
            break;
        case 1:
        {
            dataArray=unOrderArray;
            [recordTableView reloadData];
            
            
        }
            break;
        case 2:
        {
            dataArray=orderArray;
            [recordTableView reloadData];
            
            
        }
            break;
//            受理失败
        case 3:
        {
            dataArray=kispray;
            [recordTableView reloadData];
            
            
        }
            break;
            
        default:
            break;
    }
}
-(void)initTableView{
    bottomHeight=49;
    
    recordTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                 titleHeight*3/4+titleHeight+20+0.5+titleHeight/4,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height-titleHeight*3/4-titleHeight-20-0.5-titleHeight/4)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [recordTableView setBackgroundColor:[UIColor whiteColor]];
    recordTableView.dataSource                        = self;
    recordTableView.delegate                          = self;
    recordTableView.rowHeight                         = self.view.bounds.size.height/7;
    [self.view addSubview:recordTableView];
    
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
    RegistrationRecordTableCell *cell=[[RegistrationRecordTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setViewController:self];
    if (cell ==nil) {
        cell  = [[RegistrationRecordTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([dataArray count]>0) {
        NSDictionary *dic;
        switch (flag) {
            case 0:
                dic=[dataArray objectAtIndex:[indexPath row]];
                break;
            default:
                dic=[[dataArray objectAtIndex:[indexPath row]] objectAtIndex:0];
                break;
        }
        
        if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
            NSString *title=[dic objectForKey:@"title"];
            [cell.tilteLabel setText:[NSString stringWithFormat:@"%@",title]];
        }
        
        if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[dic objectForKey:@"logo"];
            [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
        }
        
        if ([dic objectForKey:@"instsort"] && ![[dic objectForKey:@"instsort"] isEqual:[NSNull null]]) {
            NSString *instname=[dic objectForKey:@"instsort"];
            [cell.projectName setText:[NSString stringWithFormat:@"%@",instname]];
        }
        
        if ([dic objectForKey:@"orderday"] && ![[dic objectForKey:@"orderday"] isEqual:[NSNull null]]) {
            NSNumber *btime=[dic objectForKey:@"orderday"];
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
            NSString *sdt=[NSString stringWithFormat:@"%@\t%@",str,[dic objectForKey:@"ordertime"]];
            
            
            
            [cell.timeLabel setText:[NSString stringWithFormat:@"%@",sdt]];
            if ([dic objectForKey:@"ordertime"] && ![[dic objectForKey:@"ordertime"] isEqual:[NSNull null]]) {
                NSNumber *etime=[dic objectForKey:@"ordertime"];
                
                NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
                NSString *timeStamp2 =[formater stringFromNumber:btime];
                long long int date1 = (long long int)[timeStamp2 intValue];
                NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:date1];
                NSTimeInterval bTimer = [aDate timeIntervalSinceNow];
                
                NSString *timeStamp3 =[formater stringFromNumber:etime];
                long long int date2 = (long long int)[timeStamp3 intValue];
                NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:date2];
                NSTimeInterval eTimer = [eDate timeIntervalSinceNow];
//                
//                if(eTimer<0){
//                    //已结束
//                    [cell.statue2Label setText:@"已结束"];
//                    [cell.statue2Label setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
//                    cell.statue2Label.layer.borderColor=[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0].CGColor;
//                }else if(bTimer<0 && eTimer>0){
//                    //已开课
//                    [cell.statue2Label setText:@"已开课"];
//                    [cell.statue2Label setTextColor:[UIColor colorWithRed:75.f/255.f green:206.f/255.f blue:109.f/255.f alpha:1.0]];
//                    cell.statue2Label.layer.borderColor=[UIColor colorWithRed:75.f/255.f green:206.f/255.f blue:109.f/255.f alpha:1.0].CGColor;
//                }else{
//                    //未开课
//                    [cell.statue2Label setText:@"未开课"];
//                    [cell.statue2Label setTextColor:[UIColor colorWithRed:245.f/255.f green:7.f/255.f blue:35.f/255.f alpha:1.0]];
//                    cell.statue2Label.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
//                    
//                }
                
            }
        }

        
        
        if ([dic objectForKey:@"status"] && ![[dic objectForKey:@"status"] isEqual:[NSNull null]]) {
            NSNumber *status=[dic objectForKey:@"status"];
           NSNumber *atime=[dic objectForKey:@"atime"];
           int at=[atime intValue];
           if ([status isEqualToNumber:[NSNumber numberWithInt:0]]&&at>0) {
               [cell.statueLabel setText:@"受理失败"];
               [cell.statueLabel setTextColor:[UIColor colorWithRed:245.f/255.f green:7.f/255.f blue:35.f/255.f alpha:1.0]];
               cell.statueLabel.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
               if (flag==0) {
                   NSArray *arry=[[NSArray alloc]initWithObjects:dic, nil];
                   BOOL toAdd=true;
                   if ([kispray count]>0) {
                       for (NSArray *item in kispray) {
                           NSNumber *itemId=[[item objectAtIndex:0] objectForKey:@"lid"];
                           NSNumber *dicId=[dic objectForKey:@"lid"];
                           if ([itemId isEqualToNumber:dicId]) {
                               toAdd=false;
                           }
                       }
                   }else{
                       toAdd=true;
                   }
                   if (toAdd) {
                       [kispray addObject:[arry mutableCopy]];
                   }
               }
               
           }
            if ([status isEqualToNumber:[NSNumber numberWithInt:0]]&&at==0) {
                [cell.statueLabel setText:@"未受理"];
                [cell.statueLabel setTextColor:[UIColor colorWithRed:245.f/255.f green:7.f/255.f blue:35.f/255.f alpha:1.0]];
                cell.statueLabel.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
                if (flag==0) {
                    NSArray *arry=[[NSArray alloc]initWithObjects:dic, nil];
                    BOOL toAdd=true;
                    if ([unOrderArray count]>0) {
                        for (NSArray *item in unOrderArray) {
                            NSNumber *itemId=[[item objectAtIndex:0] objectForKey:@"lid"];
                            NSNumber *dicId=[dic objectForKey:@"lid"];
                            if ([itemId isEqualToNumber:dicId]) {
                                toAdd=false;
                            }
                        }
                    }else{
                        toAdd=true;
                    }
                    if (toAdd) {
                        [unOrderArray addObject:[arry mutableCopy]];
                    }
                }
                
            }
           else  if ([status isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [cell.statueLabel setText:@"评价"];
                [cell.statueLabel setTag:[indexPath row]];
                UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAssessViewController:)];
                [cell.statueLabel setUserInteractionEnabled:YES];
                [cell.statueLabel addGestureRecognizer:tapGestureRecognizer];
                [cell.statueLabel setTextColor:[UIColor colorWithRed:75.f/255.f green:206.f/255.f blue:109.f/255.f alpha:1.0]];
                cell.statueLabel.layer.borderColor=[UIColor colorWithRed:75.f/255.f green:206.f/255.f blue:109.f/255.f alpha:1.0].CGColor;
                if (flag==0) {
                    NSArray *arry=[[NSArray alloc]initWithObjects:dic, nil];
                    BOOL toAdd=true;
                    if ([orderArray count]>0) {
                        for (NSArray *item in orderArray) {
                            NSNumber *itemId=[[item objectAtIndex:0] objectForKey:@"lid"];
                            NSNumber *dicId=[dic objectForKey:@"lid"];
                            if ([itemId isEqualToNumber:dicId]) {
                                toAdd=false;
                            }
                        }
                    }else{
                        toAdd=true;
                    }
                    if (toAdd) {
                        [orderArray addObject:[arry mutableCopy]];
                    }
                }
                
            }else  if ([status isEqualToNumber:[NSNumber numberWithInt:2]]) {
                [cell.statueLabel setText:@"已评价"];
                [cell.statueLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
                cell.statueLabel.layer.borderColor=[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0].CGColor;
                if (flag==0) {
                    NSArray *arry=[[NSArray alloc]initWithObjects:dic, nil];
                    BOOL toAdd=true;
                    if ([orderArray count]>0) {
                        for (NSArray *item in orderArray) {
                            NSNumber *itemId=[[item objectAtIndex:0] objectForKey:@"lid"];
                            NSNumber *dicId=[dic objectForKey:@"lid"];
                            if ([itemId isEqualToNumber:dicId]) {
                                toAdd=false;
                            }
                        }
                    }else{
                        toAdd=true;
                    }
                    if (toAdd) {
                        [orderArray addObject:[arry mutableCopy]];
                    }
                }
            }
            
        }
        
        
        
        
        
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *dic;
    switch (flag) {
        case 0:
            dic=[dataArray objectAtIndex:[indexPath row]];
            break;
        default:
            dic=[[dataArray objectAtIndex:[indexPath row]] objectAtIndex:0];
            break;
    }
    NSNumber *interId=[dic objectForKey:@"lid"];
    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    [st setObject:interId forKey:@"opid"];
    ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
    [projectDetailsViewController setProjectId:interId];
    [projectDetailsViewController setIsCancel:YES];
    [self presentViewController:projectDetailsViewController animated:YES completion:nil];
    
    
}
//跳转出错的bug
-(void)goAssessViewController:(id)sender{
    NSLog(@"开始跳转");
    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
   NSNumber *ist=[st objectForKey:@"opid"];
  
    AssessViewController *assessViewController=[[AssessViewController alloc]init];
    [assessViewController setProjectId:ist];
    [self presentViewController:assessViewController animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:recordTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
- (void)tableView:(UITableView *)stableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        [self deleteData:indexPath];
        //
        
        
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
    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    [st setObject:interId forKey:@"ld"];
    NSDictionary *lessontime=[dic objectForKey:@"lessontime"];
    NSNumber *weekid=[lessontime objectForKey:@"weekid"];
    NSNumber *weeknum=[lessontime objectForKey:@"weeknum"];
    NSString *begintime=[dic objectForKey:@"ordertime"];

    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper deleteMyLesson:interId withWeekId:weekid withWeekNum:weeknum withBeginTime:begintime withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    //dataArray=[(NSMutableArray *)model.result mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [dataArray removeObjectAtIndex:[index row]];//删除数据
                        
                        // Delete the row from the data source.
                        [recordTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
                        
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
-(void)getData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AppDelegate *myDelegate=( AppDelegate *)[[UIApplication sharedApplication]delegate];
        [HttpHelper getMyLessonList:[NSNumber numberWithInt:0] withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    dataArray=[(NSMutableArray *)model.result mutableCopy];
                    allArray=dataArray;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [recordTableView reloadData];
                        if (select_number>-1) {
                            [self selectTopBar];
                        }
                    });
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

