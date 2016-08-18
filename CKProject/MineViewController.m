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
#import "OrderRecordCell.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "YiSlideMenu.h"
#import "ChangePhoneViewController.h"
#import "ChangeNickNameViewController.h"
#import "ChangePassViewController.h"
#import "UILabel+JJKAlertActionFont.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,
UIImagePickerControllerDelegate,UIActionSheetDelegate,
UINavigationControllerDelegate,YiSlideMenuDelegate,UIPickerViewDelegate>{
    NSMutableArray *projectTableArray;
    UITableView *mainTableView;
    UINib *nib;
    
    
    NSMutableArray *dataArray;
    YiSlideMenu *slideMenu;
    UIAlertView *alertView;
    UIImageView *nodataImageView;
    
    UIAlertController *alertDialog;
    UIActivityIndicatorView *dicatorView;
    
    
    //local data
    NSDictionary *pickerDic;
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *townArray;
    NSArray *selectedArray;
    NSNumber *selectProvId;
    NSNumber *selectCityId;
    NSString *localData;
    
    UIPickerView *citypickerView;
    UIView *bgView;
    UIView *pickerTopView;
    NSString *selectCity;
    //progress
    JGProgressHUD *HUD;
}

@end

@implementation MineViewController
@synthesize titleHeight;
@synthesize leftImage;
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
    dataArray=[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"refresh_userInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSliding) name:@"closeSliding" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogoutStauets) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginAccount:) name:@"autologin" object:nil];
    [self initContentView];
    [self initTitle];
    [self getPickerData];
    [self initPickView];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(myDelegate.isLogin){
        [self changeLoginStauets];
    }
    // Do any additional setup after loading the view, typically from a nib.
}
#define RightWidth ([[UIScreen mainScreen] bounds].size.width*6/7)
-(void)closeSliding{
    if(slideMenu.contentOffset.x>(self.view.frame.size.width+RightWidth)){
        [slideMenu navRightBtAction];
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
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    //22 × 34
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/19, titleHeight/2-8, 11, 17)];
    // UITapGestureRecognizer *uITapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMsgViewController)];
  //  [leftImage addGestureRecognizer:uITapGestureRecognizer];
    [leftImage setUserInteractionEnabled:YES];
    [leftImage setImage:[UIImage imageNamed:@"msg_logo"]];
   // [titleView addSubview:leftImage];
    UIControl *leftControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, titleHeight)];
    [leftControl addTarget:self action:@selector(goMsgViewController) forControlEvents:UIControlEventTouchUpInside];
 //   [titleView addSubview:leftControl];
    
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"个人中心"];
    
    //新建右上角的图形
    msgLabel=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/19-2, titleHeight/2-7,4, 15)];
    [msgLabel setUserInteractionEnabled:YES];
    [msgLabel setImage:[UIImage imageNamed:@"menu_logo"]];
    UIControl *rightControl=[[UIControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/5.3, 0, self.view.frame.size.width/5, titleHeight)];
    [rightControl addTarget:self action:@selector(openRightMenu) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightControl];
    
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [slideMenu.centerView addSubview:titleView];
}
-(void)initContentView{
    
    titleHeight=44;
    
    int width=self.view.frame.size.width;
    int hegiht=self.view.frame.size.height;
    //侧滑菜单
    slideMenu = [[YiSlideMenu alloc] initWithFrame:CGRectMake(0, 0, width, hegiht)];
    [slideMenu setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:slideMenu];
    slideMenu.slideMenuDelegate=self;
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, hegiht-(titleHeight))];
    //顶部头像背景图片
    //450 × 300
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, titleHeight, width, width/1.9)];
    [imageView setImage:[UIImage imageNamed:@"mine_bg"]];
    
    [tableHeaderView addSubview:imageView];
    
    
    
    UIView *whiteImageView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y, width,width/2.5)];
    [whiteImageView setBackgroundColor:[UIColor whiteColor]];
    [tableHeaderView addSubview:whiteImageView];
    
    UIImageView *commentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/17.8, imageView.frame.size.height+imageView.frame.origin.y-width/12, width/6, width/6)];
    UITapGestureRecognizer *messageGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMyRegViewController)];
    [commentImageView setUserInteractionEnabled:YES];
    [commentImageView addGestureRecognizer:messageGestureRecognizer];
    [commentImageView setImage:[UIImage imageNamed:@"message"]];
    [tableHeaderView addSubview:commentImageView];
    
    UIImageView *addImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/17.8-width/6, imageView.frame.size.height+imageView.frame.origin.y-width/12, width/6, width/6)];
    [addImageView setImage:[UIImage imageNamed:@"add"]];
    UITapGestureRecognizer *addGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMyInvitationViewController)];
    [addImageView setUserInteractionEnabled:YES];
    [addImageView addGestureRecognizer:addGestureRecognizer];
    [tableHeaderView addSubview:addImageView];
    
    userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/2-width/5.2, imageView.frame.size.height+imageView.frame.origin.y-width/5.2, width/2.6, width/2.6)];
    [userImageView setImage:[UIImage imageNamed:@"logo"]];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.borderWidth=2;
    [userImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    userImageView.layer.cornerRadius = (userImageView.frame.size.width) / 2;
    [tableHeaderView addSubview:userImageView];
    
    //登陆后显示控件
    loginedControl=[[UIControl alloc]initWithFrame:CGRectMake(0, userImageView.frame.size.height+userImageView.frame.origin.y+width/17.8, width, width/20+width/30+width/20)];
    
    [loginedControl setHidden:YES];
    
    [tableHeaderView addSubview:loginedControl];
    
    userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, width/16)];
    [userNameLabel setText:@"三好学生"];
    [userNameLabel setTextColor:[UIColor blackColor]];
    [userNameLabel setFont:[UIFont systemFontOfSize:width/16]];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    [loginedControl addSubview:userNameLabel];
    
    userTelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-width/6, userNameLabel.frame.size.height+userNameLabel.frame.origin.y+width/64, width/3, width/25)];
    [userTelLabel setText:@"13256568970"];
    [userTelLabel setTextColor:[UIColor blackColor]];
    [userTelLabel setFont:[UIFont systemFontOfSize:width/25]];
    [userTelLabel setTextAlignment:NSTextAlignmentCenter];
    [loginedControl addSubview:userTelLabel];
    
    //未登陆显示控件
    unloginControl=[[UIButton alloc]initWithFrame:CGRectMake(width/2-width/7, userImageView.frame.size.height+userImageView.frame.origin.y+width/17.8, width/3.5, width/11.8)];
    [unloginControl addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    unloginControl.layer.cornerRadius=3.0;
    [unloginControl setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [tableHeaderView addSubview:unloginControl];
    //    [unloginControl setHidden:YES];
    
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake((width/3.5-0.5)/2, (width/11.8-width/20)/2, 0.5, width/20)];
    [lineLabel setBackgroundColor:[UIColor whiteColor]];
    
    [unloginControl addSubview:lineLabel];
    
    
    UILabel *loginBtn=[[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x-width/40-width/12, (width/11.8-width/35)/2, width/12, width/35.6)];
    [loginBtn setText:@"注册"];
    [loginBtn setTextColor:[UIColor whiteColor]];
    [loginBtn setFont:[UIFont systemFontOfSize:width/35]];
    [loginBtn setTextAlignment:NSTextAlignmentCenter];
    [unloginControl addSubview:loginBtn];
    
    UILabel *regBtn=[[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.size.width+lineLabel.frame.origin.x+width/40, (width/11.8-width/35)/2, width/12, width/35)];
    [regBtn setText:@"登录"];
    [regBtn setTextColor:[UIColor whiteColor]];
    [regBtn setFont:[UIFont systemFontOfSize:width/35]];
    [regBtn setTextAlignment:NSTextAlignmentCenter];
    [unloginControl addSubview:regBtn];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, whiteImageView.frame.origin.y+whiteImageView.frame.size.height, width, width/8.8)];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [tableHeaderView addSubview:headerView];
    [self initSwitchBtn:headerView];
    //241 × 200
    nodataImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/2-width/5.2, headerView.frame.size.height+headerView.frame.origin.y+2, width/2.6, width/3.2)];
    [nodataImageView setImage:[UIImage imageNamed:@"mine_nodata"]];
    [tableHeaderView addSubview:nodataImageView];
    
    [tableHeaderView setFrame:CGRectMake(0, 0, width, headerView.frame.size.height+headerView.frame.origin.y)];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               0,
                                                               width,
                                                               hegiht-(titleHeight+20))];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    mainTableView.dataSource                        = self;
    mainTableView.delegate                          = self;
    mainTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    mainTableView.tableHeaderView=tableHeaderView;
    mainTableView.separatorStyle=NO;
    [slideMenu.centerView addSubview:mainTableView];
    
}
-(void)initSwitchBtn:(UIView *)superView{
    titleHeight=44;
    int width=self.view.frame.size.width;
    
    NSArray *array = [NSArray arrayWithObjects:@"预约-",@"受理成功-", nil];
    projectTableArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[array count]; i++) {
        TopBar *topBar=[[TopBar alloc]initWithFrame:CGRectMake(width/[array count]*i, 0, width/[array count], titleHeight)];
        [topBar addTarget:self action:@selector(topBarOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBar setTag:i];
        [topBar setText:[array objectAtIndex:i]];
        [topBar initView];
        if(i==[array count]-1){
            [topBar setIsEnd:YES];
        }
        if(i==0){
            [topBar setChecked:YES];
            [topBar setIconColor:[UIColor redColor]];
            [topBar setTextColor:[UIColor redColor]];
        }else{
            [topBar setChecked:NO];
            [topBar setIconColor:[UIColor blackColor]];
            [topBar setTextColor:[UIColor blackColor]];
            
        }
        [topBar setLabelFont:[UIFont systemFontOfSize:width/22.8]];
        [topBar setLineViewFill];
        [superView addSubview:topBar];
        [projectTableArray addObject:topBar];
    }
}
-(void)topBarOnClick:(id)sender{
    TopBar *topBar=(TopBar *)sender;
    for (NSObject *object in projectTableArray) {
        TopBar *b=(TopBar *)object;
        if(b.tag!=topBar.tag){
            [b setChecked:NO];
            [b setIconColor:[UIColor blackColor]];
            [b setTextColor:[UIColor blackColor]];
        }else{
            [b setChecked:YES];
            [b setIconColor:[UIColor redColor]];
            [b setTextColor:[UIColor redColor]];
            
        }
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
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
}
-(void)goMsgViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginRegViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginRegViewController animated:YES completion:nil];
        return;
    }
    MyMsgViewController *myMsgViewController=[MyMsgViewController alloc];
    [myMsgViewController setHasMsg:hasMsg];
    myMsgViewController=[myMsgViewController init];
    [self presentViewController: myMsgViewController animated:YES completion:nil];
    
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
}
-(void)openRightMenu{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    [slideMenu navRightBtAction];
}
-(void)changeLoginStauets{
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"加载中...";
    [HUD showInView:self.view];
    [loginedControl setHidden:NO];
    [unloginControl setHidden:YES];
    [self getUserInfo];
    [self getData];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    HttpModel *httpModel=appDelegate.model;
    if([httpModel.result count]>0){
        if([httpModel.result isKindOfClass:[NSDictionary class]]){
            NSLog(@"httpModel.result %@",httpModel.result);
            if([[httpModel.result allKeys] containsObject:@"username"]){
                [userNameLabel setText:[httpModel.result objectForKey:@"username"]];
            }
        }
        
    }
    [userTelLabel setText:[NSString stringWithFormat:@"%@", appDelegate.model.tel]];
    [slideMenu setUserPhone:[NSString stringWithFormat:@"%@", appDelegate.model.tel]];
   
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
    appDelegate.isLogin=NO;
    appDelegate.model=nil;
    dataArray=[[NSMutableArray alloc]init];
    [mainTableView reloadData];
    for (int i=0; i< [projectTableArray count];i++) {
        TopBar *topBar=(TopBar *)[projectTableArray objectAtIndex:i];
        if(i==0){
            [topBar.textLabel setText:[NSString stringWithFormat:@"预约-"]];
        }
        if(i==1){
            [topBar.textLabel setText:[NSString stringWithFormat:@"受理成功-"]];
            
        }
    }
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
               // NSLog(@"2222222222222223___%@",model.result);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        myDelegate.model=model;
                        myDelegate.isLogin=YES;
                        [self setData:model.result];
                        [slideMenu setData:model.result];
                    //    [slideMenu setScrollEnabled:YES];
                    }else{
                        
                    }
                    [HUD dismiss];
                });
                
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [HUD dismiss];
                
            }];
            
        }
    });
    
}

