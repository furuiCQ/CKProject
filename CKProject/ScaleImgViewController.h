//
//  ScaleImgViewController.h
//  CKProject
//
//  Created by furui on 16/2/28.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleImgViewController : UIViewController {
    
    
    UIImageView * imageView;
    
    CGFloat lastDistance;
    
    CGFloat imgStartWidth;
    CGFloat imgStartHeight;
    
    
}
@property UIImage* loadImage;
@property int titleHeight;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)UILabel *searchLabel;
@property(strong,nonatomic)UILabel *msgLabel;
@property int bottomHeight;

-(void)reloadImage;
@end

