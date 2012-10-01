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


@synthesize state = mState;


-(void)dealloc
{
  CLCG_REL(mToggler);
  [super dealloc];
}


- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
{
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:44];
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
{
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:44];
}


-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
            height:(CGFloat)h
{
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:h];
}


- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  if (img)
    self = [super initWithImage:img style:style target:target action:action];
  else
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
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
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
      UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
      [b setTitle:title forState:UIControlStateNormal];
      [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [[b titleLabel] setFont:font];
      w = MAX([title sizeWithFont:font].width, [second w]);
      first = b;
    }

    // set up self
    mToggler = [[CLCGTogglerView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    [mToggler setFirstView:first];
    [mToggler setSecondView:second];
    [self setCustomView:mToggler];
  }
  return self;
}


-(void)setState:(enum CLCGBarButtonItemState)state
{
  if (CLCGBarButtonItemStateBusy == state) {
    // show the spinner
    [mToggler setState:CLCGTogglerSecondView];
  } else {
    // show back the button
    [mToggler setState:CLCGTogglerFirstView];
  }
  
  mState = state;
}


@end

