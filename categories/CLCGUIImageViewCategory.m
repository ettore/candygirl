// Copyright (c) 2011, Ettore Pasquini
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
//
//  Created by Ettore Pasquini on 9/22/11.
//

#import "clcg_macros.h"
#import "clcg_debug.h"

#import "CLCGUIImageViewCategory.h"
#import "CLCGUIViewCategory.h"

@implementation UIImageView (UIImageViewCategory)

// we want to not change the width and in case the contained 
// UIImageView.height > UIImage.height, we want to resize the imageView to the 
// same size of the UIImage. Otherwise do nothing.
-(void)keepWidthTrimHeight:(CGFloat)viewh
{
  CGFloat imgw, imgh, vieww, imgratio, vratio, newvh;
  
  imgw = [[self image] size].width;
  imgh = [[self image] size].height;
  vieww = [self frame].size.width;
  imgratio = imgh / imgw;
  vratio   = viewh / vieww;
  if (vratio > imgratio) {
    newvh = viewh * imgratio / vratio;
    [self setH:newvh];
  }
}

@end






