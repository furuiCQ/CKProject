//
//  CharesectionView.m
//  CKProject
//
//  Created by furui on 16/4/17.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "CharesectionView.h"
@interface CharesectionView()

@end

@implementation CharesectionView

@synthesize iconView;
@synthesize contentLabel;
@synthesize titleLabel;
@synthesize sqlString;
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

-(void)initView:(CGRect *)frame withTag:(int)numb
{
    [self setBackgroundColor:[UIColor whiteColor]];
    //第一个按钮
    int width=frame->size.width;
//    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, customerServiceView.frame.origin.y+customerServiceView.frame.size.height+width/64, (width-width/640)/2, width/5.3)];
//    [btnView setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *btnGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuGesture:)];
//    [btnView addGestureRecognizer:btnGesture];
//    [btnView setTag:0];
//    [btnView setBackgroundColor:[UIColor whiteColor]];
    
    iconView=[[UIImageView alloc]initWithFrame:CGRectMake(width/21.3, width/32, width/8, width/8)];
    [iconView setImage:[UIImage imageNamed:@"teen"]];
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconView.frame.size.width+iconView.frame.origin.x+width/40
                                                                 , width/18.8, width/22.8*5, width/22.8)];
    [titleLabel setText:@"青少年专区"];
    [titleLabel setFont:[UIFont systemFontOfSize:width/22.8]];
    [titleLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
    
    contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x
                                                                   , titleLabel.frame.size.height+titleLabel.frame.origin.y+width/80, width/32*8, width/32)];
    [contentLabel setFont:[UIFont systemFontOfSize:width/32]];
    [contentLabel setTextColor:[UIColor colorWithRed:165.f/255.f green:165.f/255.f blue:165.f/255.f alpha:1.0]];
    [contentLabel setText:@"德智体美全面发展"];
    
    [self addSubview:contentLabel];
    [self  addSubview:titleLabel];
    [self  addSubview:iconView];
    //[self.view addSubview:btnView];

    
}


@end