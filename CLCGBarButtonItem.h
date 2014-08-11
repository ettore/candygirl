//
//  CLCGBarButtonItem.h
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//


typedef NS_ENUM(NSInteger, CLCGBarButtonItemState) {
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
 *
 *
 */
@interface CLCGBarButtonItem : UIBarButtonItem

@property(nonatomic) CLCGBarButtonItemState state;

-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
                          height:(CGFloat)h;

-(id)initWithTitle:(NSString *)title
             style:(UIBarButtonItemStyle)style
            target:(id)target
            action:(SEL)action
            height:(CGFloat)height;

-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)style
            target:(id)target
            action:(SEL)action
            height:(CGFloat)height;

-(UIActivityIndicatorView*)spinner;

@end
