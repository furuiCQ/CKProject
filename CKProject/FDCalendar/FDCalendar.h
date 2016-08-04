//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EveryFrameDelegate <NSObject>

- (void)getSelectData:(NSDate *)date;

@end



@interface FDCalendar : UIView
- (instancetype)initWithCurrentDate:(NSDate *)date;
@property (nonatomic, retain) id <EveryFrameDelegate> delegate;

@end
