//
//  CircleListItem.m
//  CKProject
//
//  Created by furui on 15/12/8.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "CircleListItem.h"
@interface CircleListItem()

@end
@implementation CircleListItem

@synthesize logoView;
@synthesize titleName;
@synthesize pepoleLabel;
@synthesize contentLabel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}



-(id)initFrame:(CGRect)frame withWidth:(int)width{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frameL=self.frame;
        
        logoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/21, width/23, width/9, width/9)];
        [logoView setImage:[UIImage imageNamed:@"act_logo"]];
        
        titleName=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/9+width/20, width/23,  width/20*5, width/20)];
        [titleName setText:@"同城英语圈"];
        [titleName setFont:[UIFont systemFontOfSize:width/22.8]];
        [titleName setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
        [self addSubview:titleName];
        [self addSubview:logoView];
        
        UIImageView *joinLabel=[[UIImageView alloc]initWithFrame:CGRectMake(titleName.frame.size.width+titleName.frame.origin.x+width/46, titleName.frame.size.height+titleName.frame.origin.y-width/32-1, width/32, width/32-1)];
        [joinLabel setImage:[UIImage imageNamed:@"discuss_logo" ]];
        [self addSubview:joinLabel];
        
        
        
        pepoleLabel=[[UILabel alloc]initWithFrame:CGRectMake(joinLabel.frame.size.width+joinLabel.frame.origin.x+width/46, joinLabel.frame.size.height+joinLabel.frame.origin.y-width/32, width/32*6, width/32)];
        [pepoleLabel setText:@"1050"];
        [pepoleLabel setFont:[UIFont systemFontOfSize:width/32]];
        [pepoleLabel setTextColor:[UIColor grayColor]];
        [self addSubview:pepoleLabel];
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/9+width/20, width/23+width/20+width/36, width-(width/20+width/9+width/20+width/21), width/26)];
        [contentLabel setText:@"热爱英语,疯狂英语"];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [contentLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        [contentLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        
        [self addSubview:contentLabel];
        
        
        
        
        frameL.size.height=width/5;
        self.frame=frameL;

        
        
    }
    return self;
}


@end