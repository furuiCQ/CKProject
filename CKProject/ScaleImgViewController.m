//
//  ScaleImgViewController.m
//  CKProject
//
//  Created by furui on 16/2/28.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "ScaleImgViewController.h"
#import "HttpHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ScaleImgViewController

@synthesize loadImage;
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    lastDistance=0;
    return [super initWithCoder:aDecoder];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint p1;
    CGPoint p2;
    CGFloat sub_x;
    CGFloat sub_y;
    CGFloat currentDistance;
    CGRect imgFrame;
    
    NSArray * touchesArr=[[event allTouches] allObjects];
    
    NSLog(@"手指个数%lu",(unsigned long)[touchesArr count]);
    //    NSLog(@"%@",touchesArr);
    
    if ([touchesArr count]>=2) {
        p1=[[touchesArr objectAtIndex:0] locationInView:self.view];
        p2=[[touchesArr objectAtIndex:1] locationInView:self.view];
        
        sub_x=p1.x-p2.x;
        sub_y=p1.y-p2.y;
        
        currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
        
        if (lastDistance>0) {
            
            imgFrame=imageView.frame;
            
            if (currentDistance>lastDistance+2) {
                NSLog(@"放大");
                
                imgFrame.size.width+=10;
                if (imgFrame.size.width>1000) {
                    imgFrame.size.width=1000;
                }
                
                lastDistance=currentDistance;
            }
            if (currentDistance<lastDistance-2) {
                NSLog(@"缩小");
                
                imgFrame.size.width-=10;
                
                if (imgFrame.size.width<50) {
                    imgFrame.size.width=50;
                }
                
                lastDistance=currentDistance;
            }
            
            if (lastDistance==currentDistance) {
                imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                
                float addwidth=imgFrame.size.width-imageView.frame.size.width;
                float addheight=imgFrame.size.height-imageView.frame.size.height;
                
                imageView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
            }
            
        }else {
            lastDistance=currentDistance;
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    lastDistance=0;
}
-(void)reloadImage:(int)numb{
    //创建滚动试图
    
    NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
    NSArray *bt=[de objectForKey:@"pictures"];
    //   NSLog(@"88888888888888888---\n\n\n\n\n\n\n%@",bt);
    
    UIScrollView *sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160)];
    sc.contentSize=CGSizeMake(bt.count * self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160);
    sc.pagingEnabled=YES;
    [sc setCanCancelContentTouches:YES];
    for (int i=0; i<bt.count; i++) {
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160)];
        im.contentMode=UIViewContentModeScaleAspectFit;
        [im sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[bt objectAtIndex:i]]]];
        [im setUserInteractionEnabled:YES];
        [sc addSubview:im];
    }
    [self.view addSubview:sc];
    imgStartWidth=imageView.frame.size.width;
    imgStartHeight=imageView.frame.size.height;
    //  滚动scrollview
    CGFloat x = numb * sc.frame.size.width;
    sc.contentOffset = CGPointMake(x, 0);
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self initTitle];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [super viewDidLoad];
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    UIImageView *backImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [backImageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:backImageView];
    
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
    [searchLabel setText:@""];
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
@end
