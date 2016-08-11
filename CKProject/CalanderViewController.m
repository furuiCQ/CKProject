//
//  SearchViewController.m
//  CKProject
//
//  Created by furui on 16/1/14.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "CalanderViewController.h"
#import "HttpHelper.h"
#import "FDCalendar.h"
#import "AppDelegate.h"
@interface CalanderViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,EveryFrameDelegate>{
    NSArray *tableArray;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UITextView *contentTextView;
    UILabel *keyTextField;
    UILabel *sendAssessLabel;
    //
    NSArray *ary;
    NSDate *selectDate;
}

@end

@implementation CalanderViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize chooseImageView;
@synthesize titleView;
@synthesize contentView;
@synthesize aid;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:imageView];
    selectDate=[NSDate date];
    [ProgressHUD show:@"加载中..."];
    [self initTitle];
    [self initContentView];
    [self getLessonCount];
    // Do any additional setup after loading the view, typically from a nib.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4.5, titleHeight)];
    [cityLabel setTextAlignment:NSTextAlignmentRight];
    cityLabel.userInteractionEnabled=YES;//
    [cityLabel setText:@"返回"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"black_back"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setText:@"日期列表"];
    
    [topView addSubview:cityLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIScrollView *bgView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20+titleHeight+0.5, width, hegiht-(20+titleHeight+0.5))];
    [self.view addSubview:bgView];
    keyTextField=[[UILabel alloc]initWithFrame:CGRectMake(width/11, width/16, width*5/6, width/10.7)];
    keyTextField.text=@"今日开设课程";
    [keyTextField setTextAlignment:NSTextAlignmentCenter];
    [keyTextField setTextColor:[UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.0]];
    [keyTextField setFont:[UIFont systemFontOfSize:width/26.7]];
    [bgView addSubview:keyTextField];
    
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = keyTextField.frame.size.height+keyTextField.frame.origin.y+width/10;
    frame.origin.x=width/16;
    frame.size.width=width-width/8;
    calendar.delegate=self;
    calendar.frame = frame;
    [bgView addSubview:calendar];
    
    
    sendAssessLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width/1.3)/2, calendar.frame.size.height+calendar.frame.origin.y+width/8.4, width/1.3, width/8)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchProjectList)];
    sendAssessLabel.userInteractionEnabled=YES;
    [sendAssessLabel addGestureRecognizer:loginRecognizer];
    [sendAssessLabel setText:@"查看选定时间课程"];
    [sendAssessLabel setFont:[UIFont systemFontOfSize:width/20]];
    [sendAssessLabel setTextAlignment:NSTextAlignmentCenter];
    [sendAssessLabel setTextColor:[UIColor whiteColor]];
    [sendAssessLabel setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:99.f/255.f blue:99.f/255.f alpha:1.0]];
    [bgView addSubview:sendAssessLabel];
    
}
- (void)getSelectData:(NSDate *)date{
    selectDate=date;
    [self tzshuj:date];
}
//值发生改变时
-(void)tzshuj:(NSDate *)selected1
{
    //当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    
    [dateformatter2 setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString=[dateformatter2 stringFromDate:senddate];
    NSLog(@"当前时间：%@",locationString);
    
    //
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter1 setDateFormat:@"yyyyMMdd"];
    // NSDate *selected1 = [uiPatePicker date];
    NSString *date2=[dateFormatter1 stringFromDate:selected1];
    
    if (locationString.doubleValue>date2.doubleValue) {
        [keyTextField setText:@"时间已过期"];
        keyTextField.textColor=[UIColor grayColor];
        sendAssessLabel.userInteractionEnabled=NO;
       // sendAssessLabel.textColor=[UIColor grayColor];
    }
    else
    {
        sendAssessLabel.textColor=[UIColor whiteColor];
        sendAssessLabel.userInteractionEnabled=YES;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *selected = selected1;
        NSString *date1=[dateFormatter stringFromDate:selected];
        
        
        NSLog(@"选择的时间：%@",date1);
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper getLessonCount:[NSNumber numberWithInt:500000] andstrd:date1 success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSNumber *number=(NSNumber *)model.result;
                            
                            NSString *data=@"今日开设课程";
                            //   ww b *foramte=[[NSNumberFormatter alloc]init];
                            
                            data=[data stringByAppendingFormat:@"%@门",number];
                            
                            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:data];
                            
                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.f/255.f green:99.f/255.f blue:99.f/255.f alpha:1.0] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
                            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.view.frame.size.width/19] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
                            
                            [keyTextField setAttributedText:str];
                            
                            
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
    
    
}

-(void)searchProjectList{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  //  NSString *data=keyTextField.text;
    NSDate *selected = selectDate;
    NSString *date=[dateFormatter stringFromDate:selected];
    NSUserDefaults *src=[NSUserDefaults standardUserDefaults];
    [src setObject:date forKey:@"kp"];
   
    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    [projectListViewController setstd:2];
    [projectListViewController setTitleName:[NSString stringWithFormat:@"%@课程",date]];
    [self presentViewController:projectListViewController animated:YES completion:nil];
  //  [projectListViewController searchData:data withTime:date withAid:aid];
    
    
}

-(void)getLessonCount{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selected = [NSDate date];
    NSString *date1=[dateFormatter stringFromDate:selected];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getLessonCount:[NSNumber numberWithInt:500000] andstrd:date1 success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSNumber *number=(NSNumber *)model.result;
                        
                        NSString *data=@"今日开设课程";
                        //   ww b *foramte=[[NSNumberFormatter alloc]init];
                        
                        data=[data stringByAppendingFormat:@"%@门",number];
                        
                        NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:data];
                        
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:99.f/255.f blue:99.f/255.f alpha:1.0] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
                        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.view.frame.size.width/19] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
                        
                        [keyTextField setAttributedText:str];
                        
                        
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end