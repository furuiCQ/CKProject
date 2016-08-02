//
//  OrgListItem.h
//  CKProject
//
//  Created by furui on 16/1/4.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"


@interface OrgListItem : UIControl

@property(strong,nonatomic)UIImageView *logoView;
@property(strong,nonatomic)UILabel *logoTitle;
@property(strong,nonatomic)UILabel *orgName;
@property(strong,nonatomic)UILabel *numberLabel;
@property(strong,nonatomic)RatingBar *ratingBar;
@property(strong,nonatomic)UILabel *addLabel;
-(id)initFrame:(CGRect)frame withWidth:(int)width;

@end