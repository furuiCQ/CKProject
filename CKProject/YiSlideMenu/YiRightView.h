//
//  YiRightView.h
//  YiSlideMenu
//
//  Created by coderyi on 15/3/8.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YiRightViewDelegate;
@interface YiRightView : UIView{
    id<YiRightViewDelegate> delegate;
    UIImageView *userImageView;
}
@property id<YiRightViewDelegate> delegate;
-(void)setUserPhone:(NSString *)_phone;
-(void)setData:(NSDictionary *)dic;
-(void)setImage:(UIImage *)imageUrl;
-(void)setUserName:(NSString *)name;

@end
@protocol YiRightViewDelegate<NSObject>
- (void)rightDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)switchBtn:(BOOL)isSelected;
-(void)selectImage;
-(void)selectUserName;
@end

