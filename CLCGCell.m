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

#import <QuartzCore/QuartzCore.h>

#import "clcg_macros.h"
#import "clcg_viewport.h"
#import "UIViewCategory.h"
#import "CLCGCell.h"


static CGFloat sMaxAccessoryWidth = CLCG_DEFAULT_ACCESSORY_TYPE_W;


/*!
 @discussion This accounts for left and right viewport padding added by iOS,
    since we are still using UITableViewCell for the layout of the image.
 @note This is fragile in the sense that it could change in future releases
    of iOS, but likely is not going to change by much more. 
 @todo Nevertheless, we should remove this dependency and just derive this
    dynamically, although that can probably be done only at layout time
    (typically we want to use this before layout, to calculate the height of
    the cell.
 */
#define CLCG_DEFAULT_VIEWPORT_PADDING   11.0f

/*! Construction time defaults. */
CGFloat CLCGCELL_IMG_DEFAULT_W = 60.0f;
CGFloat CLCGCELL_IMG_DEFAULT_H = 60.0f;

@interface CLCGCell ()
@property(nonatomic,retain) CLCGCellCommonLayouter *commonLayouter;
@end

@implementation CLCGCell
{
  UILabel   *_infoTextLabel;
  CGFloat   _imgW;
  CGFloat   _imgH;
  CLCGCellCommonLayouter *_commonLayouter;
}

-(void)dealloc
{
  [self setInfoTextLabel:nil];
  [self setImgUrl:nil];
  [self setContext:nil];
  [self setNormalColor:nil];
  [self setEmphasisColor:nil];
  [self setCommonLayouter:nil];
  [super dealloc];
}


// overriding super-class designated initializer
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)cid
{
  return [self initWithImageWidth:CLCGCELL_IMG_DEFAULT_W 
                           height:CLCGCELL_IMG_DEFAULT_H 
                          padding:0
                          reuseId:cid];
}


