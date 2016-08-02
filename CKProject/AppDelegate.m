//
//  AppDelegate.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadingViewController.h"
#import "MainViewController.h"
#import "SortViewController.h"
#import "CircleViewController.h"
#import "MineViewController.h"
#import "ScaleImgViewController.h"
#import "WXApi.h"
#import "LoginViewController.h"
#import "WechatAuthSDK.h"
#import "HttpModel.h"
#import "msViewController.h"
#import "MationViewController.h"
#import "HttpHelper.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
@synthesize model;
@synthesize selectIndex;

@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;
@synthesize isLogin;
@synthesize QQauth;
static NSString * const WeiboKey=@"2850266283";
static NSString * const QQKey=@"1105170232";
static NSString * const WXKey=@"wxd1cc67205c307199";
static NSString * const WXSECRET=@"990d34906f1041777cc6867dbf2fdddb";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //        ScaleImgViewController *mtvc=[[ScaleImgViewController alloc]init];
    //        self.window.rootViewController=mtvc;
    //向微信注册
    [WXApi registerApp:@"wxd1cc67205c307199"];
    
    
    
    //判断是否登陆，由登陆状态判断启动页面
    NSArray *selectArray =[NSArray arrayWithObjects:@"main_select",@"news",@"junyouhui",@"sort_select",@"mine_select",nil];
    NSArray *unselectArray =[NSArray arrayWithObjects:@"main_unselect",@"news",@"junyouhui",@"sort_unselect",@"mine_unselect",nil];
    NSArray *textArray =[NSArray arrayWithObjects:@"首页",@"新闻",@"聚优惠",@"分类",
                         @"我",nil];
    NSArray *viewControllerArray =[NSArray arrayWithObjects:[[MainViewController alloc]init],[[MationViewController alloc]init],[[SortViewController alloc]init],[[MineViewController alloc]init],[[msViewController alloc]init],nil];
    
    MainTabBarViewController *mtvc=[[MainTabBarViewController alloc]init];
    NSMutableArray *vcArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[textArray count]; i++) {
        UIViewController *vc=[viewControllerArray objectAtIndex:i];
        vc.tabBarItem.title=[textArray objectAtIndex:i];
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        vc.tabBarItem.image=[UIImage imageNamed:[unselectArray objectAtIndex:i]];
        vc.tabBarItem.selectedImage=[UIImage imageNamed:[selectArray objectAtIndex:i]];
        [vcArray addObject:vc];
    }
    [mtvc.tabBar setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0]];
    mtvc.tabBar.selectedImageTintColor=[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0];
    [mtvc setViewControllers:[vcArray copy]];
    self.window.rootViewController=mtvc;
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboKey];
    [WXApi registerApp:WXKey];
    QQauth=[[TencentOAuth alloc] initWithAppId:QQKey andDelegate:self]; //注册
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //保存登录状态数据
    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
    //保存登录状态数据
//    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
//    [defa setObject:phone forKey:@"phon"];
//    [defa setObject:password forKey:@"pas"];
//    //获取UserDefault
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [defa objectForKey:@"ipon"];
    NSString *password=[defa objectForKey:@"pas"];
    if (name!=nil&&password!=nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
          [HttpHelper loginAcount:name with:password success:^(HttpModel *model)
           {
                NSLog(@"%@",model.message);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        myDelegate.model=model;
                        
                    }else{
                        
                    }
                    [ProgressHUD dismiss];
                 
                });
                
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"error userInfo:===>%@",error.userInfo);
                    NSString *localizedDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                    if (localizedDescription!=nil && ![localizedDescription isEqualToString:@""]) {
                    }
                    [ProgressHUD dismiss];
                    
                }
            }];
        });


        isLogin=YES;
    }
//    //获取storyboard
//    
//    //        self.window.rootViewController=mtvc;
//    
//    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    //如果用户未登陆则把根视图控制器改变成登陆视图控制器
//    if (name == nil)
//    {
//        NSLog(@"%@",name);
//        LoginViewController *vi=[[LoginViewController alloc]init];
//        //        id view = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//        self.window.rootViewController = vi;
//    }
//    else
//    {
//        self.window.rootViewController=mtvc;
//        
//    }
//

    return YES;
}
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
    
}
#pragma mark -- TencentSessionDelegate
- (void)tencentDidLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginSuccessed" object:nil];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginCancelled" object:nil];
}

- (void)tencentDidNotNetWork
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginFailed" object:nil];
}
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@"respons:%@",response.userData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getQQUserInfo" object:response.jsonResponse];
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        // NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        
        NSLog(@"didReceiveWeiboResponse:\n%@",message);
        if ([(WBAuthorizeResponse *)response accessToken]) {
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            
        }
        if ([(WBAuthorizeResponse *)response userID]) {
            self.wbCurrentUserID= [(WBAuthorizeResponse *)response userID];
        }
        if(response.userInfo!=nil){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getWBUserInfo" object:response];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}
//-----
- (BOOL)handleURL:(NSURL *)url
{
    if ([url.absoluteString hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    } else if ([url.absoluteString hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if([url.absoluteString hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    return YES;
}
//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
//        NSString *code = aresp.code;
//        [self getAccess_token:code];
    }
}
//-(void)getAccess_token:(NSString *)code
//{
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXKey,WXSECRET,code];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"getWXUserInfo" object:dic];
//                
//            }
//        });
//    });
//}
@end
