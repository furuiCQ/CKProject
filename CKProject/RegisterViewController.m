//
//  RegisterViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProgressHUD/ProgressHUD.h"
@interface RegisterViewController (){
    UIButton *checkBtn;
    UILabel *loginLabel;
}

@end

@implementation RegisterViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize userTextFiled;
@synthesize codeTextFiled;
@synthesize passTextFiled;
@synthesize timer;
@synthesize codeLabel;
@synthesize alertView;
static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";
int secondsCountDown; //倒计时总时长

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown=60;
    //[self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:imageView];
    
    [self initTitle];
    [self initCotentView];
    [self initOtherLoginView];
    
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
    [searchLabel setText:@"注册"];
    
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
//-(void)initCotentView{
//    int width=self.view.frame.size.width;
//
//    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, titleHeight+20+width/4.9, width-width/4, titleHeight)];
//    [userTextFiled setPlaceholder:@"手机号"];
//    [userTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
//    [userTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
//    [self.view addSubview:userTextFiled];
//
//    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, userTextFiled.frame.size.height+userTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
//    [line1View setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:line1View];
//
//    pasTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line1View.frame.size.height+line1View.frame.origin.y, width-width/4-titleHeight, titleHeight)];
//    [pasTextFiled setPlaceholder:@"请输入密码"];
//    [pasTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
//    [pasTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
//    [pasTextFiled setSecureTextEntry:YES];
//    [self.view addSubview:pasTextFiled];
//    UIButton *showPasImageView=[[UIButton alloc]initWithFrame:CGRectMake(pasTextFiled.frame.size.width+pasTextFiled.frame.origin.x, pasTextFiled.frame.origin.y, titleHeight, titleHeight)];
//    [showPasImageView setImage:[UIImage imageNamed:@"hid_pas"] forState:UIControlStateNormal];
//    [showPasImageView setImage:[UIImage imageNamed:@"show_pas"] forState:UIControlStateHighlighted];
//    [showPasImageView addTarget:self action:@selector(hidPas) forControlEvents:UIControlEventTouchUpInside];
//    [showPasImageView addTarget:self action:@selector(showPas) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:showPasImageView];
//
//    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(pasTextFiled.frame.origin.x, pasTextFiled.frame.size.height+pasTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
//    [line2View setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:line2View];
//
//
//    UILabel *forgetLabel=[[UILabel alloc]initWithFrame:CGRectMake(line2View.frame.origin.x, line2View.frame.size.height+line2View.frame.origin.y+width/32, width/4 , width/20)];
//    UITapGestureRecognizer *forgetRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goForgetViewController)];
//    forgetLabel.userInteractionEnabled=YES;
//    [forgetLabel addGestureRecognizer:forgetRecognizer];
//    [forgetLabel setFont:[UIFont systemFontOfSize:width/26.7]];
//    [forgetLabel setTextAlignment:NSTextAlignmentLeft];
//    [forgetLabel setText:@"忘记密码？"];
//    [forgetLabel setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
//    [self.view addSubview:forgetLabel];
//
//
//    UILabel *registerLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/4-line2View.frame.origin.x, line2View.frame.size.height+line2View.frame.origin.y+width/32, width/4 , width/20)];
//    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRegisterViewController)];
//    registerLabel.userInteractionEnabled=YES;
//    [registerLabel addGestureRecognizer:registerRecognizer];
//    [registerLabel setFont:[UIFont systemFontOfSize:width/26.7]];
//    [registerLabel setTextAlignment:NSTextAlignmentRight];
//    [registerLabel setText:@"立即注册"];
//    [registerLabel setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
//    [self.view addSubview:registerLabel];
//
//    //16
//    loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8, forgetLabel.frame.size.height+forgetLabel.frame.origin.y+width/16, width-width/4, width/8.6)];
//    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
//    loginLabel.userInteractionEnabled=YES;
//    [loginLabel addGestureRecognizer:loginRecognizer];
//    [loginLabel setText:@"登录"];
//    [loginLabel setTextAlignment:NSTextAlignmentCenter];
//    [loginLabel setTextColor:[UIColor whiteColor]];
//    [loginLabel setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:100.f/255.f blue:103.f/255.f alpha:1.0]];
//    [self.view addSubview:loginLabel];
//
//
//
//}
-(void)initCotentView{
    
    
    int width=self.view.frame.size.width;
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, titleHeight+20+width/4.9, width-width/4, titleHeight)];
    [userTextFiled setPlaceholder:@"请输入11位手机号"];
    [userTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:userTextFiled];
    
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, userTextFiled.frame.size.height+userTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line1View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line1View];
    
    
    codeTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line1View.frame.size.height+line1View.frame.origin.y, width-width/4-titleHeight*2, titleHeight)];
    [codeTextFiled setPlaceholder:@"请输入手机验证码"];
    [codeTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [codeTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:codeTextFiled];
    
    codeLabel=[[UIButton alloc]initWithFrame:CGRectMake(width*2/3, line1View.frame.size.height+line1View.frame.origin.y, titleHeight*2, titleHeight)];
    UITapGestureRecognizer *getCodeGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsg)];
    [codeLabel addGestureRecognizer:getCodeGesture];
    [codeLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
    [codeLabel setUserInteractionEnabled:YES];
    [codeLabel setTitleColor :[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]forState:UIControlStateNormal];
    [codeLabel.titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [self.view addSubview:codeLabel];
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, codeTextFiled.frame.size.height+codeTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line2View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line2View];
    
    
    passTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line2View.frame.size.height+line2View.frame.origin.y, width-width/4-titleHeight, titleHeight)];
    [passTextFiled setPlaceholder:@"请输入密码"];
    [passTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [passTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [passTextFiled setSecureTextEntry:YES];
    [self.view addSubview:passTextFiled];
    UIButton *showPasImageView=[[UIButton alloc]initWithFrame:CGRectMake(passTextFiled.frame.size.width+passTextFiled.frame.origin.x, passTextFiled.frame.origin.y, titleHeight, titleHeight)];
    [showPasImageView setImage:[UIImage imageNamed:@"hid_pas"] forState:UIControlStateNormal];
    [showPasImageView setImage:[UIImage imageNamed:@"show_pas"] forState:UIControlStateHighlighted];
    [showPasImageView addTarget:self action:@selector(hidPas) forControlEvents:UIControlEventTouchUpInside];
    [showPasImageView addTarget:self action:@selector(showPas) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:showPasImageView];
    
    UIView *line3View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, passTextFiled.frame.size.height+passTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line3View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line3View];
    
    loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8, line3View.frame.size.height+line3View.frame.origin.y+width/16, width-width/4, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"登录"];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:100.f/255.f blue:103.f/255.f alpha:1.0]];
    [self.view addSubview:loginLabel];
    
    //    checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(width/5-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/22.8, width/22.8)];
    //    [checkBtn setImage:[UIImage imageNamed:@"deal_uncheck"] forState:UIControlStateNormal];
    //    [checkBtn setImage:[UIImage imageNamed:@"deal_check"] forState:UIControlStateSelected];
    //     checkBtn.selected=YES;
    //    [checkBtn addTarget:self action:@selector(checkOnclick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:checkBtn];
    //
    //    UILabel *forgetLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/3-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/3, width/20)];
    //    [forgetLabel setFont:[UIFont systemFontOfSize:width/29]];
    //    [forgetLabel setTextAlignment:NSTextAlignmentRight];
    //    [forgetLabel setText:@"我已阅读并同意"];
    //    [forgetLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    //    [self.view addSubview:forgetLabel];
    //
    //    UILabel *clauseLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/4 , width/20)];
    //    UITapGestureRecognizer *forgetRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showClause)];
    //    clauseLabel.userInteractionEnabled=YES;
    //    [clauseLabel addGestureRecognizer:forgetRecognizer];
    //    [clauseLabel setFont:[UIFont systemFontOfSize:width/29]];
    //    [clauseLabel setTextAlignment:NSTextAlignmentLeft];
    //    [clauseLabel setText:@"蹭课服务条款"];
    //    [clauseLabel setTextColor:[UIColor orangeColor]];
    //    [self.view addSubview:clauseLabel];
    //
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)checkOnclick:(UIButton *)btn{
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        //[self collectionProject];
    }else{
        // [self deleteProject];
    }
}
-(void)showClause{
    //展示协议
    UserDealViewController *userDealViewController=[[UserDealViewController alloc]init];
    [self presentViewController: userDealViewController animated:YES completion:nil];
    
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
            NSLog(@"%@",model.message);
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.model=model;
                //[alertView setTag:1];
                NSNumber *code=(NSNumber *)model.message;
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [codeTextFiled setText:[numberFormatter stringFromNumber:code]];
                });
                //[self releaseTImer];
            }else{
                
            }
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
        [codeLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
        [codeLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [codeLabel setEnabled:YES];
    }else{
        secondsCountDown--;
        NSString *title = [NSString stringWithFormat:@"重新发送(%d秒)",secondsCountDown];
        [codeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [codeLabel setEnabled:NO];
        [codeLabel setTitle:title forState:UIControlStateNormal];
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
                [codeLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
                [codeLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [codeLabel setEnabled:YES];
            }
        }
    }
}
-(void)goLoginViewController{
    if (!checkBtn.selected) {
        [ProgressHUD showError:@"请阅读并同意蹭课服务条款"];
        return;
    }
    NSString *phone=userTextFiled.text;
    NSString *code=codeTextFiled.text;
    NSString *password=passTextFiled.text;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper registerAcount:phone withCode:code withPassword:password success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更UI
                [self releaseTImer];
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    CompleDataViewController *compleDataViewController=[[CompleDataViewController alloc]init];
                    [compleDataViewController setPhone:phone];
                    [compleDataViewController setPassword:password];
                    
                    
                    
                    
                    
                    
                    [self presentViewController: compleDataViewController animated:YES completion:nil];
                    
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
    // NSLog(@"点点点");
    [self releaseTImer];
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
    }];
}

