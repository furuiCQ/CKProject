//
//  YiSlideMenu.h
//  YiSlideMenu
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YiSlideDirection) {
    YiLeftDirection,
    YiRightDirection,
};


@protocol YiSlideMenuDelegate;

@interface YiSlideMenu : UIScrollView{
    id<YiSlideMenuDelegate> slideMenuDelegate;
}
@property id<YiSlideMenuDelegate> slideMenuDelegate;
@property UIView *centerView;
@property UIButton *navLeftBt;
@property UIButton *navRightBt;
@property UILabel *navTitleLabel;
-(void)navLeftBtAction;
-(void)navRightBtAction;
-(void)setUserPhone:(NSString *)_phone;
-(void)setData:(NSDictionary *)dic;
@end



@protocol YiSlideMenuDelegate<NSObject>
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath slide:(YiSlideDirection)slideDirection;
-(void)switchBtn:(BOOL)isSelected;
@end