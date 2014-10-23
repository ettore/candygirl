//
//  CLCGImageView.m
//  Created by Ettore Pasquini on 6/4/12.
//

// deprecated: we should really abstract this out of the class
#import "ASIHTTPRequest.h"

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
                                            CLCG_P(@"Error loading image. HTTP status=%d",
                                                   http_status);
                                          }
                                          
                                          if (self.callback) {
                                            self.callback(img, http_status);
                                          }
                                        }];
}


@end
