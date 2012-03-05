//
//  CLCGTVVC.h
//  PostalChess
//
//  Created by e p on 3/5/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "CLCGVC.h"


/**
 * Recreates the functionality of a UITableViewController, putting the 
 * tableView as a subview of [self view].
 */
@interface CLCGTVVC : CLCGVC<UITableViewDelegate,UITableViewDataSource>
{
  UITableViewStyle mStyle;
  UITableView *mTableView;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;

// if not created via nib file
- (id)initWithStyle:(UITableViewStyle)style;

// deselects all currently selected rows.
-(void)deselectAll:(BOOL)animated;

@end