// designated initializer
-(id)initWithImageWidth:(CGFloat)w 
                 height:(CGFloat)h
                padding:(CGFloat)padding
                reuseId:(NSString*)cid;
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
  if (self) {
    _imgW = w;
    _imgH = h;
    _padding = padding;
    [self setCommonLayouter:[[[CLCGCellCommonLayouter alloc] initWithCell:self] autorelease]];
    [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [[self textLabel] setTextColor:[UIColor blackColor]];
    [[self textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[self textLabel] setNumberOfLines:0];//set to 0 and calc height dynamically
    [[self detailTextLabel] setTextColor:[UIColor grayColor]];
    [[self detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[self detailTextLabel] setNumberOfLines:0];
    [[self detailTextLabel] setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [[self imageView] setFrame:CGRectMake(padding, padding, w, h)];
    [[self imageView] setAutoresizesSubviews:YES];
    [[self imageView] setAutoresizingMask:UIViewAutoresizingNone];
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [[self textLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];  //reasonable default
    [[self detailTextLabel] setFont:[UIFont systemFontOfSize:12.0f]];//reasonable default
    [_infoTextLabel setFont:[UIFont systemFontOfSize:12.0f]];        //reasonable default
    [self setEmphasisColor:[UIColor colorWithRed:1.0 green:0.98 blue:0.85 alpha:1.0]];
    [self setNormalColor:[UIColor whiteColor]];

    // info label, this goes below the detail label
    _infoTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_infoTextLabel setTextColor:[UIColor blackColor]];
    [_infoTextLabel setNumberOfLines:0];
    [_infoTextLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_infoTextLabel];

    // NOTE: despite what the docs say, it seems necessary to set the background
    // color here to have the emphasis color render correctly behind the labels.
    [[self textLabel] setBackgroundColor:[UIColor clearColor]];
    [[self detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    // needed for changing the background color
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];
    [bgview setOpaque:YES];
    [self setBackgroundView:bgview];
    [bgview release];

    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  return self;
}


-(void)setEmphasized:(BOOL)emphasized
{
  _emphasized = emphasized;
  [self updateBackgroundColor];
}


//------------------------------------------------------------------------------
#pragma mark - Layout


-(void)layoutSubviews
{
  CGRect r;
  CGSize sz;
  
  [super layoutSubviews];

  // layout image view
  [[self imageView] setFrame:CGRectMake(_padding, _padding, _imgW, _imgH)];

  // these should not change
  const CGFloat cellh = [self h];
  const CGFloat imgw = [[self imageView] w];
  const CGFloat x = [[self commonLayouter] xRightOfImage];
  const CGFloat w = [CLCGCellCommonLayouter textLabelWidthWithCellW:[self w]
                                                             imageW:imgw
                                                            padding:_padding];

  // layout text label
  sz = CGSizeMake(w, cellh);
  sz = [[[self textLabel] text] sizeWithFont:[[self textLabel] font]
                           constrainedToSize:sz
                               lineBreakMode:UILineBreakModeWordWrap];
  r = CGRectMake(x, _padding, w, sz.height);
  [[self textLabel] setFrame:r];
  
  // layout detail label
  sz = CGSizeMake(w, cellh);
  sz = [[[self detailTextLabel] text] sizeWithFont:[[self detailTextLabel] font]
                                 constrainedToSize:sz
                                     lineBreakMode:UILineBreakModeWordWrap];
  r = CGRectMake(x, [[self textLabel] low] + (int)(_padding/2), sz.width, sz.height);
  [[self detailTextLabel] setFrame:r];

  // info text label
  sz = CGSizeMake(w, cellh);
  sz = [[_infoTextLabel text] sizeWithFont:[_infoTextLabel font]
                         constrainedToSize:sz
                             lineBreakMode:UILineBreakModeWordWrap];
  r = CGRectMake(x, [[self detailTextLabel] low] + (int)(_padding/2), w, sz.height);
  [[self infoTextLabel] setFrame:r];
}


+(CGFloat)maxAccessoryWidth
{
  return sMaxAccessoryWidth;
}


+(void)setMaxAccessoryWidth:(CGFloat)w
{
  sMaxAccessoryWidth = w;
}


+(CGFloat)cellHeightForText:(NSString*)text
                 detailText:(NSString*)detailtext
                   infoText:(NSString*)infotext
                       font:(UIFont*)text_font
                 detailFont:(UIFont*)detail_font
                   infoFont:(UIFont*)info_font
                   maxWidth:(CGFloat)cell_maxw
                     imageW:(CGFloat)imgw
                     imageH:(CGFloat)imgh
                    padding:(CGFloat)padding
{
  CGSize sz;
  CGFloat label_w, h;
  const CGFloat cell_maxh = CLCG_MAX_CELL_H;
  
  // adding _padding for cell margins (L & R) and right margin of img
  // Note: using `self` here seems necessary to properly invoke polymorphism on
  // maxAccessoryWidth, called by textLabelWidthWithCellW:imageW:padding:.
  label_w = [CLCGCellCommonLayouter textLabelWidthWithCellW:cell_maxw
                                                     imageW:imgw
                                                    padding:padding];

  // measure main text size
  sz = CGSizeMake(label_w, cell_maxh);
  sz = [text sizeWithFont:text_font
              constrainedToSize:sz
                  lineBreakMode:UILineBreakModeWordWrap];
  h = sz.height;
  
  // add detail text size.
  if ([detailtext length] > 0) {
    h += padding + [detailtext sizeWithFont:detail_font
                          constrainedToSize:CGSizeMake(label_w, cell_maxh)
                              lineBreakMode:UILineBreakModeWordWrap].height;
  }

  // now we have to add space for info text + 1 padding unit
  if ([infotext length] > 0) {
    h += padding + [infotext sizeWithFont:info_font
                        constrainedToSize:CGSizeMake(label_w, cell_maxh)
                            lineBreakMode:UILineBreakModeWordWrap].height;
  }

  // add padding above and below cell content
  h = MAX(h, imgh) + padding*2;
  
  return h;
}


//------------------------------------------------------------------------------
#pragma mark - common layouter decorating interface


-(void)updateBackgroundColor
{
  [[self commonLayouter] updateBackgroundColor];
}


-(void)hideImage
{
  [[self commonLayouter] hideImage];
}

-(void)showImage:(UIImage*)img;
{
  [[self commonLayouter] showImage:img];
}

-(void)showImage:(UIImage*)img animated:(BOOL)animated
{
  [[self commonLayouter] showImage:img animated:animated];
}


@end

