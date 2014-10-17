//
//  NSDate+CLCG.m
//  Created by Pasquini, Ettore on 10/16/14.
//

#import "NSDate+CLCG.h"

@implementation NSDate (CLCG)

+(NSDate*)dateFromGregorianYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
  NSDateComponents *components = [[NSDateComponents alloc] init];
  NSCalendar *gregorian;

  gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  components.year = year;
  components.month = month;
  components.day = day;
  return [gregorian dateFromComponents:components];
}

@end
