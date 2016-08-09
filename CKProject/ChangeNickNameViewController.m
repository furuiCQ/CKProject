//
//  ChangePhoneViewController.m
//  CKProject
//
//  Created by furui on 16/8/8.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface ChangeNickNameViewController (){
    UITextField *oldPass;
    UIAlertView *alertView;
}

@end

@implementation ChangeNickNameViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view  setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:244.f/255.f blue:247.f/255.f alpha:1.0]];
    [self initTitle];
    [self initContentView];
    // Do any additional setup after loading the view, typically from a nib.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [topView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
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
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"修改昵称"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0,self.view.frame.size.width/6, titleHeight)];
    [msgLabel setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *menuapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(save)];
    [msgLabel addGestureRecognizer:menuapGestureRecognizer];
    [msgLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [msgLabel setText:@"保存"];
    [msgLabel setTextColor:[UIColor whiteColor]];

    [topView addSubview:cityLabel];
    [topView addSubview:msgLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
    
}
static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";
-(void)initContentView{
    int width=self.view.frame.size.width;
    oldPass=[[UITextField alloc]initWithFrame:CGRectMake(width/32, titleHeight+20+width/31, width-width/16, width/8)];
    [oldPass.layer setCornerRadius:3];
    [oldPass setBackgroundColor:[UIColor whiteColor]];
    [oldPass setPlaceholder:@" 请输入昵称"];
    oldPass.clearButtonMode = UITextFieldViewModeAlways;
    [oldPass setValue:[UIColor blackColor] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:oldPass];
    
}
-(void)setNickName:(NSString *)nickname{
    [oldPass setText:nickname];
}
-(void)save{
    NSLog(@"save");
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [HttpHelper resetName:oldPass.text withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        NSNotification *notification =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }];
                }else{
                    [alertView setMessage:model.message];
                    [alertView show];
                    
                }
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
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