/*
 Copyright (c) 2011, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.

  Created by Ettore Pasquini on 10/19/11.

 */

#import <QuartzCore/QuartzCore.h>
#import "clcg_gfx.h"


void clcg_safe_remove_from_superview(id view)
{
  if (view && [view isKindOfClass:[UIView class]] && [view superview]) {
    [view removeFromSuperview];
  }
}


//TODO-XX make font name and height parameters
UIImage *clcg_do_snapshot(UIView *v, NSString *title)
{
  // make space for the title below the view
  const CGFloat TITLEH = 80.0;
  CGSize sz = v.frame.size;
  sz.height += TITLEH;
  
  // add a label with the title to the view (below it)
  CGRect titlerect = CGRectMake(4, v.frame.size.height+1, sz.width-4, TITLEH-1);
  UILabel *l = [[UILabel alloc] initWithFrame:titlerect];
  [l setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
  [l setNumberOfLines:0];
  [l setTextAlignment:NSTextAlignmentCenter];
  [l setLineBreakMode:NSLineBreakByWordWrapping];
  [l setText:title];
  [l setBackgroundColor:[UIColor clearColor]];
  [v addSubview:l];
  [l setNeedsLayout];
  [l setNeedsDisplay];
  
  // take snapshot
  UIGraphicsBeginImageContext(sz);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [v.layer renderInContext:ctx];
  UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // cleanup
  [l removeFromSuperview];

  return snapshot;
}


void clcg_pushing_vc_for_hiding(UINavigationController *nc, 
                                UIViewController *vc, 
                                clcg_should_hide_vc_f shouldhide_callback)
{
  BOOL is_vc_for_hiding = shouldhide_callback(vc);
  
  vc.hidesBottomBarWhenPushed = is_vc_for_hiding;
  
  // controller currently displayed, about to be be superseded
  UIViewController *curr = [nc topViewController];
  if (!is_vc_for_hiding)
    curr.hidesBottomBarWhenPushed = NO;
}


void clcg_popping_vc_from_hiding(UINavigationController *nc,
                                 clcg_should_hide_vc_f shouldhide_callback)
{
  // this is the controller about to be removed
  //UIViewController *curr = [nc topViewController];
  
  NSArray *vcs = [nc viewControllers];
  NSUInteger cnt = [vcs count];
  if (cnt >= 2) {
    UIViewController *prev = [vcs objectAtIndex:cnt-2];
    if (shouldhide_callback(prev)) {
      prev.hidesBottomBarWhenPushed = YES;
    }
  }
  
  // now this would be the controller about to be displayed
  //  curr = [nc topViewController];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#pragma mark - Spinny

UIActivityIndicatorView *clcg_new_spinny(CGFloat size)
{
  CGRect f;
  UIActivityIndicatorView *spinny;
  
  f = CGRectMake(0.0, 0.0, size, size);
  spinny = [[UIActivityIndicatorView alloc] initWithFrame:f];
  [spinny startAnimating];
  [spinny setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [spinny sizeToFit];
  [spinny setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin |
                               UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleTopMargin |
                               UIViewAutoresizingFlexibleBottomMargin)];
  return spinny;
}


void clcg_attach_spinny2cell(CGFloat size, UITableViewCell *cell)
{
  UIActivityIndicatorView *spinny;
  
  spinny = clcg_new_spinny(size);
  [cell setAccessoryView:spinny];
}

