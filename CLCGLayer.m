//
//  CLCGLayer.m
//  Goodreads
//
//  Created by Ettore Pasquini on 7/5/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//


//TODO: remove this dependency!
#import "ASIHTTPRequest.h"

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
                                          if (img) {
                                            [self.cache
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
