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

@interface CLCGImageView ()
@property(nonatomic,strong) ASIHTTPRequest  *req;
@end

@implementation CLCGImageView
{
  // target and action for "on tap" event
  id              _tapTarget;
  SEL             _tapAction;
}


-(void)dealloc
{
  [_req clearDelegatesAndCancel];
  _tapTarget = nil;
  _tapAction = nil;
}


-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setUserInteractionEnabled:YES];
    [self setContentMode:UIViewContentModeScaleAspectFit];
  }
  return self;
}


-(void)addTarget:(id)target onTapAction:(SEL)action
{
  [self setUserInteractionEnabled:YES];

  _tapAction = action;

  // we want to keep an "assign" memory policy here to avoid circular references
  // with container classes, who are likely to retain us. For instance, on a 
  // memory warning situation the container or vc will release us, and once 
  // viewDidLoad is re-hit, the client code will reassign the target in there.
  _tapTarget = target;

  UITapGestureRecognizer *tap_recognizer = [[UITapGestureRecognizer alloc]
                                            initWithTarget:_tapTarget
                                            action:_tapAction];
  tap_recognizer.numberOfTapsRequired = 1;
  [self addGestureRecognizer:tap_recognizer];
}


-(void)loadImageForURL:(NSString*)normalurl retinaURL:(NSString*)retinaurl
{
  if (_req) {
    [_req cancel];
  }

  self.req = [CLCGImageLoader loadImageForURL:normalurl
                                retinaURL:retinaurl
                                 useCache:YES
                                    block:^(UIImage *img, int http_status) {
                                      if (img) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [self setImage:img];
                                        });
                                      } else {
                                        CLCG_P(@"Error loading image. HTTP status=%d",
                                               http_status);
                                      }
                                      
                                      if (self.callback) {
                                        self.callback(img, http_status);
                                      }
                                    }];
}


@end
