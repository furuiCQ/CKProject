//
//  CircleListItem.h
//  CKProject
//
//  Created by furui on 15/12/8.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CircleListItem : UIControl
@property(strong,nonatomic)UIImageView *logoView;
@property(strong,nonatomic)UILabel *pepoleLabel;
@property(strong,nonatomic)UILabel *titleName;
@property(strong,nonatomic)UILabel *contentLabel;
-(id)initFrame:(CGRect)frame withWidth:(int)width;
@end