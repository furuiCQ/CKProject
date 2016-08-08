//
//  ChangePhoneViewController.m
//  CKProject
//
//  Created by furui on 16/8/8.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "ChangePassViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface ChangePassViewController (){

}

@end

@implementation ChangePassViewController
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
    [searchLabel setText:@"修改密码"];
    
    [topView addSubview:cityLabel];
    //[topView addSubview:msgLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
    
}
static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";

-(void)initContentView{
    int width=self.view.frame.size.width;
    UITextField *oldPass=[[UITextField alloc]initWithFrame:CGRectMake(width/32, titleHeight+20+width/31, width-width/16, width/8)];
    [oldPass.layer setCornerRadius:3];
    [oldPass setBackgroundColor:[UIColor whiteColor]];
    [oldPass setPlaceholder:@" 请输入旧密码"];
    [oldPass setSecureTextEntry:YES];
    oldPass.clearButtonMode = UITextFieldViewModeAlways;
    
    [oldPass setValue:[UIColor blackColor] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:oldPass];
    
    UITextField *newPass=[[UITextField alloc]initWithFrame:CGRectMake(width/32, oldPass.frame.size.height+oldPass.frame.origin.y+width/31, width-width/16, width/8)];
    [newPass.layer setCornerRadius:3];
    [newPass setBackgroundColor:[UIColor whiteColor]];
    [newPass setPlaceholder:@" 请输入新密码"];
    [newPass setSecureTextEntry:YES];
    newPass.clearButtonMode = UITextFieldViewModeAlways;
    [newPass setValue:[UIColor blackColor] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:newPass];
    
    UILabel *confirmLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8.6, newPass.frame.size.height+newPass.frame.origin.y+width/31, width-width/8.6*2, width/8)];
    [confirmLabel setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [confirmLabel setText:@"保存"];
    [confirmLabel setTextColor:[UIColor whiteColor]];
    [confirmLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:confirmLabel];
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end