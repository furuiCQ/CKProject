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
#import "YiSlideMenu.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,YiSlideMenuDelegate>{
    NSMutableArray *projectTableArray;
    UITableView *mainTableView;
    UINib *nib;
    
    
    NSMutableArray *dataArray;
    YiSlideMenu *slideMenu;
    UIAlertView *alertView;
    UIImageView *nodataImageView;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginStauets) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogoutStauets) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginAccount:) name:@"autologin" object:nil];
    // [self initTitle];
    // [self initContentView];
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
    [self initContentView];
    [self initTitle];
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
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    //22 × 34
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/19, titleHeight/2-8, 11, 17)];
    UITapGestureRecognizer *uITapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMsgViewController)];
    [leftImage addGestureRecognizer:uITapGestureRecognizer];
    [leftImage setUserInteractionEnabled:YES];
    [leftImage setImage:[UIImage imageNamed:@"msg_logo"]];
    [titleView addSubview:leftImage];
    
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"个人中心"];
    
    //新建右上角的图形
    msgLabel=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/19-2, titleHeight/2-7,4, 15)];
    [msgLabel setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *menuapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openRightMenu)];
    [msgLabel addGestureRecognizer:menuapGestureRecognizer];
    
    [msgLabel setImage:[UIImage imageNamed:@"menu_logo"]];
    
    pointView=[[UIView alloc]initWithFrame:CGRectMake(8, 0, 8, 8)];
    
    [pointView setBackgroundColor:[UIColor redColor]];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = (pointView.frame.size.width + 10) / 4;
    [pointView setHidden:YES];
    [msgLabel addSubview:pointView];
    
    
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
                                                               hegiht-(titleHeight))];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    mainTableView.dataSource                        = self;
    mainTableView.delegate                          = self;
    mainTableView.rowHeight                         = self.view.bounds.size.height*7/12;
    mainTableView.tableHeaderView=tableHeaderView;
    mainTableView.separatorStyle=NO;
    //[self.view addSubview:mainTableView];
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
    [myMsgViewController init];
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
    slideMenu.navRightBtAction;
}
-(void)changeLoginStauets{
    [loginedControl setHidden:NO];
    [unloginControl setHidden:YES];
    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    HttpModel *httpModel=appDelegate.model;
    if([httpModel.result count]>0){
        [userNameLabel setText:[httpModel.result objectForKey:@"username"]];
    }
    [userTelLabel setText:[NSString stringWithFormat:@"%@", httpModel.tel]];
    [slideMenu setUserPhone:[NSString stringWithFormat:@"%@", httpModel.tel]];
    [self getUserInfo];
    [self getData];
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
                NSLog(@"2222222222222223___%@",model.result);
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
        LoginViewController *loginViewController=[[LoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
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
            
            MyCollectViewController *myCollectViewController=[[MyCollectViewController alloc]init];
            [self presentViewController: myCollectViewController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
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
    
    
    
    // NSNumber *userId=[dic objectForKey:@"id"];
    NSString *username=[dic objectForKey:@"username"];
    NSNumber *tel=[dic objectForKey:@"tel"];
    NSString *logo=[dic objectForKey:@"logo"];
    NSNumber *sex=[dic objectForKey:@"sex"];
    NSString *addr=[dic objectForKey:@"addr"];
    
    NSNumber *bk=[dic objectForKey:@"bk"];
    NSNumber *acce=[dic objectForKey:@"acce"];
    //  NSNumber *inter=[dic objectForKey:@"inter"];
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

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                NSLog(@"修改密码");
            }
                break;
            case 3:
            {
                NSLog(@"修改电话");
            }
                break;
            case 4:
            {
                NSLog(@"地址");
            }
                break;
            case 5:
            {
                NSLog(@"联系我们");
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
    }
}
//预约列表
-(void)getData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AppDelegate *myDelegate=( AppDelegate *)[[UIApplication sharedApplication]delegate];
        [HttpHelper getMyLessonList:[NSNumber numberWithInt:0] withPageNumber:[NSNumber numberWithInt:1] withPageLine:[NSNumber numberWithInt:5] withModel:myDelegate.model success:^(HttpModel *model){
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
    AppDelegate *myDelegate = ( AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.model!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [HttpHelper logoutAcount:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        if (alertView==nil) {
                            alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alertView.delegate=self;
                        }
                        [alertView setTag:1];
                        [alertView setMessage:model.message];
                        [alertView show];
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
}
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)uiAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
    switch (uiAlertView.tag) {
        case 1:
        {
            [self changeLogoutStauets];
        }
            break;
            
        default:
            break;
    }
}


@end