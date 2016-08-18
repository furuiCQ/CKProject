//
//  ProjectTimePicker.h
//  CKProject
//
//  Created by furui on 16/8/7.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerDelegate <NSObject>

-(void)orderClick:(NSNumber *)weekId withWeekNum:(NSNumber *)weeknum withBegintime:(NSString *)beginTime;

@end
@interface ProjectTimePicker : UIView
@property (nonatomic , weak) id<PickerDelegate> pickerDelegate;
-(void)initView:(CGRect *)frame;
-(void)setData:(NSDictionary *)data;
-(void)dismiss;
-(void)show;
-(void)setWeekDayStatues:(NSString *)str;
@end