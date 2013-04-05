//
//  CLCGUIViewControllerCategory.h
//  Created by Ettore Pasquini on 1/23/13.
//

@interface UIViewController (Candygirl)

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
