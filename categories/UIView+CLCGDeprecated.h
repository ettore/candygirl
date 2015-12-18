//
//  UIView+CLCGDeprecated.h
//  Candygirl
//
//  Created by Ettore Pasquini on 12/17/15.
//  Copyright © 2015 Cubelogic. All rights reserved.
//


/*!
 The names of these methods lack the `clcg` prefix found in all other category
 methods, so they may lead to name clashing.

 They are left here for legacy support and for the convenience their
 shortness brings.
 */
@interface UIView (CLCGDeprecated)

-(CGFloat)x;
-(void)setX:(CGFloat)x;

-(CGFloat)y;
-(void)setY:(CGFloat)y;

-(CGFloat)w;
-(void)setW:(CGFloat)w;

-(CGFloat)h;
-(void)setH:(CGFloat)h;

/*! The ordinate position below this view, i.e. Y + Height. */
-(CGFloat)low;

/*! The abscissa position at the right of this view, i.e. X + Width. */
-(CGFloat)r;

@end
