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
                         delegate:(id<CLCGImageLoaderDelegate>)delegate
{
  return [CLCGImageLoader loadImageForURL:normalurl 
                                retinaURL:retinaurl 
                                 useCache:NO
                                 delegate:delegate
                                  orBlock:nil];
}


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block
{
  return [CLCGImageLoader loadImageForURL:normalurl 
                                retinaURL:retinaurl 
                                 useCache:use_cache
                                 delegate:nil
                                  orBlock:block];
}


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         useCache:(BOOL)use_cache
                         delegate:(id<CLCGImageLoaderDelegate>)delegate
                          orBlock:(CLCGImageLoaderCallback)block
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
      UIImage *img = [[[CLCGImageLoader i] cache] objectForKey:url];
      if (img) {
        [self returnImage:img status:200 toDelegate:delegate orBlock:block];
        return nil;
      }
    }
    
    __block id<CLCGImageLoaderDelegate> deleg = delegate;
    block = [[block copy] autorelease];//make sure it's on the heap
    
    // configure the request
    req = [[ASIHTTPRequest alloc] initWithURL:url];
    [req addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    
    // Note: this callback is not just for success cases!
    [req setCompletionBlock:^{
      NSData *data = [req responseData];
      UIImage *img = [UIImage imageWithData:data];
      if (img == nil) {
        [CLCGImageLoader reportErrorForRequest:req toDelegate:deleg orBlock:block];
      } else {
        if (use_cache)
          [[[CLCGImageLoader i] cache] setObject:img 
                                          forKey:[[req originalURL] absoluteString]];
        
        [self returnImage:img status:[req responseStatusCode] toDelegate:deleg orBlock:block];
      }
    }];
    
    // set callback for request failure (usually for no network cases)
    [req setFailedBlock:^{
      [CLCGImageLoader reportErrorForRequest:req toDelegate:deleg orBlock:block];
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
        toDelegate:(id<CLCGImageLoaderDelegate>)deleg
           orBlock:(CLCGImageLoaderCallback)block

{
  CLCG_P(@"Status code: %d", status);
  if (block)
    block(img, status);
  else
    [deleg didDownloadImage:img];
}


+(void)reportErrorForRequest:(ASIHTTPRequest*)req
                  toDelegate:(id<CLCGImageLoaderDelegate>)deleg
                     orBlock:(CLCGImageLoaderCallback)block

{
  CLCG_P(@"Status code: %d -- %@", [req responseStatusCode], [req error]);
  if (block)
    block(nil, [req responseStatusCode]);
  else
    [deleg downloadFailedWithHTTPStatus:[req responseStatusCode]]; 
}


@end
