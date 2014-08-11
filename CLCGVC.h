//
//  CLCGVC.h
//  PostalChess
//
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>


enum CLCGLoadingState {
  CLCG_NOT_LOADED,
  CLCG_LOADING,
  CLCG_LOADED,
  CLCG_OUTDATED,
  CLCG_LOAD_ERROR,
};


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

/*!
 Subclasses should set the loading state accordingly, before/during/after
 loading content, depending what loading means in each VC. E.g. it should be 
 set to CLCG_LOADED even if there was no api call being performed.
 */
@property(nonatomic,assign) enum CLCGLoadingState loadState;

@property(nonatomic,retain) IBOutlet UIView *spinnerContainer;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic) UIActivityIndicatorViewStyle  spinnerStyle;
@property(nonatomic,retain) UIColor *spinnerBackgroundColor;
@property(nonatomic,retain) IBOutlet UIView *emptyContainer;
@property(nonatomic,retain) IBOutlet UILabel *emptyLabel;
@property(nonatomic,weak) id<CLCGPopoverContentDelegate> popoverContentDelegate;


/**
 * If msg is non-nil, this method shows and aligns the given message to the
 * center of the screen. Otherwise, it removes the message if it was displayed.
 */
-(void)showEmptyMessage:(NSString*)msg;


/**
 * If show == YES, shows and aligns the spinny indicator to the center 
 * of the screen. 
 * If show == NO, removes the spinny indicator if it was displayed, or do 
 * nothing otherwise.
 */
-(void)showLoadingView:(BOOL)show;

/*!
 @discussion Subclasses should override this method and initiate here any
 asynchronous server side call. The default implementation does nothing.
 */
-(void)loadFromServerIfNeeded;


/*! Forces a reload from the server. */
-(void)reload;


/**
 * Releases all the retained subviews of this view controller. This is called
 * by dealloc and viewDidUnload.
 * Subclasses should override this method and release their subviews here.
 */
-(void)releaseRetainedSubviews;


@end

