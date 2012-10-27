//
//  NSArrayCategory.m
//  Goodreads
//
//  Created by Ettore Pasquini on 10/25/12.
//
//


#import "NSArrayCategory.h"


@implementation NSArray (NSArrayCategory)


-(NSArray*)map:(SEL)item_method
{
  NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];

  for (id item in self) {
    [a addObject:[item performSelector:item_method]];
  }

  return a;
}

@end
