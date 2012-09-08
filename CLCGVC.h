//
//  CLCGVC.h
//  PostalChess
//
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * If your CLCGVC view controller is presented as content inside of a 
 * UIPopoverController, and you want to be notified when the user 
 * performs an action inside your content view controller (such as hitting a 
 * button that should close the popover programmatically), then you can use
 * this delegate to let (e.g.) the parent object that opened the popover
 * know that it is now time to dismiss it. This is because when you close 
 * a popover programmatically (UIPopoverController::dismissPopoverAnimated:)
 * the UIPopoverControllerDelegate::popoverControllerDidDismissPopover: 
 * method is not called.
 *
 * TODO: perhaps it'd be cleaner to extend UIPopoverController and have a new
 * method to UIPopoverControllerDelegate. (It might be dangerous to change the
 * behavior of UIPopoverController::dismissPopoverAnimated: and call 
 * popoverControllerDidDismissPopover: on the delegate.)
 */
@protocol CLCGPopoverContentDelegate
-(void)didInvokeDismissAction:(UIViewController*)vc_in_popover;
@end


@interface CLCGVC : UIViewController
{
  UIView                        *mSpinnerContainer;
  UIActivityIndicatorView       *mSpinner;
  UIActivityIndicatorViewStyle  mSpinnerStyle;
  UIColor                       *mSpinnerBackgroundColor;
  id<CLCGPopoverContentDelegate> mPopoverContentDelegate;
}

@property(nonatomic,retain) IBOutlet UIView *spinnerContainer;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic) UIActivityIndicatorViewStyle  spinnerStyle;
@property(nonatomic,retain) UIColor *spinnerBackgroundColor;
@property(nonatomic,assign) id<CLCGPopoverContentDelegate> popoverContentDelegate;

/** 
 * If show == YES, shows and aligns the spinny indicator to the center 
 * of the screen. 
 * If show == NO, removes the spinny indicator if it was displayed, or do 
 * nothing otherwise.
 */
-(void)showLoadingView:(BOOL)show;

/** 
 * Helper method that returns the height of the nav bar of the navigation
 * controller hosting this view controller. If no navigation controller is
 * present, it will return 0.
 */
-(CGFloat)navBarH;

@end
