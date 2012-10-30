//
//  CLCGTVVC.m
//  PostalChess
//
//  Created by e p on 3/5/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//


#import "CLCGTVVC.h"
#import "CLCGMoreCell.h"


@implementation CLCGTVVC


@synthesize loadState = mLoadState;
@synthesize page = mPage;
@synthesize perPage = mPerPage;
@synthesize itemsTotal = mItemsTotal;
@synthesize itemsEnd = mItemsEnd;
@synthesize moreButtonText = mMoreButtonText;


//-----------------------------------------------------------------------------
#pragma mark - Init, dealloc, memory mgmt


-(void)dealloc
{
  CLCG_REL(mItems);
  CLCG_REL(mMoreButtonText);
  [super dealloc];
}


// this is called by the super class dealloc and viewDidUnload
-(void)releaseRetainedSubviews
{
  CLCG_REL(mTableView);
  [super releaseRetainedSubviews];
}


// designated initializer
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    mStyle = UITableViewStylePlain;
    [self doInitCore];
  }
  return self;
}


-(id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    mStyle = style;
    [self doInitCore];
  }
  return self;
}


-(void)doInitCore
{
  mLoadState = CLCG_NOT_LOADED;
  mPage = 1;
  mPerPage = -1; // pagination is disabled by default
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

  // necessary to avoid default striped background for grouped tableviews
  [tv setBackgroundView:nil];

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


-(BOOL)isMoreRow:(NSIndexPath*)ip
{
  return (mItemsEnd < mItemsTotal && [ip row] == [mItems count]);
}


-(UITableViewCell*)tableView:(UITableView*)tv moreButtonCellForRow:(NSIndexPath*)ip
{
  CLCGMoreCell *cell;

  cell = (CLCGMoreCell*)[tv dequeueReusableCellWithIdentifier:CLCGTVVC_MORE_CID];

  if (cell == nil) {
    cell = [[CLCGMoreCell alloc] initReusingId:CLCGTVVC_MORE_CID withText:mMoreButtonText];
    [cell autorelease];
  }

  if (mLoadState != CLCG_LOADING)
    [cell didStopRequestingMore];

  return cell;
}


//-----------------------------------------------------------------------------
#pragma mark - UITableViewDataSource protocol


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tv
{
  return 1;
}


-(NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)sect
{
  if (mItemsEnd < mItemsTotal && [self supportsPagination])
    return [mItems count] + 1; //for the "More..." button
  else
    return [mItems count];
}


-(UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)ip
{
  return nil;
}


//------------------------------------------------------------------------------
#pragma mark - Pagination Support


-(BOOL)supportsPagination
{
  return mPerPage > 0;
}


-(void)setSupportsPagination:(BOOL)flag
{
  mPerPage = (flag ? PER_PAGE_DEFAULT : -1);
}


@end

