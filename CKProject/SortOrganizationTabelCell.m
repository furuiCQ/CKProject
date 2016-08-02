//
//  OrganizationTabelCell.m
//  CKProject
//
//  Created by furui on 15/12/15.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "SortOrganizationTabelCell.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface SortOrganizationTabelCell()
@end

@implementation SortOrganizationTabelCell
@synthesize viewController;
@synthesize titleLabel;
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;

@synthesize  imageTitle1;
@synthesize  imageTitle2;
@synthesize  imageTitle3;
@synthesize  imageTitle4;
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
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/35.6, width/21, width, width/26.7)];
        [titleLabel setText:@"早教"];
        [titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        [titleLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:titleLabel];
        
        imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(width/21, width/21+width/26.7+width/35.6, width*3/7, width/3.8)];
        [imageView1 setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        imageView1.layer.masksToBounds = YES;
        imageView1.layer.cornerRadius = 3.0f;
        imageTitle1=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, imageView1.frame.size.width, width/15)];
        [imageTitle1 setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
        [imageTitle1 setText:@"汉昌培训"];
        [imageTitle1 setTextAlignment:NSTextAlignmentCenter];
        [imageTitle1 setFont:[UIFont systemFontOfSize:width/26.7]];
        [imageTitle1 setTextColor:[UIColor whiteColor]];
        [imageView1 addSubview:imageTitle1];
        [self addSubview:imageView1];
        
        imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(width/21+width*3/7+width/23, width/21+width/26.7+width/35.6, width*3/7, width/3.8)];
        imageView2.layer.masksToBounds = YES;
        imageView2.layer.cornerRadius = 3.0f;
        [imageView2 setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        imageTitle2=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, imageView1.frame.size.width, width/15)];
        [imageTitle2 setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
        [imageTitle2 setText:@"汉昌培训"];
        [imageTitle2 setTextAlignment:NSTextAlignmentCenter];
        [imageTitle2 setFont:[UIFont systemFontOfSize:width/26.7]];
        [imageTitle2 setTextColor:[UIColor whiteColor]];
        [imageView2 addSubview:imageTitle2];
        [self addSubview:imageView2];
        
        
        imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(width/21, imageView1.frame.size.height+imageView1.frame.origin.y+width/23, width*3/7, width/3.8)];
        [imageView3 setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        imageView3.layer.masksToBounds = YES;
        imageView3.layer.cornerRadius = 3.0f;
        imageTitle3=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, imageView3.frame.size.width, width/15)];
        [imageTitle3 setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
        [imageTitle3 setText:@"汉昌培训"];
        [imageTitle3 setTextAlignment:NSTextAlignmentCenter];
        [imageTitle3 setFont:[UIFont systemFontOfSize:width/26.7]];
        [imageTitle3 setTextColor:[UIColor whiteColor]];
        [imageView3 addSubview:imageTitle3];
        [self addSubview:imageView3];
        
        
        imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(width/21+width*3/7+width/23,imageView1.frame.size.height+imageView1.frame.origin.y+width/23, width*3/7, width/3.8)];
        [imageView4 setImage:[UIImage imageNamed:@"instdetails_defalut"]];
        imageView4.layer.masksToBounds = YES;
        imageView4.layer.cornerRadius = 3.0f;
        imageTitle4=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, imageView4.frame.size.width, width/15)];
        [imageTitle4 setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
        [imageTitle4 setText:@"汉昌培训"];
        [imageTitle4 setTextAlignment:NSTextAlignmentCenter];
        [imageTitle4 setFont:[UIFont systemFontOfSize:width/26.7]];
        [imageTitle4 setTextColor:[UIColor whiteColor]];
        [imageView4 addSubview:imageTitle4];
        [self addSubview:imageView4];
        
        frame.size.height=width*3/4;
        self.frame=frame;

        
    }
    return self;
}
-(void)onClick:(id)sender{
    NSLog(@
          "跳转进入圈子列表");
    //ListItem *item=(ListItem *)sender;
    
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