-(void)initOtherLoginView{
    int width=self.view.frame.size.width;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width/26.7*9)/2, loginLabel.frame.size.height+loginLabel.frame.origin.y+width/3.2, width/26.7*9, width/26.7)];
    [titleLabel setText:@"或使用合作账号登录"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [titleLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [self.view addSubview:titleLabel];
    
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(width/8.9, loginLabel.frame.size.height+loginLabel.frame.origin.y+width/3,  width/5.2, 0.5)];
    [line1View setBackgroundColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [self.view addSubview:line1View];
    
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake((width-width/8.9)-width/5.2,loginLabel.frame.size.height+loginLabel.frame.origin.y+width/3, width/5.2, 0.5)];
    [line2View setBackgroundColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [self.view addSubview:line2View];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y+width/6.4, width, width/3)];
    [self.view addSubview:view];
    
    NSArray *otherArray= [NSArray arrayWithObjects:@"微博",@"微信",@"QQ", nil];
    NSArray *imageArray= [NSArray arrayWithObjects:@"wx_logo",@"qq_logo",@"weibo_logo", nil];
    
    
    
    for (int i=0; i<[otherArray count]; i++) {
        UIControl *control=[[UIControl alloc]initWithFrame:CGRectMake(width/3*i, 0, width/3, width/3)];
        [control setTag:i];
        [control addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [control setUserInteractionEnabled:YES];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((width/3-width/7)/2, 0, width/7, width/7)];
        [imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        [control addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((width/3-width/32*2)/2, width/8+width/10+width/64, width/32*2, width/32)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[otherArray objectAtIndex:i]];
        [label setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:width/32]];
        //  [control addSubview:label];
        
        if (![WXApi isWXAppInstalled] && i==1) {
            //[control setHidden:YES];
            
        }
        if (![WeiboSDK isWeiboAppInstalled] && i==0) {
           // [control setHidden:YES];
            
        }
        if (![TencentOAuth iphoneQQInstalled] && i==2) {
          //  [control setHidden:YES];
        }
        
        
        [view addSubview:control];
    }
    if(![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![TencentOAuth iphoneQQInstalled]){
//        [line1View setHidden:YES];
//        [titleLabel setHidden:YES];
//        [line2View setHidden:YES];
//        [view setHidden:YES];
        
        
    }
    
    
    
}
-(void)onClick:(id)sender{
    UIControl *control=(UIControl *)sender;
    NSLog(@"control===>%@",@"control");
    switch (control.tag) {
        case 0:
        //    [ShareTools loginWeibo];
            break;
        case 1:
        //    [self loginWeixin];
            break;
        case 2:
        //    [self loginQQ];
            break;
            
        default:
            break;
    }
}
-(void)hidPas{
    NSLog(@"hidPas");
    [passTextFiled setSecureTextEntry:YES];
}
-(void)showPas{
    NSLog(@"showPas");
    [passTextFiled setSecureTextEntry:NO];
    
}

@end