//
//  CLCGVC.h
//  PostalChess
//
//  Created by Ettore Pasquini on 5/4/11.
//  Copyright 2011 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLCGVC : UIViewController
{
  UIView                        *mSpinnerContainer;
  UIActivityIndicatorView       *mSpinner;
  UIActivityIndicatorViewStyle  mSpinnerStyle;
  UIColor                       *mSpinnerBackgroundColor;
}

@property(nonatomic,retain) IBOutlet UIView *spinnerContainer;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic) UIActivityIndicatorViewStyle  spinnerStyle;
@property(nonatomic,retain) UIColor *spinnerBackgroundColor;

/** 
 * If show == YES, shows and aligns the spinny indicator to the center 
 * of the screen. 
 * If show == NO, removes the spinny indicator if it was displayed, or do 
 * nothing otherwise.
 */
-(void)showLoadingView:(BOOL)show;

@end
