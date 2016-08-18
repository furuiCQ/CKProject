//
//  LoginViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "LoginViewController.h"
#import "WeiboSDK.h"
#import "ShareTools.h"
#import <JGProgressHUD/JGProgressHUD.h>


@interface LoginViewController ()<UIAlertViewDelegate,WBHttpRequestDelegate,WXApiDelegate>{
    NSString *Otheruid;
    NSString *Othernickname;
    NSString *Othertoken;
    NSString *Othertype;
    //progress
    JGProgressHUD *HUD;
}

@end

@implementation LoginViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize loginLabel;
@synthesize userTextFiled;
@synthesize pasTextFiled;
@synthesize alertView;
static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";
TencentOAuth *tencentOAuth;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:@"kLoginSuccessed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"kLoginFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelled) name:@"kLoginCancelled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQQUserInfo:) name:@"getQQUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWBUserInfo:) name:@"getWBUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWXUserInfo:) name:@"getWXUserInfo" object:nil];
    
    
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
    [searchLabel setText:@"登录"];
    
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
    
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, titleHeight+20+width/4.9, width-width/4, titleHeight)];
    [userTextFiled setPlaceholder:@"手机号"];
    [userTextFiled setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self.view addSubview:userTextFiled];
    
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(userTextFiled.frame.origin.x, userTextFiled.frame.size.height+userTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line1View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line1View];
    
    pasTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(width/8, line1View.frame.size.height+line1View.frame.origin.y, width-width/4-titleHeight, titleHeight)];
    [pasTextFiled setPlaceholder:@"请输入密码"];
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
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(pasTextFiled.frame.origin.x, pasTextFiled.frame.size.height+pasTextFiled.frame.origin.y, userTextFiled.frame.size.width, 0.5)];
    [line2View setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line2View];
    
    
    UILabel *forgetLabel=[[UILabel alloc]initWithFrame:CGRectMake(line2View.frame.origin.x, line2View.frame.size.height+line2View.frame.origin.y+width/32, width/4 , width/20)];
    UITapGestureRecognizer *forgetRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goForgetViewController)];
    forgetLabel.userInteractionEnabled=YES;
    [forgetLabel addGestureRecognizer:forgetRecognizer];
    [forgetLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [forgetLabel setTextAlignment:NSTextAlignmentLeft];
    [forgetLabel setText:@"忘记密码？"];
    [forgetLabel setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [self.view addSubview:forgetLabel];
    
    
    UILabel *registerLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/4-line2View.frame.origin.x, line2View.frame.size.height+line2View.frame.origin.y+width/32, width/4 , width/20)];
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRegisterViewController)];
    registerLabel.userInteractionEnabled=YES;
    [registerLabel addGestureRecognizer:registerRecognizer];
    [registerLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [registerLabel setTextAlignment:NSTextAlignmentRight];
    [registerLabel setText:@"立即注册"];
    [registerLabel setTextColor:[UIColor colorWithRed:47.f/255.f green:47.f/255.f blue:47.f/255.f alpha:1.0]];
    [self.view addSubview:registerLabel];
    
    //16
    loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/8, forgetLabel.frame.size.height+forgetLabel.frame.origin.y+width/16, width-width/4, width/8.6)];
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"登录"];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:100.f/255.f blue:103.f/255.f alpha:1.0]];
    [self.view addSubview:loginLabel];
    
    
    
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
    
    NSArray *otherArray= [NSArray arrayWithObjects:@"微信",@"QQ",@"微博", nil];
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
        [control addSubview:label];
        
        if (![WXApi isWXAppInstalled] && i==0) {
            [control setHidden:YES];
            
        }
        if (![WeiboSDK isWeiboAppInstalled] && i==2) {
            [control setHidden:YES];
            
        }
        if (![TencentOAuth iphoneQQInstalled] && i==1) {
            [control setHidden:YES];
        }
        
        
        [view addSubview:control];
    }
    if(![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![TencentOAuth iphoneQQInstalled]){
        [line1View setHidden:YES];
        [titleLabel setHidden:YES];
        [line2View setHidden:YES];
        [view setHidden:YES];
        
        
    }
    
    
    
}
-(void)onClick:(id)sender{
    UIControl *control=(UIControl *)sender;
    NSLog(@"control===>%@",@"control");
    switch (control.tag) {
        case 0:
            [self loginWeixin];
            break;
        case 1:
            [self loginQQ];
            break;
        case 2:
            [self loginWeibo];
            break;
            
        default:
            break;
    }
}
-(void)hidPas{
    NSLog(@"hidPas");
    [pasTextFiled setSecureTextEntry:YES];
}
-(void)showPas{
    NSLog(@"showPas");
    [pasTextFiled setSecureTextEntry:NO];
    
}
static NSString *kAuthScope = @"snsapi_userinfo";
static NSString *kAuthOpenID = @"wx53d8bade842345b7";
static NSString *kAuthState = @"xxx";
static NSString * const WeiboKey=@"2850266283";
static NSString * const WeiboRedirectURI =@"http://www.sina.com";

