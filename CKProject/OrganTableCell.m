//
//  OrganTableCell.m
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "RJUtil.h"
#import "OrganTableCell.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface OrganTableCell()
@end

@implementation OrganTableCell
@synthesize viewController;
@synthesize listItem;

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame=[self frame];
        CGRect rx = [ UIScreen mainScreen ].bounds;
        int width=rx.size.width;
        int hegiht=rx.size.height;
        listItem=[[OrgListItem alloc]initFrame:CGRectMake(0, 0, width, hegiht) withWidth:width];
        [listItem setUserInteractionEnabled:NO];
        [self addSubview:listItem];
        
        frame.size.height=listItem.frame.size.height;
        
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