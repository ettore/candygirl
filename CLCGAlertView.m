// Copyright (c) 2011, Ettore Pasquini
// Copyright (c) 2011, Cubelogic
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

#import "CLCGAlertView.h"
#import "clcg_bundle_utils.h"

@implementation CLCGAlertView 


#if NS_BLOCKS_AVAILABLE

-(void)dealloc
{
  [self setBlock:nil];
#if !__has_feature(objc_arc)
  [super dealloc];
#endif
}

-(id)initWithTitle:(NSString *)t
           message:(NSString *)m
             block:(void (^)(NSInteger btn))block
{
  self = [super initWithTitle:t 
                      message:m 
                     delegate:self
            cancelButtonTitle:CLCG_LOC(@"OK")
            otherButtonTitles:nil];
  
  if (self) {
    [self setBlock:block];
  }
  
  return self;
}


-(id)initWithTitle:(NSString *)t
           message:(NSString *)m
             block:(void (^)(NSInteger btn))block
 cancelButtonTitle:(NSString *)cancel_btn_title
 otherButtonTitles:(NSString *)other_btn_title, ... NS_REQUIRES_NIL_TERMINATION
{
  NSMutableArray *buttons = [[NSMutableArray alloc] init];

  if (other_btn_title) {
    va_list args;
    va_start(args, other_btn_title);
    id arg = nil;

    while ((arg = va_arg(args,id))) {
      [buttons addObject:arg];
    }

    va_end(args);
  }

  self = [super initWithTitle:t
                      message:m
                     delegate:self
            cancelButtonTitle:cancel_btn_title
            otherButtonTitles:nil];

  if (self) {
    if (other_btn_title) {
      [self addButtonWithTitle:other_btn_title];
    }
    for (NSString *title in buttons) {
      [self addButtonWithTitle:title];
    }
    [self setBlock:block];
  }

#if !__has_feature(objc_arc)
  // cleanup
  [buttons release];
#endif
  
  return self;
}


-(void)alertView:(UIAlertView*)av clickedButtonAtIndex:(NSInteger)btn
{
  if (_block)
    _block(btn);
}

#endif

@end

