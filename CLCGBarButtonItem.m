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


- (id)initWithImage:(UIImage*)image
            orTitle:(NSString*)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  if (image)
    self = [super initWithImage:image style:style target:target action:action];
  else
    self = [super initWithTitle:title style:style target:target action:action];
  
  if (self) {
    UIButton *first;
    UIActivityIndicatorView *second;
    CGFloat w;
    
    // set up first view
    first = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
      [first setTitle:@"" forState:UIControlStateNormal];
      [first setBackgroundImage:image forState:UIControlStateNormal];
      w = [image size].width;
    } else {
      UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
      [first setTitle:title forState:UIControlStateNormal];
      [first setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [[first titleLabel] setFont:font];
      w = [title sizeWithFont:font].width;
    }
    [first addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    // set up second view
    second = [[UIActivityIndicatorView alloc]
              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [second startAnimating];
    [second autorelease];

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

