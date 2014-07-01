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
//  Created by ep on 1/8/12.
//


@protocol CLCGUIViewLayout

/*!
 Use this method to provide a height calculation for your view, given a width.
 */
-(CGFloat)calculatedHeightForWidth:(const CGFloat)w;

@end

@interface UIView (Candygirl)

/*! Moves the X position of the view to the center of its superview. */
-(void)centerHorizontally;

/*!
 * Moves the X position of the view to the center of its superview, plus an
 * additional offset. 
 */
-(void)centerHorizontallyWithOffset:(CGFloat)offset;

/*! Moves the Y position of the view to the center of its superview. */
-(void)centerVertically;

/*!
 * Moves the Y position of the view to the center of its superview, plus an
 * additional offset. 
 */
-(void)centerVerticallyWithOffset:(CGFloat)offset;

/*!
 * Centers this view horizontally in the given rect.
 */
-(void)centerHorizontallyInRect:(CGRect)rect;

/*!
 * Centers this view vertically in the given rect.
 */
-(void)centerVerticallyInRect:(CGRect)rect;

-(void)resizeHeightForText:(NSString*)txt font:(UIFont*)font;
-(UIView*)findFirstResponder;

-(CGFloat)x;
-(void)setX:(CGFloat)x;
-(CGFloat)y;
-(void)setY:(CGFloat)y;
-(CGFloat)w;
-(void)setW:(CGFloat)w;
-(CGFloat)h;
-(void)setH:(CGFloat)h;

/*! The ordinate position below this view, i.e. Y + Height. */
-(CGFloat)low;

/*! The abscissa position at the right of this view, i.e. X + Width. */
-(CGFloat)r;

/*!
 Changes the X position of the view in order to set the given
 "right" (x + width) value.
 */
-(void)setXForR:(CGFloat)r;

/*!
 Changes the Y position of the view in order to set the given 
 "low" (y + height) value.
 */
-(void)setYForLow:(CGFloat)low;

/*!
 Changes the width of the view in order to set the given
 "right" (x + width) value.
 */
-(void)setWForR:(CGFloat)r;

/*!
 Changes the height of the view in order to set the given 
 "low" (y + height) value.
 */
-(void)setHForLow:(CGFloat)low;

/*! @return The view size. */
-(CGSize)sz;

/*! Set view size leaving origin unchanged. */
-(void)setSz:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

/*! 
 Creates and adds a spinner to the center of the view. A pre-existing spinner
 can be passed in and in that case it will be used, otherwise a new one will be
 created. The spinner will then be added as a subview, centered horizontally 
 and vertically.
 
 @param spinner The spinner to be used; if nil, a new spinner will be created.
 */
-(UIActivityIndicatorView*)showSpinner:(UIActivityIndicatorView*)spinner;

/*! 
 Removes the given spinner from the subviews of this view.
 @param spinner Spinner to be removed. No-op if spinner is nil.
 */
-(void)hideSpinner:(UIActivityIndicatorView*)spinner;

/*!
 Adds a light gray border around the view. 
 
 @param insets Use insets to offset the border by a certain number of pixels
               in the 4 directions.
*/
-(void)addBorderWithInsets:(UIEdgeInsets)insets;

-(CGFloat)heightForWidth:(CGFloat)w useAttributed:(BOOL)use_attributed;


/*!
 @abstract Lays out a text subview, such as UILabel, UITextView.
 @param subview          The subview to be layed out.
 @param use_attributed   use the attributed content from subview.
 @param horiz_align_view Lay out subview to the right of horiz_align_view.
 @param padding_horiz    Horizontal padding between horiz_align_view and subview.
 @param vert_align_view  Lay out subview below vert_align_view.
 @param padding_vert     Vertical padding between vert_align_view and subview.
 @param max_w            The max width available to the subview.
 */
-(void)putTextView:(UIView*)subview
 useAttributedText:(BOOL)use_attributed
         toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
             below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
          maxWidth:(CGFloat)max_w;

/*!
 @abstract Lays out a subview.
 @param subview          The subview to be layed out.
 @param horiz_align_view Lay out subview to the right of horiz_align_view.
 @param padding_horiz    Horizontal padding between horiz_align_view and subview.
 @param vert_align_view  Lay out subview below vert_align_view.
 @param padding_vert     Vertical padding between vert_align_view and subview.
 @param max_w            The max width available to the subview.
 @param resize           Whether the subview should be resized according to
                         @link CLCGUIViewLayout @/link protocol.
 */
-(void)putView:(UIView<CLCGUIViewLayout>*)subview
     toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
         below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
      maxWidth:(CGFloat)max_w
      resizing:(BOOL)resize;

@end

