//  Created by Ettore Pasquini on 5/22/10.

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


@interface CLCGAPNHelper : NSObject 

@property(nonatomic) BOOL isPushRegistered;
@property(nonatomic) BOOL hasSyncedDeviceToken;
@property(nonatomic,strong,readonly) NSString *deviceToken;

/*!
 Current options dictionary. This dictionary contains the notifications
 payload. We get one when a new notification is received while the app is in
 the foreground, or when you "View" the notification to bring the app in the
 foreground.
 TODO: might want to parse the dictionary and just save the individual info,
 instead of parsing it each time.
 */
@property(nonatomic,strong) NSDictionary *options;

/*! The current badge count. A negative value means badge is unassigned. */
@property(nonatomic) NSInteger badgeCount;

/*!
 @abstract Save the initial options received by 
 application:didFinishLaunchWithOptions: for later processing.
 @param opt The dictionary received by application:didFinishLaunchWithOptions:.
 */
-(void)configureWithInitialOptions:(NSDictionary*)opt;

/*!
 @return YES if the user has push notifications enabled for this app.
          NO if the user disables all push notifications in Settings.
 */
+(BOOL)hasPushNotificationsEnabled;

/*! 
 @abstract 
 Registers for sounds, badges, alerts.

 @discussion
 Handles the differences in registering across iOS versions. Call this as a
 shortcut to register for all push notifications.
 */
-(void)registerForAllNotifications;

/*!
 @discussion
 Typically you want to call this from
 application:didRegisterForRemoteNotificationsWithDeviceToken:
 to save the device token.
 */
-(void)receivedDeviceToken:(NSData*)device_token;

/*! adjust state in case registration with APNS failed. */
-(void)registrationFailed:(NSError*)err;

/*!
 @return YES if the app is currently enabled for app badges notifications.
 */
+(BOOL)isAppBadgeEnabled;

@end