-(void)loginWeibo{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboKey];
    WBAuthorizeRequest *request=[WBAuthorizeRequest request];
    request.redirectURI=WeiboRedirectURI;
    request.scope=@"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
-(void)loginWeixin{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kAuthScope; // @"post_timeline,sns"
    req.state = kAuthOpenID;
    req.openID = kAuthOpenID;
    
    [WXApi sendReq:req];
    
}
-(void)loginQQ{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tencentOAuth=myDelegate.QQauth;
    
    [tencentOAuth authorize:permissions inSafari:NO];
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)goForgetViewController{
    ForgetViewController *forgetViewController=[[ForgetViewController alloc]init];
    [self presentViewController: forgetViewController animated:YES completion:nil];
}
-(void)goLoginViewController{
    NSLog(@"gologin");
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"登陆中...";
    [HUD showInView:self.view];
    
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    
    NSString *phone=userTextFiled.text;
    NSString *password=pasTextFiled.text;
    if(phone==nil || [phone isEqualToString:@""]){
        [alertView setMessage:@"手机号为空!"];
        [alertView show];
        [HUD dismiss];
        return;
    }
    
    if(password==nil || [password isEqualToString:@""]){
        [alertView setMessage:@"密码为空!"];
        [alertView show];
        [HUD dismiss];
        return;
    }
    [alertView setTag:0];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper loginAcount:phone with:password success:^(HttpModel *model){
            NSLog(@"我想要的数据：%@",model);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    //保存登录状态数据
                    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
                    [defa setObject:phone forKey:@"phon"];
                    [defa setObject:password forKey:@"pas"];
                    [alertView setTag:1];
                    
                }else{
                    
                }
                [HUD dismiss];
                [alertView setMessage:model.message];
                [alertView show];
            });
            
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"error userInfo:===>%@",error.userInfo);
                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    
                    [alertView setMessage:localizedDescription];
                    [alertView show];
                }
                [HUD dismiss];
                
            }
        }];
    });
}
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)uiAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
    switch (uiAlertView.tag) {
        case 1:
        {
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myDelegate.isLogin=YES;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                NSNotification *notification =[NSNotification notificationWithName:@"login" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        }
            break;
        case 2:
            [self goRegisterViewController];
            
            break;
            
        default:
            break;
    }
}

-(void)goRegisterViewController{
    RegisterViewController *registerViewController=[[RegisterViewController alloc]init];
    if(Otheruid!=NULL && ![Otheruid isEqualToString:@""]){
        [registerViewController setOtherReg];
        [registerViewController setOtherData:Otheruid withData1:Othernickname withData2:Othertoken withData3:Othertype];
    }
    [self presentViewController: registerViewController animated:YES completion:nil];
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark message
- (void)loginSuccessed
{
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        
        //  记录登录用户的OpenID、Token以及过期时间
        BOOL getBool=[tencentOAuth getUserInfo];
        if (getBool) {
            NSLog(@"YES表示API调用成功");
        }else{
            NSLog(@"NO表示API调用失败");
        }
    }
    else
    {
        //tokenLable.text = @"登录不成功 没有获取accesstoken";
    }
}

