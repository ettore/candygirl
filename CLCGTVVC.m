/*
 Copyright (c) 2012, Ettore Pasquini
 Copyright (c) 2012, Cubelogic
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be
   used to endorse or promote products derived from this software without
   specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */


#import "CLCGTVVC.h"
#import "CLCGMoreCell.h"

#define CLCGTVVC_MORE_CID     @"CLCGTVVC_MORE_CID"

@implementation CLCGTVVC


@synthesize page = mPage;
@synthesize perPage = mPerPage;
@synthesize itemsTotal = mItemsTotal;
@synthesize itemsEnd = mItemsEnd;
@synthesize moreButtonText = mMoreButtonText;
@synthesize items = mItems;


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
  mPage = 1;
  mPerPage = -1; // pagination is disabled by default
}


//-----------------------------------------------------------------------------
#pragma mark - View creation


-(void)loadBaseView
{
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


-(void)viewDidLoad
{
  [super viewDidLoad];

  // necessary to avoid default striped background for grouped tableviews
  [mTableView setBackgroundView:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  switch ([self loadState]) {
    case CLCG_LOADING:
      [self showLoadingView:YES];
      break;
    default: {
      UITableView *tv = [self tableView];
      [self showLoadingView:NO];
      if ([tv indexPathForSelectedRow])
        [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:YES];
      break;
    }
  }
}


-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [mTableView flashScrollIndicators];
}


-(void)loadFromServerIfNeeded
{
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
  return (mItemsEnd < mItemsTotal && [ip row] == (NSInteger)[mItems count]);
}


//-----------------------------------------------------------------------------
#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip
{
  if ([self isMoreRow:ip] && [self supportsPagination]) {
    CLCGMoreCell *more;

    mPage++;
    [self setLoadState:CLCG_OUTDATED];
    [self loadFromServerIfNeeded];
    more = (CLCGMoreCell *)[self tableView:tv moreButtonCellForRow:ip];
    [more didStartRequestingMore];
  } else {
    [self tableView:tv didSelectNormalRow:ip];
  }
}


-(void)tableView:(UITableView*)tv didSelectNormalRow:(NSIndexPath*)ip
{
}


//-----------------------------------------------------------------------------
#pragma mark - UITableViewDataSource


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

