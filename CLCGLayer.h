//
//  CLCGLayer.h
//  Goodreads
//
//  Created by Ettore Pasquini on 7/5/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CLCGImageLoader.h"

@interface CLCGLayer : CALayer <CLCGImageLoaderDelegate>
{
  ASIHTTPRequest  *mReq;
  
  // non-retained pointer to an external cache where to store the UIImage 
  // object we fetched.
  NSCache         *mCache;
}

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
