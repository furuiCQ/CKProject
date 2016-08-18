//
//  OrderViewController.m
//  CKProject
//
//  Created by furui on 15/12/22.
//  Copyright © 2015年 furui. All rights reserved.
//

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)

#import "OrderViewController.h"
#import "ShareTools.h"
#import "RJShareView.h"
@interface OrderViewController (){
    
}

@end

@implementation OrderViewController
@synthesize titleHeight;
@synthesize advancetime;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize projectId;
@synthesize content;
@synthesize weekId;
@synthesize weekNum;
@synthesize beginTime;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initTitle];
    [self initContentView];
    
    [self orderPoject];
}
-(void)adismiss
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;///
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //[searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"预约中"];
    
//    //新建右上角的图形
//    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
//    msgLabel.userInteractionEnabled=YES;///
//    UITapGestureRecognizer *shareGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
//    [msgLabel addGestureRecognizer:shareGesutre];
//    UIImageView *shareView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_logo"]];
//    [shareView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/12.3/2, titleHeight/2-self.view.frame.size.width/12.3/2, self.view.frame.size.width/12.3, self.view.frame.size.width/12.3)];
//    [msgLabel addSubview:shareView];
//    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
//-(void)share{
//    NSString *title=[[@"我蹭到免费的“"stringByAppendingString:searchLabel.text]stringByAppendingString:@"”课程了"];
//    NSString *description=content;
//    NSString *imageurl=[[NSString alloc]init];
//    NSString *url=@"http://211.149.190.90/m/20160126/index.html";
//    
//    
//    NSDictionary *jsonData=[NSDictionary  dictionaryWithObjectsAndKeys:title,@"title",
//                            description,@"description",imageurl,@"imageurl",url,@"url",nil];
//    [RJShareView showGridMenuWithTitle:@"分享到..."
//                            itemTitles:@[@"微信好友",@"朋友圈",@"微博",@"QQ好友",@"QQ空间"]
//                                images:@[[UIImage imageNamed:@"weixin"],[UIImage imageNamed:@"wx_circle"],[UIImage imageNamed:@"weibo"],[UIImage imageNamed:@"qq"],[UIImage imageNamed:@"qzone"]]
//                             shareJson:jsonData
//                        selectedHandle:^(NSInteger index){
//                            switch (index) {
//                                case 1:
//                                case 2:
//                                    if (![WXApi isWXAppInstalled]) {
//                                        [ProgressHUD showError:@"未安装微信！"];
//                                    }
//                                    break;
//                                    
//                                case 3:
//                                    if (![WeiboSDK isWeiboAppInstalled]) {
//                                        [ProgressHUD showError:@"未安装微博！"];
//                                    }
//                                    break;
//                                    
//                                case 4:
//                                case 5:
//                                    if (![TencentOAuth iphoneQQInstalled]) {
//                                        [ProgressHUD showError:@"未安装QQ！"];
//                                    }
//                                    break;
//                                    
//                            }
//                        }];
//}
-(void)initContentView{
    int width=self.view.frame.size.width;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((width-width/2.7)/2, titleHeight+20+width/5, width/2.7, width/2.7)];
    [imageView setImage:[UIImage imageNamed:@"order_ok_logo.jpg"]];
    [self.view addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/2.7+width/5+width/12, width, width/26.7)];
    [label setText:@"您的课程已预定，客服正在飞速受理中..."];
    [label setFont:[UIFont systemFontOfSize:width/26.7]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
    [self.view addSubview:label];

}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)orderPoject{
    AppDelegate *mydelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper orderLesson:projectId withWeekId:weekId withWeekNum:weekNum withBtime:beginTime  withadvancetime:advancetime withModel:mydelegate.model  success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                      //  NSDictionary *dic=model.result;
                   
                        
                    });
                    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end