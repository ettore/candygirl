// Copyright (c) 2012, Ettore Pasquini
// Copyright (c) 2012, Cubelogic
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  Created by Ettore Pasquini on 5/4/11.
//

#import <UIKit/UIKit.h>
#import <Availability.h>

enum CLCGLoadingState {
  CLCG_NOT_LOADED,
  CLCG_LOADING,
  CLCG_LOADED,
  CLCG_OUTDATED,
  CLCG_LOAD_ERROR,
};


/*!
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
-(void)popoverContentSizeDidChange:(CGSize)size;
@end


@interface CLCGVC : UIViewController

//------------------------------------------------------------------------------
#pragma mark - Loading logic

/*!
 Subclasses should set the loading state accordingly, before/during/after
 loading content, depending what loading means in each VC. E.g. it should be 
 set to CLCG_LOADED even if there was no api call being performed.
 */
@property(nonatomic,assign) enum CLCGLoadingState loadState;

/*!
 @discussion Subclasses should override this method and initiate here any
 asynchronous server side call. The default implementation does nothing.
 */
-(void)loadFromServerIfNeeded;


/*! Forces a reload from the server. */
-(void)reload;

//------------------------------------------------------------------------------
#pragma mark - Loading view / Spinner

@property(nonatomic,strong) IBOutlet UIView *spinnerContainer;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic) UIActivityIndicatorViewStyle  spinnerStyle;
@property(nonatomic,strong) UIColor *spinnerBackgroundColor;
@property(nonatomic,strong) IBOutlet UILabel *spinnerLabel1;
@property(nonatomic,strong) IBOutlet UILabel *spinnerLabel2;

/*!
 * If show == YES, shows and aligns the spinny indicator to the center
 * of the screen.
 * If show == NO, removes the spinny indicator if it was displayed, or do
 * nothing otherwise.
 */
-(void)showLoadingView:(BOOL)show;

//------------------------------------------------------------------------------
#pragma mark - Displaying empty or error states

/*!
 The container that contains the empty or error messages, as well as the 
 Tap to Reload label in the latter case. This view spans the whole screen.
 */
@property(nonatomic,strong) IBOutlet UIView *emptyContainer;

/*!
 Label that displays the message for empty case (no data or error).
 */
@property(nonatomic,strong) IBOutlet UILabel *emptyLabel;

/*!
 * If msg is non-nil, this method shows and aligns the given message to the
 * center of the screen. Otherwise, it removes the message if it was displayed.
 */
-(void)showEmptyMessage:(NSString*)msg;

/*!
 * If msg is non-nil, this method shows and aligns the given message to the
 * center of the screen. Otherwise, it removes the message if it was displayed.
 * It also displays a Tap to Reload label.
 */
-(void)showErrorMessage:(NSString*)msg;

/*!
 This method creates the view to render the message for no data/error case.
 */
-(void)createEmptyView;

/*!
 Aligns the empty label to the center of the emptyContainer.
 */
-(void)centerEmptyView;

//------------------------------------------------------------------------------
#pragma mark - Misc

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000

@property(nonatomic,weak) id<CLCGPopoverContentDelegate> popoverContentDelegate;

#endif

/*!
 * Releases all the retained subviews of this view controller. This is called
 * by dealloc and viewDidUnload.
 * Subclasses should override this method and release their subviews here.
 */
-(void)releaseRetainedSubviews;


@end

