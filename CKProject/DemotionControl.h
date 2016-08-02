//
//  DemotionControl.h
//  CKProject
//
//  Created by furui on 16/1/19.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemotionControl : UIControl

@property(strong,nonatomic)UIButton *userLogo;
@property(strong,nonatomic)UILabel *textLabel;
-(void)initView:(CGRect *)frame withTag:(int)numb;
@end