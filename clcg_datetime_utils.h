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

#ifndef CLCG_DATETIME_UTILS_H_
#define CLCG_DATETIME_UTILS_H_

#import <Foundation/Foundation.h>

#define CLCG_MINUTE   60
#define CLCG_HOUR     (60 * CLCG_MINUTE)
#define CLCG_DAY      (24 * CLCG_HOUR)
#define CLCG_WEEK     (7 * CLCG_DAY)
#define CLCG_MONTH    (30.5 * CLCG_DAY)
#define CLCG_YEAR     (365 * CLCG_DAY)

#ifdef __cplusplus
extern "C" {
#endif

  /*! Get the year out of a date object. */
  NSInteger clcg_date_year(NSDate *d);

  /*!
   @abstract
   Formats `d` as `X days Y hour Z seconds ago` from today's date/time.
   @discussion
   Formatting assumes you have defined the following strings in your
   localizable.strings file: "year", "month", "day", "hour", "minute", "second",
   plus their respective plurals, plus the "just about now" string.
   */
  NSString *clcg_ago_format(NSDate *d);

  /*!
   @abstract
   Formats `d` according to a localized "ago_format_minimal" string.
   @discussion
   This function assumes you have defined the following strings in your
   localizable.strings file:
   "ago_format_minimal.year"
   "ago_format_minimal.month"
   "ago_format_minimal.day"
   "ago_format_minimal.hour"
   "ago_format_minimal.minutes"
   "ago_format_minimal.seconds".
   */
  NSString *clcg_ago_format_minimal(NSDate *d);

  NSTimeInterval clcg_secondsSinceEpoch();

#ifdef __cplusplus
}
#endif

#endif
