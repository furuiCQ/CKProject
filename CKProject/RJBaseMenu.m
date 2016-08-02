//
//  RJBaseMenu.m
//  RJInvestor
//
//  Created by furui on 15/1/14.
//
//
#import "RJBaseMenu.h"
#import <QuartzCore/QuartzCore.h>
#include <sys/sysctl.h>

@implementation SGButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end


@implementation RJBaseMenu
@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = SGActionViewStyleLight;
        self.roundedCorner = [self nicePerformance];
    }
    return self;
}
//设置圆角
- (void)setRoundedCorner:(BOOL)roundedCorner
{
    if (roundedCorner) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }else{
        self.layer.mask = nil;
    }
    _roundedCorner = roundedCorner;
    [self setNeedsDisplay];
}

- (BOOL)nicePerformance{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    BOOL b = YES;
    if ([machine hasPrefix:@"iPhone"]) {
        b = [[machine substringWithRange:NSMakeRange(6, 1)] intValue] >= 4;
    }else if ([machine hasPrefix:@"iPod"]){
        b = [[machine substringWithRange:NSMakeRange(4, 1)] intValue] >= 5;
    }else if ([machine hasPrefix:@"iPad"]){
        b = [[machine substringWithRange:NSMakeRange(4, 1)] intValue] >= 2;
    }
    
    return b;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
