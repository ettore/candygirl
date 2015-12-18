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
//  Created by Pasquini, Ettore on 11/7/13.
//


#import "UIColor+CLCG.h"


@implementation UIColor (Candygirl)


-(UIColor*)clcg_lighterColor
{
  CGFloat h, s, b, a;

  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:MIN(b * 1.3, 1.0)
                           alpha:a];
  }

  return nil;
}


-(UIColor*)clcg_darkerColor
{
  CGFloat h, s, b, a;

  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:b * 0.75
                           alpha:a];
  }

  return nil;
}

@end
