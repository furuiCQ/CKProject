//
//  CustomControl.m
//  CKProject
//
//  Created by furui on 16/1/2.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "CustomControl.h"
@interface CustomControl()

@end

@implementation CustomControl

@synthesize userLogo;
@synthesize userNameLabel;
@synthesize recordRight;
@synthesize bundleLabel;
@synthesize recordLabel;
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)initView:(CGRect *)frame
{
    [self setBackgroundColor:[UIColor whiteColor]];
    int width=frame->size.width;
   
    userLogo=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/20-width/40-width/10-width/20, (width/6.5-width/10)/2, width/10, width/10)];
    [userLogo setImage:[UIImage imageNamed:@"login_defalut"]];
    [self addSubview:userLogo];
    recordRight=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/45.7-width/21, (width/6.5-width/29)/2, width/45.7, width/29)];
    [recordRight setImage:[UIImage imageNamed:@"right_logo"]];
    [self addSubview:recordRight];
    
    recordLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40, (width/6.5-width/22)/2, width/4, width/22)];
    [recordLabel setTextColor:[UIColor grayColor]];
    [recordLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [self addSubview:recordLabel];
    
    userNameLabel=[[UITextField alloc]initWithFrame:CGRectMake(width/40+width/4, (width/6.5-width/22)/2, width/3, width/22)];
    [userNameLabel setEnabled:NO];//设置为无法编辑
    [userNameLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [userNameLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [self addSubview:userNameLabel];

    bundleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/21-width/7, (width/6.5-width/15)/2, width/7, width/15)];
    
    [bundleLabel setText:@"已绑定"];
    [bundleLabel setTextAlignment:NSTextAlignmentCenter];
    [bundleLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:158.f/255.f blue:42.f/255.f alpha:1.0]];
    [bundleLabel setFont:[UIFont systemFontOfSize:width/29]];
    bundleLabel.layer.borderColor= [UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor; //要设置的颜色
    bundleLabel.layer.cornerRadius=5.0;
    bundleLabel.layer.borderWidth = 1; //要设置的描边宽
    bundleLabel.layer.masksToBounds=YES;
    [self addSubview:bundleLabel];
}


@end