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

#define CLCGCELL_IMG_DEFAULT_W      60.0f
#define CLCGCELL_IMG_DEFAULT_H      60.0f
#define MAX_CELL_H                  20000.0f

@implementation CLCGCell

@synthesize textFont = mTextFont;
@synthesize detailFont = mDetailFont;
@synthesize imgUrl = mImgUrl;
@synthesize context = mContext;
@synthesize emphasized = mEmphasized;


-(void)dealloc
{
  CLCG_REL(mTextFont);
  CLCG_REL(mDetailFont);
  CLCG_REL(mImgUrl);
  CLCG_REL(mContext);
  CLCG_REL(mEmphasizedColor);
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
    mImgW = w;
    mImgH = h;
    mPadding = padding;
    [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [[self textLabel] setNumberOfLines:0];//set to 0 and calc height dynamically
    [[self textLabel] setTextColor:[UIColor blackColor]];
    [[self textLabel] setBackgroundColor:[UIColor clearColor]];
    [[self detailTextLabel] setTextColor:[UIColor grayColor]];
    [[self detailTextLabel] setNumberOfLines:0];
    [[self detailTextLabel] setAdjustsFontSizeToFitWidth:YES];
    [[self detailTextLabel] setMinimumFontSize:9];
    [[self detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    [[self imageView] setFrame:CGRectMake(padding, padding, w, h)];
    [[self imageView] setAutoresizingMask:UIViewAutoresizingNone];
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self setTextFont:[UIFont boldSystemFontOfSize:15.0f]]; //reasonable default
    [self setDetailFont:[UIFont systemFontOfSize:12.0f]];   //reasonable default
    mEmphasizedColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.85 alpha:1.0];
    [mEmphasizedColor retain];

    // needed for changing the background color
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];
    [bgview setOpaque:YES];
    [self setBackgroundView:bgview];
    [bgview release];

    // HACK: this is pretty fragile against future iterations of iOS.
    // TODO: find a way to derive the accessory width without using a
    //       custom accessory view.
    // since we don't control the disclosure indicator size (and we need to
    // know the width when we calc the cell height in the TV controller) let's
    // provide a default size here, slightly bigger than actual to avoid
    // calculating a cell height that's too small.
#define CLCGCELL_ACCESSORY_DISCL_W  22.0
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  return self;
}


-(void)setTextFont:(UIFont*)f
{
  [f retain];
  [mTextFont release];
  mTextFont = f;
  [[self textLabel] setFont:f];
}


-(void)setDetailFont:(UIFont*)f
{
  [f retain];
  [mDetailFont release];
  mDetailFont = f;
  [[self detailTextLabel] setFont:f];
}


-(void)updateBackgroundColor
{
  // Note: setting the background color on the contentView or even all the
  // subviews doesn't take care of changing the background of the accessoryView.
  // Setting the background of the accessoryView doesn't seem to work either.
  UIColor *color = (mEmphasized ? mEmphasizedColor : [UIColor whiteColor]);
  [[self backgroundView] setBackgroundColor:color];
}


-(void)setEmphasized:(BOOL)emphasized
{
  mEmphasized = emphasized;
  [self updateBackgroundColor];
}


-(void)hideImage
{
  [[[self imageView] layer] setOpacity:0.0];
}


-(void)showImage:(UIImage*)img
{
  // once the img view has been layed out once, no need to re-lay it out again
  if ([[self imageView] image] == nil)
    [self setNeedsLayout]; //layout will happen in next update cycle

  [[self imageView] setImage:img];
  
  // smooth out the appearance of the image a bit
  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
  CALayer *layer = [[self imageView] layer];
  [anim setDuration:0.2]; //0.2 sec
  [anim setFromValue:[NSNumber numberWithFloat:0.0]];
  [anim setToValue:[NSNumber numberWithFloat:1.0]];
  [layer addAnimation:anim forKey:@"animateOpacity"];
  [layer setOpacity:1.0]; //makes the animation ending value stick
}


-(void)layoutSubviews
{
  CGRect r;
  CGFloat x, w;
  CGSize sz;
  
  [super layoutSubviews];
  
  // layout image view
  [[self imageView] setFrame:CGRectMake(mPadding, mPadding, mImgW, mImgH)];
  
  // layout text label
  w = [[self imageView] w];
  x = [[self imageView] x] + w + mPadding;
  w = [CLCGCell textLabelWidthWithMax:[self w] imageW:w padding:mPadding];
  sz = CGSizeMake(w, [self h]);
  sz = [[[self textLabel] text] sizeWithFont:mTextFont 
                           constrainedToSize:sz
                               lineBreakMode:UILineBreakModeWordWrap];
  
  r = CGRectMake(x, mPadding, w, sz.height);
  [[self textLabel] setFrame:r];
  
  // layout detail label
  sz = CGSizeMake(w, [self h]);
  sz = [[[self detailTextLabel] text] sizeWithFont:mDetailFont
                                 constrainedToSize:sz
                                     lineBreakMode:UILineBreakModeWordWrap];
  w = sz.width;
  r = CGRectMake(x, [[self textLabel] low] + (int)(mPadding/2), w, sz.height);
  [[self detailTextLabel] setFrame:r];
}


+(CGFloat)textLabelWidthWithMax:(CGFloat)maxw
                         imageW:(CGFloat)imgw
                        padding:(CGFloat)pad
{
  return maxw - imgw - ((imgw > 0) ? pad:0) - pad*3 - CLCGCELL_ACCESSORY_DISCL_W;
}



+(CGFloat)cellHeightForText:(NSString*)text
                 detailText:(NSString*)detailtext
                       font:(UIFont*)text_font 
                 detailFont:(UIFont*)detail_font 
               cellMaxWidth:(CGFloat)cell_maxw
                     imageW:(CGFloat)imgw
                     imageH:(CGFloat)imgh
                    padding:(CGFloat)padding
{
  CGSize sz;
  CGFloat label_w, h;
  
  // adding mPadding for cell margins (L & R) and right margin of img
  label_w = [CLCGCell textLabelWidthWithMax:cell_maxw imageW:imgw padding:padding];

  // measure main text size
  sz = CGSizeMake(label_w, MAX_CELL_H);
  sz = [text sizeWithFont:text_font
              constrainedToSize:sz
                  lineBreakMode:UILineBreakModeWordWrap];
  h = sz.height;
  
  // add detail text size.
  h += padding + [detailtext sizeWithFont:detail_font
                        constrainedToSize:CGSizeMake(label_w, MAX_CELL_H)
                            lineBreakMode:UILineBreakModeWordWrap].height;
  
  // add padding above and below cell content
  h = MAX(h, imgh) + padding*2;
  
  return h;
}


@end
