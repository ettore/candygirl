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
//  Created by Ettore Pasquini on 9/29/12.
//


typedef NS_ENUM(NSInteger, CLCGBarButtonItemState) {
  CLCGBarButtonItemStateReady = 1,
  CLCGBarButtonItemStateBusy,
  CLCGBarButtonItemStateHidden,
};


/**
 * A button item that can switch to 3 possible states:
 *  - Ready: The normal behavior. If an image was used to create the button,
 *           the image will be used and the title and style are ignored. If
 *           the image is nil, the receiver will be displayed as a normal
 *           UIBarButtonItem, using its style and title.
 *  - Busy: An activity indicator (spinner) will be displayed.
 *  - Hidden: The button is hidden and nothing is visible/tappable.
 *
 *
 */
@interface CLCGBarButtonItem : UIBarButtonItem

@property(nonatomic) CLCGBarButtonItemState state;

-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
                          height:(CGFloat)h;

-(id)initWithTitle:(NSString *)title
             style:(UIBarButtonItemStyle)style
            target:(id)target
            action:(SEL)action
            height:(CGFloat)height;

-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)style
            target:(id)target
            action:(SEL)action
            height:(CGFloat)height;

-(UIActivityIndicatorView*)spinner;

@end
