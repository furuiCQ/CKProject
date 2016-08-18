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
    //[self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:imageView];
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
    [searchLabel setText:@"重置密码"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRegisterViewController)];
    [msgLabel addGestureRecognizer:registerRecognizer];
    [msgLabel setText:@"注册"];
    [msgLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/22.8]];
    [msgLabel setTextColor:[UIColor orangeColor]];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    [titleView addSubview:cityLabel];
    // [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}

-(void)initCotentView{
    
    
    int width=self.view.frame.size.width;
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, titleHeight+20+width/5.3, width-width/4, titleHeight)];
    [userTextFiled setPlaceholder:@"请输入11位手机号"];
    [userTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:userTextFiled];
    
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, userTextFiled.frame.size.height+userTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line1View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line1View];
    
    
    codeTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line1View.frame.size.height+line1View.frame.origin.y, width-width/4-titleHeight*2, titleHeight)];
    [codeTextFiled setPlaceholder:@"请输入验证码"];
    [codeTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [codeTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:codeTextFiled];
    
    sendLabel=[[UIButton alloc]initWithFrame:CGRectMake(width*2/3, line1View.frame.size.height+line1View.frame.origin.y, titleHeight*2, titleHeight)];
    UITapGestureRecognizer *getCodeGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsg)];
    [sendLabel addGestureRecognizer:getCodeGesture];
    [sendLabel setUserInteractionEnabled:YES];
    [sendLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
    [sendLabel setTitleColor :[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]forState:UIControlStateNormal];
    [sendLabel.titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [self.view addSubview:sendLabel];
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, codeTextFiled.frame.size.height+codeTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line2View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line2View];
    
    
    pasTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line2View.frame.size.height+line2View.frame.origin.y, width-width/4-titleHeight, titleHeight)];
    [pasTextFiled setPlaceholder:@"请输入新密码"];
    [pasTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [pasTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [pasTextFiled setSecureTextEntry:YES];
    [self.view addSubview:pasTextFiled];
    UIButton *showPasImageView=[[UIButton alloc]initWithFrame:CGRectMake(pasTextFiled.frame.size.width+pasTextFiled.frame.origin.x, pasTextFiled.frame.origin.y, titleHeight, titleHeight)];
    [showPasImageView setImage:[UIImage imageNamed:@"hid_pas"] forState:UIControlStateNormal];
    [showPasImageView setImage:[UIImage imageNamed:@"show_pas"] forState:UIControlStateHighlighted];
    [showPasImageView addTarget:self action:@selector(hidPas) forControlEvents:UIControlEventTouchUpInside];
    [showPasImageView addTarget:self action:@selector(showPas) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:showPasImageView];
    
    UIView *line3View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, pasTextFiled.frame.size.height+pasTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line3View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line3View];
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8, line3View.frame.size.height+line3View.frame.origin.y+width/16, width-width/4, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"确定"];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:100.f/255.f blue:103.f/255.f alpha:1.0]];
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
    sendLabel = [[UIButton alloc] initWithFrame:frame];
    [sendLabel setTitle:@"发送短信" forState: UIControlStateNormal];
    [sendLabel setTintColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    //[alertView setTag:1];
                    [codeTextFiled setText:[NSString stringWithFormat:@""]];
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


//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    NSLog(@"secondsCountDown%d",secondsCountDown);
    if (secondsCountDown == 1) {
        [theTimer invalidate];
        secondsCountDown = 60;
        [sendLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
        [sendLabel setTintColor:[UIColor blackColor]];
        [sendLabel setEnabled:YES];
    }else{
        secondsCountDown--;
        NSString *title = [NSString stringWithFormat:@"重新发送(%d秒)",secondsCountDown];
        [sendLabel setTitle:title forState: UIControlStateNormal];
        [sendLabel setTintColor:[UIColor grayColor
                                 ]];
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
                    
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                        NSNotification *notification =[NSNotification notificationWithName:@"autologin" object:self userInfo:@{@"tel":phone,@"pas":pasword}];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
    [self releaseTImer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)hidPas{
    NSLog(@"hidPas");
    [pasTextFiled setSecureTextEntry:YES];
}
-(void)showPas{
    NSLog(@"showPas");
    [pasTextFiled setSecureTextEntry:NO];
    
}

@end