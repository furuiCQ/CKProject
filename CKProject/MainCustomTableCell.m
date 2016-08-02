//
//  RJCustomTableView.m
//  RJYaCheDai
//
//  Created by furui on 15/7/24.
//  Copyright (c) 2015年 furui. All rights reserved.
//

#import "MainCustomTableCell.h"
#import "RJUtil.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]
@interface MainCustomTableCell()
@end

@implementation MainCustomTableCell
@synthesize viewController;
@synthesize topText;
@synthesize itemArray;
@synthesize projectId;
@synthesize typeId;

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        CGRect frame = [self frame];
//        itemArray=[[NSMutableArray alloc]init];
//        CGRect rx = [ UIScreen mainScreen ].bounds;
//        int width=rx.size.width;
//        int hegiht=rx.size.height;
//        UIView *subview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, hegiht)];
//        
//        UILabel *topImage=[[UILabel alloc]initWithFrame:CGRectMake(width/34, width/17.8, width/106, width/22.8)];
//        [topImage setUserInteractionEnabled:NO];
//        [topImage setBackgroundColor:[UIColor redColor]];
//        [subview addSubview:topImage];
//
//        
//        topText=[[UILabel alloc]initWithFrame:CGRectMake(width/34+width/25, width/21.3, width/2
//                                                         , width/16)];
//        [topText setText:@"音乐类"];
//        [topText setFont:[UIFont systemFontOfSize:width/22.8]];
//        [topText setTextColor:[UIColor colorWithRed:5.f/255.f green:27.f/255.f blue:40.f/255.f alpha:1.0]];
//        [subview addSubview:topText];
//        
//        UIControl  *moreControl=[[UIControl alloc]initWithFrame:CGRectMake(width-width/10-width/20-width/25, width/21.3, width/10+width/20, width/16)];
//       [moreControl setUserInteractionEnabled:YES];
//       [moreControl addTarget:self action:@selector(onMoreClick) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width/10, width/16)];
//        [moreLabel setText:@"更多"];
//        [moreLabel setTextAlignment:NSTextAlignmentCenter];
//        [moreLabel setFont:[UIFont systemFontOfSize:width/26.7]];
//        [moreLabel setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
//        UIImageView *rightView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more_logo"]];
//        [rightView setFrame:CGRectMake(width/10, width/32-width/40, width/20, width/20)];
//        [moreControl addSubview:moreLabel];
//        [moreControl addSubview:rightView];
//
//        [subview addSubview:moreControl];
//        
//        int itemWidth=width*5/11;
//        int itemHegiht=hegiht/2;
//        for (int i=0; i<4; i++) {
//            float x=0;
//            float y=0;
//          
//            if(i%2==0){
//                x=width/33;
//                y=itemWidth/3+(itemHegiht+itemWidth/3)*i/4;
//            }else{
//                x=width*2/33+itemWidth;
//                y=itemWidth/3+(itemHegiht+itemWidth/3)*(i-1)/4;
//            }
//            
//            MainListItem *item=[[MainListItem alloc]initFrame:CGRectMake(x, y, itemWidth, itemHegiht)withHegiht:itemHegiht];
//            [item setTag:i];
//            [item addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//            [item setUserInteractionEnabled:YES];
//            [subview addSubview:item];
//            [itemArray addObject:item];
//            if (i==3) {
//                frame.size.height=item.frame.origin.y+item.frame.size.height+width/40;
//            }
//
//        }
//        self.frame = frame;
//
//            
//        [self.contentView addSubview:subview];
//        
//        
//        
//    }
    return self;
}
-(void)onMoreClick{
    NSLog(@"moreClick");
//    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
//    [viewController presentViewController: projectListViewController animated:YES completion:nil];
}
-(void)onClick:(id)sender{
    
    //MainListItem *item=(MainListItem *)sender;
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