- (void)loginFailed
{
    
}

- (void) loginCancelled
{
    //do nothing
}
- (void)getWXUserInfo:(NSNotification*)notification{
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"登陆中...";
    [HUD showInView:self.view];
    NSDictionary *dic=(NSDictionary  *)notification.object;
    if([dic objectForKey:@"access_token"] &&[dic objectForKey:@"openid"] ){
        NSString *access_token = [dic objectForKey:@"access_token"];
        NSString *openid = [dic objectForKey:@"openid"];
        [self getWXUserInfo:access_token withOpenId:openid];
    }else{
        if (alertView==nil) {
            alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.delegate=self;
        }
        [alertView setMessage:[NSString stringWithFormat:@"%@",dic]];
        [HUD dismiss];
        [alertView show];
    }

}

- (void)getWBUserInfo:(NSNotification*)notification{
    WBBaseResponse  *jsonResponse=(WBBaseResponse  *)notification.object;
    NSLog(@"jsonResponse%@",jsonResponse.userInfo);
    NSNumberFormatter *fomatter=[[NSNumberFormatter alloc]init];
    
    // NSNumber *ID=[jsonResponse.userInfo objectForKey:@"uid"];
    NSString *uid=[jsonResponse.userInfo objectForKey:@"uid"];
    NSString *nickname=uid;
    NSString *token=[jsonResponse.userInfo objectForKey:@"access_token"];
    NSString *type=@"wb";
    [self accessLogin:uid withUserName:nickname withToken:token withType:type];
}

- (void)getQQUserInfo:(NSNotification*)notification{
    NSDictionary *jsonResponse= notification.object;
    NSLog(@"respons:%@",jsonResponse);
    //http://q.qlogo.cn/qqapp/1105170232/
    NSString *uid=tencentOAuth.openId;
    NSString *nickname=[jsonResponse objectForKey:@"nickname"];
    NSString *token=tencentOAuth.accessToken;
    NSString *type=@"qq";
    [self accessLogin:uid withUserName:nickname withToken:token withType:type];
    
}
-(void)accessLogin:(NSString *)uid withUserName:(NSString *)nickname withToken:(NSString *)token withType:(NSString *)type{
    
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    
    [HttpHelper accessLogin:uid withUserName:nickname withToken:token withType:type success:^(HttpModel *model){
        NSLog(@"%@",model.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.model=model;
                
                [alertView setTag:1];
                
            }else{
                if([model.status isEqual:[NSNumber numberWithInt:3]]){
                    [alertView setTag:2];
                    Otheruid=uid;
                    Othernickname=nickname;
                    Othertoken=token;
                    Othertype=type;
                    
                }
            }
            [HUD dismiss];
            [alertView setMessage:model.message];
            [alertView show];
        });
        
    }failure:^(NSError *error){
        if (error.userInfo!=nil) {
            NSLog(@"error userInfo:===>%@",error.userInfo);
            NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                
                [alertView setMessage:localizedDescription];
                [alertView show];
            }
            [HUD dismiss];
            
        }
    }];
}
#pragma mark
#pragma WBHttpRequestDelegate
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    //成功回调
    NSLog(@"成功回调:%@",result);
}
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    //失败回调
    NSLog(@"失败回调:%@",error);
    
}

-(void)getWXUserInfo:(NSString *)access_token withOpenId:(NSString *)openid
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if([dic objectForKey:@"nickname"]){
                    NSString *type=@"wx";
                    [self accessLogin:openid withUserName:[dic objectForKey:@"nickname"] withToken:access_token withType:type];
                }else{
                    if (alertView==nil) {
                        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alertView.delegate=self;
                    }
                    [alertView setMessage:[NSString stringWithFormat:@"%@",dic]];
                    [HUD dismiss];
                    [alertView show];
                }
            }
        });
        
    });
}


@end