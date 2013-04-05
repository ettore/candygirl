//
//  CLCGImageLoader.h
//  Goodreads
//
//  Created by Ettore Pasquini on 9/3/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
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
{
  NSCache         *mCache;
}

@property(nonatomic,retain,readonly) NSCache *cache;

// singleton instance
+(CLCGImageLoader*)i;

+(ASIHTTPRequest*)loadImageForURL:(NSString*)normalurl 
                        retinaURL:(NSString*)retinaurl
                         useCache:(BOOL)use_cache
                            block:(CLCGImageLoaderCallback)block;

@end
