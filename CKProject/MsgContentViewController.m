//
//  MsgContentViewController.m
//  CKProject
//
//  Created by 凌甫 刘pro on 16/1/13.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "MsgContentViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface MsgContentViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSArray *tableArray;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UITextView *contentTextView;
}

@end

@implementation MsgContentViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize chooseImageView;
@synthesize titleView;
@synthesize contentView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [self initTitle];
    [self initContentView];
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
    [searchLabel setText:@"消息内容"];
    
    
    
    [topView addSubview:cityLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
    
}

-(void)initContentView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(width/45.7, titleHeight+20+width/45.7, width-width/45.7*2, height-(titleHeight+20+width/45.7)-width/26.7)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, width/24.6, width, width/22.8)];
    [titleLabel setText:@"中国文学大典"];
    [titleLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [titleLabel setTextColor:[UIColor colorWithRed:68.f/255.f green:68.f/255.f blue:68.f/255.f alpha:1.0]];
    [bgView addSubview:titleLabel];
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, titleLabel.frame.size.height+titleLabel.frame.origin.y+width/26.7, width, width/35)];
    [timeLabel setText:@"2015-11-12"];
    [timeLabel setFont:[UIFont systemFontOfSize:width/35
                        ]];
    [timeLabel setTextColor:[UIColor colorWithRed:195.f/255.f green:195.f/255.f blue:195.f/255.f alpha:1.0]];
    [bgView addSubview:timeLabel];
    
    contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(width/20, timeLabel.frame.size.height+timeLabel.frame.origin.y, width-width/20*2, bgView.frame.size.height-(timeLabel.frame.size.height+timeLabel.frame.origin.y+width/29)-width/26.7)];
    [contentTextView setText:@"中国四书五经"];
    [contentTextView setUserInteractionEnabled:NO];
    [contentTextView setEditable:false];
    [contentTextView setFont:[UIFont systemFontOfSize:width/29]];
    [contentTextView setTextColor:[UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1.0]];
    [bgView addSubview:contentTextView];
    
    [self.view addSubview:bgView];
}
-(void)setContent:(NSString *)title withTime:(NSNumber *)btime withContent:(NSString *)content withId:(NSNumber *)msgId{
    
    [titleLabel setText:[NSString stringWithFormat:@"%@",title]];
    
    NSInteger myInteger = [btime integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    [timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
    [contentTextView setText:[NSString stringWithFormat:@"%@",content]];
    
    [self readMsg:msgId];
}
-(void)readMsg:(NSNumber *)msgId{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper getMsgInfo:msgId withModel:delegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    
                    
                }else{
                    
                }
               // [ProgressHUD dismiss];
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
           // [ProgressHUD dismiss];
            
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