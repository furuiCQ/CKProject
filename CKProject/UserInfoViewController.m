//
//  UserInfoViewController.m
//  CKProject
//
//  Created by furui on 15/12/11.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CustomControl.h"
#import "ForgetViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+JJKAlertActionFont.h"
#import "MainViewController.h"
#import "UIImage+ImageCompress.h"

@interface UserInfoViewController ()<UIAlertViewDelegate ,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@end

@implementation UserInfoViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize userInfoArry;
@synthesize alertDialog;
@synthesize dicatorView;
@synthesize userLogo;
@synthesize controlArray;
@synthesize customAlertView;
@synthesize updateTag;
@synthesize warnAlertView;
@synthesize logAlertView;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view Did Load");
    if (warnAlertView==nil) {
        warnAlertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        warnAlertView.delegate=self;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    controlArray=[[NSMutableArray alloc]init];
    [self initTitle];
    [self initCotentView];
    [self getUserInfo];
    
    // Do any additional setup after loading the view, typically from a nib.
}


//-(void)getUserInfo{
//        // 耗时的操作
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        if (updateTag==1) {
//            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if (myDelegate.model!=nil) {
//                
//                [HttpHelper getUserInfo:myDelegate.model success:^(HttpModel *model){
//                    NSLog(@"%@",model.message);
//                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
//                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                        myDelegate.model=model;
//                        [self setData:model.result];
//                    }else{
//                        
//                    }
//                    
//                    
//                }failure:^(NSError *error){
//                    if (error.userInfo!=nil) {
//                        NSLog(@"%@",error.userInfo);
//                    }
//                }];
//            }
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//    });
//    
//}
//获得数据
-(void)getUserInfo{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (myDelegate.model!=nil) {
            
            [HttpHelper getUserInfo:myDelegate.model success:^(HttpModel *model){
                NSLog(@"%@",model.message);
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
-(void)setData:(NSDictionary *)dic{
    
    
    
    NSNumber *userId=[dic objectForKey:@"id"];
    NSString *username=[dic objectForKey:@"username"];
    NSNumber *tel=[dic objectForKey:@"tel"];
    NSString *logo=[dic objectForKey:@"logo"];
    NSNumber *sex=[dic objectForKey:@"sex"];
    NSString *addr=[dic objectForKey:@"addr"];
    
//    NSNumber *bk=[dic objectForKey:@"bk"];
//    NSNumber *acce=[dic objectForKey:@"acce"];
//    NSNumber *inter=[dic objectForKey:@"inter"];
//    NSNumber *ismessage=[dic objectForKey:@"ismessage"];
    
//    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
//    if (![bk isEqual:[NSNull null]]) {
//        [numbLabel setText:[NSString stringWithFormat:@"%@",bk]];
//    }
//    if (![logo isEqual:@""] && logo!=nil && ![logo isEqual:[NSNull null]]) {
//        [userImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
//    }else{
//        [userImageView setImage:[UIImage imageNamed:@"logo"]];
//        logo=@"";
//    }
//    if (![acce isEqual:[NSNull null]]) {
//        [sucessNumbLabel setText:[NSString stringWithFormat:@"%@",acce]];
//    }
//    if (![inter isEqual:[NSNull null]]) {
//        [postNumbLabel setText:[NSString stringWithFormat:@"%@",inter]];
//    }
//    if (![username isEqual:[NSNull null]]) {
//        [userNameLabel setText:[NSString stringWithFormat:@"%@",username]];
//    }
//    
//    if(![ismessage isEqual:[NSNull null]]){
//        
//        if([ismessage isEqualToNumber:[NSNumber numberWithInt:0]])
//            
//        {
//            [pointView setHidden:YES];
//            hasMsg=NO;
//            NSNotification *notification =[NSNotification notificationWithName:@"hiddenpoint" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            
//        }else{
//            [pointView setHidden:NO];
//            hasMsg=YES;
//            
//            NSNotification *notification =[NSNotification notificationWithName:@"showpoint" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//        }
//        
//    }
    
    userInfoArry=[[NSMutableArray alloc]init];
    [userInfoArry addObject:logo];
    [userInfoArry addObject:username];
    if ([sex isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [userInfoArry addObject:@"男"];
    }else{
        [userInfoArry addObject:@"女"];
    }
    [userInfoArry addObject:@""];
    [userInfoArry addObject:tel];
    [userInfoArry addObject:addr];
    [userInfoArry addObject:userId];
    
    
    
    
}



//-(void)setData:(NSDictionary *)dic{
//    //"id":8,"username":"furui123","tel":"18716341029","email":null,"logo":null,"sex":1,"bk":0,"acce":0,"inter":0
//    NSNumberFormatter *fomaterr=[[NSNumberFormatter alloc]init];
//    
//    NSNumber *userId=[dic objectForKey:@"id"];
//    NSString *username=[dic objectForKey:@"username"];
//    NSString *tel=[dic objectForKey:@"tel"];
//    NSString *logo=[dic objectForKey:@"logo"];
//    NSNumber *sex=[dic objectForKey:@"sex"];
//    
//    userInfoArry=[[NSMutableArray alloc]init];
//    [userInfoArry addObject:logo];
//    [userInfoArry addObject:username];
//    if ([sex isEqualToNumber:[NSNumber numberWithInt:1]]) {
//        [userInfoArry addObject:@"男"];
//    }else{
//        [userInfoArry addObject:@"女"];
//    }
//    [userInfoArry addObject:@""];
//    [userInfoArry addObject:tel];
//    [userInfoArry addObject:[fomaterr stringFromNumber:userId]];
//    
//}

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
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    
    cityLabel.userInteractionEnabled=YES;//
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"个人资料"];
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    msgLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *registerRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completeUserInfo)];
    [msgLabel addGestureRecognizer:registerRecognizer];
    [msgLabel setText:@"保存"];
    [msgLabel setTextColor:[UIColor orangeColor]];
    [msgLabel setHidden:NO];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}

-(void)initCotentView{
    
    int width=self.view.frame.size.width;
    
    NSArray *tableArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"修改密码",@"电话",@"地址", nil];
    for(int i=0;i<[tableArray count];i++){
        //我的报名记录
        NSLog(@"%d",i);
        CustomControl *myRecord=[[CustomControl alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5+width/6.5*i+i*0.5, width, width/6.5)];
        CGRect frame=self.view.frame;
        [myRecord initView:&frame];
        [myRecord setTag:i];
        [myRecord addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i==0){
            [myRecord.userLogo setHidden:NO];
            if ([userInfoArry objectAtIndex:i]) {
                myRecord.userLogo.layer.masksToBounds = YES;
                myRecord.userLogo.layer.cornerRadius = (userLogo.frame.size.width) / 2;
                NSString *imageUrl=[NSString stringWithFormat:@"%@",[userInfoArry objectAtIndex:i] ];
                if(![imageUrl isEqualToString:@""] && ![imageUrl isEqualToString:@"<null>"]){
                    [myRecord.userLogo  sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:imageUrl]]];
                }
            }
            [myRecord.bundleLabel setHidden:YES];
            
        }
      

    
        if(i!=0 && i!=3){
            [myRecord.userLogo setHidden:YES];
            [myRecord.bundleLabel setHidden:YES];
            
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[userInfoArry objectAtIndex:i] ];
            if(![imageUrl isEqualToString:@""] && ![imageUrl isEqualToString:@"<null>"]){
                [myRecord.userNameLabel setText:imageUrl];
                [myRecord.userNameLabel addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];

            }
            
        }
        
        [myRecord.recordLabel setText:[tableArray objectAtIndex:i]];
        [myRecord.recordLabel setTextColor:[UIColor grayColor]];
        [myRecord.recordLabel setFont:[UIFont systemFontOfSize:width/22.8]];
        
        if(i!=4){
            [myRecord.recordRight setHidden:YES];
        }
        if (i==3 ) {
            [myRecord.userLogo setHidden:YES];
            [myRecord.recordRight setImage:[UIImage imageNamed:@"right_logo"]];
            [myRecord.bundleLabel setHidden:YES];
            [myRecord.recordRight setHidden:NO];

        }
        if(i==0){
            [myRecord.recordRight setHidden:NO];
        }
        if (i==4) {
            [myRecord.bundleLabel setHidden:NO];
            [myRecord.recordRight setHidden:YES];
            [myRecord.bundleLabel setText:@"已绑定"];
            [myRecord.bundleLabel setTextAlignment:NSTextAlignmentCenter];
            [myRecord.bundleLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:158.f/255.f blue:42.f/255.f alpha:1.0]];
            [myRecord.bundleLabel setFont:[UIFont systemFontOfSize:11]];
            myRecord.bundleLabel.layer.borderColor= [UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor; //要设置的颜色
            myRecord.bundleLabel.layer.cornerRadius=5.0;
            myRecord.bundleLabel.layer.borderWidth = 1; //要设置的描边宽
            myRecord.bundleLabel.layer.masksToBounds=YES;
        }
        [self.view addSubview:myRecord];
        
        [controlArray addObject:myRecord];
    }
}
- (void) textChangeAction:(id) sender {
    [msgLabel setHidden:NO];
}
-(void)onClick:(id)sender{
    CustomControl *control=(CustomControl*)sender;
    switch (control.tag)
    {
        case 0:
        {
            NSLog(@"case 0");
            [self addActionSheet];
        }
            break;
        case 1:
        {
             NSLog(@"case 1");
            [control.userNameLabel setEnabled:YES];

            //[self showResetAlertView:sender withTitle:@"修改昵称" withPlaceHolder:@"请输入昵称"];
        }
            break;
            
        case 2:
        {
            NSLog(@"case 2");
//            [control.userNameLabel resignFirstResponder];
            [self addSexAction:sender];
            
           // [self showResetAlertView:sender withTitle:@"修改性别" withPlaceHolder:@"请输入性别"];
            
        }
            break;
        case 3:
        {
            ForgetViewController *forgetViewController=[[ForgetViewController alloc]init];
            [self presentViewController:forgetViewController animated:YES completion:nil];
        }
            break;
        case 5:
        {
            [control.userNameLabel setEnabled:YES];

        }
            break;
    }
}
-(void)showResetAlertView:(id)sender withTitle:(NSString *)title withPlaceHolder:(NSString *)placeholder{
    CustomControl *control=(CustomControl*)sender;
    if (customAlertView==nil) {
        customAlertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    }
    customAlertView.delegate=self;
    [customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    NSLog(@"contol.tag----%li",control.tag);
    [customAlertView setTag:control.tag];
    UITextField *nameField = [customAlertView textFieldAtIndex:0];
    nameField.placeholder = placeholder;
    nameField.text=control.userNameLabel.text;
    [customAlertView show];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        CustomControl *control=[controlArray objectAtIndex:alertView.tag];
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *context=nameField.text;
        
        switch (alertView.tag) {
            case 1:
                
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [HttpHelper resetName:context withModel:myDelegate.model success:^(HttpModel *model){
                        NSLog(@"%@",model.message);
                        dispatch_async(dispatch_get_main_queue(), ^{

                        if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            myDelegate.model=model;
                            [control.userNameLabel setText:context];
                          
                        }else{
                            
                        }
                        [warnAlertView setMessage:model.message];
                        [warnAlertView show];
                        });
                        
                        
                    }failure:^(NSError *error){
                        if (error.userInfo!=nil) {
                            NSLog(@"error userInfo:===>%@",error.userInfo);
                            NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                            if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                                
                                [warnAlertView setMessage:localizedDescription];
                                [warnAlertView show];
                            }
                        }
                    }];
                });
            }
                break;
            case 2:
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                [HttpHelper resetSex:context withModel:myDelegate.model success:^(HttpModel *model){
                    NSLog(@"%@",model.message);
                    dispatch_async(dispatch_get_main_queue(), ^{

                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        myDelegate.model=model;
                        [control.userNameLabel setText:context];
                        
                        
                    }else{
                        
                    }
                    [warnAlertView setMessage:model.message];
                    [warnAlertView show];
                    });
                    
                    
                }failure:^(NSError *error){
                    if (error.userInfo!=nil) {
                        NSLog(@"error userInfo:===>%@",error.userInfo);
                        NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                        if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                            
                            [warnAlertView setMessage:localizedDescription];
                            [warnAlertView show];
                        }
                    }
                }];
                });
            }
                break;
            case 5:
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                [HttpHelper resetAddress:context withModel:myDelegate.model success:^(HttpModel *model){
                    NSLog(@"%@",model.message);
                    dispatch_async(dispatch_get_main_queue(), ^{

                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        myDelegate.model=model;
                        [control.userNameLabel setText:context];

                  
                    }else{
                        
                    }
                    [warnAlertView setMessage:model.message];
                    [warnAlertView show];
                    });
                    
                    
                }failure:^(NSError *error){
                    if (error.userInfo!=nil) {
                        NSLog(@"error userInfo:===>%@",error.userInfo);
                        NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                        if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                            
                            [warnAlertView setMessage:localizedDescription];
                            [warnAlertView show];
                        }
                    }
                }];
                });
            }
                break;
            default:
                break;
        }
        
        //TODO
    }
}
-(void)addActionSheet{
    
    int width=self.view.frame.size.width;
    NSString *okButtonTitle = @"取消";
    NSString *neverButtonTitle = @"从相册选择";
    NSString *laterButtonTitle = @"拍照";
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:width/22.8];
    [appearanceLabel setAppearanceFont:font];
    // 初始化
    if (alertDialog==nil) {
        alertDialog = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 分别3个创建操作
        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:laterButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"0");
            [self takePhoto];
        }];
        [laterAction setValue:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *neverAction = [UIAlertAction actionWithTitle:neverButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"2");
            [self openAlbum ];
            
        }];
        [neverAction setValue:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 取消按键
            NSLog(@"3");
            
        }];
        [okAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:laterAction];
        [alertDialog addAction:neverAction];
        [alertDialog addAction:okAction];
        
        // 呈现警告视图
    }
    
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}
-(void)addSexAction:(id)sender{
    CustomControl *control=(CustomControl*)sender;

    int width=self.view.frame.size.width;
    NSString *okButtonTitle = @"取消";
    NSString *neverButtonTitle = @"女";
    NSString *laterButtonTitle = @"男";
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:width/22.8];
    [appearanceLabel setAppearanceFont:font];
    // 初始化
    if (alertDialog==nil) {
        alertDialog = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 分别3个创建操作
        UIAlertAction *laterAction1 = [UIAlertAction actionWithTitle:laterButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"0");
           // [self takePhoto];
            [control.userNameLabel setText:laterButtonTitle];

        }];
        [laterAction1 setValue:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *neverAction2 = [UIAlertAction actionWithTitle:neverButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"2");
           // [self openAlbum ];
            [control.userNameLabel setText:neverButtonTitle];
            
        }];
        [neverAction2 setValue:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0] forKey:@"_titleTextColor"];
        
        UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 取消按键
           // NSLog(@"3");
            
        }];
        [okAction3 setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:laterAction1];
        [alertDialog addAction:neverAction2];
        [alertDialog addAction:okAction3];
        
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
        [self creatDicatorView];
        [picker dismissViewControllerAnimated:YES completion:nil];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [HttpHelper upload:myDelegate.model withImageUrl:imageURl withImage:image success:^(HttpModel *model){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [userLogo setImage:image];
                    [dicatorView stopAnimating];
                });
                
                
            }failure:^(NSError *error){
                
                [dicatorView stopAnimating];
                
            }];
            
            
            
            
        });
        
        
    }
