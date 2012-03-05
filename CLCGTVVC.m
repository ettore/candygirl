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


//-----------------------------------------------------------------------------
#pragma mark - Init, dealloc, memory mgmt


-(void)dealloc
{
  CLCG_REL(mTableView);
  [super dealloc];
}


// if not created via nib file
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    mStyle = style;
  }
  return self;
}


- (void)viewDidUnload
{
  CLCG_REL(mTableView);
  [super viewDidUnload];
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


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [mTableView reloadData];
  [self deselectAll:NO];
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
