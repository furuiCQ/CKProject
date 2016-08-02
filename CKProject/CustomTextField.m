//
//  CustomTextField.m
//  CKProject
//
//  Created by furui on 15/12/16.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "CustomTextField.h"
@interface CustomTextField()

@end

@implementation CustomTextField

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        
        self.clipsToBounds = YES;
        [self setRightViewMode:UITextFieldViewModeAlways];
        
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_logn"]];
    }
    
    return self;
}
- (CGRect) rightViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 6;
    return textRect;
}

@end