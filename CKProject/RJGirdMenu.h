//
//  RJGirdMenu.h
//  RJInvestor
//
//  Created by furui on 15/1/14.
//
//

#import <UIKit/UIKit.h>
#import "RJBaseMenu.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface RJGirdMenu : RJBaseMenu{
    NSDictionary* popJson;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images shareJson:(NSDictionary*)shareJson;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
