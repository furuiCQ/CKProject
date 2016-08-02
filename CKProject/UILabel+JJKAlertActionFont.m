//
//  UILabel+JJKAlertActionFont.m
//  CKProject
//
//  Created by furui on 15/12/26.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "UILabel+JJKAlertActionFont.h"
@implementation UILabel (JJKAlertActionFont)
- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}
@end