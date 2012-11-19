//
//  CLCGTogglerView.h
//  PostalChess
//
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CLCGTogglerState {
  CLCGTogglerFirstView,
  CLCGTogglerSecondView,
};

/**
 * A view that toggles between 2 subviews depending on state.
 * the 2 subviews take up the whole space (frames coincide).
 */
@interface CLCGTogglerView : UIView
{
  UIView *mFirstView;
  UIView *mSecondView;
  enum CLCGTogglerState mState;
}

@property(nonatomic,retain) UIView *firstView;
@property(nonatomic,retain) UIView *secondView;
@property(nonatomic,assign) enum CLCGTogglerState state;

/** By default, the receiver is condfigured to show the first view. */
- (id)initWithFrame:(CGRect)frame;

@end
