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
  [mReq cancel];
  [mReq setDelegate:nil];
  CLCG_REL(mReq);
  [super dealloc];
}


-(void)loadImageForURL:(NSString*)normalurl retinaURL:(NSString*)retinaurl
{
  if (mReq) {
    [mReq cancel];
    CLCG_REL(mReq);
  }
  
  mReq = [CLCGLayer loadImageForURL:normalurl retinaURL:retinaurl delegate:self];
  [mReq retain];
}


+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         delegate:(id<CLCGImageLoaderDelegate>)delegate
{
  NSURL *url = nil;
  ASIHTTPRequest *req = nil;
  
  if (clcg_has_retina()) {
    if (!clcg_str_isblank(retinaurl))
      url = [[NSURL alloc] initWithString:retinaurl];
    else if (!clcg_str_isblank(normalurl))
      url = [[NSURL alloc] initWithString:normalurl];
  } else if (!clcg_str_isblank(normalurl)) {
    url = [[NSURL alloc] initWithString:normalurl];
  }
  
  if (url) {
    // configure the request
    req = [[ASIHTTPRequest alloc] initWithURL:url];
    [req addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    [req setDidFinishSelector:@selector(requestFinished:)];
    [req setDidFailSelector:@selector(requestFail:)];
    [req setDelegate:delegate];
    
    // execute the request
    [req startAsynchronous];
    
    // cleanup
    [url release];
    [req autorelease];
  }
  
  return req;
}


-(void)requestFinished:(ASIHTTPRequest*)req
{
  NSData *data = [req responseData];
  UIImage *img = [UIImage imageWithData:data];
  
  [self setContents:(id)[img CGImage]];
  
  CLCG_REL(mReq);
}


-(void)requestFail:(ASIHTTPRequest*)req
{
  CLCG_P(@"%@", [req error]);
  CLCG_REL(mReq);
}


@end
