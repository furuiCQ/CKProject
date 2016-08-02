//
//  msViewController.m
//  CKProject
//
//  Created by user on 16/7/20.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "msViewController.h"
#import "ForgetViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+JJKAlertActionFont.h"
#import "MainViewController.h"
#define  swidth self.view.frame.size.width
#define  sheight self.view.frame.size.height
@interface msViewController ()<UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CGFloat titleHeight;
    UILabel *cityLabel;
    UILabel * searchLabel;
    UILabel * msgLabel;
    UIView *titleView;
    UIView *v1;
    UIView *v2;
    UIView *v3;
    UIView *v4;
    UIView *v5;
    UIView *v6;
    UIView *v7;
    UIImageView *topimg;
    UITextField *names;
    UILabel *sex;
    UILabel *tell;
    UITextField *place;
    NSDictionary *dic;
    UIAlertView *alter;
    
  
}
@end

@implementation msViewController

- (void)viewDidLoad {
    [super viewDidLoad];
self.view.backgroundColor=[UIColor greenColor];
    [self chaxunshuju];
    [self initTitle];
    [self initmainview];

    // Do any additional setup after loading the view.
}
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, titleHeight)];
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
//-(void)completeUserInfo{
//    
//    AppDelegate *myDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
////    CustomControl  *userNameControl=(CustomControl *)[controlArray objectAtIndex:1];
////    NSString *username=userNameControl.userNameLabel.text;
//    //  CustomControl  *sexControl=(CustomControl *)[controlArray objectAtIndex:5];
//    
//    
//    
//
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 耗时的操作
//        [HttpHelper completeUserInfo:username withUserSex:[NSNumber numberWithInt:1] withAddr:add withModel:myDelegate.model success:^(HttpModel *model){
//            
//            NSLog(@"%@",model.message);
//            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
//                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                myDelegate.model=model;
//                
//                [logAlertView setTag:1];
//                [self getUserInfo];
//                
//            }else{
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [logAlertView setMessage:model.message];
//                [logAlertView show];
//                NSNotification *notification =[NSNotification notificationWithName:@"refresh" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//                NSNotification *notification2 =[NSNotification notificationWithName:@"refresh_userInfo" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:notification2];
//                
//            });
//            
//            
//            
//        }failure:^(NSError *error){
//            if (error.userInfo!=nil) {
//                NSLog(@"error userInfo:===>%@",error.userInfo);
//                NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
//                if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [logAlertView setMessage:localizedDescription];
//                        [logAlertView show];
//                    });
//                    
//                }
//            }
//        }];
//        
//    });
//    
//    
//}


