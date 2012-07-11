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


#import <UIKit/UIKit.h>

@interface CLCGAlertView : UIAlertView <UIAlertViewDelegate>
{
#if NS_BLOCKS_AVAILABLE
  void (^mBlock)(NSInteger btn);
#endif
}

#if NS_BLOCKS_AVAILABLE
-(id)initWithTitle:(NSString *)t
           message:(NSString *)m
             block:(void (^)(NSInteger btn))block;

- (id)initWithTitle:(NSString *)t
            message:(NSString *)message
              block:(void (^)(NSInteger btn))clicked_btn_block
  cancelButtonTitle:(NSString *)cancelButtonTitle 
  submitButtonTitle:(NSString *)submitButtonTitle;
//  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(id)initWithTitle:(NSString *)t
           message:(NSString *)m
             block:(void (^)(NSInteger btn))block
 cancelButtonTitle:(NSString *)cancel_btn_title
 submitButtonTitle:(NSString *)submit_btn_title
  otherButtonTitle:(NSString *)other_btn_title;
#endif

@end
