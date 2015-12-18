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
//  Created by Ettore Pasquini on 1/23/13.
//

@interface UIViewController (Candygirl)

/*!
 Returns the top offset for the view in case you don't want content to appear
 behind a translucent or transparent UIKit bar. This method accounts for both
 status and navigation bar.
 */
- (CGFloat)clcg_viewTopOffset;

/*!
 Returns the bottom offset for the view in case you don't want content to appear
 behind a translucent or transparent UIKit bar. This method accounts for
 tab-bars and toolbars.
 */
- (CGFloat)clcg_viewBottomOffset;


/**
 * Helper method that returns the height of the nav bar of the navigation
 * controller hosting this view controller. If no navigation controller is
 * present, it will return 0.
 */
-(CGFloat)clcg_navBarH;


/**
 * Helper method that returns the height of the tab bar that includes the view
 * of this view controller as a subview. If no tab bar is present,
 * it will return 0.
 */
-(CGFloat)clcg_tabBarH;


/*!
 Let the receiver view controller present another view controller modally
 with animation and no completion handler.
 Handles presentModalViewController:animated: deprecation.
 */
-(void)clcg_presentVC:(UIViewController*)vc;

/*!
 Dismisses the view controller that was presented modally by this view
 controller, with default animation and no completion handler.
 Handles dismissModalViewController:animated: deprecation.
 */
-(void)clcg_dismissVC;

/*!
 @return true if the view controller view is visible.
 */
-(BOOL)clcg_isVisible;

@end
