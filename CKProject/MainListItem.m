//
//  ListItem.m
//  CKProject
//
//  Created by frain on 15/12/3.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MainListItem.h"
@interface MainListItem()

@end
@implementation MainListItem

@synthesize imageView;
@synthesize titleLabel;
@synthesize joinLabel;
@synthesize addressLabel;
@synthesize typelabel;
@synthesize typelabel1;
@synthesize typelabel2;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}


-(id)initFrame:(CGRect)frame withHegiht:(int)hegiht{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = [self frame];
        int width=frame.size.width;
        
       // [self setBackgroundColor:[UIColor redColor]];
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width*3/5)];
        [imageView setImage:[UIImage imageNamed:@"main_defalut"]];
        [self addSubview:imageView];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width*3/5+width/20, width, width/10)];
        [titleLabel setText:@"二胡十段兴趣班"];
        [titleLabel setFont:[UIFont systemFontOfSize:width/10]];
        [titleLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
        [self addSubview:titleLabel];
        
        joinLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width*3/5+width/10+width/10, width/14*4, width/14)];
        [joinLabel setText:@"已报1人"];
        [joinLabel setFont:[UIFont systemFontOfSize:width/14]];
        [joinLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:joinLabel];
        
        addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/14*4+width/20, width*3/5+width/10+width/10, width/14*4, width/14)];
        [addressLabel setText:@"渝中汉昌"];
        addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [addressLabel setFont:[UIFont systemFontOfSize:width/14]];
        [addressLabel setTextColor:[UIColor grayColor]];
        [self addSubview:addressLabel];
        
        typelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, width*3/5+width/10+width/10+width/14+width/12, width/14*3, width/12)];
        [typelabel setText:@"乐器"];
        [typelabel setTextAlignment:NSTextAlignmentCenter];
        [typelabel setFont:[UIFont systemFontOfSize:width/14]];
        [typelabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [typelabel setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel.layer setCornerRadius:3.0f];
        typelabel.layer.masksToBounds =YES;
        
        [self addSubview:typelabel];
        
        typelabel1=[[UILabel alloc]initWithFrame:CGRectMake(width/20+width/14*3, width*3/5+width/10+width/10+width/14+width/12, width/14*4, width/12)];
        [typelabel1 setText:@"3~16岁"];
        [typelabel1 setTextAlignment:NSTextAlignmentCenter];
        [typelabel1 setFont:[UIFont systemFontOfSize:width/14]];
        [typelabel1 setTextColor:[UIColor grayColor]];
        [typelabel1 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel1.layer setCornerRadius:3.0f];
        typelabel1.layer.masksToBounds =YES;
        
        [self addSubview:typelabel1];
        
        
        typelabel2=[[UILabel alloc]initWithFrame:CGRectMake(width*3/4, width*3/5+width/10+width/10+width/14+width/12, width/12*3, width/12)];
        [typelabel2 setText:@"余3天"];
        [typelabel2 setTextAlignment:NSTextAlignmentCenter];
        [typelabel2 setFont:[UIFont systemFontOfSize:width/12]];
        [typelabel2 setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        
        [self addSubview:typelabel2];
        
        frame.size.height = typelabel2.frame.origin.y+typelabel2.frame.size.height+width/20;
        self.frame = frame;
    }
    return self;
}


@end
