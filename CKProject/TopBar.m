//
//  TopBar.m
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "TopBar.h"
@interface TopBar()

@end

@implementation TopBar

@synthesize view;
@synthesize textLabel;
@synthesize text;
@synthesize iconColor;
@synthesize textColor;
@synthesize checked;
@synthesize isEnd;

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
-(void)setTextColor:(UIColor *)color {
    if (checked) {
        [textLabel setTextColor:color];
        [view setBackgroundColor:color];

    }else{
        [textLabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];

        [view setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    
}
-(void)initView{
    int width=self.frame.size.width*3;
    int height=self.frame.size.height;
    textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width/3, height*3/4-2)];
    [textLabel setText:text];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    view=[[UIView alloc]initWithFrame:CGRectMake(width/6-width/10, height*3/4-2, width/5, 2)];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width/3-0.5, height*3/4/4, 0.5, height*3/4/2)];
    [lineView setBackgroundColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
    
    if(checked){
        [textLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];

        [view setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    }else{

        [textLabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        
    }
    if (!isEnd) {
        [self addSubview:lineView];
    }
    [self addSubview:textLabel];
    [self addSubview:view];

}
-(void)setLabelFont:(UIFont *)font{
    [textLabel setFont:font];

}


@end