-(void)initmainview
{
    v1=[[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height+3,swidth , sheight/14)];
    v1.backgroundColor=[UIColor whiteColor];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, swidth/7, v1.frame.size.height)];
    la.text=@"头像";
    [v1 addSubview:la];
    topimg=[[UIImageView alloc]initWithFrame:CGRectMake(swidth-swidth/20-swidth/40-swidth/10-swidth/20, (swidth/6.5-swidth/10)/4, swidth/10, swidth/10)];
    [topimg setImage:[UIImage imageNamed:@"5.jpg"]];
    topimg.layer.cornerRadius=3.0f;
    topimg.contentMode=UIViewContentModeScaleAspectFit;
    [v1 addSubview:topimg];
    
    [self.view addSubview:v1];
    v2=[[UIView alloc]initWithFrame:CGRectMake(0, v1.frame.origin.y+v1.frame.size.height+3,swidth , sheight/14)];
    v2.backgroundColor=[UIColor whiteColor];
   
    UILabel *la1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, swidth/7, v1.frame.size.height)];
    la1.text=@"昵称";
    [v2 addSubview:la1];
    names=[[UITextField alloc]initWithFrame:CGRectMake(la1.frame.size.width+la1.frame.origin.x+40, 0, swidth-la1.frame.size.width-la1.frame.origin.x-60,sheight/14)];
    
    
    names.text=@"";
    [v2 addSubview:names];
    [self.view addSubview:v2];
  
    v3=[[UIView alloc]initWithFrame:CGRectMake(0, v2.frame.origin.y+v2.frame.size.height+3,swidth , sheight/14)];
    v3.backgroundColor=[UIColor whiteColor];
    UILabel *la2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, swidth/7, v2.frame.size.height)];
    la2.text=@"性别";
    [v3 addSubview:la2];
    
    sex=[[UILabel alloc]initWithFrame:CGRectMake(la2.frame.size.width+la2.frame.origin.x+40, 0, swidth/4, v3.frame.size.height)];
    sex.text=@"男";
    [v3 addSubview:sex];
    [self.view addSubview:v3];
    
    v4=[[UIView alloc]initWithFrame:CGRectMake(0, v3.frame.origin.y+v3.frame.size.height+3,swidth , sheight/14)];
    v4.backgroundColor=[UIColor whiteColor];
    UILabel *la3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,swidth/4, v4.frame.size.height)];
    la3.text=@"修改密码";
    [v4 addSubview:la3];
    [self.view addSubview:v4];
    
    v5=[[UIView alloc]initWithFrame:CGRectMake(0, v4.frame.origin.y+v4.frame.size.height+3,swidth , sheight/14)];
    v5.backgroundColor=[UIColor whiteColor];
    UILabel *la4=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,swidth/4, v4.frame.size.height)];
    la4.text=@"电话号码";
    
    tell=[[UILabel alloc]initWithFrame:CGRectMake(la4.frame.size.width+la4.frame.origin.x+5, 0, swidth/3, sheight/14)];
    tell.text=@"";
    UILabel *bd=[[UILabel alloc]initWithFrame:CGRectMake(swidth-swidth/9,v5.frame.size.height/3,swidth/10, v5.frame.size.height/3)];
    bd.text=@"已绑定";
    bd.backgroundColor=[UIColor grayColor];
    bd.font=[UIFont systemFontOfSize:swidth/30];
    bd.textColor=[UIColor greenColor];
    bd.layer.cornerRadius=4.0f;
    bd.clipsToBounds = YES;
    [v5 addSubview:bd];
    [v5 addSubview:tell];
    [v5 addSubview:la4];
    [self.view addSubview:v5];
    
    v6=[[UIView alloc]initWithFrame:CGRectMake(0, v5.frame.origin.y+v5.frame.size.height+3,swidth , sheight/14)];
    v6.backgroundColor=[UIColor whiteColor];
    UILabel *la5=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,swidth/6, v6.frame.size.height)];
    la5.text=@"地址";
    place=[[UITextField alloc]initWithFrame:CGRectMake(la5.frame.size.width+la5.frame.origin.x+20, 0,swidth/2, sheight/14)];
    
//    names=[[UITextField alloc]initWithFrame:CGRectMake(la1.frame.size.width+la1.frame.origin.x+40, 0, swidth-la1.frame.size.width-la1.frame.origin.x-60,sheight/14)];
    [v6 addSubview:la5];
     [v6 addSubview:place];
    [self.view addSubview:v6];
    
    
    
    
    v1.userInteractionEnabled=YES;//
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click1)];
    [v1 addGestureRecognizer:gesture];
    v3.userInteractionEnabled=YES;//
    UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click3)];
    [v3 addGestureRecognizer:gesture1];
    
    v4.userInteractionEnabled=YES;//
    UITapGestureRecognizer *gesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click4)];
    [v4 addGestureRecognizer:gesture2];

}
//更换头像
-(void)click1
{
  
    alter=[[UIAlertView alloc]initWithTitle:@"选择方式" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册获取",nil];
    alter.delegate=self;
    alter.tag=1;
    [alter show];
    


}


-(void)click3
{
    alter=[[UIAlertView alloc]initWithTitle:@"选择性别" message:@"" delegate:nil cancelButtonTitle:@"男" otherButtonTitles:@"女",nil];
    alter.delegate=self;
    alter.tag=0;
    [alter show];
   
    
    
    
    
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alter.tag==0) {
        sex.text=[alter buttonTitleAtIndex:buttonIndex];
        NSLog(@"选择：%@", [alter buttonTitleAtIndex:buttonIndex]);
    }
    if (alter.tag==1) {
        if (buttonIndex==1) {
            [self takePhoto];
        }
        if (buttonIndex==2) {
            [self openAlbum];
        }
    }
   
}
-(void)completeUserInfo{
    AppDelegate *myDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *username=names.text;
    //  CustomControl  *sexControl=(CustomControl *)[controlArray objectAtIndex:5];
    
    
    
 
    NSString *add=place.text;
    NSNumber *num;
    if ([sex.text isEqualToString:@"男"]) {
        num=[NSNumber numberWithInteger:1];
    }
    else
    {
    num=[NSNumber numberWithInteger:2];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [HttpHelper completeUserInfo:username withUserSex:num withAddr:add withModel:myDelegate.model success:^(HttpModel *model){
            
            NSLog(@"999999999999999999999---%@",model.message);
            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.model=model;
                
              
//                [self getUserInfo];
                
            }else{
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                [logAlertView setMessage:model.message];
//                [logAlertView show];
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
//                        [logAlertView setMessage:localizedDescription];
//                        [logAlertView show];
                    });
                    
                }
            }
        }];
        
    });
    
    
}

