//
//  ChangePhoneViewController.h
//  CKProject
//
//  Created by furui on 16/8/8.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
@interface ChangeNickNameViewController : BaseViewController
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
-(void)setNickName:(NSString *)nickname;
@end