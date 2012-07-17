//  CLCGVC.m
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.

#import <QuartzCore/QuartzCore.h>

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_bundle_utils.h"
#import "clcg_gfx.h"
#import "clcg_viewport.h"
#import "UIViewCategory.h"
#import "CLCGVC.h"


//------------------------------------------------------------------------------
#pragma mark -

@implementation CLCGVC

@synthesize spinnerContainer = mSpinnerContainer;
@synthesize spinner = mSpinner;
@synthesize spinnerStyle = mSpinnerStyle;
@synthesize spinnerBackgroundColor = mSpinnerBackgroundColor;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    mSpinnerStyle = UIActivityIndicatorViewStyleGray;
    [self setSpinnerBackgroundColor:[UIColor whiteColor]];
  }
  return self;
}


// just creates the spinner view and subviews, without adding to view stack
-(void)createSpinnerView
{
  UIView *container;
  UIActivityIndicatorView *ai;

  ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:mSpinnerStyle];
  [self setSpinner:ai];
  [ai release];
  
  container = [[UIView alloc] initWithFrame:[[self view] frame]];
  [container setBackgroundColor:mSpinnerBackgroundColor];
  [container addSubview:mSpinner];
  [self setSpinnerContainer:container];
  [container release];
  
//  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"alpha"];
//  anim.duration = 2.0;
//  anim.fromValue = [NSNumber numberWithFloat:0];
//  anim.toValue = [NSNumber numberWithFloat:0.7];
//  anim.repeatCount = 1;
//  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//  [[v layer] addAnimation:anim forKey:@"spinnyIn"];
  //  [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve 
  //                   animations:^{
  //                     [v setAlpha:0.7];
  //                   } 
  //                   completion:nil];
}


// From the docs: subclasses should not call [super loadView]
//-(void)loadView
//{
//  if (mSpinnerContainer == nil)
//    [self createSpinnerView];
//}


-(void)showLoadingView:(BOOL)show
{
  if (show) {
    if (![[[self view] subviews] containsObject:mSpinnerContainer]) {
      if (mSpinnerContainer == nil)
        [self createSpinnerView];
      
      [[self view] addSubview:mSpinnerContainer];
      [mSpinnerContainer setNeedsLayout];
    }
    
    const CGSize SZ = [[self view] frame].size;
    [mSpinnerContainer setW:SZ.width];
    [mSpinnerContainer setH:SZ.height];
    [mSpinner centerVerticallyWithOffset:0];
    [mSpinner centerHorizontally];
    [mSpinner startAnimating];
    [[self view] bringSubviewToFront:mSpinnerContainer];
  } else {
    [mSpinner stopAnimating];
    clcg_safe_remove_from_superview(mSpinnerContainer);
  }
}


//------------------------------------------------------------------------------
#pragma mark - Memory Mgmt


-(void)dealloc
{
  CLCG_P(@"%@", self);
  CLCG_REL(mSpinnerBackgroundColor);
  CLCG_REL(mSpinner);
  CLCG_REL(mSpinnerContainer);
  [super dealloc];
}


-(void)viewDidUnload
{
  CLCG_P(@"%@", self);
  [super viewDidUnload];
}


-(void)didReceiveMemoryWarning
{
  CLCG_P(@"%@", self);
  [super didReceiveMemoryWarning];
}


@end