//bool saveImageToCacheDir(NSString *directoryPath, UIImage *image, NSString *imageName, NSString *imageType)
//{
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
//    bool isSaved = false;
//    image=[ImageCompress compressImage:image compressRatio:0.9f];
//    if ( isDir == YES && existed == YES )
//    {
//        if ([[imageType lowercaseString] isEqualToString:@"png"])
//        {
//            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
//        }
//        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
//        {
//            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
//        }
//        else
//        {
//            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
//        }
//    }
//    image=nil;
//    return isSaved;
//}

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
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{

}
-(void)click4
{
  
    ForgetViewController *vi=[[ForgetViewController alloc]init];
    [self presentViewController:vi animated:YES completion:nil];
    
    
    
}
-(void)click5
{
    
    
    
    
    
}
-(void)click6
{
    
    
    
    
    
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
    
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [HttpHelper upload:myDelegate.model withImageUrl:imageURl withImage:image success:^(HttpModel *model){
                NSLog(@"成功或失败：%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [topimg setImage:image];
                   
                });
                
                
            }failure:^(NSError *error){
                
               
                
            }];
            
            
            
            
        });
        
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    MainViewController *main=[[MainViewController alloc]init];
    //    [self presentViewController:main animated:NO completion:nil]
    //返回上一次层
    
    
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    //    MainTabBarViewController *vo=[[MainTabBarViewController alloc]init];
    //    [self presentViewController:vo animated:YES completion:nil];
    
    
    
}


-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self];
    }];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}

-(void)chaxunshuju
{
    //保存登录状态数据
    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
  NSString *pho=  [defa objectForKey:@"phon"];
 NSString *paw=[defa objectForKey: @"pas"];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper loginAcount:pho with:paw success:^(HttpModel *model){
            NSLog(@"我想要的只是你：%@",model.result);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dic=model.result;
                    NSString *bt=[dic objectForKey:@"logo"];
                    NSString *sb=[NSString stringWithFormat:@"http://211.149.190.90%@",bt];
                    topimg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sb]]];
                    names.text=[dic objectForKey:@"username"];
                    if ([[dic objectForKey:@"sex"]intValue]==1) {
                        sex.text=@"男";
                    }
                    else
                    {
                    sex.text=@"女";
                    }
                    tell.text=[[dic objectForKey:@"tel"]stringValue];
                    place.text=[dic objectForKey:@"addr"];
//                    我想要的只是你：{
//                        acce = 2;
//                        addr = "";
//                        bk = 2;
//                        cityid = 0;
//                        created = 1463131609;
//                        deleted = 0;
//                        email = "<null>";
//                        id = 184;
//                        inter = 3;
//                        ismessage = 0;
//                        lastlogin = 1469023486;
//                        logo = "/Public/image/upload/20160718/578c6d6625ff0.png";
//                        provid = 0;
//                        qq = "<null>";
//                        qqid = "<null>";
//                        qqtoken = "<null>";
//                        sex = 1;
//                        tel = 15703021869;
//                        townid = 0;
//                        username = "Ak47 ";
//                        wbid = "<null>";
//                        wbtoken = "<null>";
//                        wxid = "<null>";
//                        wxtoken = "<null>";
//                    }

                    
                }
               
            });
            
        }failure:^(NSError *error){
        }];
    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
