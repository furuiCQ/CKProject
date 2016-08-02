//
//  CustomPopView.m
//  CKProject
//
//  Created by furui on 16/4/16.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "CustomPopView.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/QuartzCore.h>


@interface CustomPopView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;
// 点击背景取消
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation CustomPopView:UIView
//初始化整个布局
+ (CustomPopView *)sharedActionView
{
    static CustomPopView *actionView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        actionView = [[CustomPopView alloc] initWithFrame:rect];
    });
    
    
    
    return actionView;
}
//初始化布局并绑定点击事件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _menus = [NSMutableArray array];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];//添加点击监听
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    return self;
}
- (void)applicationWillResignActive:(NSNotification *)notification

{
    UIView *subview = self.menus.lastObject;
    [[CustomPopView sharedActionView] dismissMenu:subview Animated:YES];
    [self.menus removeObject:subview];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}
- (void)dealloc{
    [self removeGestureRecognizer:_tapGesture];
}
//获取点击位置，如果不在菜单内，就关闭菜单
- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
    
    UIView *subview = self.menus.lastObject;
    
    if (!CGRectContainsPoint(subview.frame, touchPoint)) {
        [[CustomPopView sharedActionView] dismissMenu:subview Animated:YES];
        [self.menus removeObject:subview];
    }
    //    }
}
//点击监听事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isEqual:self.tapGesture]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        UIView *subview = self.menus.lastObject;
        if (CGRectContainsPoint(subview.frame, p)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -
//设置菜单参数并展示动画
- (void)setMenu:(UIView *)subView animation:(BOOL)animated{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    //  RJBaseMenu *topMenu = (RJBaseMenu *)menu;
    
    [self.menus makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menus addObject:subView];
    
    //    topMenu.style = self.style;
    [self addSubview:subView];
    //   [topMenu layoutIfNeeded];
    subView.frame = (CGRect){CGPointMake(0, self.bounds.size.height - subView.bounds.size.height), subView.bounds.size};
    
    if (animated && self.menus.count == 1) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
        [subView.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
}
+(void)disMiss:(UIView *)subview{
    [[CustomPopView sharedActionView] dismissMenu:subview Animated:YES];

}
//关闭菜单
- (void)dismissMenu:(UIView *)subview Animated:(BOOL)animated
{
    if ([self superview]) {
        [self.menus removeObject:subview];
        if (animated && self.menus.count == 0) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.2];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^{
                [self removeFromSuperview];
                [subview removeFromSuperview];
            }];
            [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
            [subview.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
            [CATransaction commit];
        }else{
            [subview removeFromSuperview];
            
            UIView *view = self.menus.lastObject;
            //topMenu.style = self.style;
            [self addSubview:view];
            //[topMenu layoutIfNeeded];
            view.frame = (CGRect){CGPointMake(0, self.bounds.size.height - view.bounds.size.height), view.bounds.size};
        }
    }
}

#pragma mark -
//模糊动画
- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}
//高亮动画
- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}
//弹出动画
- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:50.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}
//消失动画
- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:50.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}
+(void)addViewAndShow:(UIView *)view{
    [[CustomPopView sharedActionView] setMenu:view animation:YES];
    
}

+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
                    shareJson:(NSDictionary*)shareJson
               selectedHandle:(SGMenuActionHandler)handler{
    //    RJGirdMenu *menu = [[RJGirdMenu alloc] initWithTitle:title
    //                                              itemTitles:itemTitles
    //                                                  images:images
    //                                               shareJson:shareJson];
    //    [menu triggerSelectedAction:^(NSInteger index){
    //        [[CustomPopView sharedActionView] dismissMenu:menu Animated:YES];
    //        if (handler) {
    //            handler(index);
    //        }
    //    }];
}

@end
