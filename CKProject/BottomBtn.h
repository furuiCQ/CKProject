//
//  BottomBtn.h
//  NWeibo
//
//  Created by frain on 15/11/27.
//  Copyright © 2015年 furui. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BottomBtn : UIControl

@property(strong,nonatomic)UIImageView *iconLabel;
@property(strong,nonatomic)UILabel *textLabel;
@property(strong,nonatomic)NSString *selectIcon;
@property(strong,nonatomic)NSString *unSelectIcon;
@property(strong,nonatomic)NSString *text;
@property(strong,nonatomic)UIColor *selectColor;
@property(strong,nonatomic)UIColor *unSelectColor;
@property(strong,nonatomic)UIFont *iconFont;
@property(strong,nonatomic)UIFont *textFont;

-(void)initView;
-(void)isCheck;
-(void)unCheck;
@end