//    MainViewController *main=[[MainViewController alloc]init];
//    [self presentViewController:main animated:NO completion:nil]
      //返回上一次层
   
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    MainTabBarViewController *vo=[[MainTabBarViewController alloc]init];
//    [self presentViewController:vo animated:YES completion:nil];
    
    
    
}
-(void)creatDicatorView{
    if (dicatorView==nil) {
        dicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [dicatorView setFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
        [dicatorView setColor:[UIColor blackColor]];
        [dicatorView startAnimating];
        [self.view addSubview:dicatorView];
    }
    [dicatorView startAnimating];
    
}
-(void)completeUserInfo{
    if (logAlertView==nil) {
        logAlertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        logAlertView.delegate=self;
    }
    
    AppDelegate *myDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    CustomControl  *userNameControl=(CustomControl *)[controlArray objectAtIndex:1];
    NSString *username=userNameControl.userNameLabel.text;
  //  CustomControl  *sexControl=(CustomControl *)[controlArray objectAtIndex:5];

    
    
    CustomControl  *addControl=(CustomControl *)[controlArray objectAtIndex:5];
    NSString *add=addControl.userNameLabel.text;
    CustomControl  *ppp=(CustomControl *)[controlArray objectAtIndex:2];
    NSString *pd=ppp.userNameLabel.text;
    NSNumber *bt;
    if ([pd isEqualToString:@"男"]) {
        bt=[NSNumber numberWithInt:1];
    }
    else
    {
        bt=[NSNumber numberWithInt:2];

    
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [HttpHelper completeUserInfo:username withUserSex:bt withAddr:add withModel:myDelegate.model success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.model=model;
                
                [logAlertView setTag:1];
                [self getUserInfo];
                
            }else{
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [logAlertView setMessage:model.message];
                
                
                NSLog(@"87654857--%@",model.message);
                [logAlertView show];
                NSNotification *notification =[NSNotification notificationWithName:@"refresh" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSNotification *notification2 =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification2];
                
            });
            
            
            
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"error userInfo:===>%@",error.userInfo);
                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [logAlertView setMessage:localizedDescription];
                        [logAlertView show];
                    });
                  
                }
            }
        }];
        
    });
    
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    updateTag=0;
    [self dismissViewControllerAnimated:YES completion:nil];
}
bool saveImageToCacheDir(NSString *directoryPath, UIImage *image, NSString *imageName, NSString *imageType)
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    NSData *imageToCompressData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1)];
    NSLog([NSString stringWithFormat:@"Original size: %lu", (unsigned long)imageToCompressData.length]);
    image= [UIImage compressImage:image
                    compressRatio:0.9f];
    imageToCompressData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1)];
    NSLog([NSString stringWithFormat:@"Original size: %lu", (unsigned long)imageToCompressData.length]);

    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    image=nil;
    return isSaved;
}

@end