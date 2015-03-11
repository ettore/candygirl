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
//  Created by Ettore Pasquini on 5/4/11.
//

#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_bundle_utils.h"
#import "clcg_gfx.h"
#import "clcg_viewport.h"
#import "UIView+CLCG.h"
#import "UILabel+CLCG.h"
#import "CLCGVC.h"
#import "NSString+CLCG.h"


#define EMPTY_VIEW_FONT_SIZE  14
#define SPINNER_TEXT_MAX_WIDTH 280

//------------------------------------------------------------------------------
#pragma mark -

@interface CLCGVC ()
@property(nonatomic,strong) UILabel *retryLabel;
@end


@implementation CLCGVC


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


-(void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];

  // in case a spinner view was added (showLoadingView:), make sure to center it
  if (_spinnerContainer.superview != nil) {
    [self centerSpinner];
  }
}


//------------------------------------------------------------------------------
#pragma mark - Spinner / Loading view


// just creates the spinner view and subviews, without adding to view stack
-(void)createSpinnerView
{
  UIView *cont;
  UIActivityIndicatorView *ai;

  ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_spinnerStyle];
  _spinner = ai;
  _spinnerLabel1 = [[UILabel alloc] init];
  _spinnerLabel2 = [[UILabel alloc] init];

  cont = [[UIView alloc] initWithFrame:[[self view] bounds]];
  cont.backgroundColor = _spinnerBackgroundColor;
  cont.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                           |UIViewAutoresizingFlexibleHeight);
  [cont addSubview:_spinner];
  [cont addSubview:_spinnerLabel1];
  [cont addSubview:_spinnerLabel2];
  self.spinnerContainer = cont;
}


-(void)centerSpinner
{
  // The spinner text is intended for short text that can be read while waiting.
  CGFloat text_max_height = clcg_screensize().height/2;
  CGSize text_size = [_spinnerLabel1.text sizeWithMaxW:SPINNER_TEXT_MAX_WIDTH
                                                  maxH:text_max_height
                                                  font:_spinnerLabel1.font];

  // put the spinner slightly above the mid-line
  [_spinner centerHorizontally];
  [_spinner centerVerticallyWithOffset:(text_size.height == 0 ?
                                        0 : -(4*CLCG_PADDING))];

  [_spinnerLabel1 setW:SPINNER_TEXT_MAX_WIDTH];
  [_spinnerLabel1 setY:([_spinner low] + 2*CLCG_PADDING)];

  [_spinnerLabel1 setSz:text_size];
  [_spinnerLabel1 centerHorizontally];
  [_spinnerLabel1 setFrame:CGRectIntegral(_spinnerLabel1.frame)];

  [_spinnerLabel2 setY:([_spinnerLabel1 low] + CLCG_PADDING)];
  text_size = [_spinnerLabel2.text sizeWithMaxW:SPINNER_TEXT_MAX_WIDTH
                                           maxH:text_max_height
                                           font:_spinnerLabel2.font];
  [_spinnerLabel2 setSz:text_size];
  [_spinnerLabel2 setXForR:[_spinnerLabel1 r]];
  [_spinnerLabel2 setFrame:CGRectIntegral(_spinnerLabel2.frame)];
}


-(void)showLoadingView:(BOOL)show
{
  if (show) {
    // make sure to clean up previous error states messages (e.g. when we
    // re-request the page after a failure.)
    [self showEmptyMessage:nil];

    if (![[[self view] subviews] containsObject:_spinnerContainer]) {
      if (_spinnerContainer == nil) {
        [self createSpinnerView];
      }
      
      [[self view] addSubview:_spinnerContainer];
      UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification,
                                      nil);

      [_spinnerContainer setNeedsLayout];
    }

    [_spinner startAnimating];
    [[self view] bringSubviewToFront:_spinnerContainer];
  } else {
    [_spinner stopAnimating];

    // Only animate if the spinner needs to be removed. Otherwise,
    // showLoadingView:NO is idempotent.
    BOOL spinner_needs_removal = (self.spinnerContainer.superview != nil);
    if (spinner_needs_removal) {
      [UIView animateWithDuration:0.3 animations:^{
        self.spinnerContainer.alpha = 0.0;
      } completion:^(BOOL finished) {
        clcg_safe_remove_from_superview(self.spinnerContainer);
        // reset so that it's visible next time
        self.spinnerContainer.alpha = 1.0;
      }];
    }
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
  [self centerEmptyView];
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
#pragma mark - Empty / Error states view


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

      [mainview addSubview:_emptyContainer];
    }

    [_emptyLabel setText:msg];
    [_emptyLabel sizeToFitWidth:([mainview w] - CLCG_PADDING*2)];
    [_retryLabel setHidden:YES];

    [_emptyContainer setNeedsLayout];
    [self centerEmptyView];
    [mainview bringSubviewToFront:_emptyContainer];
  } else {
    clcg_safe_remove_from_superview(_emptyContainer);
  }
}


-(void)showErrorMessage:(NSString*)msg
{
  [self showEmptyMessage:msg];
  _retryLabel.hidden = NO;
}


-(void)centerEmptyView
{
  // height of 2 lines of text
  CGFloat two_lines_offset = 2*[@"Mj" sizeWithMaxW:[[self view] w]
                                              font:[_retryLabel font]].height;

  [_emptyLabel centerVerticallyWithOffset:-two_lines_offset];
  [_emptyLabel centerHorizontally];
  [_retryLabel centerHorizontally];
  [_retryLabel setY:ceil([_emptyLabel low] + two_lines_offset)];
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
  [self setLoadState:CLCG_OUTDATED];
  [super didReceiveMemoryWarning];
}


//------------------------------------------------------------------------------
#pragma mark - Rotation


// iOS >= 6
-(BOOL)shouldAutorotate
{
  return YES;
}


// iOS >= 6
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

