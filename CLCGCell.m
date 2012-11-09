//
//  CLCGCell.m
//  Goodreads
//  Created by Ettore Pasquini on 9/3/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "clcg_macros.h"
#import "clcg_viewport.h"
#import "UIViewCategory.h"

#import "CLCGCell.h"

#define GRCELL_IMG_DEFAULT_W      60.0f
#define GRCELL_IMG_DEFAULT_H      60.0f
#define MAX_CELL_H                20000.0f

@implementation CLCGCell

@synthesize textFont = mTextFont;
@synthesize detailFont = mDetailFont;
@synthesize imgUrl = mImgUrl;
@synthesize context = mContext;
@synthesize isHighlighted = mIsHighlighted;


-(void)dealloc
{
  CLCG_REL(mTextFont);
  CLCG_REL(mDetailFont);
  CLCG_REL(mImgUrl);
  CLCG_REL(mContext);
  CLCG_REL(mHighlightColor);
  [super dealloc];
}


// overriding super-class designated initializer
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)cid
{
  return [self initWithImageWidth:GRCELL_IMG_DEFAULT_W 
                           height:GRCELL_IMG_DEFAULT_H 
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
    mHighlightColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.85 alpha:1.0];
    [mHighlightColor retain];

    // since we don't control the disclosure indicator size (and we need to 
    // know the width when we calc the cell height in the TV controller) let's 
    // provide a default size here, slightly bigger than actual to avoid 
    // calculating a cell height that's too small.
#define GRCELL_ACCESSORY_DISCL_W  22.0
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
  [self setBackgroundColor:(mIsHighlighted ? mHighlightColor : [UIColor whiteColor])];
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
  x = [[self imageView] right] + mPadding;
  w = [CLCGCell textLabelWidthWithMax:[self width] 
                             imageW:[[self imageView] width] 
                            padding:mPadding];
  sz = CGSizeMake(w, [self height]);
  sz = [[[self textLabel] text] sizeWithFont:mTextFont 
                           constrainedToSize:sz
                               lineBreakMode:UILineBreakModeWordWrap];
  
  r = CGRectMake(x, mPadding, w, sz.height);
  [[self textLabel] setFrame:r];
  
  // layout detail label
  sz = CGSizeMake(w, [self height]);
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
  return maxw - imgw - ((imgw > 0) ? pad:0) - pad*3 - GRCELL_ACCESSORY_DISCL_W;
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
