//
//  MsgViewController.m
//  CKProject
//
//  Created by furui on 15/12/26.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    NSNumber *page;
    NSNumber *line;
    int Tag;
}
@end

@implementation MsgViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize tabArray;
@synthesize topTitle;
@synthesize msgTableView;
@synthesize flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view Did Load");
    page=[NSNumber numberWithInt:1];
    line=[NSNumber numberWithInt:5];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self visibleTabBar];
    [self initTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)setFlag:(int)flag{
//    [self getData:flag];
//}
-(void)setFlag:(int)fl{
    flag=fl;
    [self getData:flag];
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
-(void)setTopTitle:(NSString *)str{
    [searchLabel setText:str];
    
}
//-(void)setFlag:(NSInteger *)flag{
//    [self getData:flag];
//}
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
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    //[searchLabel setText:topTitle];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initTableView{
    bottomHeight=49;
    
    msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              titleHeight+20+0.5,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height-titleHeight-20-0.5)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [msgTableView setBackgroundColor:[UIColor whiteColor]];
    msgTableView.dataSource                        = self;
    msgTableView.delegate                          = self;
    msgTableView.rowHeight                         = self.view.bounds.size.height/10;
    [self.view addSubview:msgTableView];
    
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
    MsgTableCell *cell=[[MsgTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setViewController:self];
    if (cell ==nil) {
        cell  = [[MsgTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if ([dataArray count]>0) {
        switch (Tag) {
            case 0:
            {
                NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
                if ([dic objectForKey:@"intertitle"] && ![[dic objectForKey:@"intertitle"] isEqual:[NSNull null]]) {
                    NSString *title=[dic objectForKey:@"intertitle"];
                    [cell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
                }
                if ([dic objectForKey:@"created"] && ![[dic objectForKey:@"created"] isEqual:[NSNull null]]) {
                    NSNumber *creatTime=[dic objectForKey:@"created"];
                    
                    NSInteger myInteger = [creatTime integerValue];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                    [formatter setTimeZone:timeZone];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    [cell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                    
                }
                if ([dic objectForKey:@"content"] && ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                    NSString *content=[dic objectForKey:@"content"];
                    [cell.contentLabel setText:[NSString stringWithFormat:@"%@",content]];
                }
            }
                break;
            case 1:
            {
                NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
                if ([dic objectForKey:@"intertitle"] && ![[dic objectForKey:@"intertitle"] isEqual:[NSNull null]]) {
                    NSString *title=[dic objectForKey:@"intertitle"];
                    [cell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
                }
                if ([dic objectForKey:@"created"] && ![[dic objectForKey:@"created"] isEqual:[NSNull null]]) {
                    NSNumber *creatTime=[dic objectForKey:@"created"];
                    
                    NSInteger myInteger = [creatTime integerValue];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                    [formatter setTimeZone:timeZone];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    [cell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                    
                }
                if ([dic objectForKey:@"intercontent"] && ![[dic objectForKey:@"intercontent"] isEqual:[NSNull null]]) {
                    NSString *content=[dic objectForKey:@"intercontent"];
                    [cell.contentLabel setText:[NSString stringWithFormat:@"%@",content]];
                }
            }
                break;
            case 2:
            {
                NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
                if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
                    NSString *title=[dic objectForKey:@"title"];
                    [cell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
                }
                if([dic objectForKey:@"isread"] && ![[dic objectForKey:@"isread"] isEqual:[NSNull null]]){
                    NSNumber *isread=[dic objectForKey:@"isread"];
                    if ([isread intValue]==0) {
                        [cell.pointView setHidden:NO];
                    }else{
                        [cell.pointView setHidden:YES];
                    }
                }
                if ([dic objectForKey:@"mtime"] && ![[dic objectForKey:@"mtime"] isEqual:[NSNull null]]) {
                    NSNumber *creatTime=[dic objectForKey:@"mtime"];
                    
                    NSInteger myInteger = [creatTime integerValue];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                    [formatter setTimeZone:timeZone];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    [cell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
                    
                }
                if ([dic objectForKey:@"content"] && ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                    NSString *content=[dic objectForKey:@"content"];
                    [cell.contentLabel setText:[NSString stringWithFormat:@"%@",content]];
                }
            }
                break;
                
            default:
                break;
        }
        
        //     [cell setEnterOrdersNumber:[NSString stringWithFormat:@"%@",[str objectForKey:@"EnterOrderCode"]]];
        //     [cell setEnterTime:[NSString stringWithFormat:@"%@",[str objectForKey:@"EnterTime"]]];
        //     [cell setLicenseNumber:[NSString stringWithFormat:@"%@",[str objectForKey:@"LicenseNumber"]]];
        //     [cell setCustomName:[NSString stringWithFormat:@"%@",[str objectForKey:@"CustomerName"]]];
        //     [cell setImageTxt:[NSString stringWithFormat:@"%@",[str objectForKey:@"ContractTypeName"]]];
        //     [cell setStatusLabelTxt:[NSString stringWithFormat:@"%@",[str objectForKey:@"StatusName"]]];
    }else{
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=@"数据加载中";
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
    switch (Tag) {
        case 0:
        {
        }
            break;
        case 1:
        {
           
        }
            break;
        case 2:
        {
            MsgContentViewController *msgContentViewController=[[MsgContentViewController alloc]init];
            NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
            NSString *title;
            NSNumber *creatTime;
            NSString *content;
            NSNumber *msgId;
            if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
                title=[dic objectForKey:@"title"];
            }
            if ([dic objectForKey:@"mtime"] && ![[dic objectForKey:@"mtime"] isEqual:[NSNull null]]) {
                creatTime=[dic objectForKey:@"mtime"];
            }
            if ([dic objectForKey:@"content"] && ![[dic objectForKey:@"content"] isEqual:[NSNull null]]) {
                content=[dic objectForKey:@"content"];
                
            }
            msgId=[dic objectForKey:@"mid"];
            [self presentViewController:msgContentViewController animated:YES completion:nil];
            [msgContentViewController setContent:title withTime:creatTime withContent:content withId:msgId];

        }
            break;
            
        default:
            break;
    }

    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)stableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:indexPath];
        
        
      //  [dataArray removeObjectAtIndex:indexPath.row];//删除数据
        //
        //        // Delete the row from the data source.
      //  [msgTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:msgTableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
-(void)deleteData:(NSIndexPath *)index{
    NSDictionary *dic=[dataArray objectAtIndex:[index row]];
    switch (Tag) {
        case 0:
        {
            NSNumber *interId=[dic objectForKey:@"id"];
            
            AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            [HttpHelper deleteMyCommect:interId withModel:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [dataArray removeObjectAtIndex:index.row];//删除数据
                            //
                            //        // Delete the row from the data source.
                            [msgTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
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
            break;
        case 1:
        {
            NSNumber *interId=[dic objectForKey:@"iid"];
            
            AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            
            [HttpHelper deleteInterFavorite:interId withZan:[NSNumber numberWithInt:0] withModel:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [dataArray removeObjectAtIndex:index.row];//删除数据
                            //
                            //        // Delete the row from the data source.
                            [msgTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
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
            
            break;
        case 2:
        {
            NSNumber *msgId=[dic objectForKey:@"mid"];
            
            AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            [HttpHelper deleteSysMsg:msgId withModel:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        //dataArray=[(NSMutableArray *)model.result mutableCopy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [dataArray removeObjectAtIndex:index.row];//删除数据
                            //
                            //        // Delete the row from the data source.
                            [msgTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
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
            
            break;
            
        default:
            break;
    }
    
    
}

-(void)getData:(int)tag{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    Tag=tag;
    switch (tag) {
        case 0:
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            [HttpHelper getCommectsListwithPageNumber:page withPageLine:line withModel:delegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        dataArray=[(NSMutableArray *)model.result mutableCopy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [msgTableView reloadData];
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
            break;
            
        case 1:
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            [HttpHelper getInterFavoriteListwithPageNumber:page withPageLine:line withModel:delegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        dataArray=[(NSMutableArray *)model.result mutableCopy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [msgTableView reloadData];
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
            break;
        case 2:
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            [HttpHelper getSysMsgListwithPageNumber:page withPageLine:line
                                          withModel:delegate.model success:^(HttpModel *model){
                                              NSLog(@"%@",model.message);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                                      dataArray=[(NSMutableArray *)model.result mutableCopy];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [msgTableView reloadData];
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
            break;
    }
}


@end