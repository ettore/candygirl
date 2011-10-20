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
