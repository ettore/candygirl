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


//==============================================================================


@protocol CLCGUIViewLayout

/*!
 Use this method to provide a height calculation for your view, given a width.
 @return A rounded-up value of the height needed to properly display this view.
 */
-(CGFloat)calculatedHeightForWidth:(const CGFloat)w;

@end


//==============================================================================


@interface UIView (Candygirl)

/*! Moves the X position of the view to the center of its superview. */
-(void)clcg_centerHorizontally;

/*!
 * Moves the X position of the view to the center of its superview, plus an
 * additional offset.
 */
-(void)clcg_centerHorizontallyWithOffset:(CGFloat)offset;

/*! Moves the Y position of the view to the center of its superview. */
-(void)clcg_centerVertically;

/*!
 * Moves the Y position of the view to the center of its superview, plus an
 * additional offset.
 */
-(void)clcg_centerVerticallyWithOffset:(CGFloat)offset;

/*!
 * Centers this view horizontally in the given rect.
 */
-(void)clcg_centerHorizontallyInRect:(CGRect)rect;

/*!
 * Centers this view vertically in the given rect.
 */
-(void)clcg_centerVerticallyInRect:(CGRect)rect;

-(void)clcg_resizeHForText:(NSString*)txt font:(UIFont*)font;

-(UIView*)clcg_findFirstResponder;

-(CGFloat)clcg_x;
-(void)setClcg_x:(CGFloat)x;
-(CGFloat)clcg_y;
-(void)setClcg_y:(CGFloat)y;
-(CGFloat)clcg_w;
-(void)setClcg_w:(CGFloat)w;
-(CGFloat)clcg_h;
-(void)setClcg_h:(CGFloat)h;

/*! The abscissa position at the right of this view, i.e. X + Width. */
-(CGFloat)clcg_r;

/*! The ordinate position below this view, i.e. Y + Height. */
-(CGFloat)clcg_low;

- (CGPoint)clcg_origin;
- (void)setClcg_origin:(CGPoint)origin;

/*! @return The view size. */
-(CGSize)clcg_sz;

/*! Set view size leaving origin unchanged. */
-(void)setClcg_sz:(CGSize)size;

- (CGFloat)clcg_centerX;
- (void)setClcg_centerX:(CGFloat)centerX;

- (CGFloat)clcg_centerY;
- (void)setClcg_centerY:(CGFloat)centerY;

/*!
 Changes the X position of the view in order to set the given
 "right" (x + width) value.
 */
-(void)clcg_setXForR:(CGFloat)r;

/*!
 Changes the Y position of the view in order to set the given
 "low" (y + height) value.
 */
-(void)clcg_setYForLow:(CGFloat)low;

/*!
 Changes the width of the view in order to set the given
 "right" (x + width) value.
 */
-(void)clcg_setWForR:(CGFloat)r;

/*!
 Changes the height of the view in order to set the given
 "low" (y + height) value.
 */
-(void)clcg_setHForLow:(CGFloat)low;

/*!
 Creates and adds a spinner to the center of the view. A pre-existing spinner
 can be passed in and in that case it will be used, otherwise a new one will be
 created. The spinner will then be added as a subview, centered horizontally
 and vertically.

 @param spinner The spinner to be used; if nil, a new spinner will be created.
 */
-(UIActivityIndicatorView*)clcg_showSpinner:(UIActivityIndicatorView*)spinner;

/*!
 Removes the given spinner from the subviews of this view.
 @param spinner Spinner to be removed. No-op if spinner is nil.
 */
-(void)clcg_hideSpinner:(UIActivityIndicatorView*)spinner;

/*!
 Adds a light gray border around the view.

 @param insets Use insets to offset the border by a certain number of pixels
 in the 4 directions.
 */
-(void)clcg_addBorderWithInsets:(UIEdgeInsets)insets;


/*!
 @discussion
 Calculates the height of the text contained in this view. This works by
 inspecting the presence of (`text` + 'font`) and/or `attributedText` methods.
 If none is present, the returned height will be 0.
 @param w The width available to contain text
 @param use_attributed Use the attributed version of text
 @param line_limit The limit number of lines to constrain the max height.
 @return The height of the eventual text present in this view.
 */
-(CGFloat)clcg_textHForW:(CGFloat)w
           useAttributed:(BOOL)use_attributed
               lineLimit:(NSUInteger)line_limit;


/*!
 @abstract Lays out a text subview, such as UILabel, UITextView.
 @param subview          The subview to be layed out.
 @param use_attributed   use the attributed content from subview.
 @param horiz_align_view Lay out subview to the right of horiz_align_view.
 @param padding_horiz    Horizontal padding between horiz_align_view and subview.
 @param vert_align_view  Lay out subview below vert_align_view.
 @param padding_vert     Vertical padding between vert_align_view and subview.
 @param max_w            The max width available to the subview.
 @param line_limit The limit number of lines to constrain the max height.
 */
-(void)clcg_putTextView:(UIView*)subview
      useAttributedText:(BOOL)use_attributed
              toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
                  below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
               maxWidth:(CGFloat)max_w
              lineLimit:(NSUInteger)line_limit;

/*!
 @abstract
 Lays out a subview.
 @param subview          The subview to be layed out.
 @param horiz_align_view Lay out subview to the right of horiz_align_view.
 @param padding_horiz    Horizontal padding between horiz_align_view and subview.
 @param vert_align_view  Lay out subview below vert_align_view.
 @param padding_vert     Vertical padding between vert_align_view and subview.
 */
-(void)clcg_putView:(UIView*)subview
          toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
              below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert;

/*!
 @abstract
 Lays out a subview, resizing it according to @link CLCGUIViewLayout @/link
 protocol.
 @param subview          The subview to be layed out.
 @param horiz_align_view Lay out subview to the right of horiz_align_view.
 @param padding_horiz    Horizontal padding between horiz_align_view and subview.
 @param vert_align_view  Lay out subview below vert_align_view.
 @param padding_vert     Vertical padding between vert_align_view and subview.
 @param max_w            The max width available to the subview.
 */
-(void)clcg_putView:(UIView<CLCGUIViewLayout>*)subview
          toRightOf:(UIView*)horiz_align_view horizPadding:(CGFloat)padding_horiz
              below:(UIView*)vert_align_view   vertPadding:(CGFloat)padding_vert
           maxWidth:(CGFloat)max_w;

/*!
 * Adds an action to be performed on a tap event occurring on the view.
 * The action signature is a standard -(void)theAction.
 */
-(void)clcg_addTarget:(id)target forTapAction:(SEL)action;

@end

