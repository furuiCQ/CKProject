//
//  SendInvitationViewController.m
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "SendInvitationViewController.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"

@interface SendInvitationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>{
    NSArray *tableArray;
   
}

@end

@implementation SendInvitationViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize chooseImageView;
@synthesize titleView;
@synthesize contentView;
@synthesize circleId;
@synthesize dicatorView;
@synthesize alertView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [self initTitle];
    [self initContentView];
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)textViewDidChange:(UITextView *)textView
//{
//    self.contentView.text =  textView.text;
//    if (textView.text.length == 0) {
//        uilabel.text = @"内容(不少于5个字)";
//    }else{
//        uilabel.text = @"";
//    }
//}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [topView setBackgroundColor:[UIColor whiteColor]];
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
    [searchLabel setTextColor:[UIColor colorWithRed:41.f/255.f green:41.f/255.f blue:41.f/255.f alpha:1.0]];
    [searchLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [searchLabel setText:@"发帖"];
    
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    UITapGestureRecognizer *sendgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderInvitaion)];
    [msgLabel addGestureRecognizer:sendgesture];
    [msgLabel setUserInteractionEnabled:YES];
    [msgLabel setText:@"发布"];
    [msgLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    [msgLabel setFont:[UIFont systemFontOfSize:self.view.frame.size.width/20]];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    [topView addSubview:cityLabel];
    [topView addSubview:msgLabel];
    [topView addSubview:searchLabel];
    [self.view addSubview:topView];
    
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
-(void)senderInvitaion{
    
    if ([titleView.text isEqualToString:@""]) {
  UIAlertView      *at=[[UIAlertView alloc]initWithTitle:@"提示" message:@"标题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [at show];
    
    }
  else  if (contentView.text.length<5) {
        UIAlertView      *at=[[UIAlertView alloc]initWithTitle:@"提示" message:@"内容不得少于5个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [at show];
    }
    else
    {
    [ProgressHUD show:@"正在发帖..."];
    static NSString * const DEFAULT_LOCAL_AID = @"500000";
    //[self creatDicatorView];
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    
    NSString *title=titleView.text;
    NSString *content=contentView.text;
    [titleView resignFirstResponder];
    [contentView resignFirstResponder];
    
    if (chooseImageView.image!=nil) {
        UIImage *image=chooseImageView.image;
        NSString *timeDate=[HttpHelper getNowImageTime];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths lastObject];
        NSString *imageURl=[docPath stringByAppendingFormat:@"%@%@",@"/",timeDate];
        saveImageToCacheDir(docPath, image, timeDate, @"png");
       
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper sendInvitation:circleId withAid:aid withTitle:title withContext:content withImage:imageURl withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                NSNotification *notification =[NSNotification notificationWithName:@"send" object:nil];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }];
                            
                        });
                        
                        
                    }else{
                        
                    }
                    [ProgressHUD dismiss];
                    [alertView setMessage:model.message];
                    [alertView show];
                    
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                    [ProgressHUD dismiss];

                }
                
            }];
            
            
            
        });
    }else{
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [HttpHelper sendInvitation:circleId withAid:aid withTitle:title withContext:content withModel:myDelegate.model success:^(HttpModel *model){
                
                NSLog(@"%@",model.message);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                NSNotification *notification =[NSNotification notificationWithName:@"send" object:nil];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }];
                            
                        });
                        
                        
                    }else{
                        
                    }
                    [dicatorView stopAnimating];
                    [alertView setMessage:model.message];
                    [alertView show];
                    
                    
                });
            }failure:^(NSError *error){
                if (error.userInfo!=nil) {
                    NSLog(@"%@",error.userInfo);
                }
                [dicatorView stopAnimating];
                
            }];
            
            
            
        });
    }
}

    
}
-(void)initContentView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    UIScrollView *bgView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/45.7, width, height-(titleHeight+20+width/45.7)-width/6.4-1)];
    [bgView setContentSize:CGSizeMake(width, height-(titleHeight+20+width/45.7)-width/6.4)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    titleView=[[UITextField alloc]initWithFrame:CGRectMake(width/13, width/22.8, width-width/14.5*2, width/26)];
    [titleView setPlaceholder:@"标题(必选)"];
    [titleView setTintColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    [titleView setFont:[UIFont systemFontOfSize:width/26.7]];
    [titleView setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width/22.8,width/8, width-width/22.8*2, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    contentView=[[UITextView alloc]initWithFrame:CGRectMake(width/15.5, lineView.frame.origin.y+lineView.frame.size.height+width/22.8, width-width/14.5*2, (bgView.frame.size.height-(lineView.frame.origin.y+lineView.frame.size.height+width/22.8))/2)];
    [contentView setText:@"内容(不少于5个字)"];
    contentView.delegate=self;
    
    
    
    
    [contentView setFont:[UIFont systemFontOfSize:width/26.7]];
    [contentView setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
   
    chooseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/15.5, contentView.frame.origin.y+contentView.frame.size.height+width/15, width-width/14.5*2, (bgView.frame.size.height-(contentView.frame.origin.y+contentView.frame.size.height+width/15))-width/10)];

    UIButton *closeView=[[UIButton alloc]initWithFrame:CGRectMake(chooseImageView.frame.size.width-width/22/2, -width/22/2, width/22, width/22)];
    [closeView setBackgroundImage:[UIImage imageNamed:@"delete_logo"] forState:UIControlStateNormal];
    [closeView addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    [chooseImageView addSubview:closeView];
    [chooseImageView setHidden:YES];
    [chooseImageView setUserInteractionEnabled:YES];
    [bgView addSubview:chooseImageView];
    [bgView addSubview:titleView];
    [bgView addSubview:lineView];
    [bgView addSubview:contentView];
    
    [self.view addSubview:bgView];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, height-width/6.4, width, width/6.4)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [bottomView setTag:1000];

    UIImageView *imageChooseView=[[UIImageView alloc]initWithFrame:CGRectMake(width/7, (width/6.4-width/20)/2, width/17.8, width/20)];
    UITapGestureRecognizer *imageChooseGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAlbum)];
    [imageChooseView setUserInteractionEnabled:YES];
    [imageChooseView addGestureRecognizer:imageChooseGesture];
    [imageChooseView setImage:[UIImage imageNamed:@"choose_img"]];
    
    [bottomView addSubview:imageChooseView];
    [self.view addSubview:bottomView];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    contentView.text=nil;


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
-(void)deleteImage{
    [chooseImageView setImage:nil];
    [chooseImageView setHidden:YES];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        [chooseImageView setHidden:NO];
        [chooseImageView setImage:image];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//动画时间
#define kAnimationDuration 0.2
//view高度
#define kViewHeight 56
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
  
    
    //获取键盘高度
    NSValue *keyboardObject = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, self.view.frame.size.width, kViewHeight)];
    
    [UIView commitAnimations];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-kViewHeight, self.view.frame.size.width, kViewHeight)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end