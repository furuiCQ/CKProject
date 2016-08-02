//
//  InvitationTableCell.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "InvitationTableCell.h"
#import "RJUtil.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface InvitationTableCell()
@end

@implementation InvitationTableCell
@synthesize viewController;
@synthesize rowHeight;
@synthesize addLabel;
@synthesize lastDayLabel;
@synthesize zanLabel;
@synthesize msgLabel;

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect rx = [ UIScreen mainScreen ].bounds;
        int width=rx.size.width;
            CGRect frame=self.frame;
            
            addLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23, width/23, width-width/23, width/26)];
            [addLabel setFont:[UIFont systemFontOfSize:width/26.7]];
            [addLabel setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
            [addLabel setText:@"我是如何考上高级UI设计师的"];
            [self.contentView addSubview:addLabel];
            
            
            lastDayLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/23,width/23+width/45+width/26, width/3, width/32)];
            [lastDayLabel setText:@"2015-02-22"];
            [lastDayLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
            [lastDayLabel setFont:[UIFont systemFontOfSize:width/32]];
            [self.contentView addSubview:lastDayLabel];
            
            
            UIImageView *zanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/23-width/32*3-width/32-width/64-width/21-width/32*3-width/64-width/32, width/6, width/32, width/32)];
            [zanImageView setImage:[UIImage imageNamed:@"zan_logo"]];
            [self.contentView addSubview:zanImageView];
            
            zanLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/23-width/32*3-width/32-width/64-width/21-width/32*3, width/6, width/32*3, width/32)];
            [zanLabel setText:@"1232"];
            [zanLabel setTextColor:[UIColor colorWithRed:86.f/255.f green:86.f/255.f blue:86.f/255.f alpha:1.0]];
            [zanLabel setFont:[UIFont systemFontOfSize:width/29]];
            [self.contentView addSubview:zanLabel];
            
            
            UIImageView *msgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width-width/23-width/32*3-width/32-width/64, width/6, width/32, width/32)];
            [msgImageView setImage:[UIImage imageNamed:@"discuss_logo"]];
            [self.contentView addSubview:msgImageView];
            
            msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/23-width/32*3, width/6, width/32*3, width/32)];
            [msgLabel setText:@"1232"];
            [msgLabel setTextColor:[UIColor colorWithRed:86.f/255.f green:86.f/255.f blue:86.f/255.f alpha:1.0]];
            [msgLabel setFont:[UIFont systemFontOfSize:width/29]];
            [self.contentView addSubview:msgLabel];

            frame.size.height=width/4.5;
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