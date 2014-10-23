//
//  CLCGImageLoader.h
//  Created by Ettore Pasquini on 9/3/12.
//

#import <Foundation/Foundation.h>

/*! 
 @discussion These are additional codes used when HTTP status codes are not
        suitable, for instance if the network request is skipped becaue the 
        image is cached. Therefore, they should never be greater than 100.
 */
enum CLCGImageStatus {
  CLCGImageStatusCached = 10,
};

typedef void (^CLCGImageLoaderCallback)(UIImage *img, int http_status);

@class ASIHTTPRequest;

@protocol CLCGImageLoaderDelegate
-(void)didDownloadImage:(UIImage*)img;
-(void)downloadFailedWithHTTPStatus:(int)status;
@end


@interface CLCGImageLoader : NSObject

@property(nonatomic,retain,readonly) NSCache *cache;

/*! 
 @deprecated
 */
+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block;

/*!
 @deprecated
 */
+(ASIHTTPRequest*)loadImageForURL:(NSString*)normal_url
                        retinaURL:(NSString*)retina_url
                      retinaHDURL:(NSString*)retina_hd_url
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block;

@end
