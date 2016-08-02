
//
//  AssessViewController.m
//  CKProject
//
//  Created by 凌甫 刘pro on 16/1/13.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "AssessViewController.h"

@interface AssessViewController ()<RatingBarDelegate>
{
    NSNumber *lvNumber;
}

@end

@implementation AssessViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize projectId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
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
    [searchLabel setText:@"评价"];
    
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

-(void)initContentView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 20+titleHeight+0.5, width, hegiht-(20+titleHeight+0.5))];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    
    
    UILabel *assesLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/21.3, width/8.4, width/26.7*4, width/26.7)];
    [assesLabel setText:@"课程评价"];
    [assesLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [assesLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [bgView addSubview:assesLabel];
    
    
    RatingBar *ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(width/21.3+width/26.7*4+width/2.5, width/8.4, width-(width/21.3+width/26.7*4+width/2.5), width/21.3)];
    [ratingBar setPadding:width/32];
    [ratingBar setImageDeselected:@"unselect_big_star" halfSelected:nil fullSelected:@"big_star" andDelegate:self];
    [bgView addSubview:ratingBar];
    
    
    UILabel *sendAssessLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, assesLabel.frame.size.height+assesLabel.frame.origin.y+width/8.4, width*7/9, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAssess)];
    sendAssessLabel.userInteractionEnabled=YES;
    [sendAssessLabel addGestureRecognizer:loginRecognizer];
    [sendAssessLabel setText:@"发布评价"];
    [sendAssessLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [sendAssessLabel setTextAlignment:NSTextAlignmentCenter];
    [sendAssessLabel setTextColor:[UIColor whiteColor]];
    [sendAssessLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    sendAssessLabel.layer.borderColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0].CGColor;
    sendAssessLabel.layer.cornerRadius=16.0;
    sendAssessLabel.layer.borderWidth = 1; //要设置的描边宽
    sendAssessLabel.layer.masksToBounds=YES;
    [bgView addSubview:sendAssessLabel];
 
}
-(void)ratingChanged:(float)newRating{
    lvNumber=[NSNumber numberWithFloat:newRating];
}
-(void)sendAssess{
    [ProgressHUD show:@"正在提交评价..."];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [HttpHelper setStar:projectId withLv:lvNumber withModel:myDelegate.model success:^(HttpModel *model){
                                       NSLog(@"%@",model.message);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                               });
                                               [self dismissViewControllerAnimated:YES completion:^{
                                                   NSNotification *notification =[NSNotification notificationWithName:@"refresh" object:nil];
                                                   [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                   
                                                   NSNotification *notification2 =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                                                   [[NSNotificationCenter defaultCenter] postNotification:notification2];

                                               }];
                                               
                                           }
                    //爱你是这一辈子最正确的决定
                                           
                                           else{
                                               
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

@end