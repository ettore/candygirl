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


//override designated (?) initializer
- (id)initWithTitle:(NSString *)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
{
  return [self initWithTitle:title style:style target:target action:action height:44.0];
}


- (id)initWithTitle:(NSString *)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)height
{
  self = [super initWithTitle:title style:style target:target action:action];
  if (self) {
    UIButton *uno;
    UIActivityIndicatorView *due;
    UIFont *font;
    CGSize sz;
    
    // set up first view
    uno = [UIButton buttonWithType:UIButtonTypeCustom];
    [uno setTitle:title forState:UIControlStateNormal];
    [uno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uno addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    font = [UIFont boldSystemFontOfSize:12];
    [[uno titleLabel] setFont:font];
    sz = [title sizeWithFont:font];

    // set up second view
    due = [[UIActivityIndicatorView alloc]
           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [due startAnimating];
    [due autorelease];
    
    // set up self
    mToggler = [[CLCGTogglerView alloc] initWithFrame:CGRectMake(0,0,sz.width,height)];
    [mToggler setFirstView:uno];
    [mToggler setSecondView:due];
    [self setCustomView:mToggler];
  }
  return self;
}


//-(id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
//{
//  //TODO
//}


-(void)setState:(enum CLCGBarButtonItemState)state
{
  if (state == mState)
    return;
  
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

