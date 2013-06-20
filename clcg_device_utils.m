// Copyright (c) 2011, Goodreads
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


#import <UIKit/UIKit.h>
#import "clcg_device_utils.h"


BOOL clcg_os_geq(NSString* version)
{
  NSString *sys_vers = [[UIDevice currentDevice] systemVersion];
  if (sys_vers == nil)
    return NO;
  
  // another way to do it would be to convert to float, however (e.g.)
  // 4.3.2 becomes something like 4.3000099
  
  NSComparisonResult r = [sys_vers compare:version options:NSNumericSearch];
  return (r != NSOrderedAscending);
}


BOOL clcg_is_iphone5(void)
{
  CGSize sz = [[UIScreen mainScreen] bounds].size;
  return (!clcg_is_ipad() && sz.height > 480.0f);
}


BOOL clcg_is_ipad(void)
{
  if (clcg_os_geq(@"3.2"))
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
  else
    return NO;
}


void clcg_removepref(NSString *key)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  [defs removeObjectForKey:key];
  [defs synchronize];
}


/** 
 * The value will be added to the array pref identified by `key'
 */
void clcg_savepref_in_array(NSString *key, NSString *value)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  NSArray *current = [defs arrayForKey:key];
  NSMutableArray *newarr;
  if (current == nil)
    newarr = [NSMutableArray arrayWithCapacity:1];
  else 
    newarr = [NSMutableArray arrayWithArray:current];
  
  [newarr addObject:value];
  [defs setObject:newarr forKey:key];
  [defs synchronize];
}


void clcg_savepref(NSString *key, id<NSCoding> value)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  [defs setObject:value forKey:key];
  [defs synchronize];
}


void clcg_savepref_bool(NSString *key, BOOL value)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  [defs setBool:value forKey:key];
  [defs synchronize];
}


BOOL clcg_getpref_bool(NSString *key)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  return [defs boolForKey:key];
}


NSString *clcg_getpref_str(NSString *key)
{
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  return [defs stringForKey:key];
}


NSString *clcg_device_resolution(void)
{
  CGFloat scale;
  NSString *res;
  UIScreen *screen = [UIScreen mainScreen];
  CGRect rect = [screen bounds];
  
  scale = ([screen respondsToSelector:@selector(scale)] ? [screen scale] : 1.0);
  res = [NSString stringWithFormat:@"%.0f %.0f %.1f", 
         rect.size.width, rect.size.height, scale];

  return res;
}


BOOL clcg_has_camera(void)
{
  return [UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera];
}


BOOL clcg_has_retina(void)
{
  UIScreen *screen = [UIScreen mainScreen];
  
  // the problem here is that UIScreen::scale returns 2 also on iPad 3.2 working
  // at 2x magnification, so UIScreen::scale alone can't be used to determine if 
  // the display is Retina. Apple fixed UIScreen::scale on iPad 4.2, always 
  // returning 1 in both 1x and 2x modes. So we also check for 
  // displayLinkWithTarget:selector: which only exists on iOS 4.
  // Note: iOS 4.0 - 4.1 were never released for the iPad, so no need to worry 
  // about those cases.
  return ([screen respondsToSelector:@selector(displayLinkWithTarget:selector:)] 
          && [screen scale] == 2.0);
}
