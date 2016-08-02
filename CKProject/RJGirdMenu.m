//
//  RJGirdMenu.m
//  RJInvestor
//
//  Created by furui on 15/1/14.
//
//
#import "RJGirdMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "RJUtil.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400
#define LINE_NUMBER   4     //每行图标的个数
static NSString * const WeiboRedirectURI =@"http://www.sina.com";

@interface RJGridItem : UIButton
@property (nonatomic, weak) RJGirdMenu *menu;
@end

@implementation RJGridItem
//分享菜单
- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];//菜单字体大小
        self.titleLabel.backgroundColor = [UIColor clearColor];//菜单item的背景
        self.titleLabel.textAlignment = NSTextAlignmentCenter;//菜单字体位置
        [self setTitle:title forState:UIControlStateNormal];//设置点击状态
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];//菜单样式设置
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;//获取所在布局的宽度
    float height = self.bounds.size.height;//高度
    
    CGRect imageRect = CGRectMake(width * 0.2, width * 0.2, width * 0.6, width * 0.6);//初始化图片位置和宽高
    self.imageView.frame = imageRect;
    
    float labelHeight = height - (imageRect.origin.y + imageRect.size.height);//初始化取消按钮的位置和宽高
    CGRect labelRect = CGRectMake(width * 0.05-0.2, imageRect.origin.y + imageRect.size.height+5, width * 0.9, labelHeight);
    self.titleLabel.frame = labelRect;
}

@end


@interface RJGirdMenu ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) SGButton *cancelButton;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation RJGirdMenu
//初始化menu菜单
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);
        
        _itemTitles = [NSArray array];//菜单文字
        _itemImages = [NSArray array];//菜单图片
        _items = [NSArray array];//菜单的item
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];//菜单的标题初始化
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BaseMenuTextColor(self.style);
        [self addSubview:_titleLabel];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];//中间布局view的初始化
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        _cancelButton = [SGButton buttonWithType:UIButtonTypeRoundedRect];//取消按钮
        _cancelButton.clipsToBounds = YES;
        _cancelButton.backgroundColor=[RJUtil colorWithHexString:@"de242a"];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}
//初始化item的图片和文字
- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images shareJson:(NSDictionary*)shareJson
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        _titleLabel.text = title;
        _titleLabel.textColor=[UIColor grayColor];
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        popJson=shareJson;
        [self setupWithItemTitles:_itemTitles images:_itemImages];
    }
    return self;
}
//添加item的图片和文字
- (void)setupWithItemTitles:(NSArray *)titles images:(NSArray *)images
{
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        RJGridItem *item = [[RJGridItem alloc] initWithTitle:titles[i] image:images[i]];
        item.menu = self;
        item.tag = i;
        [item addTarget:self
                 action:@selector(tapAction:)
       forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
    }
    _items = [NSArray arrayWithArray:items];
}
//设置item的样式
- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = BaseMenuTextColor(style);
    [self.cancelButton.layer setCornerRadius:5.0f];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for (RJGridItem *item in self.items) {
        [item setTitleColor:BaseMenuTextColor(style) forState:UIControlStateNormal];
    }
}
//整个布局的初始化位置宽高
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};
    
    [self layoutContentScrollView];
    self.contentScrollView.frame = (CGRect){CGPointMake(0, self.titleLabel.frame.size.height), self.contentScrollView.bounds.size};
    
    self.cancelButton.frame = CGRectMake(self.bounds.size.width*0.05, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, self.bounds.size.width*0.9, 44);
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height+20)};
}
//初始化菜单的item的宽高及位置
- (void)layoutContentScrollView
{
    UIEdgeInsets margin = UIEdgeInsetsMake(0, 10, 15, 10);
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / LINE_NUMBER, 85);
    
    NSInteger itemCount = self.items.count;
    NSInteger rowCount = ((itemCount-1) / LINE_NUMBER) + 1;
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, rowCount * itemSize.height + margin.top + margin.bottom);
    for (int i=0; i<itemCount; i++) {
        RJGridItem *item = self.items[i];
        int row = i / LINE_NUMBER;
        int column = i % LINE_NUMBER;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width, margin.top + row * itemSize.height);
        item.frame = (CGRect){p, itemSize};
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
}

#pragma mark -
//设置监听
- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}