-(void)goMyRegViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    MyRegistrationRecordViewController *myRegistrationRecordViewController=[[MyRegistrationRecordViewController alloc]init];
    [self presentViewController: myRegistrationRecordViewController animated:YES completion:nil];
}
-(void)goMyInvitationViewController{
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!myDelegate.isLogin) {
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    MyCollectViewController *myCollectViewController=[[MyCollectViewController alloc]init];
    [self presentViewController: myCollectViewController animated:YES completion:nil];
}
-(void)setData:(NSDictionary *)dic{
    NSString *username=[dic objectForKey:@"username"];
    NSNumber *tel=[dic objectForKey:@"tel"];
    NSString *logo=[dic objectForKey:@"logo"];
    NSNumber *sex=[dic objectForKey:@"sex"];
    NSString *addr=[dic objectForKey:@"addr"];
    
    NSNumber *bk=[dic objectForKey:@"bk"];
    NSNumber *acce=[dic objectForKey:@"acce"];
    //  NSNumber *inter=[dic objectForKey:@"inter"];
    NSNumber *ismessage=[dic objectForKey:@"ismessage"];
    
    // NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
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
    //    if (![inter isEqual:[NSNull null]]) {
    //        [postNumbLabel setText:[NSString stringWithFormat:@"%@",inter]];
    //    }
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
    
    for (int i=0; i< [projectTableArray count];i++) {
        TopBar *topBar=(TopBar *)[projectTableArray objectAtIndex:i];
        if(i==0){
            [topBar.textLabel setText:[NSString stringWithFormat:@"预约%@",bk]];
        }
        if(i==1){
            [topBar.textLabel setText:[NSString stringWithFormat:@"受理成功%@",acce]];
            
        }
    }
    [userInfoArray addObject:@""];
    [userInfoArray addObject:tel];
    [userInfoArray addObject:addr];
    //  [userInfoArray addObject:userId];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"CustomCell";
    OrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderRecordCell"owner:self options:nil]lastObject];
    }
    OrderRecordCell *porjectCell=(OrderRecordCell *)cell;
    NSDictionary *dic=[dataArray objectAtIndex:[indexPath row]];
    if ([dic objectForKey:@"title"] && ![[dic objectForKey:@"title"] isEqual:[NSNull null]]) {
        NSString *title=[dic objectForKey:@"title"];
        [porjectCell.titleLabel setText:[NSString stringWithFormat:@"%@",title]];
    }
    if ([dic objectForKey:@"instsort"] && ![[dic objectForKey:@"instsort"] isEqual:[NSNull null]]) {
        NSString *title=[dic objectForKey:@"instsort"];
        [porjectCell.authorLabel setText:[NSString stringWithFormat:@"%@",title]];
    }
    if ([dic objectForKey:@"people"] && ![[dic objectForKey:@"people"] isEqual:[NSNull null]]) {
        NSString *people=[dic objectForKey:@"people"];
        NSString *str=[NSString stringWithFormat:@"已报%@人",people];
        [porjectCell.orderNumbLabel setText:str];
        
    }
    
    if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
        NSString *logo=[dic objectForKey:@"logo"];
        if (![logo isEqualToString:@""]) {
            [porjectCell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
            
        }
        
    }
    if ([dic objectForKey:@"range"] && ![[dic objectForKey:@"range"] isEqual:[NSNull null]]) {
        NSNumber *range=[dic objectForKey:@"range"];
        double distance=[range doubleValue];
        if(distance>0.0){
            if (distance/1000>1) {
                [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(float)distance/1000]];
            }else if (distance/1000<1 && distance/1000>0.5){
                [porjectCell.distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)distance]];
                
            }else if (distance/1000<0.5){
                [porjectCell.distanceLabel setText:@"<500m"];
            }
        }
    }
    if ([dic objectForKey:@"grade"] && ![[dic objectForKey:@"grade"] isEqual:[NSNull null]]) {
        NSString *grade=[dic objectForKey:@"grade"];
        [porjectCell.ageLabel setText:[NSString stringWithFormat:@"适应年龄段:%@",grade]];
    }
    if ([dic objectForKey:@"btime"] && ![[dic objectForKey:@"btime"] isEqual:[NSNull null]]) {
        NSNumber *btime=[dic objectForKey:@"btime"];
        NSInteger myInteger = [btime integerValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM月 dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myInteger];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        [porjectCell.timeLabel setText:[NSString stringWithFormat:@"%@",confromTimespStr]];
    }
    if ([dic objectForKey:@"status"] && ![[dic objectForKey:@"status"] isEqual:[NSNull null]]) {
        NSNumber *status=[dic objectForKey:@"status"];
        NSNumber *atime=[dic objectForKey:@"atime"];
        int at=[atime intValue];
        if(at==0 && [status intValue]==0){
            //未受理
            [cell.accpet_image setHidden:NO];
            [cell.accpet_image setImage:[UIImage imageNamed:@"accepting"]];
        }
        if(at!=0 && [status intValue]==0){
            //受理失败
            [cell.accpet_image setHidden:NO];
            [cell.accpet_image setImage:[UIImage imageNamed:@"accepte_warn"]];
        }
        if([status intValue]==1){
         //受理成功但未评价
            [cell.accpet_image setHidden:NO];
            [cell.accpet_image setImage:[UIImage imageNamed:@"accept_sucess"]];
            
        }
        if([status intValue]==2){
            //已评价
            [cell.accpet_image setHidden:NO];
            [cell.accpet_image setImage:[UIImage imageNamed:@"accepted"]];
        }

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    ProjectDetailsViewController *projectDetailsViewController=[[ProjectDetailsViewController alloc]init];
    NSDictionary *dic=[dataArray objectAtIndex:indexPath.row];
    NSNumber *projectId=[dic objectForKey:@"lid"];
    [projectDetailsViewController setProjectId:projectId];
    [self presentViewController:projectDetailsViewController animated:YES completion:nil];
    [projectDetailsViewController setSelect];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    // NSLog(@"高度:%f",cell.frame.size.height);
    return cell.frame.size.height;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath slide:(YiSlideDirection)slideDirection{
    if(slideDirection==YiRightDirection){
        NSLog(@"didSelectRowAtIndexPath%ld",(long)[indexPath row]);
        switch ([indexPath row]) {
            case 0:
            {
                NSLog(@"优惠劵");
            }
                break;
            case 1:
            {
                NSLog(@"性别");
            }
                break;
            case 2:
            {
                ForgetViewController *changePassViewController=[[ForgetViewController alloc]init];
                [self presentViewController: changePassViewController animated:YES completion:nil];
            }
                break;
            case 3:
            {
              //  ChangePhoneViewController *changePhoneViewController=[[ChangePhoneViewController alloc]init];
              //  [self presentViewController: changePhoneViewController animated:YES completion:nil];
                
            }
                break;
            case 4:
            {
                NSLog(@"地址");
                [self showMyPicker];
                return;
            }
                break;
            case 5:
            {
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://4000020368"]]];
                [self.view addSubview:callWebview];
            }
                break;
            case 6:
            {
                SettingViewController *settingViewController=[[SettingViewController alloc]init];
                [self presentViewController: settingViewController animated:YES completion:nil];
            }
                break;
            case 7:
            {
                [self logout];

            }
                break;
            default:
                break;
        }
        [slideMenu navRightBtAction];
    }
}
//预约列表
-(void)getData{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *stand=[NSUserDefaults standardUserDefaults];
    NSNumber *ar=[stand objectForKey:@"lttt"];
    NSNumber *ngg=[stand objectForKey:@"nggg"];
    
    if (ar==NULL&&ngg==NULL) {
        ar=[NSNumber numberWithDouble:myDelegate.latitude];
        ngg=[NSNumber numberWithDouble:myDelegate.longitude];
    }
    if ([ar isEqualToNumber:[NSNumber numberWithDouble:0]]) {
        ar=[NSNumber numberWithDouble:29.5];
        ngg=[NSNumber numberWithDouble:106.5];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AppDelegate *myDelegate=( AppDelegate *)[[UIApplication sharedApplication]delegate];
        [HttpHelper getMyLessonList:[NSNumber numberWithInt:0] withLng: ngg withLat:ar  withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    dataArray=[(NSMutableArray *)model.result mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nodataImageView setHidden:YES];
                        [mainTableView reloadData];
                        
                    });
                }else{
                    
                }
                [ProgressHUD dismiss];
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                [ProgressHUD dismiss];
                
            }
        }];
    });
    
}


