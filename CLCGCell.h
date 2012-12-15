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


/*!
 @abstract The max cell height used in layout calculations.
 @discussion UIKit says that the max height of a cell should not exceed 2009px.
 @see @link //apple_ref/occ/intfm/UITableViewDelegate/tableView:heightForRowAtIndexPath: @/link
 */
#define CLCG_MAX_CELL_H             2009.0f


/*!
 @class CLCGCell
 @abstract A reusable cell capable of rendering 3 blocks of text and an image.
 @discussion This cell loads an image on the left side and renders multiline
  text in the standard UITableViewCell's textLabel and detailTextLabel. 
  It also adds an additional `infoTextLabel` positioned below detailTextLabel, 
  also with multiline text. The detailTextLabel is rendered in gray. 
  A standard disclosure indicator is added by default on the right side. 
  This cell is also able to render itself with a different background color 
  if it's set as an "emphasized" cell. 
  The layout of all components is performed accordingly, adding padding 
  between elements.
 */
@interface CLCGCell : UITableViewCell
{
  UILabel   *mInfoTextLabel;
  NSString  *mImgUrl;
  CGFloat   mImgW;
  CGFloat   mImgH;
  CGFloat   mPadding;
  UIColor   *mNormalColor;
  UIColor   *mEmphasisColor;
  BOOL      mEmphasized;
  id        mContext;
}

@property(nonatomic,retain) NSString  *imgUrl;
@property(nonatomic,assign) BOOL      emphasized;
@property(nonatomic,retain) id        context;//should this be assign?
@property(nonatomic,readonly) CGFloat padding;
@property(nonatomic,retain) UILabel   *infoTextLabel;
@property(nonatomic,retain) UIColor   *normalColor;

/*! 
 The designated initializer.
 Sets up the styling of the cell, according to the given width and height of
 the image and padding. 
 The padding value adds whitespace to all sides of the cell (i.e. left, right, 
 up, down), on the right side of the image and the left side of the accessory 
 view (if you use it) and between the textLabel and detailTextLabel.
 To use no image, simply construct a cell with image width and height set to 0.
 */
-(id)initWithImageWidth:(CGFloat)w 
                 height:(CGFloat)h
                padding:(CGFloat)padding
                reuseId:(NSString*)cid;

/*! 
 @discussion Calculates the possible width available to the text label in any
    CLCGCell, accounting for image width, accessory view, and padding.
 */
+(CGFloat)textLabelWidthWithCellW:(CGFloat)maxw imageW:(CGFloat)w padding:(CGFloat)p;

/*! 
 Calculates the height of the cell in accordance with all given parameters. 
 */
+(CGFloat)cellHeightForText:(NSString*)text
                 detailText:(NSString*)detailtext
                   infoText:(NSString*)infotext
                       font:(UIFont*)text_font
                 detailFont:(UIFont*)detail_font
                   infoFont:(UIFont*)info_font
                   maxWidth:(CGFloat)cell_maxw
                     imageW:(CGFloat)imgw
                     imageH:(CGFloat)imgh
                    padding:(CGFloat)padding;

/*! Changes the background color according to the current `emphasized' state. */
-(void)updateBackgroundColor;

/*! 
 @abstract Hides the image. 
 @discussion You might want to use this to prevent flicker when scrolling fast.
*/
-(void)hideImage;

/*! Sets the image in the cell and shows it. */
-(void)showImage:(UIImage*)img;

/*! The X position on the right of the image, considering padding. */
-(CGFloat)xRightOfImage;

/*! 
 @abstract The max width accounted during layout calculations for the
    accessory view or discolosure arrow.
 @discussion By default, CLCGCell does not use a true accessory view; rather,
    it employs the default UITableViewCellAccessoryDisclosureIndicator type.
    If you use actual custom views for your accessory element, you should 
    probably create a subclass and override this method with actual 
    measurements.
    If you don't use any accessory item, override this method and return 0.
 @return A constant value that should account for the size of a default 
    accessory type.
 */
+(CGFloat)maxAccessoryWidth;
+(void)setMaxAccessoryWidth:(CGFloat)w;

@end

