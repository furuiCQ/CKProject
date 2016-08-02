//
//  CustomControl.h
//  CKProject
//
//  Created by furui on 16/1/2.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomControl : UIControl

@property(strong,nonatomic)UIImageView *userLogo;
@property(strong,nonatomic)UITextField *userNameLabel;
@property(strong,nonatomic)UIImageView *recordRight;
@property(strong,nonatomic)UILabel *bundleLabel;
@property(strong,nonatomic)UILabel *recordLabel;
-(void)initView:(CGRect *)frame;
@end