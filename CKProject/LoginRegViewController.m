//
//  LoginRegViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "LoginRegViewController.h"

@interface LoginRegViewController ()

@end

@implementation LoginRegViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initBottomView];
    [self initLogoView];
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
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setText:@"登录注册"];
    
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initBottomView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, height-width/5-width/8.6, width*7/9, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"登录"];
    [loginLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    loginLabel.layer.borderColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0].CGColor;
    loginLabel.layer.cornerRadius=16.0;
    loginLabel.layer.borderWidth = 1; //要设置的描边宽
    loginLabel.layer.masksToBounds=YES;
    [self.view addSubview:loginLabel];
    
    
    UILabel *registerLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, height-width/5-width/8.6-width/8.6-width/45.7, width*7/9, width/8.6)];
    registerLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRegisterViewController)];
    [registerLabel addGestureRecognizer:registerRecognizer];
    [registerLabel setText:@"极速注册"];
    [registerLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [registerLabel setTextAlignment:NSTextAlignmentCenter];
    [registerLabel setTextColor:[UIColor whiteColor]];
    [registerLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    registerLabel.layer.borderColor=[UIColor orangeColor].CGColor;
    registerLabel.layer.cornerRadius=16.0;
    registerLabel.layer.borderWidth = 1; //要设置的描边宽
    registerLabel.layer.masksToBounds=YES;
    [self.view addSubview:registerLabel];
    
}
-(void)initLogoView{
    int width=self.view.frame.size.width;
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake((width-width/3.5)/2, titleHeight+20+width/5, width/3.5, width/3.5)];
    [logoView setImage:[UIImage imageNamed:@"login_defalut"]];
    logoView.layer.cornerRadius=25.0;
    logoView.layer.masksToBounds=YES;
    [self.view addSubview:logoView];
    
    UIImageView *msgImageView=[[UIImageView alloc]initWithFrame:CGRectMake((width-width/2)/2, logoView.frame.size.height+logoView.frame.origin.y, width/2, width/5.6)];
    [msgImageView setImage:[UIImage imageNamed:@"loadfont.jpg"]];

    [self.view addSubview:msgImageView];
}
-(void)goLoginViewController{
    LoginViewController *loginViewController=[[LoginViewController alloc]init];
    [self presentViewController: loginViewController animated:YES completion:nil];
}
-(void)goRegisterViewController{
    RegisterViewController *registerViewController=[[RegisterViewController alloc]init];
    [self presentViewController: registerViewController animated:YES completion:nil];
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end