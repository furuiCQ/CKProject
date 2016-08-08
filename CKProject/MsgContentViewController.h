//
//  MsgContentViewController.h
//  CKProject
//
//  Created by 凌甫 刘pro on 16/1/13.
//  Copyright © 2016年 furui. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MsgContentViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;
@property UIImageView *chooseImageView;
@property UITextField *titleView;
@property UITextView *contentView;
-(void)setContent:(NSString *)title withTime:(NSNumber *)btime withContent:(NSString *)content withId:(NSNumber *)msgId;
@end