// Copyright (c) 2012, Ettore Pasquini
// Copyright (c) 2012, Cubelogic
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  Created by Ettore Pasquini on 6/4/12.
//

// deprecated: we should really abstract this out of the class
#import "ASIHTTPRequest.h"

#import "clcg_debug.h"
#import "clcg_macros.h"
#import "clcg_str_utils.h"
#import "clcg_device_utils.h"
#import "CLCGImageView.h"

@interface CLCGImageView ()
@property(nonatomic,strong) ASIHTTPRequest  *req; //deprecated
@end

@implementation CLCGImageView


-(void)dealloc
{
  [_req clearDelegatesAndCancel];
}


-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setUserInteractionEnabled:YES];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    [self setOpaque:YES];
    [self setClearsContextBeforeDrawing:NO];
  }
  return self;
}

-(void)loadImageForURL:(NSString*)normal_url
             retinaURL:(NSString*)retina_url
{
  [self loadImageForURL:normal_url
              retinaURL:retina_url
            retinaHDURL:nil];
}

-(void)loadImageForURL:(NSString*)normal_url
             retinaURL:(NSString*)retina_url
           retinaHDURL:(NSString*)retina_hd_url
{
  if (_req) {
    [_req cancel];
  }

  self.req = [CLCGImageLoader loadImageForURL:normal_url
                                    retinaURL:retina_url
                                  retinaHDURL:retina_hd_url
                                     useCache:YES
                                        block:^(UIImage *img, int http_status){
                                          if (img) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              [self setImage:img];
                                            });
                                          } else {
                                            CLCGP(@"Error loading image. HTTP status=%d",
                                                  http_status);
                                          }
                                          
                                          if (self.callback) {
                                            self.callback(img, http_status);
                                          }
                                        }];
}


@end
