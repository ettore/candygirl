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


#import "tgmath.h"

#import "CLCGUIViewCategory.h"
#import "CLCGNSStringCategory.h"
#import "clcg_gfx.h"
#import "NSAttributedString+CLCG.h"


@implementation UIView (Candygirl)


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


-(void)centerVerticallyInRect:(CGRect)rect
{
  CGFloat y = (rect.size.height - [self h])/2;
  [self setY:(rect.origin.y + y)];
}


-(void)resizeHeightForText:(NSString*)txt font:(UIFont*)font
{
  CGSize sz;

  sz = CGSizeMake([self w], INT_MAX);
  sz = [txt sizeWithFont:font constrainedToSize:sz];

  [self setH:ceil(sz.height)];  // Can't round down, may make last line disappear
}


-(CGFloat)x
{
  return [self frame].origin.x;
}


-(void)setX:(CGFloat)x
{
  CGRect r = [self frame];
  r.origin.x = round(x);
  [self setFrame:r];
}


-(CGFloat)y
{
  return [self frame].origin.y;
}


-(void)setY:(CGFloat)y
{
  CGRect r = [self frame];
  r.origin.y = round(y);
  [self setFrame:r];
}


-(CGFloat)w
{
  return [self frame].size.width;
}


-(void)setW:(CGFloat)w
{
  CGRect r = [self frame];
  r.size.width = round(w);
  [self setFrame:r];
}


-(CGFloat)h
{
  return [self frame].size.height;
}


-(void)setH:(CGFloat)h
{
  CGRect r = [self frame];
  r.size.height = round(h);
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


-(void)setXForR:(CGFloat)r
{
  [self setX:(r - [self w])];
}


-(void)setYForLow:(CGFloat)low
{
  [self setY:(low - [self h])];
}


-(void)setWForR:(CGFloat)r
{
  if ([self x] < r) {
    [self setW:(r - [self x])];
  }
}


-(void)setHForLow:(CGFloat)low
{
  if ([self y] < low) {
    [self setH:(low - [self y])];
  }
}


-(CGSize)sz
{
  return [self frame].size;
}


-(void)setSz:(CGSize)size
{
  CGRect frame = [self frame];
  frame.size = size;
  [self setFrame:frame];
}


-(CGPoint)origin
{
  return [self frame].origin;
}


-(void)setOrigin:(CGPoint)origin {
  CGRect frame = [self frame];
  frame.origin = origin;
  [self setFrame:frame];
}


-(CGFloat)centerX
{
  return [self center].x;
}


-(void)setCenterX:(CGFloat)centerX
{
  [self setCenter:CGPointMake(centerX, [self center].y)];
}


-(CGFloat)centerY
{
  return [self center].y;
}


-(void)setCenterY:(CGFloat)centerY
{
  [self setCenter:CGPointMake([self center].x, centerY)];
}


-(UIActivityIndicatorView*)showSpinner:(UIActivityIndicatorView*)spinner
{
  // if spinner is already a subview, no need to add it (or create it)
  if (![[self subviews] containsObject:spinner]) {
    if (nil == spinner) {
      spinner = [[UIActivityIndicatorView alloc]
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      [spinner autorelease];
    }

    // the spinner is not added to the view yet, so add it
    [self addSubview:spinner];
  }

  [spinner centerHorizontally];
  [spinner centerVertically];
  [self setNeedsLayout];

  // go! and make sure to show it
  [spinner startAnimating];
  [self bringSubviewToFront:spinner];

  return spinner;
}


-(void)hideSpinner:(UIActivityIndicatorView*)spinner
{
  [spinner stopAnimating];
  clcg_safe_remove_from_superview(spinner);
}


-(UIView*)findFirstResponder
{
  if ([self isFirstResponder]) {
    return self;
  }

  for (UIView *subView in [self subviews]) {
    UIView *firstResponder = [subView findFirstResponder];

    if (firstResponder != nil) {
      return firstResponder;
    }
  }

  return nil;
}


-(void)addBorderWithInsets:(UIEdgeInsets)insets
{
  UIView *border_line = [[[UIView alloc] init] autorelease];
  [[border_line layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
  [[border_line layer] setBorderWidth:1.0];
  [border_line setFrame:UIEdgeInsetsInsetRect([self bounds], insets)];
  [border_line setAutoresizingMask:(UIViewAutoresizingFlexibleHeight
                                    |UIViewAutoresizingFlexibleWidth)];
  [self addSubview:border_line];
  [self sendSubviewToBack:border_line];
}

//------------------------------------------------------------------------------
#pragma mark - height measuring methods

-(CGFloat)textHeightForWidth:(CGFloat)w
               useAttributed:(BOOL)use_attributed
                useLineLimit:(BOOL)use_line_limit
{
  CGSize text_size = CGSizeZero;

  if (use_attributed && [self respondsToSelector:@selector(attributedText)]) {
    NSAttributedString *attr_text = [(id)self attributedText];
    if ([attr_text length] > 0) {
      if ([self respondsToSelector:@selector(numberOfLines)]) {
        NSAttributedString *s = [attr_text attributedSubstringFromRange:
                                 NSMakeRange(0,1)];
        CGFloat h = [s sizeWithMaxW:w].height + 1.0f;
        h *= [(id)self numberOfLines];
        text_size = [attr_text sizeWithMaxW:w maxH:h];
      } else {
        text_size = [attr_text sizeWithMaxW:w];
      }
    }
  } else if ([self respondsToSelector:@selector(text)]
             && [self respondsToSelector:@selector(font)]) {
    NSString *text = [(id)self text];
    UIFont *font = [(id)self font];
    if ([text length] > 0) {
      if (use_line_limit && [self respondsToSelector:@selector(numberOfLines)]) {
        CGFloat h = [@"Mj" sizeWithMaxW:w font:font].height;
        h *= [(id)self numberOfLines];
        text_size = [text sizeWithMaxW:w maxH:h font:font];
      } else {
        text_size = [text sizeWithMaxW:w font:font];
      }
    }
  }

  return text_size.height;
}

//------------------------------------------------------------------------------
#pragma mark - layout methods


-(void)putTextView:(UIView*)subview
 useAttributedText:(BOOL)use_attributed
         toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
             below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
          maxWidth:(CGFloat)max_w
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_horiz);
  const CGFloat y = round(CGRectGetMaxY(vert_align_view.frame) + padding_vert);
  const CGFloat w = max_w - x;
  const CGFloat h = round([subview textHeightForWidth:w
                                        useAttributed:use_attributed
                                         useLineLimit:YES]);
  [subview setFrame:CGRectMake(x, y, w, h)];
}


-(void)putView:(UIView*)subview
     toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
         below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_horiz);
  const CGFloat y = round(CGRectGetMaxY(vert_align_view.frame) + padding_vert);
  [subview setFrame:CGRectMake(x, y, [subview w], [subview h])];
}


-(void)putView:(UIView<CLCGUIViewLayout>*)subview
     toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
         below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
      maxWidth:(CGFloat)max_w
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_horiz);
  const CGFloat y = round(CGRectGetMaxY(vert_align_view.frame) + padding_vert);
  const CGFloat w = max_w - x;
  const CGFloat h = [subview calculatedHeightForWidth:w];
  [subview setFrame:CGRectMake(x, y, w, h)];
}


@end

