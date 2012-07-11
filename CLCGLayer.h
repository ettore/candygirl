//
//  CLCGLayer.h
//  Goodreads
//
//  Created by Ettore Pasquini on 7/5/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class ASIHTTPRequest;

@protocol CLCGImageLoaderDelegate
-(void)requestFinished:(ASIHTTPRequest *)req;
-(void)requestFail:(ASIHTTPRequest *)req;
@end


@interface CLCGLayer : CALayer <CLCGImageLoaderDelegate>
{
  ASIHTTPRequest *mReq;
}

-(void)loadImageForURL:(NSString*)url retinaURL:(NSString*)retinaurl;
+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         delegate:(id<CLCGImageLoaderDelegate>)delegate;


@end
