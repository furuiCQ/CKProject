//
//  ViewController.h
//  XMTopScrollView
//
//  Created by rgshio on 15/12/21.
//  Copyright © 2015年 rgshio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMTopScrollView.h"
#import "BaseViewController.h"
@interface ViewController : BaseViewController <XMTopScrollViewDelegate> {
    XMTopScrollView                     *_topView;
    
    NSMutableArray                      *_titleArray;
}

-(void)showBack;
@end

