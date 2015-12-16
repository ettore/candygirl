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


#import "NSArray+CLCG.h"


@implementation NSArray (Candygirl)


-(NSArray*)clcg_map:(id(^)(id item))block
{
  return [self clcg_map:block preserveLength:YES];
}


-(NSArray*)clcg_mapTrim:(id(^)(id item))block
{
  return [self clcg_map:block preserveLength:NO];
}


-(NSArray*)clcg_map:(id(^)(id item))block
     preserveLength:(BOOL)preserve_length
{
  NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];

  for (id item in self) {
    id new_item = block(item);
    if (new_item) {
      [a addObject:new_item];
    } else if (preserve_length) {
      [a addObject:[NSNull null]];
    }
  }

  return a;
}


-(id)clcg_reduce:(id)acc
           block:(id(^)(id current_acc, id item))block;
{
  for (id item in self) {
    acc = block(acc, item);
  }

  return acc;
}


@end
