//
//  CLCGBarButtonItem.m
//  PostalChess
//
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "clcg_device_utils.h"
#import "CLCGBarButtonItem.h"
#import "UIViewCategory.h"


@implementation CLCGBarButtonItem


-(void)dealloc
{
  CLCG_REL(mToggler);
  [super dealloc];
}


// Overriding super class initializer. You should avoid calling these directly.
- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:44];
}


// Overriding super class initializer. You should avoid calling this directly.
-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:44];
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


/*
 Private method.
 
 Note that this is (and must be) invoked only in this condition:
    img == nil XOR title == nil
 
 */
- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  if (title == nil)
    title = @"";

  self = [super initWithTitle:title style:style target:target action:action];
  
  if (self) {
    UIView *first;
    UIButton *b;
    UIActivityIndicatorView *second;
    CGFloat w;

    // set up second view
    second = [[UIActivityIndicatorView alloc]
              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [second startAnimating];
    [second autorelease];
    
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

      w = MAX(imgsz.width, [second w]);
      first = [[[UIView alloc] initWithFrame:CGRectMake(0,0,w,h)] autorelease];
      x = (w - imgsz.width)/2;
      y = (h - imgsz.height)/2;
      [b setFrame:CGRectMake(x, y, imgsz.width, imgsz.height)];
      [first addSubview:b];
    } else {
      // if we've a textual button, we're going to render ourselves as a
      // normal UIBarButton. This is just to display the hidden state.
      UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
      w = MAX([title sizeWithFont:font].width, [second w]);
      first = b;
    }
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    // set up the toggler view
    mToggler = [[CLCGTogglerView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    [mToggler setFirstView:first];
    [mToggler setSecondView:second];

    [self setState:CLCGBarButtonItemStateReady];
  }
  return self;
}


-(void)setState:(enum CLCGBarButtonItemState)state
{
  switch (state) {
    case CLCGBarButtonItemStateReady:
      [mToggler setState:CLCGTogglerFirstView];
      if ([[self title] length] == 0) {
        [self setCustomView:mToggler];
      } else {
        // remove the custom view, so that the normal UIBarButtonItem style
        // is rendered
        [self setCustomView:nil];
      }
      break;
    case CLCGBarButtonItemStateBusy:
      // show the spinner
      [mToggler setState:CLCGTogglerSecondView];
      [self setCustomView:mToggler];
      break;
    case CLCGBarButtonItemStateHidden:
      [mToggler setState:CLCGTogglerFirstView];
      [[mToggler firstView] setHidden:YES];
      if ([[self title] length] > 0) {
        // for a textual button, this will "show" the empty button we created.
        [self setCustomView:mToggler];
      }
      break;
    default:
      break;
  }
  
  mState = state;
}


-(enum CLCGBarButtonItemState)state
{
  return mState;
}


@end

