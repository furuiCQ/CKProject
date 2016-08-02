//
//  ForgetViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "ForgetViewController.h"
#import "LoginViewController.h"
@interface ForgetViewController ()

@end

@implementation ForgetViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize userTextFiled;
@synthesize codeTextFiled;
@synthesize pasTextFiled;
@synthesize sendLabel;
@synthesize alertView;
@synthesize timer;
@synthesize secondsCountDown;

static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown=60;
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initCotentView];
    
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
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"设置新密码"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRegisterViewController)];
    [msgLabel addGestureRecognizer:registerRecognizer];
    [msgLabel setText:@"注册"];
    [msgLabel setTextColor:[UIColor orangeColor]];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initCotentView{
    int width=self.view.frame.size.width;
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40, width, titleHeight)];
    [userTextFiled setBackgroundColor:[UIColor whiteColor]];
    [userTextFiled setPlaceholder:@"手机号"];
    [userTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(myDelegate.model.tel!=nil && ![myDelegate.model.tel isEqual:[NSNull null]]){
        [userTextFiled setText:[NSString stringWithFormat:@"%@", myDelegate.model.tel]];
    }
    [userTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self setTextFieldLeftPadding:userTextFiled forWidth:width/21];
    [self.view addSubview:userTextFiled];
    
    
    codeTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight+0.5, width, titleHeight)];
    
    [codeTextFiled setBackgroundColor:[UIColor whiteColor]];
    [codeTextFiled setPlaceholder:@"请输入验证码"];
    [codeTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [codeTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [codeTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self setTextFieldLeftPadding:codeTextFiled forWidth:width/20];
    [self setTextFieldRightView:codeTextFiled forWidth:width/3];
    [self.view addSubview:codeTextFiled];
    
    pasTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight+1+titleHeight, width, titleHeight)];
    [pasTextFiled setBackgroundColor:[UIColor whiteColor]];
    [pasTextFiled setPlaceholder:@"设置新密码"];
    [pasTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [pasTextFiled setFont:[UIFont systemFontOfSize:12]];
    [pasTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [pasTextFiled setSecureTextEntry:YES];
    [self setTextFieldLeftPadding:pasTextFiled forWidth:width/21];
    [self.view addSubview:pasTextFiled];
    
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/10, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+1+width/20, width*8/10, width/9)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    
    
    
    [loginLabel setText:@"确定"];
    [loginLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    loginLabel.layer.borderColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0].CGColor;
    loginLabel.layer.cornerRadius=16.0;
    loginLabel.layer.borderWidth = 1; //要设置的描边宽
    loginLabel.layer.masksToBounds=YES;
    [self.view addSubview:loginLabel];
    
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)setTextFieldRightView:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    sendLabel = [[UILabel alloc] initWithFrame:frame];
    [sendLabel setText:@"发送短信"];
    [sendLabel setTextAlignment:NSTextAlignmentCenter];
    [sendLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsg)];
    sendLabel.userInteractionEnabled=YES;
    [sendLabel addGestureRecognizer:loginRecognizer];
    [sendLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/26.7]];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = sendLabel;
}
-(void)sendMsg{
    NSLog(@"发送短信中....");
    NSString *phone=userTextFiled.text;
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    if(phone==nil ||[phone isEqualToString:@""]){
        [alertView setMessage:@"手机号不能为空！"];
        [alertView show];
        return;
    }
    
    if (timer==nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
     
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getMsgCode:phone success:^(HttpModel *model){
            NSLog(@"111111111111-%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    //[alertView setTag:1];
                    NSNumber *code=(NSNumber *)model.message;
                    [codeTextFiled setText:[NSString stringWithFormat:@""]];
//                    [self releaseTImer];
                }else{
                    
                }
            });
            // [alertView setMessage:model.message];
            // [alertView show];
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
        
    });
    
}


//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    NSLog(@"secondsCountDown%d",secondsCountDown);
    if (secondsCountDown == 1) {
        [theTimer invalidate];
        secondsCountDown = 60;
        [sendLabel setText:@"获取验证码" ];
        [sendLabel setTextColor:[UIColor blackColor]];
        [sendLabel setEnabled:YES];
    }else{
        secondsCountDown--;
        NSString *title = [NSString stringWithFormat:@"重新发送(%d秒)",secondsCountDown];
        [sendLabel setText:title ];
        [sendLabel setTextColor:[UIColor grayColor]];
        [sendLabel setEnabled:NO];
    }
}
//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                timer=nil;
                secondsCountDown = 60;
            }
        }
    }
}
-(void)goLoginViewController{
    NSString *phone=userTextFiled.text;
    NSString *code=codeTextFiled.text;
    NSString *pasword=pasTextFiled.text;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper resetPassowrd:phone andCode:code andPas:pasword success:^(HttpModel *model){
           

            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                        NSNotification *notification =[NSNotification notificationWithName:@"autologin" object:self userInfo:@{@"tel":phone,@"pas":pasword}];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                        
//                        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"提示" message:model.message delegate:@selector(goforlogin) cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                  
//                       alt show
                        
                    }];
                    [self releaseTImer];
                    [alertView setMessage:model.message];
                    [alertView show];
                    LoginViewController *li=[[LoginViewController alloc]init];
                    [self presentViewController:li animated:YES completion:nil];

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
-(void)goRegisterViewController{
    NSLog(@"goRegister");
    
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end