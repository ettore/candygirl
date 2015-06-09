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

//TODO: remove this dependency!
#import "ASIHTTPRequest.h"

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"
#import "CLCGLayer.h"


@interface CLCGLayer ()

// non-retained pointer to an external cache where to store the UIImage
// object we fetched.
@property(nonatomic,weak) NSCache *cache;

@property(nonatomic,strong) ASIHTTPRequest  *req;

@end


@implementation CLCGLayer


-(void)dealloc
{
  [self cleanupLayer];
}


-(void)cleanupLayer
{
  [self setContents:nil];
  _cache = nil;
  [_req clearDelegatesAndCancel];
}


-(void)loadImageForURL:(NSString*)normalurl 
             retinaURL:(NSString*)retinaurl
                 cache:(NSCache*)cache
{
  if (_req) {
    [_req cancel];
  }
  
  self.cache = cache;

  // don't use the built-in CLCGImageLoader cache if we're using an external cache
  self.req = [CLCGImageLoader loadImageForURL:normalurl
                                    retinaURL:retinaurl
                                     useCache:(_cache == nil)
                                        block:^(UIImage *img, int http_status) {
                                          NSCache *cache = self.cache;
                                          if (img) {
                                            [cache
                                             setObject:img
                                             forKey:[[self.req
                                                      originalURL] absoluteString]];
                                            [self setContents:(id)[img CGImage]];
                                          } else {
                                            CLCGP(@"Error loading image. HTTP status=%d",
                                                   http_status);
                                          }
                                          self.req = nil;
                                        }];
}


@end