//－－－－－－－－－－－－－－－－－－－－－－－－
-(void)logout{
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"退出登陆中...";
    [HUD showInView:self.view];
    AppDelegate *myDelegate = ( AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.model!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper logoutAcount:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (alertView==nil) {
                        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alertView.delegate=self;
                    }
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                       
                        [alertView setTag:5];
                        [slideMenu setScrollEnabled:NO];
                    }else{
                        
                    }
                    [alertView setMessage:model.message];
                    [alertView show];
                    [HUD dismiss];
                });
                
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [HUD dismiss];

            }];
        });
        
    }
}
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)uiAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
    switch (uiAlertView.tag) {
        case 5:
        {
            [self changeLogoutStauets];
        }
            break;
            
        default:
            break;
    }
}
-(void)selectImage{
    [self addActionSheet];
}
-(void)selectUserName{
    ChangeNickNameViewController *changePassViewController=[[ChangeNickNameViewController alloc]init];
    [self presentViewController: changePassViewController animated:YES completion:nil];
    NSLog(@"selectUserName");
    [changePassViewController setNickName:userNameLabel.text];
}
-(void)switchBtn:(BOOL)isSelected{
    NSString *str=@"";
    if(isSelected){
        str=@"女";
    }else{
        str=@"男";
    }
    [self restSex:str];
}
-(void)restSex:(NSString *)context{
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }

    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper resetSex:context withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    myDelegate.model=model;
                    
                }else{
                    
                }
                [alertView setMessage:model.message];
                [alertView show];
 
            });
            
            
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"error userInfo:===>%@",error.userInfo);
                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    
                }
                
            }
        }];
    });
}
//打开相册
-(void)addActionSheet{
    
    int width=self.view.frame.size.width;
    NSString *okButtonTitle = @"取消";
    NSString *neverButtonTitle = @"从相册选择";
    NSString *laterButtonTitle = @"拍照";
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:width/15.2];
    [appearanceLabel setAppearanceFont:font];
    // 初始化
    if (alertDialog==nil) {
        alertDialog = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 分别3个创建操作
        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:laterButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"0");
            [self takePhoto];
        }];
        [laterAction setValue:[UIColor colorWithRed:1 green:59.f/255.f blue:48.f/255.f alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *neverAction = [UIAlertAction actionWithTitle:neverButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"2");
            [self openAlbum ];
            
        }];
        [neverAction setValue:[UIColor colorWithRed:0 green:122.f/255.f blue:1 alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 取消按键
            NSLog(@"3");
            
        }];
        [okAction setValue:[UIColor colorWithRed:0 green:122.f/255.f blue:1 alpha:1.0]  forKey:@"_titleTextColor"];
        
        
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:laterAction];
        [alertDialog addAction:neverAction];
        [alertDialog addAction:okAction];
        
        // 呈现警告视图
    }
    
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}
//2
-(void)openAlbum{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else {
        NSLog(@"该设备无摄像头");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        //  [imageView setImage:image];
        //保存
        AppDelegate *myDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSString *timeDate=[HttpHelper getNowImageTime];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths lastObject];
        NSString *imageURl=[docPath stringByAppendingFormat:@"%@%@",@"/",timeDate];
        saveImageToCacheDir(docPath, image, timeDate, @"png");
        HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"图片上传中...";
        [HUD showInView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [HttpHelper upload:myDelegate.model withImageUrl:imageURl withImage:image success:^(HttpModel *model){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (alertView==nil) {
                        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alertView.delegate=self;
                    }
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        [slideMenu setImage:nil withImage:image];
                        [userImageView setImage:image];
                        
                    }else{
                        
                        
                    }
                    [alertView setMessage:model.message];
                    [alertView show];
                    
                    [HUD dismiss];
                });
                
                
            }failure:^(NSError *error){
                if(error.code==500){
                    HUD.textLabel.text = @"网络异常！";
                    [HUD dismissAfterDelay:5];
                }
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
            }];
            
        });
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

    
}

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
-(void)initPickView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    bgView=	[[UIView alloc] initWithFrame:kScreen_Frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    citypickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, height-width/45.7-titleHeight-width*2/3, width, width*2/3)];
    citypickerView.delegate=self;
    [citypickerView setUserInteractionEnabled:YES];
    [citypickerView setBackgroundColor:[UIColor colorWithRed:236.f/255.f green:237.f/255.f blue:238.f/255.f alpha:1]];
    
    pickerTopView=[[UIView alloc]initWithFrame:CGRectMake(0, height-width/45.7-titleHeight-width*2/3, width, titleHeight)];
    [pickerTopView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/35.6, 0, width/4, titleHeight)];
    [cancelLabel setText:@"取消"];
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMyPicker)];
    [cancelLabel setUserInteractionEnabled:YES];
    [cancelLabel addGestureRecognizer:cancelGesture];
    [cancelLabel setTextColor:[UIColor colorWithRed:37.f/255.f green:110.f/255.f blue:1 alpha:1]];
    [cancelLabel setTextAlignment:NSTextAlignmentLeft];
    [pickerTopView addSubview:cancelLabel];
    
    UILabel *saveLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/4-width
                                                                /35.6, 0, width/4, titleHeight)];
    [saveLabel setText:@"完成"];
    UITapGestureRecognizer *saveGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAddres)];
    [saveLabel setUserInteractionEnabled:YES];
    [saveLabel addGestureRecognizer:saveGesture];
    [saveLabel setTextColor:[UIColor colorWithRed:37.f/255.f green:110.f/255.f blue:1 alpha:1]];
    [saveLabel setTextAlignment:NSTextAlignmentRight];
    [pickerTopView addSubview:saveLabel];
    
    //[self.view addSubview:citypickerView];	
}
-(void)changeAddres{
    [self hideMyPicker];
    if(selectCity==nil){
        selectCity=@"湖南省湘潭市雨湖区";
    }
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [HttpHelper resetAddress:selectCity withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    [alertView setMessage:@"地址修改成功"];
                    [alertView show];
                    [slideMenu setUserAddress:selectCity];

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
#pragma mark - private method
- (void)showMyPicker {
    [self.view addSubview:bgView];
    [self.view addSubview:citypickerView];
    [self.view addSubview:pickerTopView];
    bgView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        bgView.alpha = 0.3;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        bgView.alpha = 0;
        // citypickerView.top = self.view.height;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [citypickerView removeFromSuperview];
        [pickerTopView removeFromSuperview];
    }];
}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    provinceArray = [pickerDic allKeys];
    selectedArray = [pickerDic objectForKey:[[pickerDic allKeys] objectAtIndex:0]];
    
    if (selectedArray.count > 0) {
        cityArray = [[selectedArray objectAtIndex:0] allKeys];
    }
    
    if (cityArray.count > 0) {
        townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
    }
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return provinceArray.count;
    } else if (component == 1) {
        return cityArray.count;
    } else {
        return townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [cityArray objectAtIndex:row];
    } else {
        return [townArray objectAtIndex:row];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 150, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        myView.text = [provinceArray objectAtIndex:row];

    } else if (component == 1) {
        myView.text = [cityArray objectAtIndex:row];

    } else {
        myView.text = [townArray objectAtIndex:row];
    }
    return myView;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedArray = [pickerDic objectForKey:[provinceArray objectAtIndex:row]];
        if (selectedArray.count > 0) {
            cityArray = [[selectedArray objectAtIndex:0] allKeys];
        } else {
            cityArray = nil;
        }
        if (cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
        } else {
            townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (selectedArray.count > 0 && cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:row]];
        } else {
            townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
    
    NSString *provice=[provinceArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *city=[cityArray objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSString *town=@"";
    if([townArray count]>0){
        town=[townArray objectAtIndex:[pickerView selectedRowInComponent:2]];
    }
      [self setProviceID:provice andCityID:city andTown:town];
    
    
    selectCity=[[provice stringByAppendingString:city]stringByAppendingString:town];
    
}
-(void)setProviceID:(NSString *)prvoice andCityID:(NSString *)city andTown:(NSString *)town{
    NSLog(@"prvoice%@",prvoice);
    NSLog(@"city%@",city);
    NSLog(@"town%@",town);
    
    NSRange rang  = [localData rangeOfString:city];
    NSLog(@"%@",NSStringFromRange(rang));
    NSString *str=[localData substringWithRange:NSMakeRange(rang.location-10, rang.length+18)];
    NSLog(@"%@",str);
    NSLog(@"%lu",(unsigned long)[str length]);
    NSArray *thisdataArray=[str componentsSeparatedByString:NSLocalizedString(@",", nil)];
    NSString *provStr=[thisdataArray objectAtIndex:2];
    NSString *cityStr=[thisdataArray objectAtIndex:0];
    cityStr=[cityStr substringWithRange:NSMakeRange(1, cityStr.length-2)];
    NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
    selectCityId=[formater numberFromString:cityStr];
    selectProvId=[formater numberFromString:provStr];
    
    
}

@end