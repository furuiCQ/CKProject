//
//  SortProjectListTableCell.m
//  CKProject
//
//  Created by furui on 15/12/15.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "RJUtil.h"
#import "SortProjectListTableCell.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface SortProjectListTableCell()
@end

@implementation SortProjectListTableCell
@synthesize viewController;
@synthesize titleLabel;
@synthesize logoImage;
@synthesize moreLabel;
@synthesize goImage;
@synthesize controlArray;
@synthesize isSelected;
/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        controlArray=[[NSMutableArray alloc]init];

        CGRect rx = [ UIScreen mainScreen ].bounds;
        int width=rx.size.width;
        CGRect frame=self.frame;
        logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(width/21.3, width/40, width/11.4, width/11.4)];
        [logoImage setImage:[UIImage imageNamed:@"zaojiao_logo"]];
        [self addSubview:logoImage];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.size.width+logoImage.frame.origin.x+width/64, width/21, width/2, width/22.8)];
        [titleLabel setText:@"早教"];
        [titleLabel setFont:[UIFont systemFontOfSize:width/22.8]];
        [titleLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
        [self addSubview:titleLabel];
      
        goImage=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/21.3-width/32, width/20, width/32, width/53)];
        [goImage setImage:[UIImage imageNamed:@"arrow"]];
        [goImage setUserInteractionEnabled:YES];
        [self addSubview:goImage];
        
        moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(goImage.frame.origin.x-goImage.frame.size.width-width/26.7*2, width/21, width/26.7*2, width/26.7)];
        [moreLabel setText:@"全部"];
        [moreLabel setUserInteractionEnabled:YES];
        [moreLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        [moreLabel setTextColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.0]];
       // [self addSubview:moreLabel];
        
       // frame.size.height=width*3/4;
        self.frame=frame;
        
    }
    return self;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    UITextView *text=(UITextView *)sender;
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [text resignFirstResponder];                     //do not allow the user to selected anything
    return NO;
    
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end