//
//  CLCGBarButtonItem.m
//  Created by Ettore Pasquini on 9/29/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "clcg_device_utils.h"
#import "CLCGBarButtonItem.h"
#import "UIViewCategory.h"
#import "CLCGTogglerView.h"


@interface CLCGBarButtonItem ()
-(UIActivityIndicatorView*)spinner;
@end

@implementation CLCGBarButtonItem
{
  CLCGTogglerView             *mToggler;
  enum CLCGBarButtonItemState mState;
  BOOL                        mIsSystemItem;
}


-(void)dealloc
{
  CLCG_REL(mToggler);
  [super dealloc];
}


//------------------------------------------------------------------------------
#pragma mark - Overrides


-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
{
  return [self initWithImage:nil
                     orTitle:nil
                orSystemItem:item
                       style:UIBarButtonItemStylePlain
                      target:target
                      action:action
                      height:44]; //arbitrary yet reasonable default height
}


- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default height
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:44];
}


-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
{
  // just called with an arbitrary (yet reasonable) default height
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:44];
}


-(void)setTintColor:(UIColor*)col
{
  if (clcg_os_geq(@"5.0")) {
    [super setTintColor:col];
    [[self spinner] setColor:col];
  }
}


//------------------------------------------------------------------------------
#pragma mark - Public API


-(id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item
                          target:(id)target
                          action:(SEL)action
                          height:(CGFloat)h
{
  return [self initWithImage:nil
                     orTitle:nil
                orSystemItem:item
                       style:UIBarButtonItemStylePlain
                      target:target
                      action:action
                      height:h];
}


- (id)initWithTitle:(NSString *)t
              style:(UIBarButtonItemStyle)st
             target:(id)target
             action:(SEL)a
             height:(CGFloat)h
{
  return [self initWithImage:nil orTitle:t style:st target:target action:a height:h];
}


-(id)initWithImage:(UIImage *)img
             style:(UIBarButtonItemStyle)st
            target:(id)target
            action:(SEL)a
            height:(CGFloat)h
{
  return [self initWithImage:img orTitle:nil style:st target:target action:a height:h];
}


-(void)setState:(enum CLCGBarButtonItemState)state
{
  switch (state) {
    case CLCGBarButtonItemStateReady:
      if (mIsSystemItem) {
        // remove customView so that UIBarButtonItem system graphics are rendered
        [self setCustomView:nil];
      } else {
        [mToggler setState:CLCGTogglerFirstView];
        if ([[self title] length] == 0) {
          [self setCustomView:mToggler];
        } else {
          [self setCustomView:nil];
        }
      }
      break;
    case CLCGBarButtonItemStateBusy:
      // show the spinner
      [mToggler setState:CLCGTogglerSecondView];
      [self setCustomView:mToggler];
      break;
    case CLCGBarButtonItemStateHidden:
      [mToggler setState:CLCGTogglerFirstView];
      [[mToggler firstView] setHidden:YES];
      if ([[self title] length] > 0) {
        // for a textual button, this will "show" the empty button we created.
        [self setCustomView:mToggler];
      }
      break;
    default:
      break;
  }

  mState = state;
}


-(enum CLCGBarButtonItemState)state
{
  return mState;
}


//------------------------------------------------------------------------------
#pragma mark - Private


/*
 This method MUST NOT be invoked with `img` and `title` both non-nil.
 The non-nil value will be used. 
 If `img` and `title` are both nil, the systemItem will be considered,
 otherwise it will be ignored.
 */
- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  return [self initWithImage:img
                     orTitle:title
                orSystemItem:UIBarButtonSystemItemDone
                       style:style
                      target:target
                      action:action
                      height:h];
}


- (id)initWithImage:(UIImage*)img
            orTitle:(NSString*)title
       orSystemItem:(UIBarButtonSystemItem)item
              style:(UIBarButtonItemStyle)style
             target:(id)target
             action:(SEL)action
             height:(CGFloat)h
{
  if (title == nil)
    title = @"";

  if (img == nil && [title length] == 0) {
    self = [super initWithBarButtonSystemItem:item target:target action:action];
    mIsSystemItem = YES;
  } else {
    self = [super initWithTitle:title style:style target:target action:action];
    mIsSystemItem = NO;
  }

  if (self) {
    UIView *first;
    UIButton *b;
    UIActivityIndicatorView *second;
    CGFloat w;

    // set up second view
    second = [[UIActivityIndicatorView alloc]
              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [second startAnimating];
    [second autorelease];
    
    // set up first view
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    if (img) {
      CGFloat x, y;
      CGSize imgsz = [img size];

      [b setTitle:@"" forState:UIControlStateNormal];
      [b setBackgroundImage:img forState:UIControlStateNormal];
      [b setAutoresizingMask:
       UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin
       |UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
      [b setContentMode:UIViewContentModeCenter];
      [b setOpaque:YES];
      [b setBackgroundColor:[UIColor clearColor]];

      w = MAX(imgsz.width, [second w]);
      first = [[[UIView alloc] initWithFrame:CGRectMake(0,0,w,h)] autorelease];
      x = (w - imgsz.width)/2;
      y = (h - imgsz.height)/2;
      [b setFrame:CGRectMake(x, y, imgsz.width, imgsz.height)];
      [first addSubview:b];
    } else {
      // if we've a textual button, we're going to render ourselves as a
      // normal UIBarButton. This is just to display the hidden state.
      UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
      w = MAX([title sizeWithFont:font].width, [second w]);
      first = b;
    }
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    // set up the toggler view
    mToggler = [[CLCGTogglerView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    [mToggler setFirstView:first];
    [mToggler setSecondView:second];

    [self setState:CLCGBarButtonItemStateReady];
  }
  return self;
}


-(UIActivityIndicatorView*)spinner
{
  return (UIActivityIndicatorView*)[mToggler secondView];
}


@end

