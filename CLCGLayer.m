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
  [mReq cancel];
  [mReq setDelegate:nil];
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
  mReq = [CLCGImageLoader loadImageForURL:normalurl retinaURL:retinaurl delegate:self];
  
  // will release on callbacks
  [mReq retain];
}


-(void)didDownloadImage:(UIImage*)img
{
  [mCache setObject:img forKey:[[mReq originalURL] absoluteString]];
  [self setContents:(id)[img CGImage]];
  
  // we retained in loadImageForURL:retinaURL:cache:, so release here.
  CLCG_REL(mReq);
}


-(void)downloadFailedWithHTTPStatus:(int)status
{
  // we retained in loadImageForURL:retinaURL:cache:, so release here.
  CLCG_REL(mReq);
}


@end
