//
//  CLCGUIViewControllerCategory.h
//  Created by Ettore Pasquini on 1/23/13.
//

@interface UIViewController (Candygirl)

/*!
 Present view controller modally with animation and no completion handler.
 Handles deprecation of presentModalViewController:animated: deprecation.
 */
-(void)presentVC:(UIViewController*)vc;

/*!
 @return true if the view controller view is visible.
 */
-(BOOL)isVisible;

@end
