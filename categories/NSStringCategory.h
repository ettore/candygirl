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

/** URL-encodes (i.e. %-escapes) the receiver. */
-(NSString*)URLEncode;

/** Trims whitespaces only. */
-(NSString *)trimws;

/** Trims whitespaces and new lines too. */
-(NSString *)trimwsnl;

/**
 * Trims and attempts to fix the receiver by adding the "http://" scheme
 * specification if no other scheme is present.
 */
-(NSString *)fixURLString;

/**
 * Returns a shortened version of a given name, taking the first words that
 * match the given length. E.g.
 *      shortenedName(@"Ettore Pasquini", 10) --> "Ettore"
 * If the first word is still too long, it will be returned truncated with a
 * tolerance of + 2 additional chars.
 */
-(NSString *)shortenedName:(int)max_len;

@end
