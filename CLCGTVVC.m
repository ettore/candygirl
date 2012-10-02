//
//  CLCGTVVC.m
//  PostalChess
//
//  Created by e p on 3/5/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "CLCGTVVC.h"
#import "clcg_macros.h"

@implementation CLCGTVVC

@synthesize loadState = mLoadState;

//-----------------------------------------------------------------------------
#pragma mark - Init, dealloc, memory mgmt


// designated initializer
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    mStyle = UITableViewStylePlain;
    mLoadState = CLCG_NOT_LOADED;
  }
  return self;
}


-(id)initWithStyle:(UITableViewStyle)style
{
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    mStyle = style;
  }
  return self;
}


// this is called by the super class dealloc and viewDidUnload
-(void)releaseRetainedSubviews
{
  CLCG_REL(mTableView);
  [super releaseRetainedSubviews];
}


//-----------------------------------------------------------------------------
#pragma mark - View creation


-(void)loadView
{
  if ([self nibName]) {
    [super loadView];
    NSAssert(mTableView != nil, @"NIB file didn't set tableView.");
    return;
  }
  
  UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
  UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:mStyle];
  
  // set views to expand to all available area
  UIViewAutoresizing expandmask;
  expandmask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [v setAutoresizingMask:expandmask];
  [tv setAutoresizingMask:expandmask];
  
  // build view hierarchy
  [self setView:v];
  [self setTableView:tv];
  [v addSubview:tv];

  // cleanup
  [v release];
  [tv release];
}



//-----------------------------------------------------------------------------
#pragma mark - UITableView behavior


-(UITableView*)tableView
{
  return mTableView;
}


-(void)setTableView:(UITableView *)tv
{
  if (![mTableView isEqual:tv]) {
    [mTableView release];
    mTableView = [tv retain];
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
  }
}


-(void)deselectAll:(BOOL)animated
{
  NSArray *selips = [mTableView indexPathsForSelectedRows];
  for (NSIndexPath *ip in selips) {
    [mTableView deselectRowAtIndexPath:ip animated:animated];
  }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  [mTableView setEditing:editing animated:animated];
}



//-----------------------------------------------------------------------------
#pragma mark - UITableViewDataSource protocol


-(NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)section
{
  return 0;
}


-(UITableViewCell*)tableView:(UITableView*)tv 
       cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return nil;
}


@end
