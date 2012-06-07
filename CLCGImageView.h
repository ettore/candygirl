//
//  CLCGImageView.h
//  Goodreads
//  Created by Ettore Pasquini on 6/4/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

@class ASIHTTPRequest;

@interface CLCGImageView : UIImageView
{
  NSString *mUrl;
  NSString *mRetinaUrl;
  ASIHTTPRequest *mReq;
}

-(void)loadImageForURL:(NSString*)url retinaURL:(NSString*)retinaurl;

@end
