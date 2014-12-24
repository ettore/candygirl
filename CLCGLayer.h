// Copyright (c) 2012, Ettore Pasquini
// Copyright (c) 2012, Cubelogic
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
//  Created by Ettore Pasquini on 7/5/12.
//

#import <QuartzCore/QuartzCore.h>

#import "CLCGImageLoader.h"

@interface CLCGLayer : CALayer

/**
 * Loads image from a URL and sets it as this layer's contents.
 * Will load the retina or non-retina image according to device capabilities.
 *
 * If a cache is provided, the downloaded UIImage object will be stored there 
 * with the used URL as key. The caller will need to call cleanupLayer if it
 * is about to release the cache object from memory in order to avoid a 
 * dangling pointer error.
 *
 * TODO: the caller doesn't know which URL was actually used.
 */
-(void)loadImageForURL:(NSString*)url
             retinaURL:(NSString*)retinaurl
                 cache:(NSCache*)cache;

/**
 * Removes content, cancels pending request, and zeros out delegate and cache
 * pointers.
 */
-(void)cleanupLayer;

@end
