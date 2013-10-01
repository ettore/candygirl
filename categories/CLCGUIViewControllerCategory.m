//
//  CLCGUIViewControllerCategory.m
//  Goodreads
//  Created by Ettore Pasquini on 1/23/13.
//

#import "clcg_device_utils.h"
#import "CLCGUIViewControllerCategory.h"


@implementation UIViewController (Candygirl)


- (CGFloat)viewTopOffset
{
  CGFloat top = 0.0f;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    top = [[self topLayoutGuide] length];
  }
  return top;
}


- (CGFloat)viewBottomOffset
{
  CGFloat bottom = 0.0f;
  if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
    bottom = [[self bottomLayoutGuide] length];
  }
  return bottom;
}


-(void)presentVC:(UIViewController*)vc
{
  // check if project deployment target is iOS 4.x
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
  if (clcg_os_geq(@"5.0")) {
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    [self presentModalViewController:vc animated:YES];
  }
#else
  [self presentViewController:vc animated:YES completion:nil];
#endif
}


-(void)dismissVC
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
  if (clcg_os_geq(@"5.0")) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    [self dismissModalViewControllerAnimated:YES];
  }
#else
  [self dismissViewControllerAnimated:YES completion:nil];
#endif
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
