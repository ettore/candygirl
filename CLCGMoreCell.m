//
//  CLCGMoreCell.m
//  Created by Ettore Pasquini on 10/29/12.
//

#import "clcg_bundle_utils.h"
#import "clcg_macros.h"
#import "CLCGUIViewCategory.h"
#import "CLCGMoreCell.h"


@implementation CLCGMoreCell
{
  UIActivityIndicatorView *_spinner;
}


// superclass designated initializer
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuse_id
{
  return [self initReusingId:reuse_id withText:CLCG_LOC(@"More...")];
}


// designated initializer
-(id)initReusingId:(NSString*)reuse_id
          withText:(NSString*)text
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
  if (self) {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_spinner];

    self.textLabel.numberOfLines = 1;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                       | UIViewAutoresizingFlexibleHeight);
    if (text == nil) {
      [_spinner startAnimating];
      self.textLabel.hidden = YES;
    } else {
      [_spinner setHidden:YES];
      [self.textLabel setText:text];
      [self.textLabel setFont:[UIFont boldSystemFontOfSize:18]];

      UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(didTap)];
      [self addGestureRecognizer:recognizer];

      // required to let the tap reach to the underlying tableview
      recognizer.cancelsTouchesInView = NO;
    }
  }

  return self;
}


-(void)didTap
{
  if (_spinner.isHidden) {
    [self showSpinner:YES];
  }
}


-(void)showSpinner:(BOOL)display_spinner
{
  [self.textLabel setHidden:display_spinner];
  [_spinner setHidden:!display_spinner];
  if (display_spinner) {
    [_spinner startAnimating];
  } else {
    [_spinner stopAnimating];
  }
  [self setNeedsLayout];
}


-(void)layoutSubviews
{
  [super layoutSubviews];

  [_spinner centerHorizontally];
  [_spinner centerVertically];

  [self.textLabel setW:([self w] - [self.textLabel x]*2)];
  [self.textLabel centerHorizontally];
  [self.textLabel centerVertically];
}


+(CGFloat)cellHeight
{
  return 50.0f; //TODO-XX
}


@end
