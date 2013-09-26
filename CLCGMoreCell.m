//
//  CLCGMoreCell.m
//  Goodreads
//
//  Created by Ettore Pasquini on 10/29/12.
//
//

#import "clcg_bundle_utils.h"
#import "clcg_macros.h"
#import "CLCGUIViewCategory.h"
#import "CLCGMoreCell.h"

@implementation CLCGMoreCell


-(void)dealloc
{
  CLCG_REL(mSpinner);
  [super dealloc];
}


-(id)initReusingId:(NSString*)reuse_id
{
  return [self initReusingId:reuse_id withText:CLCG_LOC(@"More...")];
}


// designated initializer
-(id)initReusingId:(NSString*)reuse_id withText:(NSString*)text
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
  if (self) {
    [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [[self textLabel] setNumberOfLines:1];//set to 0 and calc height dynamically
    [[self textLabel] setTextColor:[UIColor blackColor]];
    [[self textLabel] setBackgroundColor:[UIColor clearColor]];
    [[self textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self textLabel] setText:text];
    [[self textLabel] setFont:[UIFont boldSystemFontOfSize:18]];

    mSpinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self setAccessoryView:mSpinner];
    [mSpinner setHidden:YES];
  }

  return self;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuse_id
{
  return [self initReusingId:reuse_id];
}


-(void)didStartRequestingMore
{
  [mSpinner startAnimating];
  [mSpinner setHidden:NO];
}


-(void)didStopRequestingMore
{
  [mSpinner stopAnimating];
  [mSpinner setHidden:YES];
}


-(void)layoutSubviews
{
  [super layoutSubviews];
  [[self textLabel] setW:[self w]];
}


+(CGFloat)cellHeight
{
  return 50.0f; //TODO-XX
}


@end
