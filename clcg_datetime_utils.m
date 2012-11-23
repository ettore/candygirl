// Copyright (c) 2011, Ettore Pasquini
// Copyright (c) 2011, Cubelogic
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice, this 
//   list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation 
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  Created by Ettore Pasquini on 9/20/11.
//

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

NSString *clcg_ago_format(NSDate *d)
{
  NSCalendar *greg;
  unsigned int flags;
  NSDateComponents *dc;
  NSDate *now = [NSDate date];
  NSInteger t;
  NSString *res, *interval;

  greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  dc = [greg components:flags fromDate:d toDate:now options:0];
  [greg release];

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
