//
//  SearchViewController.m
//  CKProject
//
//  Created by furui on 16/1/14.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "SearchViewController.h"
#import "HttpHelper.h"
#import "FDCalendar.h"
#import "AppDelegate.h"
#import "ProjectListViewController.h"
#import "FavourableViewController.h"
#import "OrganismListViewController.h"
@interface SearchViewController ()<UITextFieldDelegate>{
    NSArray *tableArray;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UITextView *contentTextView;
    UILabel *keyTextField;
    UILabel *sendAssessLabel;
    //
    NSArray *ary;
    NSDate *selectDate;
    //
    UIView *bgView;
    BOOL isShow;
    BOOL isSearch;
    NSNumber *searchType;
}

@end

@implementation SearchViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchField;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize chooseImageView;
@synthesize contentView;
@synthesize aid;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:imageView];
    selectDate=[NSDate date];
    searchType=[[NSNumber alloc]init];
    [self initTitle];
    //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。

    // Do any additional setup after loading the view, typically from a nib.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    int width=self.view.frame.size.width;
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
   
    
    cityLabel=[[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setText:@"机构"];
    [cityLabel setFont:[UIFont systemFontOfSize:15]];
    [cityLabel setTextColor:[UIColor colorWithRed:95.f/255.f green:98.f/255.f blue:107.f/255.f alpha:1.0]];
    [cityLabel setEnabled:false];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    //17 × 10
    UIImageView *downView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_down"]];
    [downView setFrame:CGRectMake(0, 0, 7, 3)];
    [cityLabel setRightView:downView];
    [cityLabel setRightViewMode:UITextFieldViewModeAlways];
       //新建查询视图
    searchField=[[CustomTextField alloc]initWithFrame:(CGRectMake(width/35.6, titleHeight*2/16, width/1.2, titleHeight*3/4))];
    searchField.delegate=self;
    [searchField setBackgroundColor:[UIColor colorWithRed:228.f/255.f green:229.f/255.f blue:230.f/255.f alpha:1.0]];
    [searchField.layer setCornerRadius:2.0f];
    [searchField setFont:[UIFont systemFontOfSize:15]];
    [searchField setLeftView:cityLabel];
    [searchField setLeftViewMode:UITextFieldViewModeAlways];
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/32-self.view.frame.size.width/11.8, (titleHeight-self.view.frame.size.width/11.8)/2, self.view.frame.size.width/11.8, self.view.frame.size.width/11.8)];
    UITapGestureRecognizer *uITapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchData)];
    [msgLabel addGestureRecognizer:uITapGestureRecognizer];
    [msgLabel setUserInteractionEnabled:YES];
    [msgLabel setText:@"取消"];
    [msgLabel setFont:[UIFont systemFontOfSize:width/24.6]];

    UILabel *contextLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, titleHeight)];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showView)];
    [contextLabel addGestureRecognizer:gesture];
    [contextLabel setUserInteractionEnabled:YES];
    
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:msgLabel];
    [titleView addSubview:searchField];
    [titleView addSubview:contextLabel];

    [self.view addSubview:titleView];
    [self initPopView:titleView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:searchField];

}
-(void)showView{
    if(isShow){
        [self hideView];
        isShow=NO;
    }else{
        [self.view addSubview:bgView];
        isShow=YES;

    }
}
-(void)hideView{
    [bgView removeFromSuperview];
}
-(void)initPopView:(UIView *)view{
    int width=self.view.frame.size.width;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(width/80, view.frame.size.height+view.frame.origin.y, width/2.1, width/2.1)];
    
    UIImageView *imageBgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width/2.1, width/2.1)];
    [imageBgView setImage:[UIImage imageNamed:@"-drop-down_bg"]];
    [imageBgView setContentMode:UIViewContentModeScaleAspectFit];
    [imageBgView setUserInteractionEnabled:YES];
    [bgView addSubview:imageBgView];
    
    
    //14.5  //6.7
    UIControl *orginControl=[[UIControl alloc]initWithFrame:CGRectMake(0, width/32, imageBgView.frame.size.width, width/6.7)];
    [orginControl setBackgroundColor:[UIColor clearColor]];
    [orginControl setTag:1];
    [orginControl setUserInteractionEnabled:YES];
    [orginControl addTarget:self action:@selector(controlOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *orginImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/13.3, width/29, width/13.9, width/13.9)];
    [orginImageView setImage:[UIImage imageNamed:@"institutions_icon"]];
    [orginControl addSubview:orginImageView];
    UILabel *orginLabel=[[UILabel alloc]initWithFrame:CGRectMake(orginImageView.frame.size.width+orginImageView.frame.origin.x+width/14.2, width/19.4, orginControl.frame.size.width/2, width/22.8)];
    [orginLabel setText:@"机构"];
    [orginLabel setTextColor:[UIColor whiteColor]];
    [orginLabel setTextAlignment:NSTextAlignmentLeft];
    [orginLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [orginControl addSubview:orginLabel];
    [imageBgView addSubview:orginControl];

    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(3, orginControl.frame.size.height+orginControl.frame.origin.y, imageBgView.frame.size.width-6, 1)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [imageBgView addSubview:lineView];
    
    //14.5  //6.7
    UIControl *projectControl=[[UIControl alloc]initWithFrame:CGRectMake(0, lineView.frame.size.height+lineView.frame.origin.y, imageBgView.frame.size.width, width/6.7)];
    [projectControl setBackgroundColor:[UIColor clearColor]];
    [projectControl setTag:2];
    [projectControl setUserInteractionEnabled:YES];
    [projectControl addTarget:self action:@selector(controlOnclick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *projectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/13.3, width/29, width/13.9, width/13.9)];
    [projectImageView setImage:[UIImage imageNamed:@"course_icon"]];
    [projectImageView setContentMode:UIViewContentModeScaleAspectFit];
    [projectControl addSubview:projectImageView];

    UILabel *projectLabel=[[UILabel alloc]initWithFrame:CGRectMake(projectImageView.frame.size.width+projectImageView.frame.origin.x+width/13.3, width/19.4, projectControl.frame.size.width/2, width/22.8)];
    [projectLabel setText:@"课程"];
    [projectLabel setTextColor:[UIColor whiteColor]];
    [projectLabel setTextAlignment:NSTextAlignmentLeft];
    [projectLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [projectControl addSubview:projectLabel];
    [imageBgView addSubview:projectControl];
    
    
    UIView *line2View=[[UIView alloc]initWithFrame:CGRectMake(3, projectControl.frame.size.height+projectControl.frame.origin.y  , imageBgView.frame.size.width-6, 1)];
    [line2View setBackgroundColor:[UIColor grayColor]];
    [imageBgView addSubview:line2View];
    //14.5  //6.7
    UIControl *rebateControl=[[UIControl alloc]initWithFrame:CGRectMake(0, line2View.frame.size.height+line2View.frame.origin.y, imageBgView.frame.size.width, width/6.7)];
    [rebateControl setBackgroundColor:[UIColor clearColor]];
    [rebateControl setTag:3];
    [rebateControl setUserInteractionEnabled:YES];
    [rebateControl addTarget:self action:@selector(controlOnclick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *rebateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/13.3, width/29, width/13.9, width/13.9)];
    [rebateImageView setImage:[UIImage imageNamed:@"privilege_icon"]];
    [rebateImageView setContentMode:UIViewContentModeScaleAspectFit];
    [rebateControl addSubview:rebateImageView];
    UILabel *rebateLabel=[[UILabel alloc]initWithFrame:CGRectMake(rebateImageView.frame.size.width+rebateImageView.frame.origin.x+width/13.3, width/19.4, rebateControl.frame.size.width/2, width/22.8)];
    [rebateLabel setText:@"优惠"];
    [rebateLabel setTextColor:[UIColor whiteColor]];
    [rebateLabel setTextAlignment:NSTextAlignmentLeft];
    [rebateLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [rebateControl addSubview:rebateLabel];
    [imageBgView addSubview:rebateControl];
}
-(void)controlOnclick:(id)sender{
    UIControl *control=(UIControl *)sender;
    searchType=[NSNumber numberWithInt:(int)control.tag];
    for(UIView *view in control.subviews){
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)view;
            [cityLabel setText:label.text];
 
        }
    }
    [self hideView];
}
//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)[notification object];
    if([textField.text length]>0){
        [msgLabel setText:@"确定"];
        isSearch=YES;
    }else{
        [msgLabel setText:@"取消"];
        isSearch=NO;
        
    }
}
-(void)searchData{
    if(isSearch){
        NSString *str=searchField.text;
        switch ([searchType intValue]) {
            case 1:
            {
                OrganismListViewController *registerViewController=[[OrganismListViewController alloc]init];
                [registerViewController setSearchs:str];
                [self presentViewController: registerViewController animated:YES completion:nil];

            }
                break;
            case 2:
            {
                ProjectListViewController *registerViewController=[[ProjectListViewController alloc]init];
                [registerViewController setSearchs:str];
                [self presentViewController: registerViewController animated:YES completion:nil];
                
            }
                break;
            case 3:
            {
                FavourableViewController *registerViewController=[[FavourableViewController alloc]init];
                [registerViewController setSearchs:str];
                [self presentViewController: registerViewController animated:YES completion:nil];
            }
                break;
            default:
            {
                OrganismListViewController *registerViewController=[[OrganismListViewController alloc]init];
                [registerViewController setSearchs:str];
                [self presentViewController: registerViewController animated:YES completion:nil];
                
            }
                break;
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end