#pragma mark -

- (void)tapAction:(id)sender
{
    if (self.actionHandle) {
        if ([sender isEqual:self.cancelButton]) {
            double delayInSeconds = 0.15;//延时关闭时间
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(0);//延时关闭弹出框
            });
        }else{
            RJBaseMenu *rjmenu=(RJBaseMenu*)sender;
            NSLog(@"%ld",(long)rjmenu.tag);
            switch (rjmenu.tag) {
                case 0://微信好友
                    if ([WXApi isWXAppInstalled]) {
                        [self shareToWxFriend];
                    }
                    break;
                case 1://微信朋友圈
                    if ([WXApi isWXAppInstalled]) {
                        [self shareToWxTimeLine];
                    }
                    break;
                case 2://微博
                    if ([WeiboSDK isWeiboAppInstalled]) {
                        [self shareToWeiBo];
                    }
                    break;
                case 3://qq好友
                    if ([TencentOAuth iphoneQQInstalled]) {
                        [self shareToQQFriend];
                    }
                    break;
                case 4://qq空间
                    if ([TencentOAuth iphoneQQInstalled]) {
                        [self shareToQQZone];
                    }
                    break;
            }
            
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(rjmenu.tag + 1);
            });
        }
    }
}
//通过网络地址获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
//通过
- (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image toSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    NSLog(@"%f",scaledWidth);
    NSLog(@"%f",scaledHeight);
    
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}




//分享给好友
-(void)shareToWxFriend
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [popJson valueForKey:@"title"];  //@"Web_title";
    message.description = [popJson valueForKey:@"description"];
    UIImage * result;
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
  //  NSString *imageurl=[popJson valueForKey:@"imageurl"];
   // result = [self getImageFromURL:imageurl];
    
    // UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
    // if(image==nil || [image isEqual:0]){
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    // }else{
    //    [message setThumbImage:image];
    //  }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [popJson valueForKey:@"url"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
-(void)shareToWxTimeLine
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [popJson valueForKey:@"title"];  //@"Web_title";
    message.description =[popJson valueForKey:@"description"];
    
    UIImage * result;
    // NSString *str=@"http://img.my.csdn.net/uploads/201402/24/1393242467_3999.jpg";
//    NSString *imageurl=[popJson valueForKey:@"imageurl"];
//    result = [self getImageFromURL:imageurl];
    
    // UIImage *image=[self imageByScalingAndCroppingForSize:result toSize:CGSizeMake(80, 80)];//压缩到指定大小80*80
    
    // if(image==nil || [image isEqual:0]){
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    //  }else{
    //  [message setThumbImage:image];
    //}
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [popJson valueForKey:@"url"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}
-(void)shareToWeiBo{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = WeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
-(WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    
    message.text = [[popJson valueForKey:@"title"]stringByAppendingString:[popJson valueForKey:@"url"]];
    
    
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(image);
    message.imageObject = imageObject;
    
    
    //    WBWebpageObject *webpage = [WBWebpageObject object];
    //
    //    webpage.objectID = @"identifier1";
    //    webpage.title =[popJson valueForKey:@"title"];
    //    webpage.description = [popJson valueForKey:@"description"];
    //    webpage.thumbnailData = UIImagePNGRepresentation(image);
    //    webpage.webpageUrl = @"http://www.baidu.com";
    //    message.mediaObject = webpage;
    //
    return message;
}

-(void)shareToQQZone{
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    NSString *title=[popJson valueForKey:@"title"];
    NSString *description=[popJson valueForKey:@"description"];
    NSString *url=[popJson valueForKey:@"url"];
    
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]  title:title description:description previewImageData:UIImagePNGRepresentation(image)];
    
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if ([TencentOAuth iphoneQQInstalled]) {
        [self handleSendResult:sent];
    }
}
-(void)shareToQQFriend{
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    
    NSString *title=[popJson valueForKey:@"title"];
    NSString *description=[popJson valueForKey:@"description"];
    NSString *url=[popJson valueForKey:@"url"];
    
    QQApiURLObject *imObj=[[QQApiURLObject alloc]initWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImagePNGRepresentation(image) targetContentType:QQApiURLTargetTypeNews];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [self handleSendResult:sent];
    }
}
-(void)handleSendResult:(QQApiSendResultCode)sendResult
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
