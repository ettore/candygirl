// Copyright (c) 2011, Ettore Pasquini
// Copyright (c) 2011, Cubelogic
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

#import "clcg_debug.h"
#import "clcg_viewport.h"
#import "clcg_device_utils.h"


#ifndef CLCG_APP_EXTENSIONS
CGFloat clcg_statusbar_h()
{
  const CGSize sz = [[UIApplication sharedApplication] statusBarFrame].size;

  if (clcg_os_geq(@"8.0")) {
    return sz.height;
  } else {
    const UIInterfaceOrientation orient = clcg_orientation();
    if (UIInterfaceOrientationIsPortrait(orient)) {
      return sz.height;
    } else {
      return sz.width;
    }
  }
}


UIInterfaceOrientation clcg_orientation()
{
  return [[UIApplication sharedApplication] statusBarOrientation];
}


CGSize clcg_screensize()
{
  CGRect bounds = [[UIScreen mainScreen] bounds];

  if (! clcg_os_geq(@"8.0")) {
    const UIInterfaceOrientation orientation = clcg_orientation();
    if (UIInterfaceOrientationIsLandscape(orientation)) {
      CGFloat w = bounds.size.width;
      bounds.size.width = bounds.size.height;
      bounds.size.height = w;
    }
  }

  return bounds.size;
}
#endif
