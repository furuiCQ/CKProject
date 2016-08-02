//
//  CustomAlertview.h

//  CKProject
//
//  Created by furui on 15/12/20.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** A view with a UIActivityIndicator and "Loading..." title. */
    FVAlertTypeLoading,
    /** A view with a checkmark and "Done" title. */
    FVAlertTypeDone,
    /** A view with a cross and "Error" title. */
    FVAlertTypeError,
    /** A view with an exclamation point and "Warning" title. */
    FVAlertTypeWarning,
    /** A view with a background shadow. */
    FVAlertTypeCustom,
} FVAlertType;

/**
 * Displays a custom alert view. It can contain either a title or a custom UIView
 * The view is customisable and has 4 default modes:
 * - FVAlertTypeLoading - displays a UIActivityIndicator
 * - FVAlertTypeDone/Error/Warning - displays a checkmark/cross/exclamation point
 * - FVAlertTypeCustom - lets the user to customise the view
 */

@interface FVCustomAlertView : UIView

/**
 * Getter to the current FVCustomAlertView displayed
 * If no alert view is displayed on the screen, the result will be nil.
 * @return the current FVCustomAlertView
 */
+ (UIView *)currentView;

/**
 * Creates a new view and adds it to the view. Use hideAlertFromView to hide it.
 * Adds the view on top of all of the views.
 * Can't create more than one view at a time.
 * @param view The view that the alertView will be added to
 * @param title The title shown on the top of the alert view
 * @param titleColor The title text color
 * @param width The width of the view
 * @param height The height of the view
 * @param backgroundImage If set, will set the background as a tiled image. Background color will be unavalible.
 * @param blur If set, tbe background will have a blur effect
 * @param backgroundColor Color of the background. Used if the image is not set.
 * @param cornerRadius The radius of the rounded corners
 * @param shadowAlpha The background shadow opacity
 * @param alpha The opacity of the alert view
 * @param contentView The content of the view. Can be nil and choose a special type. Can be filled with a UIView or other derived classes.
 * @param type
 * @param tap Allow the user to tap to dismiss
 */
+ (void)showAlertOnView:(UIView *)view
              withTitle:(NSString *)title
             titleColor:(UIColor *)titleColor
                  width:(CGFloat)width
                 height:(CGFloat)height
                   blur:(BOOL)blur
        backgroundImage:(UIImage *)backgroundImage
        backgroundColor:(UIColor *)backgroundColor
           cornerRadius:(CGFloat)cornerRadius
            shadowAlpha:(CGFloat)shadowAlpha
                  alpha:(CGFloat)alpha
            contentView:(UIView *)contentView
                   type:(FVAlertType)type
               allowTap:(BOOL)tap;

/**
 * Creates a default loading view
 * with the activity indicator from pictures 1.png 2.png...20.png
 * @param view The view that the alertView will be added to
 * @param title The title shown on the top of the alert view
 * @param blur If set, tbe background will have a blur effect
 * @param tap Allow the user to tap to dismiss
 */
+ (void)showDefaultLoadingAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap;

/**
 * Creates a default done view
 * with a checkmark and a title
 * @param view The view that the alertView will be added to
 * @param title The title shown on the top of the alert view
 * @param blur If set, tbe background will have a blur effect
 * @param tap Allow the user to tap to dismiss
 */
+ (void)showDefaultDoneAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap;

/**
 * Creates a default done view
 * with a cross (X) and a title
 * @param view The view that the alertView will be added to
 * @param title The title shown on the top of the alert view
 * @param blur If set, tbe background will have a blur effect
 * @param tap Allow the user to tap to dismiss
 */
+ (void)showDefaultErrorAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap;

/**
 * Creates a default done view
 * with an exclamation point (!) and a title
 * @param view The view that the alertView will be added to
 * @param title The title shown on the top of the alert view
 * @param blur If set, tbe background will have a blur effect
 * @param tap Allow the user to tap to dismiss
 */
+ (void)showDefaultWarningAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap;

/**
 * Hides the active view on the specified view.
 * @param view The view that the alertView is already added to
 * @param fading If set to YES, an animation will perform the hiding of the view as a fading effect.
 */
+ (void)hideAlertFromView:(UIView *)view fading:(BOOL)fading;

@end