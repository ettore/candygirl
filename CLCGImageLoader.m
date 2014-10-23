//
//  CLCGImageLoader.m
//  Created by Ettore Pasquini on 9/3/12.
//

// TODO remove this horrible dependency
#import "ASIHTTPRequest.h"

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





+(ASIHTTPRequest*)loadImageForURL:(NSString*)normal_url
                        retinaURL:(NSString*)retina_url
                      retinaHDURL:(NSString*)retina_hd_url
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block
{
  NSURL *url = nil;
  __block ASIHTTPRequest *req = nil;
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

  if (url) {
    if (use_cache) {
      UIImage *img = [[[CLCGImageLoader i] cache] objectForKey:[url absoluteString]];
      if (img) {
        [self returnImage:img status:CLCGImageStatusCached block:block];
        return nil;
      }
    }
    
    block = [block copy];//make sure it's on the heap
    
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
