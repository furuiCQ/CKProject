//
//  MsgTableCell.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "MsgTableCell.h"
#import "RJUtil.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface MsgTableCell()
@end

@implementation MsgTableCell
@synthesize viewController;
@synthesize rowHeight;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize pointView;
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
//        UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/22.8, width/11.8, width/11.8)];
//        //[logoView setBackgroundColor:[UIColor grayColor]];
//        logoView.layer.masksToBounds = YES;
//        logoView.layer.cornerRadius = (logoView.frame.size.width) / 2;
//        [self.contentView addSubview:logoView];
        pointView=[[UIView alloc]initWithFrame:CGRectMake(width/11.8+width/26.7-8-width/40,  width/22.8+width/26.7-8, 8, 8)];
        [pointView setBackgroundColor:[UIColor redColor]];
        pointView.layer.masksToBounds = YES;
        pointView.layer.cornerRadius = (pointView.frame.size.width + 10) / 4;
        [self.contentView addSubview:pointView];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/11.8+width/26.7, width/22.8, width/4, width/26.7)];
        [titleLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
        [titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        [titleLabel setText:@"feifei鱼"];
        [self.contentView addSubview:titleLabel];

        
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/11.8+width/26.7, width/22.8+width/26.7+width/53, width/29*20, width/29)];
        [contentLabel setFont:[UIFont systemFontOfSize:width/29]];
        [contentLabel setTextColor:[UIColor colorWithRed:104.f/255.f green:104.f/255.f blue:104.f/255.f alpha:1.0]];
        [contentLabel setText:@"系统消息:你的预约已被受理，请注意上课时间"];
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;  //结尾部分的内容以……方式省略，显示头的文字内容。
        [self.contentView addSubview:contentLabel];
        
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/22.8-width/5, width/22.8, width/5, width/20)];
        [timeLabel setText:@"2015-02-01"];
        [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [timeLabel setFont:[UIFont systemFontOfSize:width/29]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:timeLabel];
        
        frame.size.height=width/5.7;
        self.frame=frame;
        
    }
    return self;
}
-(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
-(void)onMoreClick{
    NSLog(@"moreClick");
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