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

#import "UIView+CLCG.h"
#import "NSString+CLCG.h"
#import "clcg_gfx.h"
#import "NSAttributedString+CLCG.h"


@implementation UIView (Candygirl)


//------------------------------------------------------------------------------
#pragma mark - Easy view centering


-(void)clcg_centerHorizontally
{
  [self clcg_centerHorizontallyWithOffset:0];
}


-(void)clcg_centerHorizontallyWithOffset:(CGFloat)offset
{
  CGSize sz;
  CGFloat x;

  sz = [[self superview] frame].size;
  x = (sz.width - [self clcg_w])/2 + offset;
  [self setClcg_x:x];
}


-(void)clcg_centerHorizontallyInRect:(CGRect)rect
{
  CGFloat x = (rect.size.width - [self clcg_w])/2;
  [self setClcg_x:(rect.origin.x + x)];
}


-(void)clcg_centerVertically
{
  [self clcg_centerVerticallyWithOffset:0];
}


-(void)clcg_centerVerticallyWithOffset:(CGFloat)offset
{
  CGSize sz;
  CGFloat y;

  sz = [[self superview] frame].size;
  y = (sz.height - [self clcg_h])/2 + offset;
  [self setClcg_y:y];
}


-(void)clcg_centerVerticallyInRect:(CGRect)rect
{
  CGFloat y = (rect.size.height - [self clcg_h])/2;
  [self setClcg_y:(rect.origin.y + y)];
}


//------------------------------------------------------------------------------
#pragma mark - Easy resizing


-(void)clcg_resizeHForText:(NSString*)txt font:(UIFont*)font
{
  CGSize sz;

  sz = CGSizeMake([self clcg_w], INT_MAX);
  sz = [txt clcg_sizeWithMaxW:sz.width maxH:sz.height font:font];

  [self setClcg_h:ceil(sz.height)];  // Can't round down, may make last line disappear
}


//------------------------------------------------------------------------------
#pragma mark - Easy access to positioning info of view


-(CGFloat)clcg_x
{
  return [self frame].origin.x;
}


-(void)setClcg_x:(CGFloat)x
{
  CGRect r = [self frame];
  r.origin.x = round(x);
  [self setFrame:r];
}


-(CGFloat)clcg_y
{
  return [self frame].origin.y;
}


-(void)setClcg_y:(CGFloat)y
{
  CGRect r = [self frame];
  r.origin.y = round(y);
  [self setFrame:r];
}


-(CGFloat)clcg_w
{
  return [self frame].size.width;
}


-(void)setClcg_w:(CGFloat)w
{
  CGRect r = [self frame];
  r.size.width = round(w);
  [self setFrame:r];
}


-(CGFloat)clcg_h
{
  return [self frame].size.height;
}


-(void)setClcg_h:(CGFloat)h
{
  CGRect r = [self frame];
  r.size.height = round(h);
  [self setFrame:r];
}


-(CGFloat)clcg_r
{
  CGRect r = [self frame];
  return r.origin.x + r.size.width;
}


-(CGFloat)clcg_low
{
  CGRect r = [self frame];
  return r.origin.y + r.size.height;
}


-(CGPoint)clcg_origin
{
  return [self frame].origin;
}


-(void)setClcg_origin:(CGPoint)origin {
  CGRect frame = [self frame];
  frame.origin = origin;
  [self setFrame:frame];
}


-(CGSize)clcg_sz
{
  return [self frame].size;
}


-(void)setClcg_sz:(CGSize)size
{
  CGRect frame = [self frame];
  frame.size = size;
  [self setFrame:frame];
}


-(CGFloat)clcg_centerX
{
  return [self center].x;
}


-(void)setClcg_centerX:(CGFloat)centerX
{
  [self setCenter:CGPointMake(centerX, [self center].y)];
}


-(CGFloat)clcg_centerY
{
  return [self center].y;
}


-(void)setClcg_centerY:(CGFloat)centerY
{
  [self setCenter:CGPointMake([self center].x, centerY)];
}


//------------------------------------------------------------------------------
#pragma mark - Change x, y, w, h given right or bottom alignment value


-(void)clcg_setXForR:(CGFloat)r
{
  [self setClcg_x:(r - [self clcg_w])];
}


-(void)clcg_setYForLow:(CGFloat)low
{
  [self setClcg_y:(low - [self clcg_h])];
}


-(void)clcg_setWForR:(CGFloat)r
{
  if ([self clcg_x] < r) {
    [self setClcg_w:(r - [self clcg_x])];
  }
}


-(void)clcg_setHForLow:(CGFloat)low
{
  if ([self clcg_y] < low) {
    [self setClcg_h:(low - [self clcg_y])];
  }
}


//------------------------------------------------------------------------------
#pragma mark - Spinner positoning


