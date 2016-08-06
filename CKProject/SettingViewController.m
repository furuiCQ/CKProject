//
//  SettingViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "SettingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:240.f/255.f green:244.f/255.f blue:247.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initContentView];
    
    // Do any additional setup after loading the view, typically from a nib.
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
    [searchLabel setText:@"设置"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    [msgLabel setBackgroundColor:[UIColor greenColor]];
    [msgLabel setText:@"未知"];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    // int height=self.view.frame.size.height;
    UIControl *aboutView=[[UIControl alloc]initWithFrame:CGRectMake(0, titleHeight+20, width, titleHeight)];
    [aboutView setBackgroundColor:[UIColor whiteColor]];
    UILabel *aboutlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, (titleHeight-width/23.7)/2, width/3, width/23.7)];
    [aboutlabel setText:@"关于我们"];
    [aboutlabel setFont:[UIFont systemFontOfSize:width/23.7]];
    [aboutView addSubview:aboutlabel];
    UIImageView *aboutRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/45.7-width/26, (width/6.5-width/17.8)/2, width/26, width/17.8)];
    [aboutRight setImage:[UIImage imageNamed:@"right_logo"]];
    [aboutView addSubview:aboutRight];
    [self.view addSubview:aboutView];
    
    
    
    //绑定跳转至关于我们界面
    [aboutView addTarget:self action:@selector(toAboutUsViewControll) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIControl *clearView=[[UIControl alloc]initWithFrame:CGRectMake(0, titleHeight+20+titleHeight+0.5, width, titleHeight)];
    [clearView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *clearlabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14.5, (titleHeight-width/23.7)/2, width/3, width/23.7)];
    [clearlabel setText:@"清空缓存"];
    [clearlabel setFont:[UIFont systemFontOfSize:width/23.7]];
    [clearView addSubview:clearlabel];
    
    UIImageView *clearRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/45.7-width/26, (width/6.5-width/17.8)/2, width/26, width/17.8)];
    [clearRight setImage:[UIImage imageNamed:@"right_logo"]];
    
    [clearView addSubview:clearRight];
    UITapGestureRecognizer *gestureRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getjuste)];
    [clearView addGestureRecognizer:gestureRecognizer1];
    [clearView setUserInteractionEnabled:YES];
    // [clearView addSubview:sizeLabel];
    
    
    [self.view addSubview:clearView];
    
    
    //    UILabel *logoutLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20, titleHeight+20+titleHeight/8+titleHeight+0.5+titleHeight+titleHeight, width*9/10, width/8.7)];
    //    UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logout)];
    //    [logoutLabel addGestureRecognizer:gestureRecognizer];
    //    [logoutLabel setUserInteractionEnabled:YES];
    //    [logoutLabel setText:@"退出账号"];
    //    [logoutLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    //    [logoutLabel setTextAlignment:NSTextAlignmentCenter];
    //    [logoutLabel setTextColor:[UIColor orangeColor]];
    //    logoutLabel.layer.borderColor=[UIColor orangeColor].CGColor;
    //    logoutLabel.layer.cornerRadius=15.0;
    //    logoutLabel.layer.borderWidth = 1; //要设置的描边宽
    //    logoutLabel.layer.masksToBounds=YES;
    //    [self.view addSubview:logoutLabel];
}
//－－－－－－－－－－－－－－－－－－－－－－
-(void)getjuste
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
}
//－－－－－－－－－－－－－－－－－－－－－－－－
-(void)logout{
    AppDelegate *myDelegate = ( AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.model!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper logoutAcount:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        if (alertView==nil) {
                            alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alertView.delegate=self;
                        }
                        [alertView setTag:1];
                        [alertView setMessage:model.message];
                        [alertView show];
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
}
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)uiAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
    switch (uiAlertView.tag) {
        case 1:
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)toAboutUsViewControll{
    AboutViewController *aboutViewController=[[AboutViewController alloc]init];
    [self presentViewController: aboutViewController animated:YES completion:nil];
    
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
