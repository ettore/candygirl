//
//  UILabelCategory.m
//  Goodreads
//
//  Created by Ettore Pasquini on 6/4/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "UILabelCategory.h"
#import "UIViewCategory.h"

@implementation UILabel (Candygirl)

-(void)resizeHeightForText
{
  return [self resizeHeightForText:[self text] font:[self font]];
}

@end
