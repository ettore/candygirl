//
//  CLCGImageView.h
//  Created by Ettore Pasquini on 6/4/12.
//

#import "CLCGImageLoader.h"

typedef void (^CLCGImageViewOnLoadCallback)(UIImage *img, int http_status);

@interface CLCGImageView : UIImageView

@property (nonatomic, copy) CLCGImageViewOnLoadCallback callback;

-(void)loadImageForURL:(NSString*)url
             retinaURL:(NSString*)retinaurl;

-(void)loadImageForURL:(NSString*)normal_url
             retinaURL:(NSString*)retina_url
           retinaHDURL:(NSString*)retina_hd_url;

@end
