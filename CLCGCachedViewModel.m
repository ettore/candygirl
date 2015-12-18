// Copyright (c) 2012, Ettore Pasquini
// Copyright (c) 2012, Cubelogic
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  Created by Pasquini, Ettore on 8/24/14.
//

#import "UIView+CLCG.h"
#import "CLCGCachedViewModel.h"
#import "NSAttributedString+CLCG.h"
#import "NSString+CLCG.h"

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
      CGFloat h = ceil([s clcg_sizeWithMaxW:w].height);
      h *= line_limit;
      text_size = [attr_str clcg_sizeWithMaxW:w maxH:h];
    } else {
      text_size = [attr_str clcg_sizeWithMaxW:w];
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
    const CGFloat h = ceil([view clcg_textHForW:w
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
  return [NSString stringWithFormat:@"%lu-%.2f-%lu",
          (unsigned long)[attr_str hash], w, (unsigned long)line_limit];
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
    text_hash = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)[text hash],
                 (unsigned long)[font hash]];
  } else {
    text_hash = [NSString stringWithFormat:@"%lu", (unsigned long)[view hash]];
  }

  return [NSString stringWithFormat:@"%@-%.2f-%lu", text_hash, w, (unsigned long)line_limit];
}

@end
