//
//  UILabelCategory.m
//  Goodreads
//
//  Created by Ettore Pasquini on 6/4/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "CLCGUILabelCategory.h"
#import "CLCGUIViewCategory.h"


@implementation UILabel (Candygirl)


-(void)sizeToFitWidth:(CGFloat)w
{
  CGSize sz;

  sz = CGSizeMake(w, INT_MAX);
  sz = [[self text] sizeWithFont:[self font] constrainedToSize:sz];

  [self setW:sz.width];
  [self setH:sz.height];
}


-(void)resizeHeightForText
{
  return [self resizeHeightForText:[self text] font:[self font]];
}


@end

