//
//  UIColor+CLCG.m
//  Candygirl
//  Created by Pasquini, Ettore on 11/7/13.
//

#import "UIColor+CLCG.h"


@implementation UIColor (CLCG)


- (UIColor *)lighterColor
{
  CGFloat h, s, b, a;

  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:MIN(b * 1.3, 1.0)
                           alpha:a];
  }

  return nil;
}


- (UIColor *)darkerColor
{
  CGFloat h, s, b, a;

  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:b * 0.75
                           alpha:a];
  }

  return nil;
}

@end
