//
//  CharesectionView.h
//  CKProject
//
//  Created by furui on 16/4/17.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharesectionView : UIControl

@property(strong,nonatomic)UIImageView *iconView;
@property(strong,nonatomic)UILabel *contentLabel;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)NSString *sqlString;
-(void)initView:(CGRect *)frame withTag:(int)numb;
@end