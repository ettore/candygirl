/*
 Copyright (c) 2012, Ettore Pasquini
 Copyright (c) 2012, Cubelogic
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


@interface NSString (Candygirl)


/*! 
 Truncates the string (after stripping HTML) if it's longer than 150
 characters, and adds ellipsis if needed.
 */
-(NSString*)ellipsisized;

/*!
 Truncates the string (after stripping HTML) if it's longer than a given number
 of characters, and adds ellipsis if needed.
 */
-(NSString*)ellipsisized:(NSUInteger)maxlen;

/*!
 Decodes characters from their respective HTML entities.
 E.g.:    &amp  --->  &;
 */
-(NSString*)HTMLDecoded;

/*! 
 Encodes characters into their respective HTML entities.
 Currently this supports only the predefined XML entities " ' < > &.
 E.g.:    &     --->  &amp;
 */
-(NSString *)HTMLEncoded;

/*! 
 Strips all HTML tags from the receiver. 
 */
-(NSString *)HTMLStripped;

/*! URL-encodes (i.e. %-escapes) the receiver. */
-(NSString*)URLEncode;

/*! Trims whitespaces only. */
-(NSString*)trimws;

/*! Trims whitespaces and new lines too. */
-(NSString*)trimwsnl;

/*! Trims all content after the first occurrence of `search_str'. */
-(NSString*)trimAfterFirstOccurrence:(NSString*)search_str;

/*!
 * Trims and attempts to fix the receiver by adding the "http://" scheme
 * specification if no other scheme is present.
 */
-(NSString *)fixURLString;

/*!
 * @return A shortened version of a given name, taking the first words that
 * match the given length. E.g.
 *      shortenedName(@"Ettore Pasquini", 10) --> "Ettore"
 * If the first word is still too long, it will be returned truncated with a
 * tolerance of + 2 additional chars. No ellipses are added.
 */
-(NSString *)shortenedName:(NSUInteger)max_len;

#ifndef CLCG_APP_EXTENSIONS

/*!
 Measures the size of this string with a max width assuming word wrapping 
 line break and a max height as device height.

 This is a wrapper for -boundingRectWithSize:options:attributes:context: and
 sizeWithFont:forWidth:lineBreakMode:.
 */
-(CGSize)sizeWithMaxW:(CGFloat)max_w font:(UIFont*)font;

/*!
 Measures the size of this string with a max width/height assuming word 
 wrapping line break.

 This is a wrapper for -boundingRectWithSize:options:attributes:context: and
 sizeWithFont:forWidth:lineBreakMode:.
 */
-(CGSize)sizeWithMaxW:(CGFloat)max_w maxH:(CGFloat)max_h font:(UIFont*)font;

#endif

@end
