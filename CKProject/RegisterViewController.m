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
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"填写手机号"];
    

    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initCotentView{
    
    
    int width=self.view.frame.size.width;
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40, width, titleHeight)];
    [userTextFiled setBackgroundColor:[UIColor whiteColor]];
    [userTextFiled setPlaceholder:@"请输入手机号码"];
    [userTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [userTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self setTextFieldLeftPadding:userTextFiled forWidth:width/21];
    [self.view addSubview:userTextFiled];
    
    codeTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight+0.5, width*2/3, titleHeight)];
    [codeTextFiled setBackgroundColor:[UIColor whiteColor]];
    [codeTextFiled setPlaceholder:@"请输入手机验证码"];
    [codeTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [codeTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [codeTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [self setTextFieldLeftPadding:codeTextFiled forWidth:width/21];
    [self.view addSubview:codeTextFiled];
    
    codeLabel=[[UIButton alloc]initWithFrame:CGRectMake(width*2/3, titleHeight+20+width/40+titleHeight+0.5, width/3, titleHeight)];
    UITapGestureRecognizer *getCodeGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsg)];
    [codeLabel addGestureRecognizer:getCodeGesture];
    [codeLabel setTitle:@"获取验证码" forState: UIControlStateNormal];
    [codeLabel setBackgroundColor:[UIColor whiteColor]];
    [codeLabel setUserInteractionEnabled:YES];
    [codeLabel setTitleColor :[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]forState:UIControlStateNormal];
    [codeLabel.titleLabel setFont:[UIFont systemFontOfSize:width/32]];
    [self.view addSubview:codeLabel];
    
    
    passTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight+0.5+titleHeight+0.5, width
                                                               , titleHeight)];
    [passTextFiled setBackgroundColor:[UIColor whiteColor]];
    [passTextFiled setPlaceholder:@"请输入密码"];
    [passTextFiled setSecureTextEntry:YES];
    [passTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [passTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [passTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [self setTextFieldLeftPadding:passTextFiled forWidth:width/21];
    [self.view addSubview:passTextFiled];
    
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20, width*7/9, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"下一步"];
    [loginLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    loginLabel.layer.borderColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0].CGColor;
    loginLabel.layer.cornerRadius=16.0;
    loginLabel.layer.borderWidth = 1; //要设置的描边宽
    loginLabel.layer.masksToBounds=YES;
    [self.view addSubview:loginLabel];
    
    checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(width/5-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/22.8, width/22.8)];
    [checkBtn setImage:[UIImage imageNamed:@"deal_uncheck"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"deal_check"] forState:UIControlStateSelected];
     checkBtn.selected=YES;
    [checkBtn addTarget:self action:@selector(checkOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    UILabel *forgetLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/3-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/3, width/20)];
    [forgetLabel setFont:[UIFont systemFontOfSize:width/29]];
    [forgetLabel setTextAlignment:NSTextAlignmentRight];
    [forgetLabel setText:@"我已阅读并同意"];
    [forgetLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [self.view addSubview:forgetLabel];
    
    UILabel *clauseLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/80, titleHeight+20+width/40+titleHeight+0.5+titleHeight+titleHeight+0.5+width/20+width/9+width/40, width/4 , width/20)];
    UITapGestureRecognizer *forgetRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showClause)];
    clauseLabel.userInteractionEnabled=YES;
    [clauseLabel addGestureRecognizer:forgetRecognizer];
    [clauseLabel setFont:[UIFont systemFontOfSize:width/29]];
    [clauseLabel setTextAlignment:NSTextAlignmentLeft];
    [clauseLabel setText:@"蹭课服务条款"];
    [clauseLabel setTextColor:[UIColor orangeColor]];
    [self.view addSubview:clauseLabel];
    
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

@end