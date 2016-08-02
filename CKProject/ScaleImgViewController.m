//
//  ScaleImgViewController.m
//  CKProject
//
//  Created by furui on 16/2/28.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "ScaleImgViewController.h"
#import "HttpHelper.h"
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
-(void)reloadImage{
    //创建滚动试图
    
    NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
    NSArray *bt=[de objectForKey:@"pictures"];
    NSLog(@"88888888888888888---\n\n\n\n\n\n\n%@",bt);
    
    UIScrollView *sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160)];
    sc.contentSize=CGSizeMake(bt.count * self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160);
    sc.pagingEnabled=YES;
    for (int i=0; i<bt.count; i++) {
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-160)];
        //获取网路图片
        
        im.contentMode=UIViewContentModeScaleAspectFit;
        NSString *str=[NSString stringWithFormat:@"http://211.149.190.90%@",[bt objectAtIndex:i]];
      im.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
        
        
        
//         [im sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:[bt objectAtIndex:i]]]];
        [sc addSubview:im];
     
    }
    [self.view addSubview:sc];
//    imageView =[[UIImageView alloc]initWithImage:loadImage];
//    //    [imageView setFrame:CGRectMake(self.view.frame.size.width/2-loadImage.size.width/2, self.view.frame.size.height/2-loadImage.size.height/2, loadImage.size.width, loadImage.size.height)];
//    
//    //    [imageView setFrame:CGRectMake(50, 100, 100, 100)];
//    CGFloat margin=20;
//    CGFloat NavH=20+44;
//    CGFloat screenW=[UIScreen mainScreen].bounds.size.width;
//    CGFloat screenH=[UIScreen mainScreen].bounds.size.height;
//    CGFloat imgX=margin;
//    CGFloat imgY=NavH+margin;
//    CGFloat imgW=screenW-2*margin;
//    CGFloat imgH=screenH-8*margin;
//    [imageView setFrame:CGRectMake(imgX, imgY, imgW, imgH)];
//    [self.view addSubview:imageView];
    imgStartWidth=imageView.frame.size.width;
    imgStartHeight=imageView.frame.size.height;
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
    [titleView setBackgroundColor:[UIColor whiteColor]];
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

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
