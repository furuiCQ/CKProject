//
//  MineViewController.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MineViewController.h"
#import "ProgressHUD/ProgressHUD.h"
#import "MsgViewController.h"
#import "msViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize imageView;
@synthesize userImageView;
@synthesize loginedControl;
@synthesize unloginControl;
@synthesize userNameLabel;
@synthesize userTelLabel;
@synthesize numbLabel;
@synthesize sucessNumbLabel;
@synthesize postNumbLabel;
@synthesize userInfoArray;
@synthesize pointView;
@synthesize hasMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"refresh_userInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogoutStauets) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginAccount:) name:@"autologin" object:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [self initTitle];
    [self initContentView];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(myDelegate.isLogin){
        [ProgressHUD show:@"加载中..."];
        [self changeLoginStauets];
    }
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"refresh_userInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogoutStauets) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginAccount:) name:@"autologin" object:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initContentView];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   //-------------------------
    if(myDelegate.isLogin){
       [ProgressHUD show:@"加载中..."];
        [self changeLoginStauets];
    }



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
    
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //  [searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"个人中心"];
    
    //新建右上角的图形
    msgLabel=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-16, titleHeight/2-8, 16, 18)];
    [msgLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *uITapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMsgViewController)];
    [msgLabel addGestureRecognizer:uITapGestureRecognizer];
    
    [msgLabel setImage:[UIImage imageNamed:@"msg_logo"]];
    
    pointView=[[UIView alloc]initWithFrame:CGRectMake(8, 0, 8, 8)];
    
    [pointView setBackgroundColor:[UIColor redColor]];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = (pointView.frame.size.width + 10) / 4;
    [pointView setHidden:YES];
    [msgLabel addSubview:pointView];
    
    
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    //顶部头像背景图片
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, titleHeight+20, width, hegiht/4)];
    [imageView setImage:[UIImage imageNamed:@"logo_bg"]];
    
    [self.view addSubview:imageView];
    
    userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/2-width/10, hegiht/8-width/5+width/30, width/5,width/5)];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.borderWidth=2;
    [userImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    userImageView.layer.cornerRadius = (userImageView.frame.size.width) / 2;
    [userImageView setImage:[UIImage imageNamed:@"logo"]];
    
    [imageView addSubview:userImageView];
    
    //登陆后显示控件
    loginedControl=[[UIControl alloc]initWithFrame:CGRectMake(0, hegiht/8+width/20+width/30, width, width/20+width/30+width/20)];
    [loginedControl setHidden:YES];
    
    [imageView addSubview:loginedControl];
    
    userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, width/24)];
    [userNameLabel setText:@"三好学生"];
    [userNameLabel setTextColor:[UIColor whiteColor]];
    [userNameLabel setFont:[UIFont systemFontOfSize:width/24.6]];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    [loginedControl addSubview:userNameLabel];
    
    userTelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/6, width/24+width/100, width/3, width/20)];
    [userTelLabel setText:@"132-5656-8970"];
    [userTelLabel setTextColor:[UIColor whiteColor]];
    [userTelLabel setFont:[UIFont systemFontOfSize:width/29]];
    [userTelLabel setTextAlignment:NSTextAlignmentCenter];
    [loginedControl addSubview:userTelLabel];
    //未登陆显示控件
    
    
    unloginControl=[[UIButton alloc]initWithFrame:CGRectMake(width/2-width/10, hegiht/8+width/20+width/30, width/5, width/20)];
    
    [unloginControl addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    unloginControl.layer.borderColor= [UIColor whiteColor].CGColor; //要设置的颜色
    unloginControl.layer.cornerRadius=3.0;
    unloginControl.layer.borderWidth = 1; //要设置的描边宽
    unloginControl.layer.masksToBounds=YES;
    
    [imageView addSubview:unloginControl];
    
    UILabel *loginBtn=[[UILabel alloc]initWithFrame:CGRectMake(width/100, width/100, width/12, width/29)];
    [loginBtn setText:@"登陆"];
    [loginBtn setTextColor:[UIColor whiteColor]];
    [loginBtn setFont:[UIFont systemFontOfSize:width/29]];
    [loginBtn setTextAlignment:NSTextAlignmentCenter];
    
    [unloginControl addSubview:loginBtn];
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/12+width/100+2, (width/20-width/35)/2, 1, width/32)];
    [lineLabel setBackgroundColor:[UIColor whiteColor]];
    
    [unloginControl addSubview:lineLabel];
    
    UILabel *regBtn=[[UILabel alloc]initWithFrame:CGRectMake(width/12+width/100+5, width/100, width/12, width/29)];
    [regBtn setText:@"注册"];
    [regBtn setTextColor:[UIColor whiteColor]];
    [regBtn setFont:[UIFont systemFontOfSize:width/29]];
    [regBtn setTextAlignment:NSTextAlignmentCenter];
    [unloginControl addSubview:regBtn];
    
    
    //小标题
    UIView *centerView=[[UIView alloc]initWithFrame:CGRectMake(0, hegiht/4+titleHeight+20, width, hegiht/15)];
    [self.view addSubview:centerView];
    //预约按钮
    UIControl *bespeakControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, width/2-1, hegiht/15)];
    [bespeakControl setBackgroundColor:[UIColor whiteColor]];
    [bespeakControl setTag:0];
    [bespeakControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:bespeakControl];
    //
    UILabel *bespeakLabel=[[UILabel alloc]initWithFrame:CGRectMake(bespeakControl.frame.size.width/2-bespeakControl.frame.size.width/4, bespeakControl.frame.size.height/4, bespeakControl.frame.size.width/2, bespeakControl.frame.size.height/2)];
    [bespeakLabel setText:@"预约"];
    [bespeakLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    
    [bespeakLabel setFont:[UIFont systemFontOfSize:width/20]];
    
    [bespeakControl addSubview:bespeakLabel];
    numbLabel=[[UILabel alloc]initWithFrame:CGRectMake(bespeakControl.frame.size.width/2+bespeakControl.frame.size.width/8+bespeakControl.frame.size.width/8, bespeakControl.frame.size.height/4, bespeakControl.frame.size.width/8, bespeakControl.frame.size.height/2)];
    [numbLabel setText:@"0"];
    [numbLabel setTextColor:[UIColor redColor]];
    [numbLabel setFont:[UIFont systemFontOfSize:width/20]];
    [bespeakControl addSubview:numbLabel];
    
    
    
    
    
    
    
    //受理成功按钮
    UIControl *sucessControl=[[UIControl alloc]initWithFrame:CGRectMake(width/2, 0, width/2-1, hegiht/15)];
    [sucessControl setBackgroundColor:[UIColor whiteColor]];
    [sucessControl setTag:1];
    [sucessControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];

    [centerView addSubview:sucessControl];
    //
    UILabel *sucessLabel=[[UILabel alloc]initWithFrame:CGRectMake(sucessControl.frame.size.width/2-sucessControl.frame.size.width/4, sucessControl.frame.size.height/4, sucessControl.frame.size.width/2, sucessControl.frame.size.height/2)];
    [sucessLabel setText:@"受理成功"];
    [sucessLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    
    [sucessLabel setFont:[UIFont systemFontOfSize:width/20]];
    [sucessControl addSubview:sucessLabel];
    sucessNumbLabel=[[UILabel alloc]initWithFrame:CGRectMake(sucessControl.frame.size.width/2+sucessControl.frame.size.width/4+sucessControl.frame.size.width/16, sucessControl.frame.size.height/4, sucessControl.frame.size.width/4, sucessControl.frame.size.height/2)];
    [sucessNumbLabel setText:@"0"];
    [sucessNumbLabel setTextColor:[UIColor redColor]];
    [sucessNumbLabel setFont:[UIFont systemFontOfSize:width/20]];
    [sucessControl addSubview:sucessNumbLabel];
    
    
    
//    //预约按钮
//    UIControl *postControl=[[UIControl alloc]initWithFrame:CGRectMake(width/3+width/3, 0, width/3, hegiht/15)];
//    [postControl setBackgroundColor:[UIColor whiteColor]];
//    [postControl setTag:2];
//    [postControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
//    [centerView addSubview:postControl];
//    //
//    UILabel *postLabel=[[UILabel alloc]initWithFrame:CGRectMake(postControl.frame.size.width/2-postControl.frame.size.width/8, postControl.frame.size.height/4, postControl.frame.size.width/4, postControl.frame.size.height/2)];
//    [postLabel setText:@"发帖"];
//    [postLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
//    
//    [postLabel setFont:[UIFont systemFontOfSize:width/29]];
//    [postControl addSubview:postLabel];
//    postNumbLabel=[[UILabel alloc]initWithFrame:CGRectMake(postControl.frame.size.width/2+postControl.frame.size.width/8+postControl.frame.size.width/16, postControl.frame.size.height/4, postControl.frame.size.width/4, postControl.frame.size.height/2)];
//    [postNumbLabel setText:@"0"];
//    [postNumbLabel setTextColor:[UIColor redColor]];
//    [postNumbLabel setFont:[UIFont systemFontOfSize:width/26.7]];
//    [postControl addSubview:postNumbLabel];
    
    
    NSArray *tableArray = [NSArray arrayWithObjects:@"我的报名记录",@"收藏的课程",@"设置", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"my_sign",@"my_collect",@"my_set", nil];
    
    for(int i=0;i<3;i++){
        //我的报名记录
        UIButton *myRecord=[[UIButton alloc]initWithFrame:CGRectMake(0, hegiht/4+titleHeight+20+hegiht/15+width/40+hegiht/13*i+i*0.5, width, hegiht/13)];
        [myRecord setTag:i];
        [myRecord addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        // [myRecord setBackgroundColor:[UIColor whiteColor]];
        [myRecord setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [myRecord setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0]] forState:UIControlStateHighlighted];
        
        UIImageView *recordImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/20, (hegiht/13-width/10)/2, width/10, width/10)];
        [recordImageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        [myRecord addSubview:recordImageView];
        
        UILabel *recordLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/10+width/40, (hegiht/13-width/20)/2, width/3, width/20)];
        [recordLabel setText:[tableArray objectAtIndex:i]];
        
        [recordLabel setFont:[UIFont systemFontOfSize:width/24.6]];
        
        [myRecord addSubview:recordLabel];
        
        UIImageView *recordRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/20-width/45.7, (hegiht/13-width/29)/2, width/45.7, width/29)];
        [recordRight setImage:[UIImage imageNamed:@"right_logo"]];
        [myRecord addSubview:recordRight];

        [self.view addSubview:myRecord];
    }
    
    
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)goMsgViewControll{
    
    MyMsgViewController *myMsgViewController=[[MyMsgViewController alloc]init];
    [self presentViewController: myMsgViewController animated:YES completion:nil];
}
-(void)onClick:(id)sender{
    UIButton *control=(UIButton*)sender;
    NSLog(@"个人中心列表点击中.....%ld",(long)control.tag);
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    switch (control.tag)
    {
        case 0:
        {
            MyRegistrationRecordViewController *myRegistrationRecordViewController=[[MyRegistrationRecordViewController alloc]init];
            [self presentViewController: myRegistrationRecordViewController animated:YES completion:nil];
        }
            break;
//        case 1:
//        {
//            
//            MyInvitationViewController *myInvitationViewController=[[MyInvitationViewController alloc]init];
//            [self presentViewController: myInvitationViewController animated:YES completion:nil];
//        }
//            break;
            
        case 1:
        {
            MyCollectViewController *myCollectViewController=[[MyCollectViewController alloc]init];
            [self presentViewController: myCollectViewController animated:YES completion:nil];
            
        }
            break;
            
            
        case 2:
        {
            SettingViewController *settingViewController=[[SettingViewController alloc]init];
            [self presentViewController: settingViewController animated:YES completion:nil];
        }
            
            break;
            
        default:
            NSLog(@"头像被点击");
            
            break;
    }
}
-(void)goMsgViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    MyMsgViewController *myMsgViewController=[MyMsgViewController alloc];
    [myMsgViewController setHasMsg:hasMsg];
    [myMsgViewController init];
    [self presentViewController: myMsgViewController animated:YES completion:nil];
    
}
-(void)gotoViewController{
    NSLog(@"头像被点击");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:imageView];
    int stringFloatx = (int)(touchPoint.x);
    int stringFloaty = (int)(touchPoint.y);
    
    //选中登陆注册按钮
    if (stringFloatx>self.view.frame.size.width/2-self.view.frame.size.width/10
        && stringFloaty>self.view.frame.size.height/8+self.view.frame.size.width/20+self.view.frame.size.width/30 && stringFloatx<self.view.frame.size.width/2-self.view.frame.size.width/10+self.view.frame.size.width/6 && stringFloaty<self.view.frame.size.height/8+self.view.frame.size.width/20+self.view.frame.size.width/30+self.view.frame.size.width/6) {
        if(loginedControl.hidden){
            LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
            [self presentViewController:loginRegViewController animated:YES completion:nil];
        }
    }
    
    if (stringFloatx>self.view.frame.size.width/2-self.view.frame.size.width/12
        && stringFloaty>self.view.frame.size.height/8-self.view.frame.size.width/6+self.view.frame.size.width/30 && stringFloatx<self.view.frame.size.width/2-self.view.frame.size.width/12+self.view.frame.size.width/6 && stringFloaty<self.view.frame.size.height/8+self.view.frame.size.width/30) {
//        个人资料页面
        if(!loginedControl.hidden){
            UIAlertView *ip=[[UIAlertView alloc]initWithTitle:@"提示" message:@"个人资料修改暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [ip show];
//            UserInfoViewController *userInfoViewController=[[UserInfoViewController alloc]init];
//            [userInfoViewController setUserInfoArry:userInfoArray];
//            [self presentViewController: userInfoViewController animated:YES completion:nil];
//            跳转
//            msViewController *vi=[[msViewController alloc]init];
//        [self presentViewController: vi animated:YES completion:nil];
//            [self.navigationController pushViewController:mi animated:YES];
//
//            anTableViewController *pa=[[anTableViewController alloc]init];
//            [self presentViewController: pa animated:YES completion:nil];
//            [self.navigationController pushViewController:pa animated:YES];
            

        }
    }
}
-(void)changeLoginStauets{
    
    [loginedControl setHidden:NO];
    [unloginControl setHidden:YES];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    HttpModel *httpModel=appDelegate.model;
    NSLog(@"获取数据：－－－－－－－%@",httpModel.result);
    if([httpModel.result count]>0){
        [userNameLabel setText:[httpModel.result objectForKey:@"username"]];
        
//        imageView.image=[UIImage imageNamed:[httpModel.result objectForKey:@"logo"]];
    }
    [userTelLabel setText:[NSString stringWithFormat:@"%@", httpModel.tel]];
    
    
    [self getUserInfo];
    
    
}
-(void)changeLogoutStauets{
    
    [loginedControl setHidden:YES];
    [unloginControl setHidden:NO];
    [numbLabel setText:@"0"];
    [sucessNumbLabel setText:@"0"];
    [postNumbLabel setText:@"0"];
    [pointView setHidden:YES];
    NSNotification *notification =[NSNotification notificationWithName:@"hiddenpoint" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.model=nil;
    [userImageView setImage:[UIImage imageNamed:@"logo"]];
}
-(void)autoLoginAccount:(NSNotification*)notification{
    NSDictionary *dic = [notification userInfo];
    NSString *phone=[dic objectForKey:@"tel"];
    NSString *password=[dic objectForKey:@"pas"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    [HttpHelper loginAcount:phone with:password success:^(HttpModel *model){
        NSLog(@"返回数据需三少：%@",model.message);
        dispatch_async(dispatch_get_main_queue(), ^{

        if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myDelegate.model=model;
            [self changeLoginStauets];
        }else{
            
        }
        });
        //[alertView setMessage:model.message];
        //[alertView show];
        
        
    }failure:^(NSError *error){
        if (error.userInfo!=nil) {
            NSLog(@"error userInfo:===>%@",error.userInfo);
            NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                
                // [alertView setMessage:localizedDescription];
                // [alertView show];
            }
        }
    }];
    });
}

