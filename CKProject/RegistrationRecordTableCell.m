//
//  RegistrationRecordTableCell.m
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "RegistrationRecordTableCell.h"
#import "RJUtil.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface RegistrationRecordTableCell()
@end

@implementation RegistrationRecordTableCell
@synthesize viewController;
@synthesize rowHeight;


@synthesize logoImageView;
@synthesize projectName;
@synthesize tilteLabel;
@synthesize timeLabel;
@synthesize statueLabel;
@synthesize statue2Label;

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
        //int hegiht=self.contentView.frame.size.height;
        logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/45.7, width/45.7, width/5.7, width/5.7)];
        
        [logoImageView setBackgroundColor:[UIColor redColor]];
        
        //UIColor *color=[self randomColor];
        //[self.contentView setBackgroundColor:color];
        [self.contentView addSubview:logoImageView];
        
        projectName=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/5.7+width/26.7, width/29, width/3, width/35)];
        [projectName setFont:[UIFont systemFontOfSize:width/35.6]];
        [projectName setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [projectName setText:@"汉昌IT岗前实训中心"];
        [self.contentView addSubview:projectName];
        
        tilteLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/5.7+width/26.7, width/29+width/35+width/32, width/2, width/24)];
        [tilteLabel setText:@"二胡八段干货讲座"];
        [tilteLabel setFont:[UIFont systemFontOfSize:width/24.6]];
        [self.contentView addSubview:tilteLabel];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/45.7+width/5.7+width/26.7,  width/29+width/35+width/32+width/24+width/32, width/2, width/35)];
        [timeLabel setText:@"02-01 上午9:00"];
        [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [timeLabel setFont:[UIFont systemFontOfSize:width/35.6]];
        [self.contentView addSubview:timeLabel];
        
        
        
        
        statueLabel=[[UILabel alloc]initWithFrame:CGRectMake(width-width/33-width/8, width/4.5-width/20-width/45.7, width/8, width/20)];
        [statueLabel setText:@""];
        [statueLabel setTextColor:[UIColor colorWithRed:245.f/255.f green:7.f/255.f blue:35.f/255.f alpha:1.0]];
        [statueLabel setTextAlignment:NSTextAlignmentCenter];
        [statueLabel setFont:[UIFont systemFontOfSize:width/32]];
        statueLabel.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
        statueLabel.layer.cornerRadius=4.0;
        statueLabel.layer.borderWidth = 1; //要设置的描边宽
        statueLabel.layer.masksToBounds=YES;
        
        
        [self.contentView addSubview:statueLabel];
        
//        statue2Label=[[UILabel alloc]initWithFrame:CGRectMake(width-width/33*2-width/8*2, width/4.5-width/20-width/45.7, width/8, width/20)];
//        [statue2Label setText:@"未受理"];
//        [statue2Label setTextColor:[UIColor colorWithRed:245.f/255.f green:7.f/255.f blue:35.f/255.f alpha:1.0]];
//        [statue2Label setTextAlignment:NSTextAlignmentCenter];
//        [statue2Label setFont:[UIFont systemFontOfSize:width/32]];
//        statue2Label.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
//        statue2Label.layer.cornerRadius=4.0;
//        statue2Label.layer.borderWidth = 1; //要设置的描边宽
//        statue2Label.layer.masksToBounds=YES;
//        [self.contentView addSubview:statue2Label];
        
        
        frame.size.height=width/4.5;
        self.frame=frame;
        
    }
    return self;
}
//green color 75,206,109
//green bordercolor

//red color

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
-(void)onClick:(id)sender{
    //ListItem *item=(ListItem *)sender;
    // [viewController presentViewController:nil animated:YES completion:nil];
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