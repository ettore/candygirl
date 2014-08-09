//
//  NSObject+CLCG.m
//  Goodreads
//
//  Created by Pasquini, Ettore on 7/30/14.
//
//

#import "NSObject+CLCG.h"

@implementation NSObject (CLCG)


-(id)performGetter:(SEL)getter
{
  IMP imp = [self methodForSelector:getter];
  id (*func)(id, SEL) = (void *)imp;
  id result = func(self, getter);
  return result;
}


-(void)performSetter:(SEL)setter withObject:(id)value
{
  IMP imp = [self methodForSelector:setter];
  CGRect (*func)(id, SEL, id) = (void *)imp;
  func(self, setter, value);
}


@end
