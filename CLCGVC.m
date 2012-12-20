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
#import "UILabelCategory.h"
#import "CLCGVC.h"


//------------------------------------------------------------------------------
#pragma mark -

@implementation CLCGVC

@synthesize spinnerContainer = mSpinnerContainer;
@synthesize spinner = mSpinner;
@synthesize spinnerStyle = mSpinnerStyle;
@synthesize spinnerBackgroundColor = mSpinnerBackgroundColor;
@synthesize popoverContentDelegate = mPopoverContentDelegate;
@synthesize emptyLabel = mEmptyLabel;
@synthesize emptyContainer = mEmptyContainer;
@synthesize loadState = mLoadState;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  CLCG_P(@"INIT...");
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    mSpinnerStyle = UIActivityIndicatorViewStyleGray;
    [self setSpinnerBackgroundColor:[UIColor whiteColor]];
    mLoadState = CLCG_NOT_LOADED;
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


-(void)centerSpinnerAndEmptyPlaceholder
{
  [mSpinner centerVerticallyWithOffset:0];
  [mSpinner centerHorizontally];
  [mEmptyLabel centerVerticallyWithOffset:0];
  [mEmptyLabel centerHorizontally];
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
    
    [self centerSpinnerAndEmptyPlaceholder];
    [mSpinner startAnimating];
    [[self view] bringSubviewToFront:mSpinnerContainer];
  } else {
    [mSpinner stopAnimating];
    clcg_safe_remove_from_superview(mSpinnerContainer);
  }
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  switch ([self loadState]) {
    case CLCG_LOADING:
      // the reason why we're showing the loading view here and not earlier
      // is because earlier, eg at viewDidLoad time, the view is not really
      // laid out (e.g. frame is Zero)
      [self showLoadingView:YES];
      break;
    default: {
      [self showLoadingView:NO];
      break;
    }
  }
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)to_orient
                                        duration:(NSTimeInterval)duration
{
  [super willAnimateRotationToInterfaceOrientation:to_orient duration:duration];
  [self centerSpinnerAndEmptyPlaceholder];
}


//------------------------------------------------------------------------------
#pragma mark - Empty Placeholder View


-(void)createEmptyView
{
  UIView *cont;
  UILabel *label;

  label = [[UILabel alloc] initWithFrame:CGRectZero];
  [self setEmptyLabel:label];
  [label release];
  [mEmptyLabel setTextColor:[UIColor darkGrayColor]];
  [mEmptyLabel setFont:[UIFont systemFontOfSize:14]];
  [mEmptyLabel setTextAlignment:UITextAlignmentCenter];
  [mEmptyLabel setLineBreakMode:UILineBreakModeWordWrap];
  [mEmptyLabel setNumberOfLines:0];//use as many lines as needed

  cont = [[UIView alloc] initWithFrame:[[self view] frame]];
  [cont setBackgroundColor:[UIColor whiteColor]];
  [cont setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [cont addSubview:mEmptyLabel];
  [self setEmptyContainer:cont];
  [cont release];
}


-(void)showEmptyMessage:(NSString*)msg
{
  if (msg) {
    UIView *mainview = [self view];

    if (![[mainview subviews] containsObject:mEmptyContainer]) {
      if (mEmptyContainer == nil)
        [self createEmptyView];

      [mEmptyLabel setText:msg];
      [mEmptyLabel sizeToFitWidth:([mainview w] - DEFAULT_PADDING*2)];
      [mainview addSubview:mEmptyContainer];
      [mEmptyContainer setNeedsLayout];
    }

    [self centerSpinnerAndEmptyPlaceholder];
    [mainview bringSubviewToFront:mEmptyContainer];
  } else {
    clcg_safe_remove_from_superview(mEmptyContainer);
  }
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
  CLCG_REL(mEmptyLabel);
  CLCG_REL(mEmptyContainer);
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


//------------------------------------------------------------------------------
#pragma mark - Rotation


// iOS 6
-(BOOL)shouldAutorotate
{
  return YES;
}


// iOS 6
- (NSUInteger)supportedInterfaceOrientations {
  // by default, UIInterfaceOrientationMaskAllButUpsideDown is returned on
  // iPhone. Override that and let the default be the project level setting.
  return UIInterfaceOrientationMaskAll;
}


// iOS < 6
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
  return YES;
}


@end

