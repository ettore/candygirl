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
  [mReq cancel];
  [mReq setDelegate:nil];
  mTapTarget = nil;
  mTapAction = nil;
  CLCG_REL(mReq);
  [super dealloc];
}


-(void)addTarget:(id)target onTapAction:(SEL)action
{
  mTapAction = action;

  // we want to keep an "assign" memory policy here to avoid circular references
  // with container classes, who are likely to retain us. For instance, on a 
  // memory warning situation the container or vc will release us, and once 
  // viewDidLoad is re-hit, the client code will reassign the target in there.
  mTapTarget = target;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  if ([touches count] == 1)
    [mTapTarget performSelector:mTapAction withObject:self];
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


- (void)requestFinished:(ASIHTTPRequest *)req
{
  NSData *data = [req responseData];
  UIImage *img = [UIImage imageWithData:data];
  
  [self setImage:img];
  
  CLCG_REL(mReq);
}


- (void)requestFail:(ASIHTTPRequest *)req
{
  CLCG_P(@"%@", [req error]);
  CLCG_REL(mReq);
}

@end
