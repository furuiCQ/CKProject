//
//  BottomBtn.m
//  NWeibo
//
//  Created by frain on 15/11/27.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "BottomBtn.h"
@interface BottomBtn()

@end

@implementation BottomBtn

@synthesize iconLabel;
@synthesize textLabel;
@synthesize text;
@synthesize iconFont;
@synthesize textFont;
@synthesize selectIcon;
@synthesize unSelectIcon;
@synthesize selectColor;
@synthesize unSelectColor;
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
-(void)setTextColor:(UIColor *)color{
    [textLabel setTextColor:color];

}
-(void)isCheck{
    [iconLabel setImage:[UIImage imageNamed:selectIcon]];
    [textLabel setTextColor:selectColor];
}
-(void)unCheck{
    [iconLabel setImage:[UIImage imageNamed:unSelectIcon]];
    [textLabel setTextColor:unSelectColor];

}
-(void)initView{
        [self setBackgroundColor:[UIColor greenColor]];
        iconLabel=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-8, self.frame.size.height/6, 19, 19)];
        [self addSubview:iconLabel];
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/4, self.frame.size.height/6+19+self.frame.size.height/10, self.frame.size.width/2, self.frame.size.height/3-1)];
        [textLabel setText:text];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont systemFontOfSize:self.frame.size.width/24.6]];
        [self addSubview:textLabel];
        
    
}


@end