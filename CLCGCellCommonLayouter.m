// Copyright (c) 2012, Ettore Pasquini
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
//  Created by Ettore Pasquini on 5/1/13.
//

#import <QuartzCore/QuartzCore.h>
#import "CLCGCellCommonLayouter.h"
#import "CLCGCell.h"

@implementation CLCGCellCommonLayouter


-(id)initWithCell:(id<CLCGCell>)cell
{
  self = [super init];
  if (self) {
    [self setCell:cell];
  }
  return self;
}


-(void)updateBackgroundColor
{
  // Note: setting the background color on the contentView or even all the
  // subviews doesn't take care of changing the background of the accessoryView.
  // Setting the background of the accessoryView doesn't seem to work either.
  UIColor *color = ([_cell emphasized] ? [_cell emphasisColor] : [_cell normalColor]);
  [[_cell backgroundView] setBackgroundColor:color];
}


-(void)hideImage
{
  [[[_cell imageView] layer] setOpacity:0.0];
}


-(void)showImage:(UIImage*)img
{
  [self showImage:img animated:([[_cell imageView] image] == nil)];
}


-(void)showImage:(UIImage*)img animated:(BOOL)animated
{
  CALayer *layer = [[_cell imageView] layer];

  if (animated) {
    [_cell setNeedsDisplay];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [anim setDuration:0.4]; // seconds
    [anim setFromValue:[NSNumber numberWithFloat:0.0]];
    [anim setToValue:[NSNumber numberWithFloat:1.0]];
    [layer addAnimation:anim forKey:@"animateOpacity"];
  }

  [[_cell imageView] setImage:img];
  [layer setOpacity:1.0]; //makes the animation ending value stick
}


-(CGFloat)xRightOfImage
{
  CGRect r = [[_cell imageView] frame];
  return r.origin.x + r.size.width + [_cell innerPadding];
}


@end
