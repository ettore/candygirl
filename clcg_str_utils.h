// Copyright (c) 2011, Goodreads
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

#ifndef CLCG_STR_UTILS_H_
#define CLCG_STR_UTILS_H_

#ifdef __cplusplus
extern "C" {
#endif

  // given a url string, append the given parameter to it.
  extern NSString *clcg_str_append2url(NSString *url,
                                       NSString *param_name,
                                       NSString *param_val);

  // returns YES if string are equal (or both nil), NO otherwise
  extern BOOL clcg_str_eq(NSString *s, NSString *t);

  // Converts the contents of the object (e.g. NSData) into a string.
  extern NSString *clcg_str_from(id data);
  
  // trims string left and right.
  extern NSString *clcg_str_trim(NSString *s);
  
  // returns a substring no longer than max_len; if max_len > [s length], 
  // returns the whole string.
  extern NSString *clcg_str_sub(NSString *s, unsigned max_len);

  // is the string nil, empty string, or whitespace chars only.
  extern BOOL clcg_str_isblank(NSString *s);

  // adds possessive suffix ('s or ')
  extern NSString* clcg_str_addpossessive(NSString *s);

  // extracts first word in a string
  extern NSString *clcg_str_firstword(NSString *s);
  
  // returns the same string with the first character capitalized.
  extern NSString *clcg_str_capitalize_firstword(NSString *s);

#ifdef __cplusplus
}
#endif

#endif
