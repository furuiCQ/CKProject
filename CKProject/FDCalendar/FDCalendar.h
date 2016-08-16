//
//  FDCalendar.h
//  FDCalendarDemo
//


#import <UIKit/UIKit.h>

@protocol EveryFrameDelegate <NSObject>

- (void)getSelectData:(NSDate *)date;

@end



@interface FDCalendar : UIView
- (instancetype)initWithCurrentDate:(NSDate *)date;
@property (nonatomic, retain) id <EveryFrameDelegate> delegate;

@end