-(void)getUserInfo{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.model!=nil) {
        
        [HttpHelper getUserInfo:myDelegate.model success:^(HttpModel *model){
            NSLog(@"2222222222222223___%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{

            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.model=model;
                myDelegate.isLogin=YES;
                [self setData:model.result];
                
            }else{
                
            }
            [ProgressHUD dismiss];
            });
            
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
            [ProgressHUD dismiss];

        }];
        
    }
    });
    
}
-(void)controlClick:(UIControl *)control{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginRegViewController *loginRegViewController=[[LoginRegViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    long tag=(long)control.tag;
    switch (tag) {
        case 0://预约
        {
            MyRegistrationRecordViewController *myRegistrationRecordViewController=[[MyRegistrationRecordViewController alloc]init];
            [self presentViewController: myRegistrationRecordViewController animated:YES completion:nil];
            [myRegistrationRecordViewController clickNumber:1];

        }
            break;
        case 1://受理成功
        {
            MyRegistrationRecordViewController *myRegistrationRecordViewController=[[MyRegistrationRecordViewController alloc]init];
            [self presentViewController: myRegistrationRecordViewController animated:YES completion:nil];
            [myRegistrationRecordViewController clickNumber:2];
        }
            break;
        case 2://发帖
        {
            
            MyInvitationViewController *myInvitationViewController=[[MyInvitationViewController alloc]init];
            [self presentViewController: myInvitationViewController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
-(void)setData:(NSDictionary *)dic{
    
    

    NSNumber *userId=[dic objectForKey:@"id"];
    NSString *username=[dic objectForKey:@"username"];
    NSNumber *tel=[dic objectForKey:@"tel"];
    NSString *logo=[dic objectForKey:@"logo"];
    NSNumber *sex=[dic objectForKey:@"sex"];
    NSString *addr=[dic objectForKey:@"addr"];
    
    NSNumber *bk=[dic objectForKey:@"bk"];
    NSNumber *acce=[dic objectForKey:@"acce"];
    NSNumber *inter=[dic objectForKey:@"inter"];
    NSNumber *ismessage=[dic objectForKey:@"ismessage"];
    
    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
    if (![bk isEqual:[NSNull null]]) {
        [numbLabel setText:[NSString stringWithFormat:@"%@",bk]];
    }
    if (![logo isEqual:@""] && logo!=nil && ![logo isEqual:[NSNull null]]) {
        [userImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
    }else{
        [userImageView setImage:[UIImage imageNamed:@"logo"]];
        logo=@"";
    }
    if (![acce isEqual:[NSNull null]]) {
        [sucessNumbLabel setText:[NSString stringWithFormat:@"%@",acce]];
    }
    if (![inter isEqual:[NSNull null]]) {
        [postNumbLabel setText:[NSString stringWithFormat:@"%@",inter]];
    }
    if (![username isEqual:[NSNull null]]) {
        [userNameLabel setText:[NSString stringWithFormat:@"%@",username]];
    }
    
    if(![ismessage isEqual:[NSNull null]]){
        
        if([ismessage isEqualToNumber:[NSNumber numberWithInt:0]])
            
        {
            [pointView setHidden:YES];
            hasMsg=NO;
            NSNotification *notification =[NSNotification notificationWithName:@"hiddenpoint" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }else{
            [pointView setHidden:NO];
            hasMsg=YES;

            NSNotification *notification =[NSNotification notificationWithName:@"showpoint" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
        
    }
    
    userInfoArray=[[NSMutableArray alloc]init];
    [userInfoArray addObject:logo];
    [userInfoArray addObject:username];
    if ([sex isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [userInfoArray addObject:@"男"];
    }else{
        [userInfoArray addObject:@"女"];
    }
    [userInfoArray addObject:@""];
    [userInfoArray addObject:tel];
    [userInfoArray addObject:addr];
    [userInfoArray addObject:userId];
    
    
    
    
}

@end