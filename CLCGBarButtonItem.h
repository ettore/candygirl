//
//  CLCGBarButtonItem.h
//  PostalChess
//
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLCGTogglerView.h"


enum CLCGBarButtonItemState {
  CLCGBarButtonItemStateReady = 1,
  CLCGBarButtonItemStateBusy,
  CLCGBarButtonItemStateHidden,
};


/**
 * A button item that can switch to 3 possible states:
 *  - Ready: The normal behavior. If an image was used to create the button,
 *           the image will be used and the title and style are ignored. If
 *           the image is nil, the receiver will be displayed as a normal
 *           UIBarButtonItem, using its style and title.
 *  - Busy: An activity indicator (spinner) will be displayed.
 *  - Hidden: The button is hidden and nothing is visible/tappable.
 */
@interface CLCGBarButtonItem : UIBarButtonItem
{
  CLCGTogglerView *mToggler;
  enum CLCGBarButtonItemState mState;
}

@property(nonatomic,assign) enum CLCGBarButtonItemState state;

- (id)initWithTitle:(NSString *)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)height;

-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)style
            target:(id)target
            action:(SEL)action
            height:(CGFloat)height;

@end
