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
//  Created by Ettore Pasquini on 10/31/12.
//


#import "CLCGModel.h"


@implementation CLCGModel : NSObject

@synthesize searchable = mSearchable;


-(id)copyWithZone:(NSZone*)zone
{
  CLCGModel *copy = [[[self class] allocWithZone:zone] init];
  [copy setSearchable:[self searchable]];
  return copy;
}


/**
 * Returns YES if this user matches all the input words.
 * NB: Each word must be a lowercase string.
 */
-(BOOL)containsWords:(NSArray*)words
{
  if (mSearchable == nil) {
    return NO;
  }

  for (NSString *w in words) {
    NSRange r = [mSearchable rangeOfString:w options:NSCaseInsensitiveSearch];
    if (r.location == NSNotFound)
      return NO;
  }
  return YES;
}


-(BOOL)containsPrefix:(NSString*)prefix
{
  NSArray *words = [mSearchable componentsSeparatedByCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];

  for (NSString *w in words) {
    if ([w hasPrefix:prefix]) {
      return YES;
    }
  }
  return NO;
}



-(BOOL)matches:(NSPredicate*)pred
{
  return [pred evaluateWithObject:mSearchable];
}


@end
