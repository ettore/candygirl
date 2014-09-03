//
//  CLCGCachedViewModel.m
//  Cubelogic
//
//  Created by Pasquini, Ettore on 8/24/14.
//

#import "CLCGUIViewCategory.h"
#import "CLCGCachedViewModel.h"
#import "NSAttributedString+CLCG.h"
#import "CLCGNSStringCategory.h"

@interface CLCGCachedViewModel ()
@property(nonatomic,strong) NSMutableDictionary *cache;
@end

@implementation CLCGCachedViewModel

-(id)init
{
  self = [super init];

  if (self) {
    _cache = [[NSMutableDictionary alloc] init];
  }

  return self;
}


-(CGFloat)cachedHeightForAttributedString:(NSAttributedString*)attr_str
                                    width:(CGFloat)w
                                lineLimit:(NSUInteger)line_limit
{
  NSString *key = [self hashKeyForAttributedString:attr_str
                                             width:w
                                         lineLimit:line_limit];
  NSNumber *val = [_cache objectForKey:key];

  if (val == nil && [attr_str length] > 0) {
    CGSize text_size;
    if (line_limit > 0){
      NSAttributedString *s = [attr_str attributedSubstringFromRange:
                               NSMakeRange(0,1)];
      CGFloat h = ceil([s sizeWithMaxW:w].height);
      h *= line_limit;
      text_size = [attr_str sizeWithMaxW:w maxH:h];
    } else {
      text_size = [attr_str sizeWithMaxW:w];
    }

    val = @(text_size.height);
    [_cache setObject:val forKey:key];
  }

  return [val floatValue];
}


-(CGFloat)cachedTextHeightForSubview:(UIView*)view
                               width:(CGFloat)w
                       useAttributed:(BOOL)use_attributed
                           lineLimit:(NSUInteger)line_limit
{
  NSString *key = [self hashKeyForSubview:view
                                    width:w
                            useAttributed:use_attributed
                                lineLimit:line_limit];
  NSNumber *val = [_cache objectForKey:key];

  if (val == nil) {
    const CGFloat h = ceil([view textHeightForWidth:w
                                      useAttributed:use_attributed
                                          lineLimit:line_limit]);
    val = @(h);
    if ([self shouldCacheForSubview:view useAttributed:use_attributed]) {
      [_cache setObject:val forKey:key];
    }
  }

  return [val floatValue];
}


-(BOOL)shouldCacheForSubview:(UIView*)view
               useAttributed:(BOOL)use_attributed
{
  if (use_attributed && [view respondsToSelector:@selector(attributedText)]) {
    NSAttributedString *attr_text = [(id)view attributedText];
    return [attr_text length] > 0;
  } else if ([view respondsToSelector:@selector(text)]
             && [view respondsToSelector:@selector(font)]) {
    return ([[(id)self text] length] > 0);
  } else {
    return NO;
  }
}


-(NSString*)hashKeyForAttributedString:(NSAttributedString*)attr_str
                                 width:(CGFloat)w
                             lineLimit:(NSUInteger)line_limit
{
  return [NSString stringWithFormat:@"%u-%.2f-%u", [attr_str hash], w, line_limit];
}


-(NSString*)hashKeyForSubview:(UIView*)view
                        width:(CGFloat)w
                useAttributed:(BOOL)use_attributed
                    lineLimit:(NSUInteger)line_limit
{
  NSString *text_hash;
  if (use_attributed && [view respondsToSelector:@selector(attributedText)]) {
    return [self hashKeyForAttributedString:[(id)view attributedText]
                                      width:w
                                  lineLimit:line_limit];
  } else if ([view respondsToSelector:@selector(text)]
             && [view respondsToSelector:@selector(font)]) {
    NSString *text = [(id)self text];
    UIFont *font = [(id)self font];
    text_hash = [NSString stringWithFormat:@"%u-%u", [text hash], [font hash]];
  } else {
    text_hash = [NSString stringWithFormat:@"%u", [view hash]];
  }

  return [NSString stringWithFormat:@"%@-%.2f-%u", text_hash, w, line_limit];
}

@end
