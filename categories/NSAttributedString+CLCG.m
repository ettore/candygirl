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
//  Created by Pasquini, Ettore on 6/2/14.
//

#import <tgmath.h>
#import "NSAttributedString+CLCG.h"

@implementation NSAttributedString (CLCG)


-(CGSize)sizeWithMaxW:(CGFloat)max_w
{
  return [self sizeWithMaxW:max_w maxH:CGFLOAT_MAX];
}


-(CGSize)sizeWithMaxW:(CGFloat)max_w maxH:(CGFloat)max_h
{
  if (max_h == 0.0f) {
    max_h = CGFLOAT_MAX;
  }

  NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin
                                    |NSStringDrawingTruncatesLastVisibleLine
                                    |NSStringDrawingUsesFontLeading);

  CGSize size = [self boundingRectWithSize:CGSizeMake(max_w, max_h)
                                   options:options
                                   context:nil].size;
  return (CGSize){
    .height = ceil(size.height),
    .width = ceil(size.width)
  };
}

@end
