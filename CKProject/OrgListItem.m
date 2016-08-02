//
//  OrgListItem.m
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "OrgListItem.h"
@interface OrgListItem()

@end
@implementation OrgListItem


@synthesize logoView;
@synthesize logoTitle;
@synthesize orgName;
@synthesize numberLabel;
@synthesize ratingBar;
@synthesize addLabel;

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
        CGRect fram=[self frame];
        
        logoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/45.7, width/45.7, width/2.7, width/3.8)];
        [logoView setUserInteractionEnabled:NO];
        logoView.layer.masksToBounds = YES;
        logoView.layer.cornerRadius = 3.0f;
        [logoView setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        logoTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, logoView.frame.size.width+30, width/15)];
        [logoTitle setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
        [logoTitle setText:@"汉昌培训"];
        [logoTitle setTextAlignment:NSTextAlignmentCenter];
        [logoTitle setFont:[UIFont systemFontOfSize:width/26.7]];
        [logoTitle setTextColor:[UIColor whiteColor]];
        [logoView addSubview:logoTitle];
        
        [self addSubview:logoView];

        orgName=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/2.7+width/17.8, width/24.6
                                                                  , width/2, width/22)];
        [orgName setText:@"二胡十段兴趣班"];
        [orgName setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
        [orgName setFont:[UIFont systemFontOfSize:width/22]];
        [self addSubview:orgName];
        
        
        UILabel *orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/2.7+width/17.8, width/24.6+width/22+width/35.6, width/32*2, width/32)];
        [orderLabel setText:@"预约"];
        [orderLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [orderLabel setFont:[UIFont systemFontOfSize:width/32]];
        [self addSubview:orderLabel];
        
        numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/2.7+width/17.8+width/32*2+width/45.7, width/24.6+width/22+width/35.6, width/32*4, width/32)];
        [numberLabel setText:@"200"];
        [numberLabel setFont:[UIFont systemFontOfSize:width/32]];
        [numberLabel setTextColor:[UIColor colorWithRed:240.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0]];
        [self addSubview:numberLabel];
        
        ratingBar=[[RatingBar alloc]initWithFrame:CGRectMake(width/45.7+width/2.7+width/17.8+width/32*2+width/45.7+width/32*4+width/35.6, width/24.6+width/22+width/35.6, width/29*6, width/20)];
        ratingBar.isIndicator=YES;
        [ratingBar setImageDeselected:@"star_unselect" halfSelected:nil fullSelected:@"star_select" andDelegate:nil];
        [ratingBar displayRating:4.0f];
        [self addSubview:ratingBar];
       
        UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_logo"]];
        [localImageView setFrame:CGRectMake(width/45.7+width/2.7+width/17.8, width/24.6+width/22+width/35.6+width/32+width/11.4+width/160, width/35.5, width/29)];
        [self addSubview:localImageView];
        
        addLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/2.7+width/17.8+width/35.5+width/45.7, width/24.6+width/22+width/35.6+width/32+width/11.4, width/29*18, width/26.7)];
        [addLabel setText:@"渝中区牛角沱太平洋广场3楼"];
        [addLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
        [addLabel setFont:[UIFont systemFontOfSize:width/29]];
        [self addSubview:addLabel];
        
        fram.size.height=width/45.7+width/45.7+width/3.8;
        
        [self setFrame:fram];
        
    }
    return self;
}


@end
