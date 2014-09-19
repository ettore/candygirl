//
//  NSAttributedString+CLCG.m
//  Goodreads
//
//  Created by Pasquini, Ettore on 6/2/14.
//

#import <tgmath.h>
#import "NSAttributedString+CLCG.h"

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

  NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin
                                    |NSStringDrawingTruncatesLastVisibleLine
                                    |NSStringDrawingUsesFontLeading);

  CGSize size = [self boundingRectWithSize:CGSizeMake(max_w, max_h)
                                   options:options
                                   context:nil].size;
  return (CGSize){
    .height = ceil(size.height),
    .width = ceil(size.width)
  };
}

@end
