//
//  ProjectSimpleTableCell.m
//  CKProject
//
//  Created by furui on 15/12/18.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "RJUtil.h"
#import "ProjectSimpleTableCell.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface ProjectSimpleTableCell()
@end

@implementation ProjectSimpleTableCell
@synthesize viewController;
@synthesize logoImageView;
@synthesize projectName;
@synthesize haveSomeOneLabel;
@synthesize addressLabel;
@synthesize typelabel;
@synthesize typelabel1;
@synthesize typelabel2;
@synthesize typelabel3;
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
       // int hegiht=rx.size.height;
        
        logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/46, width/5, width/5)];
        [logoImageView setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        [self addSubview:logoImageView];
        
        projectName=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23, width/16, width/2+30, width/23)];
        [projectName setText:@"二胡十段兴趣班"];
        [self addSubview:projectName];
        
        haveSomeOneLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23, width/16+width/53+width/23, width/32*5, width/32)];
        [haveSomeOneLabel setText:@"已报1人"];
        [haveSomeOneLabel setFont:[UIFont systemFontOfSize:width/32]];
        [haveSomeOneLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [haveSomeOneLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:haveSomeOneLabel];

        
        addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23+width/40+haveSomeOneLabel.frame.size.width, width/16+width/53+width/23, width/32*4+80, width/32)];
        [addressLabel setText:@"渝中汉昌"];
        [addressLabel setTextAlignment:NSTextAlignmentCenter];
        [addressLabel setFont:[UIFont systemFontOfSize:width/32]];
        [addressLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:addressLabel];
        
        typelabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23, width/16+width/53+width/23+width/32+width/53, width/6, width/22)];
        [typelabel setText:@"适应年龄段"];
        [typelabel setTextAlignment:NSTextAlignmentCenter];
        [typelabel setFont:[UIFont systemFontOfSize:width/32]];
        [typelabel setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        [typelabel setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel.layer setCornerRadius:5.0f];
        typelabel.layer.masksToBounds =YES;
        
        [self addSubview:typelabel];
        
        typelabel1=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23+width/10+width/40+10, width/16+width/53+width/23+width/32+width/53, width/7, width/22)];
        [typelabel1 setText:@"3~6岁"];
        [typelabel1 setTextAlignment:NSTextAlignmentCenter];
        [typelabel1 setFont:[UIFont systemFontOfSize:width/32]];
        [typelabel1 setTextColor:[UIColor colorWithRed:146.f/255.f green:146.f/255.f blue:146.f/255.f alpha:1.0]];
        [typelabel1 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
        [typelabel1.layer setCornerRadius:5.0f];
        typelabel1.layer.masksToBounds =YES;
        
        [self addSubview:typelabel1];
        
        
        typelabel2=[[UILabel alloc]initWithFrame:CGRectMake(width-width/7-width/40, width/16+width/53+width/23+width/32+width/53, width/7, width/29)];
        [typelabel2 setText:@""];
        [typelabel2 setTextAlignment:NSTextAlignmentRight];
        [typelabel2 setFont:[UIFont systemFontOfSize:width/29]];
        [typelabel2 setTextColor:[UIColor grayColor]];
        
        [self addSubview:typelabel2];
        typelabel3=[[UILabel alloc]initWithFrame:CGRectMake(width/2, width/16+width/53+width/23+width/32+width/53, width/7, width/29)];
        [typelabel3 setText:@"免费"];
        [typelabel3 setTextAlignment:NSTextAlignmentRight];
        [typelabel3 setFont:[UIFont systemFontOfSize:width/29]];
        [typelabel3 setTextColor:[UIColor greenColor]];
         [self addSubview:typelabel3];
        
        
        frame.size.height=typelabel1.frame.size.height+typelabel1.frame.origin.y+width/46;
        
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