//
//  NSAttributedString+CLCG.m
//  Goodreads
//
//  Created by Pasquini, Ettore on 6/2/14.
//
//

#import "NSAttributedString+CLCG.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (CLCG)


-(CGSize)sizeWithMaxW:(CGFloat)max_w
{
  return [self sizeWithMaxW:max_w maxH:CGFLOAT_MAX];
}


-(CGSize)sizeWithMaxW:(CGFloat)max_w maxH:(CGFloat)max_h
{
  if (max_h == 0.0f) {
    max_h = CGFLOAT_MAX;
  }

  CTFramesetterRef framesetter;
  framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);

  CGSize max_size = CGSizeMake(max_w, max_h);
  CGSize fit_size;
  fit_size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                          CFRangeMake(0, [self length]),
                                                          NULL, max_size, NULL);
  CFRelease(framesetter);
  return fit_size;
}

@end
