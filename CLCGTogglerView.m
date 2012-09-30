//
//  CLCGTogglerView.m
//  PostalChess
//
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "CLCGTogglerView.h"
#import "clcg_gfx.h"


@implementation CLCGTogglerView


-(void)dealloc
{
  CLCG_REL(mFirstView);
  CLCG_REL(mSecondView);
  [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UIViewAutoresizing same_sz_mask;
    
    // config self
    same_sz_mask = UIViewAutoresizingFlexibleHeight;
    mState = CLCGTogglerFirstView;
    [self setAutoresizingMask:same_sz_mask];
    [self setAutoresizesSubviews:YES];
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  
  return self;
}


//------------------------------------------------------------------------------
#pragma mark - Accessors


-(void)setFirstView:(UIView *)first
{
  [self setView:first on:&mFirstView];
}


-(UIView*)firstView
{
  return mFirstView;
}


-(void)setSecondView:(UIView *)second
{
  [self setView:second on:&mSecondView];
}


-(UIView*)secondView
{
  return mSecondView;
}


-(void)setView:(UIView *)view on:(UIView **)ivar_ptr
{
  UIViewAutoresizing same_sz_mask;
  UIView *current = *ivar_ptr;
  
  if (view == current || ivar_ptr == nil)
    return;

  [view retain];
  clcg_safe_remove_from_superview(current);
  [current release];
  *ivar_ptr = current = view;

  same_sz_mask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [current setAutoresizingMask:same_sz_mask];
  [current setBackgroundColor:[UIColor clearColor]];

  // set frame of subview to match self
  CGRect r = [self frame];
  [current setFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
  
  [self addSubview:current];
}


//------------------------------------------------------------------------------
#pragma mark - Layout


-(void)layoutSubviews
{
  [super layoutSubviews];
  [self setState:mState];
//  CGRect r = [self frame];
//  CGRect r1 = [mFirstView frame];
//  CGRect r2 = [mSecondView frame];
//  CGFloat w = MAX(r1.size.width, r2.size.width);
//  if (w == 0)
//    w = r.size.width;
//  [mFirstView setFrame:CGRectMake(0,0,w,r.size.height)];
//  [mSecondView setFrame:CGRectMake(0,0,w,r.size.height)];
}


-(void)setState:(enum CLCGTogglerState)state
{
  if (CLCGTogglerFirstView == state) {
    [mFirstView setHidden:NO];
    [mSecondView setHidden:YES];
  } else if (CLCGTogglerSecondView == state) {
    [mFirstView setHidden:YES];
    [mSecondView setHidden:NO];
  }
  
  mState = state;
  
  [self setNeedsDisplay];
}


-(enum CLCGTogglerState)state
{
  return mState;
}


@end

