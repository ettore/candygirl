//
//  CLCGUIViewControllerCategory.m
//  Goodreads
//  Created by Ettore Pasquini on 1/23/13.
//

#import "clcg_device_utils.h"
#import "CLCGUIViewControllerCategory.h"


@implementation UIViewController (Candygirl)


-(void)presentVC:(UIViewController*)vc
{
  if (clcg_os_geq(@"5.0")) {
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    [self presentModalViewController:vc animated:YES];
  }
}


-(void)dismissVC
{
  if (clcg_os_geq(@"5.0")) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    [self dismissModalViewControllerAnimated:YES];
  }
}


-(BOOL)isVisible
{
  // The view's window property is non-nil if a view is currently visible
  // and nil if it has not been added to a window (and therefore can't be
  // visible).
  // To avoid loading the view inadvertently ([self view] does that if view's
  // not loaded) we also check for isViewLoaded.
  return [self isViewLoaded] && [[self view] window];
}

@end
