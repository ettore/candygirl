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


#import "NSStringCategory.h"
#import "NSMutableCharacterSetCategory.h"


@implementation NSString (Candygirl)


-(NSString*)URLEncode
{
  NSString *s;
  
  s = NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                (
#if __has_feature(objc_arc)
                                                                 __bridge
#endif
                                                                 CFStringRef)self,
                                                                NULL, 
                                                                CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                kCFStringEncodingUTF8));
	if (s)
		return [s autorelease];
	else
    return @"";
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


-(NSString*)fixURLString
{
  NSString *result;
  NSRange range;
  
  result = [self trimwsnl];
  
  if (result == nil || [result isEqual:@""]) {
    result = @"";
  } else {
    // Note: if we try to open a URL w/ an unsupported scheme
    // such as `ttp://example.com', it returns:
    // LSOpenCFURLRef() returned -10814 for URL ttp://example.com
    range = [result rangeOfString:@"://" options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound)
      result = [@"http://" stringByAppendingString:result];
  }
  
  return result;
}


-(NSString*)shortenedName:(int)max_len
{
  int len = [self length];
  if (len <= max_len)
    return self;
  
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


@end

