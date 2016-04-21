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
//  Created by Ettore Pasquini on 5/1/13.
//

/*
 ------------------------------------------------------------------------------
 The classes and protocols on this file are deprecated.
 They will be removed in the future.
 ------------------------------------------------------------------------------
*/

/*!
 @discussion Since we don't control the disclosure indicator size (and we need
 to know the width when we calc the cell height in the TV controller) let's
 provide a default size here, slightly bigger than actual to avoid
 calculating a cell height that's too small.
 The default should cover both UITableViewCellAccessoryDisclosureIndicator
 and UITableViewCellAccessoryCheckmark.
 NOTE: Looks like this is actually 20px on iOS <= 6
 HACK: this is fragile against future iterations of iOS.
 TODO: find a way to derive the accessory width when we're not using a
 custom accessory view.
 */
#define CLCG_DEFAULT_ACCESSORY_TYPE_W   22.0f
#define CLCG_ACCESSORY_BUTTON_TYPE_W    33.0f

/*! Left and right 10 px margins on grouped table views. */
#define CLCG_TV_GROUPED_PADDING         20.0f


//==============================================================================
#pragma mark


@protocol CLCGCell

/*! Does this cell need to stand out (e.g. a new update in feed) or not. */
@property(nonatomic,assign)   BOOL      emphasized;

/*! Padding between subviews. */
@property(nonatomic,readonly) CGFloat   innerPadding;

/*! Color (usually background) for non-emphasized cells. */
@property(nonatomic,retain)   UIColor   *normalColor;

/*! 
 Color (usually background) for cells that need to stand out against
 normal cells. 
 */
@property(nonatomic,retain)   UIColor   *emphasisColor;

// "overrides" from UITableViewCell
@property(nonatomic,retain) UIView      *backgroundView;
@property(nonatomic,readonly,retain) UIImageView *imageView NS_AVAILABLE_IOS(3_0);
-(void)setNeedsDisplay;

@end


//==============================================================================
#pragma mark

/*!
 @deprecated
 */
@protocol CLCGCellCommonLayouter

/*! Changes the background color according to the current `emphasized' state. */
-(void)updateBackgroundColor;

/*!
 @abstract Hides the image.
 @discussion You might want to use this to prevent flicker when scrolling fast.
 */
-(void)hideImage;

/*! Sets the image in the cell and shows it. */
-(void)showImage:(UIImage*)img;

/*!
 Sets the image in the cell and shows it with or without a short fade-in
 animation.
 */
-(void)showImage:(UIImage*)img animated:(BOOL)animated;

@end


//==============================================================================
#pragma mark


/*!
 @discussion
 Common layout and display logic for our default cells, composed of a image
 on the left side, and 3 text fields on the right side.

 @deprecated
 */
@interface CLCGCellCommonLayouter : NSObject <CLCGCellCommonLayouter>

// assign policy because cell owns us
@property(nonatomic,assign) id<CLCGCell> cell;

-(id)initWithCell:(id<CLCGCell>)cell;

/*! The X position on the right of the image, considering padding. */
-(CGFloat)xRightOfImage;

@end

