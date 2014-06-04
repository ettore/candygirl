//
//  NSAttributedString+CLCG.m
//  Goodreads
//
//  Created by Pasquini, Ettore on 6/2/14.
//
//

#import "NSAttributedString+CLCG.h"

@implementation NSAttributedString (CLCG)


-(CGSize)sizeWithMaxW:(CGFloat)max_w
{
  return [self sizeWithMaxW:max_w maxH:clcg_screensize().height];
}


-(CGSize)sizeWithMaxW:(CGFloat)max_w maxH:(CGFloat)max_h
{
  if (max_h == 0.0f) {
    max_h = clcg_screensize().height;
  }

  NSDictionary *attrs = [self attributesAtIndex:0 effectiveRange:NULL];

  if (clcg_os_geq(@"7")) {
    return [[self string]
            boundingRectWithSize:CGSizeMake(max_w, max_h)
            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
            attributes:attrs
            context:nil].size;
  } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [[self string] sizeWithFont:attrs[NSFontAttributeName]
                     constrainedToSize:CGSizeMake(max_w, max_h)
                         lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
  }
}

@end
