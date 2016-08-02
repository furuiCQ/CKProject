//
//  InvitaitionTabelCell.m
//  CKProject
//
//  Created by furui on 15/12/28.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "RJUtil.h"
#import "InvitaitionTabelCell.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface InvitaitionTabelCell()
@end

@implementation InvitaitionTabelCell
@synthesize viewController;
@synthesize dianZanLabel;
@synthesize logoView;
@synthesize contextView;
@synthesize timeLabel;
@synthesize userName;
@synthesize data;
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
        logoView=[[UIImageView alloc]initWithFrame:CGRectMake(width/20, width/22.8, width/13, width/13)];
        logoView.layer.masksToBounds = YES;
        [logoView.layer setBorderColor:[UIColor whiteColor].CGColor];
        logoView.layer.cornerRadius = (logoView.frame.size.width) / 2;
        [logoView setImage:[UIImage imageNamed:@"qq_logo"]];
        [self addSubview:logoView];
       
        userName=[[UILabel alloc]initWithFrame:CGRectMake(width/40, width/22.8+width/64+width/13, width/8, width/26.7)];
        [userName setText:@"小哥"];
        [userName setTextAlignment:NSTextAlignmentCenter];
        [userName setFont:[UIFont systemFontOfSize:width/26.7]];
        [self addSubview:userName];
        
        contextView=[[UITextView alloc]initWithFrame:CGRectMake(width/20+width/13+width/15, width/20, width-width/21-(width/20+width/13+width/15), width/20)];
        [contextView setFont:[UIFont systemFontOfSize:width/26.7]];
        [contextView setEditable:NO];
        [contextView setText:@"感受大自然"];
        [self addSubview:contextView];
        //加入动态计算高度
        CGSize size = [self getStringRectInTextView:@"感受大自然" InTextView:contextView];
        CGRect frame = contextView.frame;
        frame.size.height = size.height+40;
        contextView.frame = frame;
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, contextView.frame.origin.y+contextView.frame.size.height+width/22.8, width-width/21, width/32)];
        [timeLabel setText:@"2015-12-3"];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont systemFontOfSize:width/32]];
        [timeLabel setTextColor:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0]];
        [self addSubview:timeLabel];
        
        dianZanLabel=[[UIButton alloc]initWithFrame:CGRectMake(width-width/21-width/20, timeLabel.frame.origin.y
                                                               +timeLabel.frame.size.height+width/45.7, width/20, width/22.8)];
        [dianZanLabel setUserInteractionEnabled:YES];
        [dianZanLabel setImage:[UIImage imageNamed:@"zan_logo"] forState:UIControlStateNormal];
        [dianZanLabel setImage:[UIImage imageNamed:@"dianzan_logo"] forState:UIControlStateSelected];
        [dianZanLabel addTarget:self action:@selector(dianzanOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dianZanLabel];
        
        frame=self.frame;
        frame.size.height=dianZanLabel.frame.size.height+dianZanLabel.frame.origin.y+width/22.8;
        self.frame=frame;
        
    }
    return self;
}
-(void)dianzanOnClick:(id)sender{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    dianZanLabel.selected=!dianZanLabel.selected;//每次点击都改变按钮的状态
    NSNumber *zan;
    if(dianZanLabel.selected){
        zan=[NSNumber numberWithInt:1];
        
        
    }else{
        zan=[NSNumber numberWithInt:0];
        //在此实现打勾时的方法
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [HttpHelper zanComments:[data objectForKey:@"id"] withZan:zan withModel:myDelegate.model
                         success:^(HttpModel *model){
            
            NSLog(@"%@",model.message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                    });
                    
                }else{
                    
                }
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
        
        
    });

    
    
}
- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //
    //    NSLog(@"行高  ＝ %f container = %@,xxx = %f",self.textview.font.lineHeight,self.textview.textContainer,self.textview.textContainer.lineFragmentPadding);
    //
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
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