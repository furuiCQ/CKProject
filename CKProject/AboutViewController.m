//
//  AboutViewController.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initLogoView];
    
    // Do any additional setup after loading the view, typically from a nib.
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
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;//
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];

    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setTextColor:[UIColor whiteColor]];
    [searchLabel setText:@"关于我们"];
    
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initLogoView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;

    UIScrollView *viewScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, titleHeight+20, width, height-(titleHeight+20))];
    [self.view addSubview:viewScroll];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((width-width/5.6)/2, width/8, width/5.6, width/5.6)];
    [imageView setImage:[UIImage imageNamed:@"icon"]];
    imageView.layer.cornerRadius=15.0;
    imageView.layer.masksToBounds=YES;
    [viewScroll addSubview:imageView];
    
    UILabel *appNameLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width/26.7*2)/2, width/8+width/5.6+width/21.3, width/26.7*2, width/26.7)];
    [appNameLabel setText:@"蹭课"];
    [appNameLabel setTextAlignment:NSTextAlignmentCenter];
    [appNameLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
    [appNameLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [viewScroll addSubview:appNameLabel];
    
    UILabel *versionLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width/2)/2, appNameLabel.frame.size.height+appNameLabel.frame.origin.y+width/53, width/2, width/40)];
    NSString *filepath=[[NSBundle mainBundle]pathForResource:@"Info.plist" ofType:@""];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:filepath];
    NSString *vison=[dic objectForKey:@"CFBundleShortVersionString"];
    
//    [versionLabel setText:@"版本 1.0"];
    [versionLabel setText:[NSString stringWithFormat:@"版本 %@",vison]];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
    [versionLabel setFont:[UIFont systemFontOfSize:width/40]];
    [viewScroll addSubview:versionLabel];

    UITextView *infoLabel=[[UITextView alloc]initWithFrame:CGRectMake(width/14.5,  appNameLabel.frame.size.height+appNameLabel.frame.origin.y+width/7, width-width/14.5*2, width)];
    [infoLabel setFont:[UIFont systemFontOfSize:width/29]];
    [infoLabel setEditable:NO];
    [infoLabel setText:@"    蹭课课堂网致力于打造集实用性,互动性，趣味性为一体的在线蹭课平台."];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [infoLabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
    [viewScroll addSubview:infoLabel];
 
}

-(void)toAboutUsViewControll{
    
}

-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end