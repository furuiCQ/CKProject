//
//  TopBar.h
//  CKProject
//
//  Created by furui on 15/12/9.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBar : UIControl

@property(strong,nonatomic)UIView *view;
@property(strong,nonatomic)UILabel *textLabel;
@property(strong,nonatomic)NSString *text;
@property(strong,nonatomic)UIColor *iconColor;
@property(strong,nonatomic)UIColor *textColor;
@property(strong,nonatomic)UIFont *iconFont;
@property(strong,nonatomic)UIFont *textFont;
@property BOOL checked;
@property BOOL isEnd;

-(void)initView;
-(void)setLabelFont:(UIFont *)font;
@end