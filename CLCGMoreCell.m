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
//  Created by Ettore Pasquini on 10/29/12.
//

#import "clcg_bundle_utils.h"
#import "clcg_macros.h"
#import "UIView+CLCG.h"
#import "CLCGMoreCell.h"


@implementation CLCGMoreCell
{
  UIActivityIndicatorView *_spinner;
}


// superclass designated initializer
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuse_id
{
  return [self initReusingId:reuse_id withText:CLCG_LOC(@"More...")];
}


// designated initializer
-(id)initReusingId:(NSString*)reuse_id
          withText:(NSString*)text
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
  if (self) {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_spinner];

    self.textLabel.numberOfLines = 1;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                       | UIViewAutoresizingFlexibleHeight);
    if (text == nil) {
      [_spinner startAnimating];
      self.textLabel.hidden = YES;
    } else {
      [_spinner setHidden:YES];
      [self.textLabel setText:text];
      [self.textLabel setFont:[UIFont boldSystemFontOfSize:18]];

      UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(didTap)];
      [self addGestureRecognizer:recognizer];

      // required to let the tap reach to the underlying tableview
      recognizer.cancelsTouchesInView = NO;
    }
  }

  return self;
}


-(void)didTap
{
  if (_spinner.isHidden) {
    [self showSpinner:YES];
  }
}


-(void)showSpinner:(BOOL)display_spinner
{
  [self.textLabel setHidden:display_spinner];
  [_spinner setHidden:!display_spinner];
  if (display_spinner) {
    [_spinner startAnimating];
  } else {
    [_spinner stopAnimating];
  }
  [self setNeedsLayout];
}


-(void)layoutSubviews
{
  [super layoutSubviews];

  [_spinner centerHorizontally];
  [_spinner centerVertically];

  [self.textLabel setW:([self w] - [self.textLabel x]*2)];
  [self.textLabel centerHorizontally];
  [self.textLabel centerVertically];
}


+(CGFloat)cellHeight
{
  return 50.0f; //TODO-XX
}


@end
