/*
 Copyright (c) 2011, Ettore Pasquini
 Copyright (c) 2011, Cubelogic
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

//  Created by Ettore Pasquini on 9/20/11.

#import "clcg_datetime_utils.h"
#import "clcg_bundle_utils.h"


/** Get the year out of a date object. */
NSInteger clcg_date_year(NSDate *d)
{
  NSCalendar *greg;
  NSDateComponents *comps;
  
  greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  comps = [greg components:NSYearCalendarUnit fromDate:d];
  return [comps year];
}


NSDateComponents *date_components_from(NSDate *d)
{
  NSCalendar *greg;
  unsigned int flags;
  NSDate *now = [NSDate date];

  greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  return [greg components:flags fromDate:d toDate:now options:0];
}


NSString *clcg_ago_format(NSDate *d)
{
  NSDateComponents *dc = date_components_from(d);

  NSInteger t;
  NSString *res, *interval;

  if ((t = [dc year])) {
    interval = ((t == 1) ? CLCG_LOC(@"year") : CLCG_LOC(@"years"));
  } else if ((t = [dc month])) {
    interval = ((t == 1) ? CLCG_LOC(@"month") : CLCG_LOC(@"months"));
  } else if ((t = [dc day])) {
    interval = ((t == 1) ? CLCG_LOC(@"day") : CLCG_LOC(@"days"));
  } else if ((t = [dc hour])) {
    interval = ((t == 1) ? CLCG_LOC(@"hour") : CLCG_LOC(@"hours"));
  } else if ((t = [dc minute])) {
    interval = ((t == 1) ? CLCG_LOC(@"minute") : CLCG_LOC(@"minutes"));
  } else if ((t = [dc second])) {
   interval = ((t == 1) ? CLCG_LOC(@"second") : CLCG_LOC(@"seconds"));
  } else {
    return CLCG_LOC(@"just about now");
  }

  res = [NSString stringWithFormat:@"%d %@ %@",t,interval,CLCG_LOC(@"ago")];
  
  return res;
}


NSString *clcg_ago_format_minimal(NSDate *d)
{
  NSDateComponents *dc = date_components_from(d);

  NSInteger t;
  NSString *interval;

  if ((t = [dc year])) {
    interval = CLCG_LOC(@"ago_format_minimal.year");
  } else if ((t = [dc month])) {
    interval = CLCG_LOC(@"ago_format_minimal.month");
  } else if ((t = [dc day])) {
    interval = CLCG_LOC(@"ago_format_minimal.day");
  } else if ((t = [dc hour])) {
    interval = CLCG_LOC(@"ago_format_minimal.hour");;
  } else if ((t = [dc minute])) {
    interval = CLCG_LOC(@"ago_format_minimal.minutes");;
  } else {
    t = [dc second];
    interval = CLCG_LOC(@"ago_format_minimal.seconds");
  }
  return [NSString stringWithFormat:@"%d%@",t,interval];
  
}

