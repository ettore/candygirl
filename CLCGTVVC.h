//
//  CLCGTVVC.h
//  PostalChess
//
//  Created by e p on 3/5/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "CLCGVC.h"


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
  UITableViewStyle mStyle;
  UITableView *mTableView;
  enum CLCGLoadingState mLoadState;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,assign) enum CLCGLoadingState loadState;

// still the designated initializer. Defaults style to UITableViewStylePlain.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

// use this if you don't use a nib
-(id)initWithStyle:(UITableViewStyle)style;

// deselects all currently selected rows.
-(void)deselectAll:(BOOL)animated;

@end
