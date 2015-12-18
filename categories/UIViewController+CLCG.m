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

#import "clcg_device_utils.h"
#import "UIView+CLCG.h"
#import "UIViewController+CLCG.h"


@implementation UIViewController (Candygirl)


-(CGFloat)clcg_viewTopOffset
{
  CGFloat top = 0.0f;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    top = [[self topLayoutGuide] length];
  }
  return top;
}


-(CGFloat)clcg_viewBottomOffset
{
  CGFloat bottom = 0.0f;
  if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
    bottom = [[self bottomLayoutGuide] length];
  }
  return bottom;
}


-(CGFloat)clcg_navBarH
{
  UINavigationBar *nb = [[self navigationController] navigationBar];
  return (nb ? [nb clcg_h] : 0.0f);
}


-(CGFloat)clcg_tabBarH
{
  UITabBar *tb = [[self tabBarController] tabBar];
  return (tb ? [tb clcg_h] : 0.0f);
}


-(void)clcg_presentVC:(UIViewController*)vc
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


-(void)clcg_dismissVC
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


-(BOOL)clcg_isVisible
{
  // The view's window property is non-nil if a view is currently visible
  // and nil if it has not been added to a window (and therefore can't be
  // visible).
  // To avoid loading the view inadvertently ([self view] does that if view's
  // not loaded) we also check for isViewLoaded.
  return [self isViewLoaded] && [[self view] window];
}

@end
