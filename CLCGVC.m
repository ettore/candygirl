//  CLCGVC.m
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.

#import "clcg_debug.h"

#import "DSActivityView.h"

#import "CLCGVC.h"

////////////////////////////////////////////////////////////////////////////////

static void removeSpinny()
{
  //TODO also look at DSActivityView::removeViewAnimated:YES
  [DSActivityView removeView];
}


static NSString *loadingMessage()
{
  return CLLocalized(@"Loading...");
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation CLCGVC

-(UIView*)viewForActivityView
{
  return [self view];
}


// adds the activity view to our view: subclasses will have release it at the
// appropriate time (e.g. when we the server responds back) by calling 
// removeSpinny
-(void)showSpinny 
{ 
  UIView *v = [self viewForActivityView];
  
  // if clients changed the view-for-act-view (v!=self.view) we're going to 
  // trust them and always display the activity view
  if (mVisible || v != [self view])
    [DSBezelActivityView newActivityViewForView:v
                                      withLabel:[self loadingMessage]];
}


-(void)removeSpinny 
{
  removeSpinny();
}


-(NSString*)loadingMessage
{
  return loadingMessage();
}


-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  mVisible = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  mVisible = NO;
}

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation CLCGTableVC

-(UIView*)viewForActivityView
{
  return [self view];
}


// adds the activity view to our view: subclasses will have release it at the
// appropriate time (e.g. when we the server responds back) by calling 
// removeSpinny
-(void)showSpinny 
{ 
  UIView *v = [self viewForActivityView];
  
  // if clients changed the view-for-act-view (v!=self.view) we're going to 
  // trust them and always display the activity view
  if (mVisible || v != [self view])
    [DSBezelActivityView newActivityViewForView:v
                                      withLabel:[self loadingMessage]];
}


-(void)removeSpinny 
{
  removeSpinny();
}


-(NSString*)loadingMessage 
{
  return loadingMessage();
}


-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  mVisible = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  mVisible = NO;
}


@end
