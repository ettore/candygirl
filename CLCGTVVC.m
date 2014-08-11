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
#import "clcg_device_utils.h"
#import "clcg_viewport.h"
#import "CLCGUIViewControllerCategory.h"


#define CLCGTVVC_MORE_CID     @"CLCGTVVC_MORE_CID"

@implementation CLCGTVVC
{
  UITableViewStyle        _style;
}


@synthesize tableView = _tableView;


//-----------------------------------------------------------------------------
#pragma mark - Init, dealloc, memory mgmt


// this is called by the super class dealloc and viewDidUnload
-(void)releaseRetainedSubviews
{
  // avoid "message sent to deallocated instance" errors on iOS 7
  [_tableView setDelegate:nil];
  [_tableView setDataSource:nil];

  [super releaseRetainedSubviews];
}


// designated initializer
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _style = UITableViewStylePlain;
    [self doInitCore];
  }
  return self;
}


-(id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _style = style;
    [self doInitCore];
  }
  return self;
}


-(void)doInitCore
{
  _items = [[NSMutableArray alloc] init];
  _page = 1;
  _perPage = -1; // pagination is disabled by default
}


//-----------------------------------------------------------------------------
#pragma mark - View creation


-(void)loadBaseView
{
  UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
  UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero style:_style];
  
  // set views to expand to all available area
  UIViewAutoresizing expandmask;
  expandmask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [v setAutoresizingMask:expandmask];
  [tv setAutoresizingMask:expandmask];

  // build view hierarchy
  [self setView:v];
  [self setTableView:tv];
  [v addSubview:tv];
}


-(void)viewDidLoad
{
  [super viewDidLoad];
  
  CGFloat left_inset;

  if ([_tableView style] == UITableViewStyleGrouped) {
    // necessary to avoid default striped background for grouped tableviews
    [_tableView setBackgroundView:nil];
    left_inset = CLCG_PADDING;
  } else {
    left_inset = 0.0f;
  }
  
  if (clcg_os_geq(@"7")) {
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, left_inset, 0, 0)];
  }

  // This is needed to suppress extra table separators which appear if there
  // aren't many rows in the tableview.
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if ([self loadState] != CLCG_LOADING) {
    UITableView *tv = [self tableView];
    if ([tv indexPathForSelectedRow])
      [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:YES];
  }
}


-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [_tableView flashScrollIndicators];
}


//-----------------------------------------------------------------------------
#pragma mark - UITableView behavior


-(UITableView*)tableView
{
  return _tableView;
}


-(void)setTableView:(UITableView *)tv
{
  if (![_tableView isEqual:tv]) {
    _tableView = tv;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
  }
}


-(void)deselectAll:(BOOL)animated
{
  NSArray *selected_ips = [_tableView indexPathsForSelectedRows];
  for (NSIndexPath *ip in selected_ips) {
    [_tableView deselectRowAtIndexPath:ip animated:animated];
  }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  [_tableView setEditing:editing animated:animated];
}


-(BOOL)isMoreRow:(NSIndexPath*)ip
{
  return (_itemsEnd < _itemsTotal && [ip row] == (NSInteger)[_items count]);
}


-(void)reload
{
  self.page = 1;
  [self.items removeAllObjects];
  [super reload];
}


//-----------------------------------------------------------------------------
#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip
{
  if ([self isMoreRow:ip] && [self supportsPagination]) {
    CLCGMoreCell *more;

    _page++;
    [self setLoadState:CLCG_OUTDATED];
    [self loadFromServerIfNeeded];
    more = (CLCGMoreCell *)[self tableView:tv moreButtonCellForRow:ip];
    [more didStartRequestingMore];
    [tv deselectRowAtIndexPath:ip animated:YES];
  } else {
    [self tableView:tv didSelectNormalRow:ip];
  }
}


-(void)tableView:(UITableView*)tv didSelectNormalRow:(NSIndexPath*)ip
{
}


-(CGFloat)tableView:(UITableView*)tv heightForRowAtIndexPath:(NSIndexPath*)ip
{
  CGFloat h;

  if ([self isMoreRow:ip] && [self supportsPagination]) {
    h = [CLCGMoreCell cellHeight];
  } else {
    h = [self tableView:tv heightForNormalRowAtIndexPath:ip];
  }

  return h;
}


-(CGFloat)tableView:(UITableView*)tv heightForNormalRowAtIndexPath:(NSIndexPath*)ip
{
  return tv.rowHeight;
}


//-----------------------------------------------------------------------------
#pragma mark - UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tv
{
  return 1;
}


-(NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)sect
{
  if (_itemsEnd < _itemsTotal && [self supportsPagination]) {
    return [_items count] + 1; //for the "More..." button
  } else {
    return [_items count];
  }
}


-(UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)ip
{
  if ([self isMoreRow:ip] && [self supportsPagination]) {
    return [self tableView:tv moreButtonCellForRow:ip];
  } else {
    return [self tableView:tv normalCellForRowAtIndexPath:ip];
  }
}


-(UITableViewCell*)tableView:(UITableView*)tv
 normalCellForRowAtIndexPath:(NSIndexPath*)ip
{
#ifdef DEBUG
  [NSException raise:NSInternalInconsistencyException
              format:@"You forgot to override tableView:normalCellForRowAtIndexPath:"];
#endif
  return nil;
}


-(UITableViewCell*)tableView:(UITableView*)tv moreButtonCellForRow:(NSIndexPath*)ip
{
  CLCGMoreCell *cell;

  cell = (CLCGMoreCell*)[tv dequeueReusableCellWithIdentifier:CLCGTVVC_MORE_CID];

  if (cell == nil) {
    cell = [[CLCGMoreCell alloc] initReusingId:CLCGTVVC_MORE_CID
                                      withText:_moreButtonText];
  }

  if (self.loadState != CLCG_LOADING)
    [cell didStopRequestingMore];

  return cell;
}


//------------------------------------------------------------------------------
#pragma mark - Pagination Support


-(BOOL)supportsPagination
{
  return _perPage > 0;
}


-(void)setSupportsPagination:(BOOL)flag
{
  _perPage = (flag ? PER_PAGE_DEFAULT : -1);
}


@end

