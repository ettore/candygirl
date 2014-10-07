/*
 Copyright (c) 2009, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "CLCGAPNHelper.h"
#import "clcg_debug.h"


@interface CLCGAPNHelper ()
@property(nonatomic,retain,readwrite) NSString *deviceToken;
@end


@implementation CLCGAPNHelper

@synthesize isPushRegistered = mIsPushRegistered;
@synthesize hasSyncedDeviceToken = mHasSyncedDeviceToken;
@synthesize deviceToken = mDeviceToken;


#if !__has_feature(objc_arc)
-(void)dealloc
{
  [mDeviceToken release];
  [mOptions release];
  [super dealloc];
}
#endif


-(id)init
{
  if (!(self = [super init]))
    return nil;
  
  mIsPushRegistered = NO;
  mHasSyncedDeviceToken = NO;
  mBadgeCount = -1;

  return self;
}


// @param opt the dictionary received by application:didFinishLaunchWithOptions:
-(void)configureWithInitialOptions:(NSDictionary*)opt
{
  if (opt) {
    NSDictionary *payld;
    
    CLCG_P(@"Initializing with options: %@", opt);
    payld = [opt objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self setOptions:payld];
  }
  [self registerForAllNotifications];
}


+(BOOL)hasPushNotificationsEnabled
{
  if (clcg_os_geq(@"8")) {
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
  } else {
    return ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]
            != UIRemoteNotificationTypeNone);
  }
}


-(void)registerForAllNotifications
{
  CLCG_P(@"Registering for Push Notifications...");
  UIApplication *app = [UIApplication sharedApplication];
  [app registerForRemoteNotificationTypes: 
   (UIRemoteNotificationTypeBadge 
    | UIRemoteNotificationTypeAlert
    | UIRemoteNotificationTypeSound)];
}


-(void)receivedDeviceToken:(NSData*)devtoken_data
{
  CLCG_P(@"Registered for APN: deviceToken=\n%@", [devtoken_data description]);
  
  if (devtoken_data == nil)
    return;
  
  NSString *tokstr;
  
  //  const unsigned *tokdata = (const unsigned *)devtoken_data;
  //	tokstr = [NSString stringWithFormat:
  //            @"%08x%08x%08x%08x%08x%08x%08x%08x", 
  //            ntohl(tokdata[0]), ntohl(tokdata[1]), ntohl(tokdata[2]), 
  //            ntohl(tokdata[3]), ntohl(tokdata[4]), ntohl(tokdata[5]),
  //            ntohl(tokdata[6]), ntohl(tokdata[7])];
  
  tokstr = [[[[devtoken_data description] 
              stringByReplacingOccurrencesOfString:@"<" withString:@""] 
             stringByReplacingOccurrencesOfString:@">" withString:@""] 
            stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  [self setDeviceToken:tokstr];
  mIsPushRegistered = YES;
}


-(void)registrationFailed:(NSError *)err
{
  CLCG_P(@"Registration for APN failed: %@", [err description]);

  [self setDeviceToken:nil];
  mIsPushRegistered = NO;
}


-(NSDictionary*)options
{
  return mOptions;
}


-(void)setOptions:(NSDictionary*)opt
{
#if !__has_feature(objc_arc)
  [opt retain];
  [mOptions release];
#endif
  mOptions = opt;
  [self parseBadgeCount];
}


-(void)parseBadgeCount
{
  if (mOptions == nil)
    mBadgeCount = 0;
  
  NSDictionary *aps = [mOptions objectForKey:@"aps"];
  if (aps == nil)
    mBadgeCount = 0;
  
  id badgeobj = [aps objectForKey:@"badge"];
  if (badgeobj)
    mBadgeCount = [badgeobj integerValue];
}


-(NSUInteger)badgeCount
{
  // if we have a valid value (>0) return that
  if (mBadgeCount >= 0)
    return mBadgeCount;
  
  // ... otherwise parse options
  [self parseBadgeCount];
  
  return (NSUInteger)mBadgeCount;
}


-(void)setBadgeCount:(NSInteger)count
{
  mBadgeCount = count;
}


@end
