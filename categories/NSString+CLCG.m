/*
 Copyright (c) 2012, Ettore Pasquini
 Copyright (c) 2012, Cubelogic
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be
 used to endorse or promote products derived from this software without
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */


#import "NSString+CLCG.h"
#import "NSMutableCharacterSet+CLCG.h"
#import "clcg_viewport.h"
#import "clcg_device_utils.h"


@implementation NSString (Candygirl)


-(NSString*)ellipsisized
{
  return [self ellipsisized:150];
}


-(NSString*)ellipsisized:(NSUInteger)maxlen
{
  NSString *s;

  s = [self HTMLStripped];
  if ([s length] > maxlen)
    s = [[s substringToIndex:maxlen] stringByAppendingString:@"..."];

  return s;
}


//
// TODO
// we should have a more systematic approach to this, perhaps using
// a dictionary with all entities, something like:
// https://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/Foundation/GTMNSString%2BHTML.m
//
-(NSString*)HTMLDecoded
{
	return [[[[[[self
               stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"]
              stringByReplacingOccurrencesOfString: @"&quot;" withString: @"\""]
             stringByReplacingOccurrencesOfString: @"&#39;" withString: @"'"]
            stringByReplacingOccurrencesOfString: @"&gt;" withString: @">"]
           stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"]
          stringByReplacingOccurrencesOfString: @"&nbsp;" withString: @" "];
}


-(NSString*)HTMLEncoded
{
	return [[[[[self
              stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
             stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
            stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"]
           stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
          stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
}


-(NSString*)HTMLStripped
{
  NSScanner *scanner;
  NSString *text = nil, *s = self;

  scanner = [NSScanner scannerWithString:self];

  while ([scanner isAtEnd] == NO) {

    // find start of tag
    [scanner scanUpToString:@"<" intoString:NULL];

    // find end of tag
    [scanner scanUpToString:@">" intoString:&text] ;

    // replace the found tag with a space
    //(you can filter multi-spaces out later if you wish)
    text = [NSString stringWithFormat:@"%@>", text];
    s = [s stringByReplacingOccurrencesOfString:text withString:@" "];
  }

  return [s HTMLDecoded];
}


-(NSString*)URLEncode
{
  CFStringRef s;

  s = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                              (__bridge CFStringRef)self,
                                              NULL,
                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                              kCFStringEncodingUTF8);
  NSString *nss = CFBridgingRelease(s);
	if (nss) {
		return nss;
	} else {
    return @"";
  }
}


-(NSString*)trimws
{
  return [self stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceCharacterSet]];
}


-(NSString*)trimwsnl
{
  return [self stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(NSString*)trimAfterFirstOccurrence:(NSString*)search_str
{
  NSRange range;

  range = [self rangeOfString:search_str];
  if (range.location == NSNotFound) {
    return self;
  } else {
    return [self substringToIndex:range.location];
  }
}


-(NSString*)fixURLString
{
  NSString *result;
  NSRange range;
  
  result = [self trimwsnl];
  
  if (result == nil || [result isEqualToString:@""]) {
    result = @"";
  } else {
    // Note: if we try to open a URL w/ an unsupported scheme
    // such as `ttp://example.com', it returns:
    // LSOpenCFURLRef() returned -10814 for URL ttp://example.com
    range = [result rangeOfString:@"://" options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound) {
      result = [@"http://" stringByAppendingString:result];
    }
  }
  
  return result;
}


-(NSString*)shortenedName:(NSUInteger)max_len
{
  NSUInteger len = [self length];
  if (len <= max_len) {
    return self;
  }
  
  NSCharacterSet *charset = [NSMutableCharacterSet punctSpaces];
  NSString *trimmed = [self stringByTrimmingCharactersInSet:charset];
  if ([trimmed length] == 0)
    return [self substringToIndex:max_len];
  
  NSArray *pieces = [trimmed componentsSeparatedByCharactersInSet:charset];
  trimmed = [pieces objectAtIndex:0];
  
  // concede tolerance of 2 extra chars, if still longer, truncate
  len = [trimmed length];
  if (len > max_len + 2)
    return [trimmed substringToIndex:max_len];
  
  return trimmed;
}

#ifndef CLCG_APP_EXTENSIONS

-(CGSize)sizeWithMaxW:(CGFloat)max_w
                 font:(UIFont*)font
{
  return [self sizeWithMaxW:max_w
                       maxH:CGFLOAT_MAX
                       font:font];
}


-(CGSize)sizeWithMaxW:(CGFloat)max_w
                 maxH:(CGFloat)max_h
                 font:(UIFont*)font
{
  return [self sizeWithMaxW:max_w
                       maxH:max_h
                       font:font
             paragraphStyle:[NSParagraphStyle defaultParagraphStyle]];
}


-(CGSize)sizeWithMaxW:(CGFloat)max_w
                 maxH:(CGFloat)max_h
                 font:(UIFont*)font
       paragraphStyle:(NSParagraphStyle*)style
{
  if ([self length] == 0) {
    return CGSizeZero;
  }

  if (max_h == 0.0f) {
    max_h = clcg_screensize().height;
  }

  if (clcg_os_geq(@"7")) {
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] initWithCapacity:2];
    attrs[NSParagraphStyleAttributeName] = style;
    if (font) {
      attrs[NSFontAttributeName] = font;
    }

    return [self
            boundingRectWithSize:CGSizeMake(max_w, max_h)
            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
            attributes:attrs
            context:nil].size;
  } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(max_w, max_h)
                lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
  }
}

#endif

@end

