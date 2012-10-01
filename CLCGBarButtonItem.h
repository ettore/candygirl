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
  CLCGBarButtonItemStateReady,
  CLCGBarButtonItemStateBusy,
};


/**
 * A button item that can switch to a spinner if some activity (such as a 
 * network request) is being performed.
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
