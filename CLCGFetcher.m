//  CLCGFetcher.m
//  Goodreads
//  Created by Ettore Pasquini on 12/21/10.
//  Copyright 2010 Goodreads. All rights reserved.

#import "clcg_macros.h"
#import "CLCGFetcher.h"

static const NSTimeInterval SIMPLE_DATA_FETCHER_TIMEOUT = 20.0; //seconds

@implementation CLCGFetcher

@synthesize data = mRespData;
@synthesize error = mError;
@synthesize success = mSuccess;
@synthesize delegate = mDelegate;
@synthesize model = mModel;
@synthesize view = mView;

- (void)dealloc
{
  CLCG_P(@"");
  mDelegate = nil;
  mView = nil;
  mModel = nil;
  [mConnection cancel];
  CLCG_REL(mConnection);
  CLCG_REL(mRequest);
  CLCG_REL(mResponse);
  CLCG_REL(mRespData);
  CLCG_REL(mError);
  
  [super dealloc];
}


-(id)init:(NSString*)url 
 delegate:(id<CLCGFetcherDelegate>)d
    model:(id)m
     view:(id)v
{
  if (self = [super init]) {
    mRequest = [[NSMutableURLRequest alloc] 
                initWithURL:[NSURL URLWithString:url]
                cachePolicy:NSURLRequestReloadIgnoringCacheData
                timeoutInterval:SIMPLE_DATA_FETCHER_TIMEOUT];
    [mRequest setHTTPMethod:@"GET"];
    mDelegate = d;
    mModel = m;
    mView = v;
  }
  
  return self;
}


- (void)start
{
  CLCG_P(@"STARTING");

  if (mConnection)
    [self cancel]; //clears any existing connection
  TTDASSERT(mConnection == nil);
  
  // need to retain model and view if we want callers to access them when the
  // connection completes
  [mModel retain];
  [mView retain];
  mConnection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
    
  if (mRespData)
    [mRespData release];
  mRespData = [[NSMutableData data] retain];
}


- (void)cancel
{
  if (mConnection) {
    CLCG_P(@"CANCEL");
    [mConnection cancel];
    [mConnection release];
    mConnection = nil;
  }
}


- (BOOL)isEqual:(id)object
{
  return (self == object);
}


#pragma mark -
#pragma mark NSURLConnection methods


// Called when the remote site has responded and download is about to begin. 
- (void)connection:(NSURLConnection*)conn didReceiveResponse:(NSURLResponse*)resp
{
  CLCG_P(@"RESPN");
  
	if (mResponse) {
		[mResponse release];
  }
	mResponse = [resp retain];
	
  // prepared buffer to store actual data
  [mRespData setLength:0];
}


- (void)connection:(NSURLConnection*)conn didReceiveData:(NSData*)d
{
  CLCG_P(@"DOWNLDING");
  [mRespData appendData:d];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)conn
{
  CLCG_P(@"FINISHED");
  mSuccess = YES;
  
  //TODO-XX should make sure this is invoked on the main thread
  [mDelegate didDownload:self];
  
  // cleanup
  [mModel release];
  [mView release];
}


- (void)connection:(NSURLConnection*)conn didFailWithError:(NSError*)err
{
  TTDPRINT(@"%@ FAILED:  %@ %@", self, err, [mRequest URL]);
  mSuccess = NO;
  mError = [err retain];

  //TODO-XX should make sure this is invoked on the main thread
  [mDelegate didDownload:self];

  // cleanup
  [mModel release];
  [mView release];
}


@end
