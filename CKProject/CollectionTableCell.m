//
//  CollectionTableCell.m
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "CollectionTableCell.h"
#import "RJUtil.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface CollectionTableCell()
@end

@implementation CollectionTableCell
@synthesize viewController;
@synthesize rowHeight;

@synthesize logoImageView;
@synthesize projectName;
@synthesize haveSomeOneLabel;
@synthesize addressLabel;
@synthesize typelabel;
@synthesize typelabel1;
@synthesize typelabel2;
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
        //int hegiht=self.contentView.frame.size.height;
            CGRect frame=self.frame;
            logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width/40, width/23, width/5, width/5)];
            [logoImageView setImage:[UIImage imageNamed:@"instdetails_defalut"]];

            [self.contentView addSubview:logoImageView];
            
            projectName=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23, width/16, width/1.5, width/22)];
            [projectName setFont:[UIFont systemFontOfSize:width/22.8]];
            [projectName setTextColor:[UIColor colorWithRed:86.f/255.f green:86.f/255.f blue:86.f/255.f alpha:1.0]];
            [projectName setText:@"二胡十段兴趣班"];
            [self.contentView addSubview:projectName];
            
            
           
            
            haveSomeOneLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23,width/16+width/22+width/32, width/32*4, width/32)];
            [haveSomeOneLabel setText:@"已报1人"];
            [haveSomeOneLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
            [haveSomeOneLabel setFont:[UIFont systemFontOfSize:width/32]];
            [self.contentView addSubview:haveSomeOneLabel];
            
            addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23+width/32*4+width/32, width/16+width/22+width/32, width/32*20, width/32)];
            [addressLabel setText:@"渝中汉昌"];
            
            [addressLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
            [addressLabel setFont:[UIFont systemFontOfSize:width/32]];
            [self.contentView addSubview:addressLabel];
            
            
            typelabel=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23-10, width/16+width/22+width/32*2+width/35.6, width/22*5, width/22)];
            [typelabel setText:@"适应年龄段"];
            [typelabel setTextAlignment:NSTextAlignmentCenter];
            [typelabel setFont:[UIFont systemFontOfSize:width/32]];
            [typelabel setTextColor:[UIColor grayColor]];
            [typelabel setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
            [typelabel.layer setCornerRadius:5.0f];
            typelabel.layer.masksToBounds =YES;
            
            [self.contentView addSubview:typelabel];
            
            typelabel1=[[UILabel alloc]initWithFrame:CGRectMake(width/40+width/5+width/23+width/22*2+width/45.7+20, width/16+width/22+width/32*2+width/35.6, width/22*3, width/22)];
            [typelabel1 setText:@"0~3岁"];
            [typelabel1 setTextAlignment:NSTextAlignmentCenter];
            [typelabel1 setFont:[UIFont systemFontOfSize:width/32]];
            [typelabel1 setTextColor:[UIColor grayColor]];
            [typelabel1 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
            [typelabel1.layer setCornerRadius:5.0f];
            typelabel1.layer.masksToBounds =YES;
            
            [self.contentView addSubview:typelabel1];
            
            
            
            
            
//           typelabel2=[[UILabel alloc]initWithFrame:CGRectMake(width-width/21-width/8, width/16+width/22+width/32*2+width/35.6, width/8, width/29)];
//            [typelabel2 setText:@"余1天"];
//            [typelabel2 setTextAlignment:NSTextAlignmentRight];
//            [typelabel2 setFont:[UIFont systemFontOfSize:width/29]];
//            [self.contentView addSubview:typelabel2];
        
            frame.size.height=width/23*2+width/5;
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