// Copyright (c) 2011, Goodreads
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

#import <Foundation/Foundation.h>
#import "clcg_str_utils.h"


BOOL clcg_str_eq(NSString *s, NSString *t)
{
  if (s == nil && t == nil)
    return YES;
  
  if (s)
    return [t isEqualToString:s];
  else
    return [s isEqualToString:t];
}


NSString *clcg_str_from(id data)
{
  NSString *s = nil;
  
  // we could use this helper function to return the contents of container 
  // classes (like NSData). The advantage of using this instead of a similar
  // method in a category is that we don't need to worry about types from the 
  // caller side.
  if ([data isKindOfClass:[NSData class]]) {
    s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [s autorelease];
  }
  
  return s;
}


NSString *clcg_str_trim(NSString *s)
{
	return [s stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


NSString *clcg_str_sub(NSString *s, unsigned max_len)
{
  if (s == nil)
    return @"";
  
  if (max_len > [s length])
    return s;
  
  return [[s substringToIndex:max_len] stringByAppendingString:@"..."];
}


BOOL clcg_str_isblank(NSString *s)
{
  if (s == nil || [s isEqualToString:@""])
    return YES;
  
  NSCharacterSet *whitesp = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  s = [s stringByTrimmingCharactersInSet:whitesp];
  return [s isEqualToString:@""];
}


NSString *clcg_str_addpossessive(NSString *s)
{
  NSArray *locs = [[NSBundle mainBundle] preferredLocalizations];
  if ([locs count] > 0 && [@"en" isEqualToString:[locs objectAtIndex:0]]) {
    unichar c = [s characterAtIndex:([s length] - 1)];
    if (c == 's' || c == 'z') 
      return [s stringByAppendingString:@"'"];
    else
      return [s stringByAppendingString:@"'s"];
  }
  return s;
}


NSString *clcg_str_firstword(NSString *s)
{
  NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSArray *a = [s componentsSeparatedByCharactersInSet:cs];
  return [a objectAtIndex:0];
}


NSString *clcg_str_capitalize_firstword(NSString *s)
{
  return [s stringByReplacingCharactersInRange:NSMakeRange(0,1) 
                                    withString:[[s substringToIndex:1] uppercaseString]];
}

