//
//  ShareTools.m
//  CKProject
//
//  Created by furui on 16/1/3.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "WXApi.h"
#import "WXApiObject.h"
#import "ShareTools.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"

@implementation ShareTools
static NSString * const WeiboKey=@"2850266283";
static NSString * const WeiboRedirectURI =@"http://www.sina.com";

+(void)loginWeibo{
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
+(void)shareButtonPressed
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = WeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}
+(WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);

    
//    if (self.imageSwitch.on)
//    {
//        WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//        message.imageObject = image;
//    }
//    
//    if (self.mediaSwitch.on)
//    {
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"identifier1";
//        webpage.title = NSLocalizedString(@"分享网页标题", nil);
//        webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//        webpage.webpageUrl = @"http://sina.cn?a=1";
//        message.mediaObject = webpage;
//    }
    
    return message;
}


//分享给好友
+(void)shareToWxFriend
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"蹭课应用";  //@"Web_title";
    message.description = @"这里有这么多丰富免费的课程，你也来看看。";
  //  UIImage * result;
  //  NSString *str=@"这里有这么多丰富免费的课程，你也来看看。";
   // result=[UIImage imageNamed:@"instlist_defalut"];
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
    //NSString *imageurl=[popJson valueForKey:@"imageurl"];
   // result = [self getImageFromURL:imageurl];
    
    //UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
//    if(image==nil || [image isEqual:0]){
//        [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
//        
//    }else{
//        [message setThumbImage:image];
//    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"www.baidu.com";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
+(void)shareToWxTimeLine:(UIImage *)contentImage withContentTitle:(NSString *)title
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"login_defalut"]];//缩略图
    WXImageObject *imageObject=[WXImageObject object];
    imageObject.imageData=UIImagePNGRepresentation([UIImage imageNamed:@"login_defalut"]);
    message.mediaObject=imageObject;
    
    SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
    req.text=title;
    req.bText=NO;
    req.message=message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    
}
+(void)shareToWxTimeLine
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"蹭课应用";  //@"Web_title";
    message.description = @"这里有这么多丰富免费的课程，你也来看看。";
  //  UIImage * result;
   // NSString *str=@"这里有这么多丰富免费的课程，你也来看看。";
  //  result=[UIImage imageNamed:@"instlist_defalut"];
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
  // NSString *imageurl=[popJson valueForKey:@"imageurl"];
  //  result = [self getImageFromURL:imageurl];
    
  //  UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
//    if(image==nil || [image isEqual:0]){
//        [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
//        
//    }else{
//        [message setThumbImage:image];
//    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"www.baidu.com";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}
+(void)shareToQQ{
    UIImage *image=[UIImage imageNamed:@"login_defalut"];
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(image)
                                
                                               previewImageData:UIImagePNGRepresentation(image)
                                
                                                          title:@"123"
                                
                                                    description:@"由 桂林理工大学-校园通 转码"];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    //将内容分享到qq
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

+(void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}



@end