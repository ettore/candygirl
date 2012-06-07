//
//  CLCGImageView.m
//  Goodreads
//
//  Created by Ettore Pasquini on 6/4/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "ASIHTTPRequest.h"

#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"
#import "CLCGImageView.h"

@implementation CLCGImageView


-(void)dealloc
{
  CLCG_REL(mUrl);
  CLCG_REL(mRetinaUrl);
  CLCG_REL(mReq);
  [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}


-(void)loadImageForURL:(NSString*)normalurl retinaURL:(NSString*)retinaurl
{
  NSURL *url = nil;
  
  if (mReq) {
    [mReq cancel];
    CLCG_REL(mReq);
  }
  
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
    mReq = [[ASIHTTPRequest alloc] initWithURL:url];
    [mReq addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    [mReq setDidFinishSelector:@selector(requestSuccess:)];
    [mReq setDidFailSelector:@selector(requestFail:)];
    [mReq setDelegate:self];
    
    // execute the request
    [mReq startAsynchronous];
    
    // cleanup
    [url release];
  }
}


- (void)requestSuccess:(ASIHTTPRequest *)req
{
  NSData *data = [req responseData];
  UIImage *img = [UIImage imageWithData:data];
  
  [self setImage:img];
  
  CLCG_REL(mReq);
}


- (void)requestFail:(ASIHTTPRequest *)req
{
  NSError *err = [req error];
  CLCG_P(@"%@", err);
  CLCG_REL(mReq);
}

@end
