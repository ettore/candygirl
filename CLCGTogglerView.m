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
//  Created by Ettore Pasquini on 9/29/12.
//


#import "CLCGTogglerView.h"
#import "clcg_gfx.h"


@implementation CLCGTogglerView


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UIViewAutoresizing same_sz_mask;
    
    // config self
    same_sz_mask = UIViewAutoresizingFlexibleHeight;
    _togglerState = CLCGTogglerFirstView;
    [self setAutoresizingMask:same_sz_mask];
    [self setAutoresizesSubviews:YES];
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  
  return self;
}


//------------------------------------------------------------------------------
#pragma mark - Accessors


-(void)setFirstView:(UIView*)view
{
  if (view != _firstView) {
    clcg_safe_remove_from_superview(_firstView);
    [self configAndAddView:view];
    _firstView = view;
  }
}


-(void)setSecondView:(UIView *)view
{
  if (view != _secondView) {
    clcg_safe_remove_from_superview(_secondView);
    [self configAndAddView:view];
    _secondView = view;
  }
}


-(void)configAndAddView:(UIView*)view
{
  UIViewAutoresizing same_sz_mask;

  same_sz_mask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [view setAutoresizingMask:same_sz_mask];
  [view setBackgroundColor:[UIColor clearColor]];
  [view setOpaque:YES];

  // set frame of subview to match self
  CGRect r = [self frame];
  [view setFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
  
  [self addSubview:view];
}


//------------------------------------------------------------------------------
#pragma mark - Layout


-(void)setTogglerState:(CLCGTogglerState)state
{
  if (state != _togglerState) {
    if (CLCGTogglerFirstView == state) {
      [_firstView setHidden:NO];
      [_secondView setHidden:YES];
      [_firstView setAlpha:1.0];
      [_secondView setAlpha:0.0];
    } else if (CLCGTogglerSecondView == state) {
      [_firstView setHidden:YES];
      [_secondView setHidden:NO];
      [_firstView setAlpha:0.0];
      [_secondView setAlpha:1.0];
    } else {
      CLCG_ASSERT(NO);
    }
    
    _togglerState = state;
    
    [self setNeedsDisplay];
  }
}


@end

