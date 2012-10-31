//
//  CLCGModel.m
//  Goodreads
//
//  Created by Ettore Pasquini on 10/31/12.
//
//

#import "CLCGModel.h"


@implementation CLCGModel : NSObject

@synthesize searchable = mSearchable;


-(void)dealloc
{
  CLCG_REL(mSearchable);
  [super dealloc];
}


/**
 * Returns YES if this user matches all the input words.
 * NB: Each word must be a lowercase string.
 */
-(BOOL)containsWords:(NSArray*)words
{
  if (mSearchable == nil)
    return NO;

  for (NSString *w in words) {
    NSRange r = [mSearchable rangeOfString:w options:NSCaseInsensitiveSearch];
    if (r.location == NSNotFound)
      return NO;
  }
  return YES;
}


-(BOOL)matches:(NSPredicate*)pred
{
  return [pred evaluateWithObject:mSearchable];
}


@end
