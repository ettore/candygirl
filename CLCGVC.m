//  CLCGVC.m
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.

#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_bundle_utils.h"
#import "clcg_gfx.h"
#import "clcg_viewport.h"
#import "CLCGUIViewCategory.h"
#import "CLCGUILabelCategory.h"
#import "CLCGVC.h"
#import "CLCGNSStringCategory.h"


#define EMPTY_VIEW_FONT_SIZE  14


//------------------------------------------------------------------------------
#pragma mark -

@interface CLCGVC ()
@property(nonatomic,strong) UILabel *retryLabel;
@end


@implementation CLCGVC
{
  // loading/spinner views
  UIView                        *_spinnerContainer;
  UIActivityIndicatorView       *_spinner;
  UIActivityIndicatorViewStyle  _spinnerStyle;
  UIColor                       *_spinnerBackgroundColor;

  // support for empty content case
  UIView                        *_emptyContainer;
  UILabel                       *_emptyLabel;

  // network state
  enum CLCGLoadingState         _loadState;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  CLCG_P(@"INIT...");
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _spinnerStyle = UIActivityIndicatorViewStyleGray;
    [self setSpinnerBackgroundColor:[UIColor whiteColor]];
    _loadState = CLCG_NOT_LOADED;
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

  ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_spinnerStyle];
  [self setSpinner:ai];

  cont = [[UIView alloc] initWithFrame:[[self view] bounds]];
  [cont setBackgroundColor:_spinnerBackgroundColor];
  [cont setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [cont addSubview:_spinner];
  [self setSpinnerContainer:cont];
}


-(void)centerSpinner
{
  [_spinner centerVerticallyWithOffset:0];
  [_spinner centerHorizontally];
}


-(void)centerEmptyPlaceholder
{
  // height of 2 lines of text
  CGFloat two_lines_offset = 2*[@"Mj" sizeWithMaxW:[[self view] w]
                                              font:[_retryLabel font]].height;

  [_emptyLabel centerVerticallyWithOffset:-two_lines_offset];
  [_emptyLabel centerHorizontally];
  [_retryLabel centerHorizontally];
  [_retryLabel setY:ceil([_emptyLabel low] + two_lines_offset)];
}


-(void)showLoadingView:(BOOL)show
{
  if (show) {
    if (![[[self view] subviews] containsObject:_spinnerContainer]) {
      if (_spinnerContainer == nil) {
        [self createSpinnerView];
      }
      
      [[self view] addSubview:_spinnerContainer];
      [_spinnerContainer setNeedsLayout];
    }
    
    [self centerSpinner];
    [_spinner startAnimating];
    [[self view] bringSubviewToFront:_spinnerContainer];
  } else {
    [_spinner stopAnimating];
    clcg_safe_remove_from_superview(_spinnerContainer);
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
  [self centerSpinner];
  [self centerEmptyPlaceholder];
}


//------------------------------------------------------------------------------
#pragma mark - Load from server


-(void)loadFromServerIfNeeded
{
}


-(void)reload
{
  [self setLoadState:CLCG_OUTDATED];
  [self loadFromServerIfNeeded];
}


//------------------------------------------------------------------------------
#pragma mark - Empty Placeholder View


-(void)createEmptyView
{
  UIView *cont;

  {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setEmptyLabel:label];
    [_emptyLabel setTextColor:[UIColor darkGrayColor]];
    [_emptyLabel setFont:[UIFont systemFontOfSize:EMPTY_VIEW_FONT_SIZE]];
    [_emptyLabel setTextAlignment:NSTextAlignmentCenter];
    [_emptyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_emptyLabel setNumberOfLines:0];//use as many lines as needed
  }

  {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setRetryLabel:label];
    [_retryLabel setTextColor:[UIColor darkGrayColor]];
    [_retryLabel setFont:[UIFont systemFontOfSize:EMPTY_VIEW_FONT_SIZE]];
    [_retryLabel setTextAlignment:NSTextAlignmentCenter];
    [_retryLabel setAdjustsFontSizeToFitWidth:YES];
    [_retryLabel setNumberOfLines:1];
    [_retryLabel setText:CLCG_LOC(@"Tap to reload")];
    [_retryLabel sizeToFit];
  }

  cont = [[UIView alloc] initWithFrame:[[self view] frame]];
  [cont setBackgroundColor:[UIColor whiteColor]];
  [cont setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [cont addSubview:_emptyLabel];
  [cont addSubview:_retryLabel];
  UITapGestureRecognizer *tap_recognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(reload)];
  tap_recognizer.numberOfTapsRequired = 1;
  [cont addGestureRecognizer:tap_recognizer];

  [self setEmptyContainer:cont];
}


-(void)showEmptyMessage:(NSString*)msg
{
  if (msg) {
    UIView *mainview = [self view];

    if (![[mainview subviews] containsObject:_emptyContainer]) {
      if (_emptyContainer == nil) {
        [self createEmptyView];
      }

      [_emptyLabel setText:msg];
      [_emptyLabel sizeToFitWidth:([mainview w] - CLCG_PADDING*2)];
      [mainview addSubview:_emptyContainer];
      [_emptyContainer setNeedsLayout];
    }

    [self centerEmptyPlaceholder];
    [mainview bringSubviewToFront:_emptyContainer];
  } else {
    clcg_safe_remove_from_superview(_emptyContainer);
  }
}


//------------------------------------------------------------------------------
#pragma mark - Memory Mgmt


-(void)releaseRetainedSubviews
{
}


-(void)dealloc
{
  CLCG_P(@"%@", self);
  [self releaseRetainedSubviews];
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

