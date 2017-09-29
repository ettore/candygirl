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


/*
 ------------------------------------------------------------------------------
 This entire class is deprecated.
 It will be removed in its entirety in the future.
 ------------------------------------------------------------------------------
 */


/*!
 @abstract The max cell height used in layout calculations.
 @discussion UIKit says that the max height of a cell should not exceed 2009px.
 @see @link //apple_ref/occ/intfm/UITableViewDelegate/tableView:heightForRowAtIndexPath: @/link
 */
#define CLCG_MAX_CELL_H             2009.0f


#import "CLCGCellCommonLayouter.h"

@class CLCGImageView;


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
 
 @deprecated
 */
@interface CLCGCell : UITableViewCell <CLCGCell, CLCGCellCommonLayouter>

@property(nonatomic,copy)   NSString  *imgUrl;
@property(nonatomic,retain) id        context;//should this be assign?
@property(nonatomic,retain) UILabel   *infoTextLabel;
@property(nonatomic,retain) CLCGCellCommonLayouter *commonLayouter;

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
 Executes block if a tap on the imageView happens.
 */
-(void)addTapActionOnImage:(void(^)(void))block;

/*!
 Load an image for the cell that displaying info of particular object(context).
 If the image loads after the cell is reused, the context will be different and
 the outdated image will not appear.
 */
-(void)loadImageForURL:(NSString*)img_url
             retinaURL:(NSString*)retina_img_url
               context:(id)cell_cxt_obj;


//------------------------------------------------------------------------------
#pragma mark - Height calculation methods

/*!
 Calculates the size of the text of textLabel (the top UILabel in this cell).
 @param w_available_for_text The actual width that the text label can occupy.
 */
-(CGSize)calculateTextLabelSizeForCellWidth:(CGFloat)w_available_for_text;

/*!
 Calculates the size of the text of detailTextLabel.
 @param w_available_for_text The actual width that the text label can occupy.
 */
-(CGSize)calculateDetailLabelSizeForCellWidth:(CGFloat)w_available_for_text;

/*!
 Calculates the size of the text of infoTextLabel.
 @param w_available_for_text The actual width that the text label can occupy.
 */
-(CGSize)calculateInfoLabelSizeForCellWidth:(CGFloat)w_available_for_text;

/*!
 Uses styling class methods to derive height measurement that belong to
 these cells.
 */
+(CGFloat)cellHeightForText:(NSString*)text
                 detailText:(NSString*)detailtext
                   infoText:(NSString*)infotext
                   maxWidth:(CGFloat)cell_maxw;

/*!
 @deprecated
 @abstract
 Calculates the height of the cell in accordance with all given parameters.
 @discussion
 This method takes padding values from +innerPadding and +topBottomPadding class
 methods. Subclasses likely shouldn't override this method: rather, define a
 more custom interface (perhaps with less params!) and if needed eventually call:
 [self
 cellHeightForText:detailText:infoText:font:detailFont:infoFont:maxWidth:imageW:imageH:]
 (and not [CLCGCell cellHeightForText:...]) to exploit its polymorphic behavior.
 */
+(CGFloat)cellHeightForText:(NSString*)text
                 detailText:(NSString*)detailtext
                   infoText:(NSString*)infotext
                       font:(UIFont*)text_font
                 detailFont:(UIFont*)detail_font
                   infoFont:(UIFont*)info_font
                   maxWidth:(CGFloat)cell_maxw
                     imageW:(CGFloat)imgw
                     imageH:(CGFloat)imgh;

/*!
 @abstract The max width accounted during layout calculations for the
 accessory view or disclosure arrow.
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

/*! @deprecated */
+(void)setMaxAccessoryWidth:(CGFloat)w;

/*!
 This method calculates the possible width available to text content.
 It accounts for:
 - image width
 - accessory item (we assume it's either present/absent on all views)
 - padding left and right of the _cell's borders,
 - padding on the right side of the image, if we have it,
 - padding on the left side of the accessory view, if we have it.
 */
+(CGFloat)textLabelWidthWithCellW:(CGFloat)maxw;

//------------------------------------------------------------------------------
#pragma mark - Styling class methods


+(CGFloat)viewportPadding;
+(CGFloat)topBottomPadding;
+(CGFloat)imageRightPadding;
+(CGFloat)accessoryViewLeftPadding;
+(CGFloat)innerPadding;
+(CGSize)imageSize;

+(UIFont*)textFont;
+(UIFont*)detailFont;
+(UIFont*)infoFont;


@end

