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

#import <Availability.h>

#ifndef CLCG_MACROS_H_
#define CLCG_MACROS_H_

////////////////////////////////////////////////////////////////////////////////
// Block-related macros

/*!
 @defined CLCG_EXEC_BLOCK
 @abstract Executes given block by nil-checking it first.
 @discussion E.g. Instead of:
 
 if (the_block) {
   the_block(arg1, arg2, arg3);
 }
 
 use:

 CLCG_EXEC_BLOCK(the_block, arg1, arg2, arg3);
 */
#define CLCG_EXEC_BLOCK(block, ...) if (block) { block(__VA_ARGS__); };


////////////////////////////////////////////////////////////////////////////////
// Stringification macros

/*!
 @defined CLCG_STRINGIFY
 @abstract Converts input param to a stringified version of itself.
 @discussion Note that if `str' is itself a macro, the macro won't be expanded.
 E.g.
 CLCG_STRINGIFY(my_string) will expand to "my_string".

 #define MY_MACRO      my_string
 CLCG_STRINGIFY(MY_MACRO) will expand to "MY_MACRO".
 */
#define CLCG_STRINGIFY(str) #str

/*!
 @defined CLCG_STRINGIFY_DEEP
 @abstract Expands input and adds quotes to stringify the content.
 @discussion This macro stringifies the actual content of the argument,
 expanding all other macros eventually applied.
 E.g.
 CLCG_STRINGIFY_DEEP(my_string) will expand to "my_string".

 #define MY_MACRO      my_string
 CLCG_STRINGIFY_DEEP(MY_MACRO) will also expand to "my_string".
 */
#define CLCG_STRINGIFY_DEEP(str) CLCG_STRINGIFY(str)


////////////////////////////////////////////////////////////////////////////////
// Deprecation helpers

/*!
 * Borrowed from Apple's AvailabiltyInternal.h header. There's no reason why we 
 * shouldn't be able to use this macro, as it's a gcc-supported flag.
 * Here's what we based it off of.
 * __AVAILABILITY_INTERNAL_DEPRECATED         __attribute__((deprecated))
 */
#define __CLCG_DEPRECATED_METHOD __attribute__((deprecated))


////////////////////////////////////////////////////////////////////////////////
// Safe release

#define CLCG_REL(__PTR) { id __T = __PTR; __PTR = nil; [__T release]; }

#define CLCG_CFREL(__REF) { if (nil != (__REF)) {CFRelease(__REF); __REF=nil;} }


////////////////////////////////////////////////////////////////////////////////
// Weak and strong references

/*! Macro to create a weak reference to an object. */
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
#define CLCG_MAKE_WEAK(OBJ)   __weak __typeof__(OBJ) OBJ ## _weak_ = (OBJ);
#else
#define CLCG_MAKE_WEAK(OBJ)   __unsafe_unretained __typeof__(OBJ) OBJ ## _weak_ = (OBJ);
#endif

/*! Macro to create a strong reference to an object. */
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000

#define CLCG_MAKE_STRONG(OBJ) \
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Wshadow\"")\
__strong __typeof__(OBJ) OBJ = OBJ ## _weak_;\
_Pragma("clang diagnostic pop")

#else

#define CLCG_MAKE_STRONG(OBJ) \
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Wshadow\"")\
__typeof__(OBJ) OBJ = OBJ ## _weak_;\
_Pragma("clang diagnostic pop")

#endif


////////////////////////////////////////////////////////////////////////////////
// Flags

/*!
 * For when the flag might be a set of bits, this will ensure that the exact 
 * set of bits in the flag have been set in the value.
 */
#define IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))


#endif //ifdef CLCG_MACROS_H
