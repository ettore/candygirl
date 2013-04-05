//
//  CLCGImageLoader.m
//  Goodreads
//
//  Created by Ettore Pasquini on 9/3/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "ASIHTTPRequest.h"

#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"

#import "CLCGImageLoader.h"

@implementation CLCGImageLoader

@synthesize cache = mCache;

-(void)dealloc
{
  CLCG_REL(mCache);
  [super dealloc];
}


-(id)init
{
  self = [super init];
  if (self) {
    mCache = [[NSCache alloc] init];
    [mCache setCountLimit:40];
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


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block
{
  NSURL *url = nil;
  __block ASIHTTPRequest *req = nil;
  
  if (clcg_has_retina()) {
    if (!clcg_str_isblank(retinaurl))
      url = [[NSURL alloc] initWithString:retinaurl];
    else if (!clcg_str_isblank(normalurl))
      url = [[NSURL alloc] initWithString:normalurl];
  } else if (!clcg_str_isblank(normalurl)) {
    url = [[NSURL alloc] initWithString:normalurl];
  }
  
  if (url) {
    [url autorelease];
    
    if (use_cache) {
      UIImage *img = [[[CLCGImageLoader i] cache] objectForKey:[url absoluteString]];
      if (img) {
        [self returnImage:img status:CLCGImageStatusCached block:block];
        return nil;
      }
    }
    
    block = [[block copy] autorelease];//make sure it's on the heap
    
    // configure the request
    req = [[ASIHTTPRequest alloc] initWithURL:url];
    [req addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    
    // Note: this callback is not just for success cases!
    [req setCompletionBlock:^{
      NSData *data = [req responseData];
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
      [CLCGImageLoader reportErrorForRequest:req block:block];
    }];
    
    // execute the request
    [req startAsynchronous];
    
    // cleanup
    [req autorelease];
  }
  
  return req;
}


+(void)returnImage:(UIImage*)img 
            status:(int)status
             block:(CLCGImageLoaderCallback)block
{
#if DEBUG
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
