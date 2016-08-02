//
//  DemotionControl.m
//  CKProject
//
//  Created by furui on 16/1/19.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "DemotionControl.h"
@interface DemotionControl()

@end

@implementation DemotionControl

@synthesize userLogo;
@synthesize textLabel;
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
//    UIControl *subView=[[UIControl alloc]initWithFrame:CGRectMake(view.frame.size.width/4*i, 0,view.frame.size.width/4, titleHeight*3/4)];
//    [subView setUserInteractionEnabled:YES];
//    [subView setTag:i];
//    [subView addTarget:self action:@selector(topOnClick:) forControlEvents:UIControlEventTouchUpInside];

    textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width/2, self.frame.size.height)];
    //[label setText:[titleArray objectAtIndex:i]];
    [textLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0
                         ]];
    [textLabel setFont:[UIFont systemFontOfSize:frame->size.width/29]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    userLogo=[[UIButton alloc]initWithFrame:CGRectMake(textLabel.frame.size.width, self.frame.size.height/2-frame->size.width/46/2, frame->size.width/29,frame->size.width/46)];
    [userLogo setUserInteractionEnabled:NO];
    [self addSubview:textLabel];
    [self addSubview:userLogo];
    if (numb>2) {
        [userLogo setFrame:CGRectMake(self.frame.size.width/2-frame->size.width/21, self.frame.size.height/2-frame->size.width/23/2, frame->size.width/21,frame->size.width/23)];
        [textLabel setFrame:CGRectMake(self.frame.size.width/2, 0,self.frame.size.width/2, self.frame.size.height)];
        
    }
    
}


@end