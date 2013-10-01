//
//  CLCGUIViewControllerCategory.h
//  Created by Ettore Pasquini on 1/23/13.
//

@interface UIViewController (Candygirl)

/*!
 Returns the top offset for the view in case you don't want content to appear 
 behind a translucent or transparent UIKit bar. This method accounts for both
 status and navigation bar.
 */
- (CGFloat)viewTopOffset;

/*!
 Returns the bottom offset for the view in case you don't want content to appear
 behind a translucent or transparent UIKit bar. This method accounts for 
 tab-bars and toolbars.
 */
- (CGFloat)viewBottomOffset;

/*!
 Let the receiver view controller present another view controller modally 
 with animation and no completion handler.
 Handles presentModalViewController:animated: deprecation.
 */
-(void)presentVC:(UIViewController*)vc;

/*!
 Dismisses the view controller that was presented modally by this view 
 controller, with default animation and no completion handler.
 Handles dismissModalViewController:animated: deprecation.
 */
-(void)dismissVC;

/*!
 @return true if the view controller view is visible.
 */
-(BOOL)isVisible;

@end
