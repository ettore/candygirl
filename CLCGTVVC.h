//
//  CLCGTVVC.h
//  PostalChess
//
//  Created by e p on 3/5/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "CLCGVC.h"


// used to deque cells in table-view
#define CLCGTVVC_CID          @"CLCGTVVC_CID"
#define CLCGTVVC_MORE_CID     @"CLCGTVVC_MORE_CID"

// default number of items to be loaded in table-view
#define PER_PAGE_DEFAULT  20


enum CLCGLoadingState {
  CLCG_NOT_LOADED,
  CLCG_LOADING,
  CLCG_LOADED,
  CLCG_OUTDATED,
  CLCG_LOAD_ERROR,
};

/**
 * Recreates the functionality of a UITableViewController, putting the 
 * tableView as a subview of [self view].
 */
@interface CLCGTVVC : CLCGVC<UITableViewDelegate,UITableViewDataSource>
{
  UITableViewStyle        mStyle;
  UITableView             *mTableView;
  enum CLCGLoadingState   mLoadState;

  // array containing the models of the table-view items.
  NSMutableArray          *mItems;

  // support for pagination. Disabled by default.
  int                     mPage;
  int                     mPerPage;
  int                     mItemsTotal; //total number of items
  int                     mItemsEnd;   //current number of items being displayed
  NSString                *mMoreButtonText;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,assign) enum CLCGLoadingState loadState;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int perPage;
@property(nonatomic,assign) BOOL supportsPagination;
@property(nonatomic,assign) int itemsTotal;
@property(nonatomic,assign) int itemsEnd;
@property(nonatomic,retain) NSString *moreButtonText;

// still the designated initializer. Defaults style to UITableViewStylePlain.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

// use this if you don't use a nib
-(id)initWithStyle:(UITableViewStyle)style;

// if a subclass does not use a nib file, you should call this method in your
// loadView implementation to create the base view structure (this includes
// a background view and a TableView on top of that. The reason why this is
// NOT done inside a local loadView implementation is because UIKit prohibits
// to override loadView if the actual class uses a nib file: since this is a
// base class and subclasses MIGHT use a nib file, we leave the task of actually
// building the views hierarchy up to the user (either as a nib or by calling
// loadBaseView inside the actual loadView implementation).
-(void)loadBaseView;

// deselects all currently selected rows.
-(void)deselectAll:(BOOL)animated;

-(UITableViewCell*)tableView:(UITableView*)tv moreButtonCellForRow:(NSIndexPath*)ip;

-(BOOL)isMoreRow:(NSIndexPath*)ip;

@end
