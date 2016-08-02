//
//  ProjectListItem.m
//  CKProject
//
//  Created by furui on 15/12/4.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "ProjectListItem.h"
@interface ProjectListItem()

@end
@implementation ProjectListItem

@synthesize logoView;
@synthesize projectName;
@synthesize joinLabel;
@synthesize addressLabel;
@synthesize typelabel3;
@synthesize typelabel;
@synthesize typelabel1;
@synthesize typelabel2;
@synthesize typelabel4;

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
        
        logoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/23, width/6, width/5.7)];
        [logoView setUserInteractionEnabled:NO];
        [logoView setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        
        projectName=[[UILabel alloc]initWithFrame:CGRectMake(width/23+width/6+width/40, width/15, width/22*18, width/22)];
        [projectName setText:@"二胡十段兴趣班"];
        [projectName setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
        [projectName setFont:[UIFont systemFontOfSize:width/22.8]];
        [self addSubview:projectName];
        [self addSubview:logoView];

        joinLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23+width/6+width/40, width/22+width/15+width/40, width/32*4, width/32)];
        [joinLabel setText:@"已报1人"];
        [joinLabel setFont:[UIFont systemFontOfSize:width/32]];
        [joinLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:joinLabel];
        addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(joinLabel.frame.size.width+joinLabel.frame.origin.x+2, joinLabel.frame.origin.y, width/2.4, width/32)];
        [addressLabel setText:@"渝中区"];
        [addressLabel setFont:[UIFont systemFontOfSize:width/32]];
        [addressLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:addressLabel];
        typelabel3=[[UILabel alloc]initWithFrame:CGRectMake(width-width/6-width/40, width/22+width/15+width/40, width/6, width/32)];
        [typelabel3 setText:@"<500m"];
        [typelabel3 setTextAlignment:NSTextAlignmentRight];
        [typelabel3 setFont:[UIFont systemFontOfSize:width/32]];
        [typelabel3 setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        
        [self addSubview:typelabel3];
        
        
        
        typelabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23+width/6+width/40, width/22+width/15+width/40+width/32+width/90, width/5, width/22)];
        [typelabel setText:@"适应年龄段"];
        [typelabel setTextAlignment:NSTextAlignmentCenter];
        [typelabel setFont:[UIFont systemFontOfSize:width/32]];
        [typelabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        [typelabel setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel.layer setCornerRadius:5.0f];
        typelabel.layer.masksToBounds =YES;
        
        [self addSubview:typelabel];
   
        
        
        
        typelabel1=[[UILabel alloc]initWithFrame:CGRectMake(typelabel.frame.origin.x+typelabel.frame.size.width+2, width/22+width/15+width/40+width/32+width/90, width/10, width/22)];
        [typelabel1 setText:@"小学"];
        [typelabel1 setTextAlignment:NSTextAlignmentCenter];
        [typelabel1 setFont:[UIFont systemFontOfSize:10]];
        [typelabel1 setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        [typelabel1 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel1.layer setCornerRadius:5.0f];
        typelabel1.layer.masksToBounds =YES;
        
        [self addSubview:typelabel1];
        
        
        typelabel2=[[UILabel alloc]initWithFrame:CGRectMake(width-width/7-width/40, width/5+width/40-width/20, width/7, width/29)];
        [typelabel2 setText:@"余2小时"];
        [typelabel2 setTextAlignment:NSTextAlignmentRight];
        [typelabel2 setFont:[UIFont systemFontOfSize:11]];
        [typelabel2 setTextColor:[UIColor grayColor]];
        
        [self addSubview:typelabel2];
        typelabel4=[[UILabel alloc]initWithFrame:CGRectMake(typelabel1.frame.size.width+typelabel1.frame.origin.x+width/7, width/22+width/15+width/40+width/32+width/90,  width/10, width/22)];
         [typelabel4 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel4 setText:@"免费"];
        typelabel4.clipsToBounds = YES;
        typelabel4.layer.cornerRadius=4.0f;
        [typelabel4 setTextAlignment:NSTextAlignmentLeft];
        [typelabel4 setFont:[UIFont systemFontOfSize:width/29]];
        [typelabel4 setTextColor:[UIColor colorWithRed:50.f/255.f green:100.f/255.f blue:50.f/255.f alpha:1.0]];
        [self addSubview:typelabel4];
        fram.size.height=width/23+width/23+width/5.7;
        
        [self setFrame:fram];

    }
    return self;
}


@end
