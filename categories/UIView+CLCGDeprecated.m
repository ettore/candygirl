//
//  UIView+CLCGDeprecated.m
//  Candygirl
//
//  Created by Ettore Pasquini on 12/17/15.
//  Copyright © 2015 Cubelogic. All rights reserved.
//

#import "UIView+CLCGDeprecated.h"

@implementation UIView (CLCGDeprecated)


-(CGFloat)x
{
  return [self frame].origin.x;
}


-(void)setX:(CGFloat)x
{
  CGRect r = [self frame];
  r.origin.x = round(x);
  [self setFrame:r];
}


-(CGFloat)y
{
  return [self frame].origin.y;
}


-(void)setY:(CGFloat)y
{
  CGRect r = [self frame];
  r.origin.y = round(y);
  [self setFrame:r];
}


-(CGFloat)w
{
  return [self frame].size.width;
}


-(void)setW:(CGFloat)w
{
  CGRect r = [self frame];
  r.size.width = round(w);
  [self setFrame:r];
}


-(CGFloat)h
{
  return [self frame].size.height;
}


-(void)setH:(CGFloat)h
{
  CGRect r = [self frame];
  r.size.height = round(h);
  [self setFrame:r];
}


-(CGFloat)r
{
  CGRect r = [self frame];
  return r.origin.x + r.size.width;
}


-(CGFloat)low
{
  CGRect r = [self frame];
  return r.origin.y + r.size.height;
}


@end
