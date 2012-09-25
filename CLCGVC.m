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
@synthesize popoverContentDelegate = mPopoverContentDelegate;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    mSpinnerStyle = UIActivityIndicatorViewStyleGray;
    [self setSpinnerBackgroundColor:[UIColor whiteColor]];
  }
  return self;
}


//------------------------------------------------------------------------------
#pragma mark - Spinner


// just creates the spinner view and subviews, without adding to view stack
-(void)createSpinnerView
{
  UIView *cont;
  UIActivityIndicatorView *ai;

  ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:mSpinnerStyle];
  [self setSpinner:ai];
  [ai release];
  
  cont = [[UIView alloc] initWithFrame:[[self view] frame]];
  [cont setBackgroundColor:mSpinnerBackgroundColor];
  [cont setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [cont addSubview:mSpinner];
  [self setSpinnerContainer:cont];
  [cont release];
}


-(void)centerSpinner
{
  [mSpinner centerVerticallyWithOffset:0];
  [mSpinner centerHorizontally];
}


-(void)showLoadingView:(BOOL)show
{
  if (show) {
    if (![[[self view] subviews] containsObject:mSpinnerContainer]) {
      if (mSpinnerContainer == nil)
        [self createSpinnerView];
      
      [[self view] addSubview:mSpinnerContainer];
      [mSpinnerContainer setNeedsLayout];
    }
    
    [self centerSpinner];
    [mSpinner startAnimating];
    [[self view] bringSubviewToFront:mSpinnerContainer];
  } else {
    [mSpinner stopAnimating];
    clcg_safe_remove_from_superview(mSpinnerContainer);
  }
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)to_orient
                                        duration:(NSTimeInterval)duration
{
  [super willAnimateRotationToInterfaceOrientation:to_orient duration:duration];
  [self centerSpinner];
}


//------------------------------------------------------------------------------
#pragma mark - Utils


-(CGFloat)navBarH
{
  UINavigationBar *nb = [[self navigationController] navigationBar];
  return (nb ? [nb h] : 0.0f);
}


-(CGFloat)tabBarH
{
  UITabBar *tb = [[self tabBarController] tabBar];
  return (tb ? [tb h] : 0.0f);
}


//------------------------------------------------------------------------------
#pragma mark - Memory Mgmt


-(void)releaseRetainedSubviews
{
  CLCG_REL(mSpinner);
  CLCG_REL(mSpinnerContainer);
}


-(void)dealloc
{
  CLCG_P(@"%@", self);
  mPopoverContentDelegate = nil;
  CLCG_REL(mSpinnerBackgroundColor);
  [self releaseRetainedSubviews];
  [super dealloc];
}


-(void)viewDidUnload
{
  CLCG_P(@"%@", self);
  [self releaseRetainedSubviews];
  [super viewDidUnload];
}


-(void)didReceiveMemoryWarning
{
  CLCG_P(@"%@", self);
  [super didReceiveMemoryWarning];
}


@end

