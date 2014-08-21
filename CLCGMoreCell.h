//
//  CLCGMoreCell.h
//  Created by Ettore Pasquini on 10/29/12.
//


/*! 
 @class
 
 @description
 This cell renders a centered "Load More" text along with a spinner once 
 loading begins. It is possible to configure the cell to always display the
 spinner, for use cases like infinite scrolling.
 */
@interface CLCGMoreCell : UITableViewCell

/*! 
 Designated initializer.
 @param reuse_id  The tableview reuse identifier.
 @param text THe text to be displayed (e.g. "Load More") or nil to
 always display the spinner.
 */
-(id)initReusingId:(NSString*)reuse_id
          withText:(NSString*)text;

// the More cell height is constant
+(CGFloat)cellHeight;

-(void)showSpinner:(BOOL)display_spinner;

@end

