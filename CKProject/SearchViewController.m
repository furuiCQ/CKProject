//
//  SearchViewController.m
//  CKProject
//
//  Created by furui on 16/1/14.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "SearchViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface SearchViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSArray *tableArray;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UITextView *contentTextView;
    UILabel *keyTextField;
    UIDatePicker *uiPatePicker;
    UILabel *sendAssessLabel;
    //
    NSArray *ary;
}

@end

@implementation SearchViewController
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
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
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
    [topView setBackgroundColor:[UIColor whiteColor]];
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
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"日期列表"];
 
    [topView addSubview:cityLabel];
    //[topView addSubview:msgLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
    
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIScrollView *bgView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20+titleHeight+0.5, width, hegiht-(20+titleHeight+0.5))];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    keyTextField=[[UILabel alloc]initWithFrame:CGRectMake(width/11, width/8, width*5/6, width/10.7)];
    keyTextField.text=@"今日开设课程";
    [keyTextField setTextAlignment:NSTextAlignmentCenter];
    [keyTextField setTextColor:[UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.0]];
    [keyTextField setFont:[UIFont systemFontOfSize:width/26.7]];
    [bgView addSubview:keyTextField];


    uiPatePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(width/11, width/8+width/10.7+width/10.7+width/26.7+width/26.7, width*5/6, width/2.5)];
    uiPatePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
//    添加事件
    [uiPatePicker addTarget:self action:@selector(tzshuj) forControlEvents:UIControlEventValueChanged];
    
    
    uiPatePicker.locale = locale;
    [bgView addSubview:uiPatePicker];
 
    sendAssessLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, uiPatePicker.frame.size.height+uiPatePicker.frame.origin.y+width/8.4, width*7/9, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchProjectList)];
    sendAssessLabel.userInteractionEnabled=YES;
    [sendAssessLabel addGestureRecognizer:loginRecognizer];
    [sendAssessLabel setText:@"查看选定时间课程"];
    [sendAssessLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [sendAssessLabel setTextAlignment:NSTextAlignmentCenter];
    [sendAssessLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [sendAssessLabel setBackgroundColor:[UIColor whiteColor]];
    sendAssessLabel.layer.borderColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0].CGColor;
    sendAssessLabel.layer.cornerRadius=16.0;
    sendAssessLabel.layer.borderWidth = 1; //要设置的描边宽
    sendAssessLabel.layer.masksToBounds=YES;
    [bgView addSubview:sendAssessLabel];
    
}
//值发生改变时
-(void)tzshuj
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
    NSDate *selected1 = [uiPatePicker date];
    NSString *date2=[dateFormatter1 stringFromDate:selected1];
    
    if (locationString.doubleValue>date2.doubleValue) {
        [keyTextField setText:@"时间已过期"];
        keyTextField.textColor=[UIColor grayColor];
        sendAssessLabel.userInteractionEnabled=NO;
        sendAssessLabel.textColor=[UIColor grayColor];
    }
    
    else
    {
        sendAssessLabel.textColor=[UIColor orangeColor];
        sendAssessLabel.userInteractionEnabled=YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selected = [uiPatePicker date];
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
                        
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
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
    NSString *data=keyTextField.text;
    NSDate *selected = [uiPatePicker date];
    NSString *date=[dateFormatter stringFromDate:selected];
    NSUserDefaults *src=[NSUserDefaults standardUserDefaults];
    [src setObject:date forKey:@"kp"];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        [HttpHelper searchData:aid withData:data withDate:date  success:^(HttpModel *model){
//          
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
//                    NSDictionary *result=model.result;
//                    
//                    ary=(NSArray *)[result objectForKey:@"lesson"];
//                    NSLog(@"tabl----%@",ary);
//                    NSUserDefaults *skp=[NSUserDefaults standardUserDefaults];
//                    [skp setObject:ary forKey:@"ary"];
//                    
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
////                        [projectTableView reloadData];
//                    });
//                    
//                    
//                }else{
//                    
//                }
//                [ProgressHUD dismiss];
//                
//                
//                
//                
//            });
//        }failure:^(NSError *error){
//            if (error.userInfo!=nil) {
//                NSLog(@"%@",error.userInfo);
//                
//            }
//            [ProgressHUD dismiss];
//            
//        }];
//        
//        
//    });

    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    [projectListViewController setTitleName:@"搜索结果"];
    [projectListViewController setstd:2];
    [self presentViewController:projectListViewController animated:YES completion:nil];
//    [projectListViewController searchData:data withTime:date withAid:aid];


}

-(void)getLessonCount{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selected = [uiPatePicker date];
    NSString *date1=[dateFormatter stringFromDate:selected];
    NSLog(@"1111111---\n\n%@  ppppp", date1);
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
                        
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6,[[NSString stringWithFormat:@"%@",number] length])];
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