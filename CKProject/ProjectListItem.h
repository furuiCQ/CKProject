//
//  ProjectListItem.h
//  CKProject
//
//  Created by furui on 15/12/4.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectListItem : UIControl
@property(strong,nonatomic)UIImageView *logoView;
@property(strong,nonatomic)UILabel *projectName;
@property(strong,nonatomic)UILabel *joinLabel;
@property(strong,nonatomic)UILabel *addressLabel;
@property(strong,nonatomic)UILabel *typelabel3;
@property(strong,nonatomic)UILabel *typelabel;
@property(strong,nonatomic)UILabel *typelabel1;
@property(strong,nonatomic) UILabel *typelabel2;
@property(strong,nonatomic) UILabel *typelabel4;

-(id)initFrame:(CGRect)frame withWidth:(int)width;
@end