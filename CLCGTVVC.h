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


#import "CLCGVC.h"


/*! Default number of items to be loaded in table-view. */
#define PER_PAGE_DEFAULT  20


/*!
 @abstract Recreates the functionality of a UITableViewController and adds 
    handling of content downloaded from the network.
 @discussion This view controller creates and configures the tableview 
    programmatically, handles showing a "currently loading" spinner screen,
    adds pagination support. By default, only one section is supported.
 @note This class puts the tableView as a subview of [self view] making
    it easy to swap it out while downloading content from the net.
 */
@interface CLCGTVVC : CLCGVC<UITableViewDelegate,UITableViewDataSource>
{
  UITableViewStyle        mStyle;
  UITableView             *mTableView;

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
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int perPage;
@property(nonatomic,assign) BOOL supportsPagination; /*! Disabled by default */
@property(nonatomic,assign) int itemsTotal;
@property(nonatomic,assign) int itemsEnd;
@property(nonatomic,retain) NSString *moreButtonText;
@property(nonatomic,retain,readonly) NSMutableArray *items;

/*! Still the designated initializer. Defaults style to UITableViewStylePlain. */
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

/*! Use this if you don't use a nib. */
-(id)initWithStyle:(UITableViewStyle)style;

/*!
 If a subclass does not use a nib file, you should call this method in your
 loadView implementation to create the base view structure (this includes
 a background view and a TableView on top of that. The reason why this is
 NOT done inside a local loadView implementation is because UIKit prohibits
 to override loadView if the actual class uses a nib file: since this is a
 base class and subclasses MIGHT use a nib file, we leave the task of actually
 building the views hierarchy up to the user (either as a nib or by calling
 loadBaseView inside the actual loadView implementation).
 */
-(void)loadBaseView;

/*! 
 @discussion Subclasses should override this method and initiate here any
    asynchronous server side call. The default implementation does nothing.
 */
-(void)loadFromServerIfNeeded;

/*! Deselects all currently selected rows. */
-(void)deselectAll:(BOOL)animated;

/*! 
 Creates a standard "More..." CLCGMoreCell using @link moreButtonText @/link 
 as its text. 
 */
-(UITableViewCell*)tableView:(UITableView*)tv moreButtonCellForRow:(NSIndexPath*)ip;

/*! 
 @discussion Handles loading the next page in case pagination is supported
  and the user tapped on the "more" row, otherwise calls
  @link tableView::didSelectNormalRow: @/link
 */
-(void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip;

/*!  Does nothing by default. */
-(void)tableView:(UITableView*)tv didSelectNormalRow:(NSIndexPath*)ip;

-(BOOL)isMoreRow:(NSIndexPath*)ip;

@end
