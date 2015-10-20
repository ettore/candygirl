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
 Singleton instance of the CLCGImageLoader
 */
+(CLCGImageLoader*)i;

/*!
 @return The largest size image currently stored in cache.
 */
+(UIImage*)bestCachedImageForURL:(NSString*)normal_url
                       retinaURL:(NSString*)retina_url
                     retinaHDURL:(NSString*)retina_hd_url;

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
