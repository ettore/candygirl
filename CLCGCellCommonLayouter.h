//
//  CLCGCellCommonLayouter.h
//  Goodreads
//
//  Created by Ettore Pasquini on 5/1/13.
//

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

@property(nonatomic,retain) UIView      *backgroundView;
@property(nonatomic,readonly,retain) UIImageView *imageView NS_AVAILABLE_IOS(3_0);
- (void)setNeedsLayout;
@property(nonatomic,assign)   BOOL      emphasized;
@property(nonatomic,readonly) CGFloat   viewportPadding;
@property(nonatomic,retain)   UIColor   *normalColor;
@property(nonatomic,retain)   UIColor   *emphasisColor;

@end


//==============================================================================
#pragma mark


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
 Common layout and display logic for our default cells, composed of a image
 on the left side, and 3 text fields on the right side.
 */
@interface CLCGCellCommonLayouter : NSObject <CLCGCellCommonLayouter>

// assign policy because cell owns us
@property(nonatomic,assign) id<CLCGCell> cell;

-(id)initWithCell:(id<CLCGCell>)cell;

/*! The X position on the right of the image, considering padding. */
-(CGFloat)xRightOfImage;

/*!
 @discussion Calculates the possible width available to the text label in any
 CLCGCell, accounting for image width, accessory view, and padding.
 */
+(CGFloat)textLabelWidthWithCellW:(CGFloat)maxw
                           imageW:(CGFloat)imgw
                  viewportPadding:(CGFloat)viewport_pad
                     innerPadding:(CGFloat)internal_pad;


@end

