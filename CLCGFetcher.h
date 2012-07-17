//
//  CLCGFetcher.h
//  Goodreads
//  Created by Ettore Pasquini on 12/21/10.
//  Copyright 2012 Goodreads. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////

@class CLCGFetcher;

@protocol CLCGFetcherDelegate

-(void)didDownload:(CLCGFetcher*)r;

@end

///////////////////////////////////////////////////////////////////////////////


@interface CLCGFetcher : NSObject {
  NSMutableURLRequest *mRequest;
  NSURLResponse *mResponse;
  NSURLConnection *mConnection;
  NSMutableData *mRespData;
  id<CLCGFetcherDelegate> mDelegate;
  id mModel;
  id mView;
  BOOL mSuccess;
  NSError *mError;
}

@property(nonatomic,retain,readonly) NSMutableData *data;
@property(nonatomic,retain,readonly) NSError *error;
@property(nonatomic,readonly)        BOOL success;
@property(nonatomic,assign)          id<CLCGFetcherDelegate> delegate;
@property(nonatomic,retain,readonly) id model;
@property(nonatomic,retain,readonly) id view;

-(id)init:(NSString*)url 
 delegate:(id<CLCGFetcherDelegate>)d 
    model:(id)m 
     view:(id)v;

-(void)start;
-(void)cancel;

@end
