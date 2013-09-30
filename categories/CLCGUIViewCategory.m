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
//  Created by ep on 1/8/12.
//


#import "CLCGUIViewCategory.h"


@implementation UIView (Candygirl)


-(void)centerVertically
{
  [self centerVerticallyWithOffset:0];
}


-(void)centerVerticallyWithOffset:(CGFloat)offset
{
  CGSize sz;
  CGFloat y;
  
  sz = [[self superview] frame].size;
  y = (sz.height - [self h])/2 + offset;
  [self setY:y];
}


-(void)centerHorizontally
{
  [self centerHorizontallyWithOffset:0];
}


-(void)centerHorizontallyWithOffset:(CGFloat)offset
{
  CGSize sz;
  CGFloat x;

  sz = [[self superview] frame].size;
  x = (sz.width - [self w])/2 + offset;
  [self setX:x];
}


-(void)centerHorizontallyInRect:(CGRect)rect
{
  CGFloat x = (rect.size.width - [self w])/2;
  [self setX:(rect.origin.x + x)];
}


-(void)resizeHeightForText:(NSString*)txt font:(UIFont*)font
{
  CGSize sz;

  sz = CGSizeMake([self w], INT_MAX);
  sz = [txt sizeWithFont:font constrainedToSize:sz];

  [self setH:sz.height];
}


-(CGFloat)x
{
  return [self frame].origin.x;
}


-(void)setX:(CGFloat)x
{
  CGRect r = [self frame];
  r.origin.x = x;
  [self setFrame:r];
}


-(CGFloat)y
{
  return [self frame].origin.y;
}


-(void)setY:(CGFloat)y
{
  CGRect r = [self frame];
  r.origin.y = y;
  [self setFrame:r];
}


-(CGFloat)w
{
  return [self frame].size.width;
}


-(void)setW:(CGFloat)w
{
  CGRect r = [self frame];
  r.size.width = w;
  [self setFrame:r];
}


-(CGFloat)h
{
  return [self frame].size.height;
}


-(void)setH:(CGFloat)h
{
  CGRect r = [self frame];
  r.size.height = h;
  [self setFrame:r];
}


-(CGFloat)r
{
  CGRect r = [self frame];
  return r.origin.x + r.size.width;
}


-(CGFloat)low
{
  CGRect r = [self frame];
  return r.origin.y + r.size.height;
}


- (CGSize)sz
{
  return [self frame].size;
}


- (void)setSz:(CGSize)size
{
  CGRect frame = [self frame];
  frame.size = size;
  [self setFrame:frame];
}


- (CGPoint)origin {
  return [self frame].origin;
}


- (void)setOrigin:(CGPoint)origin {
  CGRect frame = [self frame];
  frame.origin = origin;
  [self setFrame:frame];
}


- (CGFloat)centerX {
  return [self center].x;
}


- (void)setCenterX:(CGFloat)centerX {
  [self setCenter:CGPointMake(centerX, [self center].y)];
}


- (CGFloat)centerY {
  return [self center].y;
}


- (void)setCenterY:(CGFloat)centerY {
  [self setCenter:CGPointMake([self center].x, centerY)];
}


- (UIView *)findFirstResponder
{
  if (self.isFirstResponder) {        
    return self;     
  }
  
  for (UIView *subView in self.subviews) {
    UIView *firstResponder = [subView findFirstResponder];
    
    if (firstResponder != nil) {
      return firstResponder;
    }
  }
  
  return nil;
}


@end

