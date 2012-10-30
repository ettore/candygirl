//
//  CLCGMoreCell.h
//  Goodreads
//
//  Created by Ettore Pasquini on 10/29/12.
//
//


@interface CLCGMoreCell : UITableViewCell
{
  UIActivityIndicatorView *mSpinner;
}

// designated initializer
-(id)initReusingId:(NSString*)reuse_id withText:(NSString*)text;

// uses "More..." as default text
-(id)initReusingId:(NSString*)reuse_id;

// the More cell height is constant
+(CGFloat)cellHeight;

-(void)didStartRequestingMore;
-(void)didStopRequestingMore;

@end