-(UIActivityIndicatorView*)clcg_showSpinner:(UIActivityIndicatorView*)spinner
{
  // if spinner is already a subview, no need to add it (or create it)
  if (![[self subviews] containsObject:spinner]) {
    if (nil == spinner) {
      spinner = [[UIActivityIndicatorView alloc]
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }

    // the spinner is not added to the view yet, so add it
    [self addSubview:spinner];
  }

  [spinner clcg_centerHorizontally];
  [spinner clcg_centerVertically];
  [self setNeedsLayout];

  // go! and make sure to show it
  [spinner startAnimating];
  [self bringSubviewToFront:spinner];

  return spinner;
}


-(void)clcg_hideSpinner:(UIActivityIndicatorView*)spinner
{
  [spinner stopAnimating];
  clcg_safe_remove_from_superview(spinner);
}


//------------------------------------------------------------------------------
#pragma mark - Misc


-(UIView*)clcg_findFirstResponder
{
  if ([self isFirstResponder]) {
    return self;
  }

  for (UIView *subView in [self subviews]) {
    UIView *firstResponder = [subView clcg_findFirstResponder];

    if (firstResponder != nil) {
      return firstResponder;
    }
  }

  return nil;
}


-(void)clcg_addBorderWithInsets:(UIEdgeInsets)insets
{
  UIView *border_line = [[UIView alloc] init];
  [[border_line layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
  [[border_line layer] setBorderWidth:1.0];
  [border_line setFrame:UIEdgeInsetsInsetRect([self bounds], insets)];
  [border_line setAutoresizingMask:(UIViewAutoresizingFlexibleHeight
                                    |UIViewAutoresizingFlexibleWidth)];
  [self addSubview:border_line];
  [self sendSubviewToBack:border_line];
}


//------------------------------------------------------------------------------
#pragma mark - Height measuring methods


// TODO: this method is fairly expensive if used with attributed strings.
// it would be good to implement some form of caching of these heights.
-(CGFloat)clcg_textHForW:(CGFloat)w
           useAttributed:(BOOL)use_attributed
               lineLimit:(NSUInteger)line_limit
{
  CGSize text_size = CGSizeZero;

  if (use_attributed && [self respondsToSelector:@selector(attributedText)]) {
    NSAttributedString *attr_text = [(id)self attributedText];

    // TODO: instead of calculating these sizes each time, we should consider
    // caching these somewhere

    if ([attr_text length] > 0) {
      if (line_limit > 0){
        NSAttributedString *s = [attr_text attributedSubstringFromRange:
                                 NSMakeRange(0,1)];
        CGFloat h = ceil([s clcg_sizeWithMaxW:w].height);
        h *= line_limit;
        text_size = [attr_text clcg_sizeWithMaxW:w maxH:h];
      } else {
        text_size = [attr_text clcg_sizeWithMaxW:w];
      }
    }
  } else if ([self respondsToSelector:@selector(text)]
             && [self respondsToSelector:@selector(font)]) {
    NSString *text = [(id)self text];
    UIFont *font = [(id)self font];
    if ([text length] > 0) {
      if (line_limit > 0){
        CGFloat h = [@"Mj" clcg_sizeWithMaxW:w font:font].height;
        h *= line_limit;
        text_size = [text clcg_sizeWithMaxW:w maxH:h font:font];
      } else {
        text_size = [text clcg_sizeWithMaxW:w font:font];
      }
    }
  }

  return text_size.height;
}


//------------------------------------------------------------------------------
#pragma mark - Layout methods


-(void)clcg_putTextView:(UIView*)subview
      useAttributedText:(BOOL)use_attributed
              toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_h
                  below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_v
               maxWidth:(CGFloat)max_w
              lineLimit:(NSUInteger)line_limit
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_h);
  CGFloat y = round(CGRectGetMaxY(vert_align_view.frame));
  const CGFloat w = max_w - x;
  const CGFloat h = ceil([subview clcg_textHForW:w
                                   useAttributed:use_attributed
                                       lineLimit:line_limit]);
  if (h > 0) {
    y += padding_v;
  }
  [subview setFrame:CGRectMake(x, y, w, h)];
}


-(void)clcg_putView:(UIView*)subview
          toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_h
              below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_v
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_h);
  const CGFloat y = round(CGRectGetMaxY(vert_align_view.frame) + padding_v);
  [subview setFrame:CGRectMake(x, y, [subview clcg_w], [subview clcg_h])];
}


-(void)clcg_putView:(UIView<CLCGUIViewLayout>*)subview
          toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_h
              below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_v
           maxWidth:(CGFloat)max_w
{
  const CGFloat x = round(CGRectGetMaxX(horiz_align_view.frame) + padding_h);
  const CGFloat y = round(CGRectGetMaxY(vert_align_view.frame) + padding_v);
  const CGFloat w = max_w - x;
  const CGFloat h = [subview calculatedHeightForWidth:w];
  [subview setFrame:CGRectMake(x, y, w, h)];
}


-(void)clcg_addTarget:(id)target forTapAction:(SEL)action
{
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap_recognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:target
                                            action:action];
  tap_recognizer.numberOfTapsRequired = 1;
  [self addGestureRecognizer:tap_recognizer];
}


@end

