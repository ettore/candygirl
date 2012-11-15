//
//  CLCGLayer.m
//  Goodreads
//
//  Created by Ettore Pasquini on 7/5/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//


#import "ASIHTTPRequest.h"

#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"

#import "CLCGLayer.h"


@implementation CLCGLayer


-(void)dealloc
{
  [self cleanupLayer];
  [super dealloc];
}


-(void)cleanupLayer
{
  [self setContents:nil];
  mCache = nil;

  [mReq clearDelegatesAndCancel];
  CLCG_REL(mReq);
}


-(void)loadImageForURL:(NSString*)normalurl 
             retinaURL:(NSString*)retinaurl
                 cache:(NSCache*)cache
{
  if (mReq) {
    [mReq cancel];
    CLCG_REL(mReq);
  }
  
  mCache = cache;

  // don't use the built-in CLCGImageLoader cache if we're using an external cache
  mReq = [CLCGImageLoader loadImageForURL:normalurl
                                retinaURL:retinaurl
                                 useCache:(mCache == nil)
                                    block:^(UIImage *img, int http_status) {
                                      if (img) {
                                        [mCache setObject:img
                                                   forKey:[[mReq originalURL] absoluteString]];
                                        [self setContents:(id)[img CGImage]];
                                      } else {
                                        CLCG_P(@"Error loading image. HTTP status=%d",
                                               http_status);
                                      }
                                      CLCG_REL(mReq);
                                    }];
  
  // will release in the block callback
  [mReq retain];
}


@end
