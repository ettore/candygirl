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

#ifndef CLCG_DEBUG_H_
#define CLCG_DEBUG_H_

#ifdef __cplusplus
extern "C" {
#endif


///////////////////////////////////////////////////////////////////////////////
// logging macro

#define CLCG_LOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define CLCGLOG CLCG_LOG


///////////////////////////////////////////////////////////////////////////////
// debugging macros

#ifdef CLCG_DEBUG_LOGGING
#define CLCG_P(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CLCG_P(xx, ...)  ((void)0)
#endif
#define CLCGP CLCG_P


/* e.g. CLCG_PSIZE(@"screen bounds", [[UIScreen mainScreen] bounds]); */
#ifdef CLCG_DEBUG_LOGGING
#define CLCG_PRECT(s,r) NSLog(@"%s(%d): %@ (%.0f,%.0f) (%.0f,%.0f)", __PRETTY_FUNCTION__, \
        __LINE__, s, r.origin.x, r.origin.y, r.size.width, r.size.height)
#else
#define CLCG_PRECT(s,r)  ((void)0)
#endif
#define CLCGPR CLCG_PRECT


/* e.g. CLCG_PSIZE(@"screen size", [[UIScreen mainScreen] bounds].size); */
#ifdef CLCG_DEBUG_LOGGING
#define CLCG_PSIZE(s,r) NSLog(@"%s(%d): %@ (%.0f,%.0f)", __PRETTY_FUNCTION__, \
        __LINE__, s, r.width, r.height);
#else
#define CLCG_PSIZE(s,r)  ((void)0)
#endif
#define CLCGPSZ CLCG_PSIZE


///////////////////////////////////////////////////////////////////////////////
// assert macro

#ifdef DEBUG

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR

int am_i_being_debugged(void);
// We leave the __asm__ in this macro so that when a break occurs, we don't 
// have to step out of a "breakInDebugger" function.
#define CLCG_ASSERT(xx) { if (!(xx)) { CLCG_P(@"CLCG_ASSERT failed: %s", #xx); \
if (am_i_being_debugged()) { __asm__("int $3\n" : : ); }; } \
} ((void)0)
#else
#define CLCG_ASSERT(xx) { if (!(xx)) { CLCG_P(@"CLCG_ASSERT failed: %s", #xx); } } ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR

#else
#define CLCG_ASSERT(xx) ((void)0)
#endif // #ifdef DEBUG
#define CLCGASSERT CLCG_ASSERT


///////////////////////////////////////////////////////////////////////////////
// exception macro

#ifdef DEBUG
#define CLCG_INCONSISTENCY(msg,obj) {[NSException raise:NSInternalInconsistencyException format:@"%@ Class: %@",msg,NSStringFromClass([obj class])];}
#else
#define CLCG_INCONSISTENCY(msg,obj) ((void)0)
#endif


#ifdef __cplusplus
}
#endif
    
#endif // #ifndef CLCG_DEBUG_H_
