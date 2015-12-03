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
//  Created by Ettore Pasquini on 9/3/12.
//


// TODO remove this horrible dependency
#import "ASIHTTPRequest.h"

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"

#import "CLCGImageLoader.h"

@implementation CLCGImageLoader
{
  NSCache         *_cache;
}


-(id)init
{
  self = [super init];
  if (self) {
    _cache = [[NSCache alloc] init];
    [_cache setCountLimit:40];
  }
  return self;
}


// singleton instance
+(CLCGImageLoader*)i
{
  static CLCGImageLoader* _instance = nil;

  if (_instance == nil)
    _instance = [[CLCGImageLoader alloc] init];
  
  return _instance;
}


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normal_url
                        retinaURL:(NSString*)retina_url
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block
{
  return [self loadImageForURL:normal_url
                     retinaURL:retina_url
                   retinaHDURL:nil
                      useCache:use_cache
                         block:block];
}



+(NSURL*)screenImageURLForURL:(NSString*)normal_url
                    retinaURL:(NSString*)retina_url
                  retinaHDURL:(NSString*)retina_hd_url
{
  NSURL *url = nil;
  const CGFloat screen_scale = [UIScreen mainScreen].scale;
  const BOOL is_retina_hd = (screen_scale >= 3.0);
  const BOOL is_retina = (screen_scale >= 2.0);

  if (is_retina_hd &&
      !clcg_str_isblank(retina_hd_url)) {
    url = [[NSURL alloc] initWithString:retina_hd_url];
  }

  if (url == nil
      && is_retina
      && !clcg_str_isblank(retina_url)) {
    url = [[NSURL alloc] initWithString:retina_url];
  }

  if (url == nil
      && !clcg_str_isblank(normal_url)) {
    url = [[NSURL alloc] initWithString:normal_url];
  }
  return url;
}


+(UIImage*)bestCachedImageForURL:(NSString*)normal_url
                       retinaURL:(NSString*)retina_url
                     retinaHDURL:(NSString*)retina_hd_url
{
  UIImage *img = [[[CLCGImageLoader i] cache] objectForKey:retina_hd_url];

  if (img == nil) {
    img = [[[CLCGImageLoader i] cache] objectForKey:retina_url];
  }

  if (img == nil) {
    img = [[[CLCGImageLoader i] cache] objectForKey:normal_url];
  }

  if (img) {
    return img;
  }

  return nil;
}


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normal_url
                        retinaURL:(NSString*)retina_url
                      retinaHDURL:(NSString*)retina_hd_url
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block
{
  __block ASIHTTPRequest *req = nil;
  NSURL *url = [CLCGImageLoader screenImageURLForURL:normal_url
                                           retinaURL:retina_url
                                         retinaHDURL:retina_hd_url];
  if (url) {
    block = [block copy];//make sure it's on the heap

    if (use_cache) {
      UIImage *img = [[[CLCGImageLoader i] cache] objectForKey:[url absoluteString]];
      if (img) {
        [self returnImage:img status:CLCGImageStatusCached block:block];
        return nil;
      }
    }
    // configure the request
    req = [[ASIHTTPRequest alloc] initWithURL:url];
    [req addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    
    CLCG_MAKE_WEAK(req);

    // Note: this callback is not just for success cases!
    [req setCompletionBlock:^{
      CLCG_MAKE_STRONG(req);
      NSData *data = [req responseData];
      // TODO: we should likely use imageWithData:scale: instead. 
      UIImage *img = [UIImage imageWithData:data];
      
      if (img == nil) {
        [CLCGImageLoader reportErrorForRequest:req block:block];
      } else {
        if (use_cache) {
          [[[CLCGImageLoader i] cache] setObject:img
                                          forKey:[[req originalURL] absoluteString]];
        }
        [self returnImage:img status:[req responseStatusCode] block:block];
      }
    }];
    
    // set callback for request failure (usually for no network cases)
    [req setFailedBlock:^{
      CLCG_MAKE_STRONG(req);
      [CLCGImageLoader reportErrorForRequest:req block:block];
    }];
    
    // execute the request
    [req startAsynchronous];
  }
  
  return req;
}


+(void)returnImage:(UIImage*)img 
            status:(int)status
             block:(CLCGImageLoaderCallback)block
{
#if CLCG_DEBUG_LOGGING
  if (status != 200 && status >= 100)
    CLCG_P(@"Status code: %d", status);
#endif

  if (block)
    block(img, status);
}


+(void)reportErrorForRequest:(ASIHTTPRequest*)req
                       block:(CLCGImageLoaderCallback)block

{
  CLCG_P(@"Status code: %d -- %@", [req responseStatusCode], [req error]);
  if (block)
    block(nil, [req responseStatusCode]);
}


@end
