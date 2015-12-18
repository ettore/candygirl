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


#import "clcg_device_utils.h"
#import "CLCGBarButtonItem.h"
#import "UIView+CLCG.h"
#import "CLCGTogglerView.h"


@implementation CLCGBarButtonItem
{
  CLCGTogglerView             *_toggler;
  CLCGBarButtonItemState      _buttonState;
  BOOL                        _isSystemItem;
}


@synthesize state = _buttonState;


//------------------------------------------------------------------------------
#pragma mark - Overrides


-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
{
  return [self initWithImage:nil
                     orTitle:nil
                orSystemItem:item
                       style:UIBarButtonItemStylePlain
                      target:target
                      action:action
                      height:44]; //arbitrary yet reasonable default height
}


- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default height
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:44];
}


-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default height
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:44];
}


-(void)setTintColor:(UIColor*)col
{
  if (clcg_os_geq(@"5.0")) {
    [super setTintColor:col];
    [[self spinner] setColor:col];
  }
}


//------------------------------------------------------------------------------
#pragma mark - Public API


-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
                          height:(CGFloat)h
{
  return [self initWithImage:nil
                     orTitle:nil
                orSystemItem:item
                       style:UIBarButtonItemStylePlain
                      target:target
                      action:action
                      height:h];
}


- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
             height:(CGFloat)h
{
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:h];
}


-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
            height:(CGFloat)h
{
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:h];
}


-(void)setState:(enum CLCGBarButtonItemState)state
{
  if (state != _buttonState) {
    switch (state) {
      case CLCGBarButtonItemStateReady:
        if (_isSystemItem) {
          // remove customView so that UIBarButtonItem system graphics are rendered
          [self setCustomView:nil];
        } else {
          [_toggler setTogglerState:CLCGTogglerFirstView];
          if ([[self title] length] == 0) {
            [self setCustomView:_toggler];
          } else {
            [self setCustomView:nil];
          }
        }
        break;
      case CLCGBarButtonItemStateBusy:
        // show the spinner
        [_toggler setTogglerState:CLCGTogglerSecondView];
        [self setCustomView:_toggler];
        break;
      case CLCGBarButtonItemStateHidden:
        [_toggler setTogglerState:CLCGTogglerFirstView];
        [[_toggler firstView] setHidden:YES];
        if ([[self title] length] > 0) {
          // for a textual button, this will "show" the empty button we created.
          [self setCustomView:_toggler];
        }
        break;
      default:
        break;
    }

    _buttonState = state;
  }
}


-(enum CLCGBarButtonItemState)state
{
  return _buttonState;
}


//------------------------------------------------------------------------------
#pragma mark - Private


/*
 This method shouldn't be invoked with `img` and `title` both non-nil. In that 
 case the `title` will be ignored. Otherwise, the non-nil value will be used.
 If `img` and `title` are both nil, a Refresh systemItem will be used instead.
 */
- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  return [self initWithImage:img
                     orTitle:title
                orSystemItem:UIBarButtonSystemItemRefresh
                       style:style
                      target:target
                      action:action
                      height:h];
}


- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
       orSystemItem:(UIBarButtonSystemItem)item
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  if (title == nil)
    title = @"";

  if (img == nil && [title length] == 0) {
    self = [super initWithBarButtonSystemItem:item target:target action:action];
    _isSystemItem = YES;
  } else {
    if (img) {
      title = nil;
    }
    self = [super initWithTitle:title style:style target:target action:action];
    _isSystemItem = NO;
  }

  if (self) {
    UIView *first;
    UIButton *b;
    UIActivityIndicatorView *second;
    CGFloat w;

    // set up second view
    second = [[UIActivityIndicatorView alloc]
              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [second startAnimating];

    // set up first view
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    if (img) {
      CGFloat x, y;
      CGSize imgsz = [img size];

      [b setTitle:@"" forState:UIControlStateNormal];
      [b setBackgroundImage:img forState:UIControlStateNormal];
      [b setAutoresizingMask:
       UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin
       |UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
      [b setContentMode:UIViewContentModeCenter];
      [b setOpaque:YES];
      [b setBackgroundColor:[UIColor clearColor]];

      w = MAX(imgsz.width, [second clcg_w]);
      first = [[UIView alloc] initWithFrame:CGRectMake(0,0,w,h)];
      x = (w - imgsz.width)/2;
      y = (h - imgsz.height)/2;
      [b setFrame:CGRectMake(x, y, imgsz.width, imgsz.height)];
      [first addSubview:b];
    } else {
      // if we've a textual button, we're going to render ourselves as a
      // normal UIBarButton. This is just to display the hidden state.
      UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
      w = MAX([title sizeWithFont:font].width, [second clcg_w]);
      first = b;
    }
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    // set up the toggler view
    _toggler = [[CLCGTogglerView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    [_toggler setFirstView:first];
    [_toggler setSecondView:second];

    [self setState:CLCGBarButtonItemStateReady];
  }
  return self;
}


-(UIActivityIndicatorView*)spinner
{
  return (UIActivityIndicatorView*)[_toggler secondView];
}


@end

