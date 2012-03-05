//
//  CLCGVC.h
//  PostalChess
//
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSActivityView;

//@interface UIViewController(CLCGVC)
@interface CLCGVC : UIViewController
{
  // Tells if this view controller is currently displayed on the screen.
  // Apparently this may be superfluous, as it seems that evaluating
  // self.view.window could be enough to determine if the view is currently 
  // visible; our strategy seems more robust though.
  // http://stackoverflow.com/questions/3678180/how-to-check-if-a-specific-uiviewcontrollers-view-is-currently-visible/3681076#3681076
  BOOL mVisible;
}

/** Show spinny indicator with the message obtained from loadingMessage:. */
-(void)showSpinny;

/** Remove the spinny indicator if one was out, or do nothing otherwise. */
-(void)removeSpinny;

/** Subclasses should override this and return the appropriate loading message */
-(NSString*)loadingMessage;

-(UIView*)viewForActivityView;

@end


///////////////////////////////////////////////////////////////////////////////


@interface CLCGTableVC : UITableViewController
{
  BOOL mVisible;
}

/** Show spinny indicator with the message obtained from loadingMessage:. */
-(void)showSpinny;

/** Remove the spinny indicator if one was out, or do nothing otherwise. */
-(void)removeSpinny;

/** Subclasses should override this and return the appropriate loading message */
-(NSString*)loadingMessage;

-(UIView*)viewForActivityView;

@end
