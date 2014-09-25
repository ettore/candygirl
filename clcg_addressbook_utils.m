/*
 Copyright (c) 2012, Ettore Pasquini
 Copyright (c) 2012, Cubelogic
 All rights reserved.

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


#import <AddressBook/AddressBook.h>

#import "clcg_addressbook_utils.h"



//------------------------------------------------------------------------------
#pragma mark - Private declarations

static NSMutableArray *clcg__process_ab(ABAddressBookRef ab);


//------------------------------------------------------------------------------
#pragma mark - Public definitions


void clcg_addressbook_load_contacts(dispatch_queue_t currq, CLCGABCallback callback)
{
  ABAddressBookRef ab;
  NSDictionary *user_info;

  // make sure to keep a valid object on the heap
  callback = [callback copy];

  // check existence of function, only defined in iOS 6
  if (&ABAddressBookCreateWithOptions != NULL) {
    // iOS 6+
    CFErrorRef error = nil;

    ABAuthorizationStatus auth = ABAddressBookGetAuthorizationStatus();
    switch (auth) {
      case kABAuthorizationStatusRestricted:
        // there's nothing the user can do to change this (e.g. parental
        // controls restrictions, etc)
        user_info = @{NSLocalizedDescriptionKey :
                        CLCG_LOC(@"Unable to access address book.")};
        callback(nil, NO, [[NSError alloc]
                           initWithDomain:@"CLCG"
                           code:-1
                           userInfo:user_info]);
        break;
      case kABAuthorizationStatusDenied: {
        // user denied access in the past. They need to manually go change it
        // in iOS's Settings.app.
        NSString *app_name = [[NSBundle mainBundle]
                              objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        user_info = @{
                      NSLocalizedDescriptionKey :
                        CLCG_LOC(@"An error occurred while trying to access your address book."),

                      NSLocalizedRecoverySuggestionErrorKey :
                        [NSString stringWithFormat:
                         CLCG_LOC(@"Please open the Settings app and enable access to %@ in Privacy > Contacts."),
                         app_name]
                      };

        callback(nil, NO, [[NSError alloc] initWithDomain:@"CLCG"
                                                     code:-2
                                                 userInfo:user_info]);
        break;
      }
      case kABAuthorizationStatusNotDetermined:
        // the user never asked for these permissions ever before
      case kABAuthorizationStatusAuthorized:
        ab = ABAddressBookCreateWithOptions(NULL, &error);
        if (error || ab == nil) {
          callback(nil, NO, (__bridge NSError*)error);
          if (ab)
            CFRelease(ab);
        } else {
          ABAddressBookRequestAccessWithCompletion(ab, [^(bool granted, CFErrorRef err) {
            // the callback could occur in the background, but the address book
            // must be accessed on the thread it was created on
            dispatch_async(currq, [^{
              if (err || !granted) {
                callback(nil, granted, (__bridge NSError*)err);
              } else {
                NSMutableArray *people = clcg__process_ab(ab);
                callback(people, YES, nil);
                CFRelease(ab);
              }
            } copy]);
          } copy]);
        }
        break;
    }
  } else {
    // iOS 4/5
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ab = ABAddressBookCreate();
#pragma clang diagnostic pop
    NSMutableArray *people = clcg__process_ab(ab);
    callback(people, YES, nil);
    CFRelease(ab);
  }
}


//------------------------------------------------------------------------------
#pragma mark - Private definitions


static NSMutableArray *clcg__process_ab(ABAddressBookRef ab)
{
  // extract address book info
  ABAddressBookRevert(ab);
  CFArrayRef all_people = ABAddressBookCopyArrayOfAllPeople(ab);
  CFMutableArrayRef people = CFArrayCreateMutableCopy(NULL, 0, all_people);
  CFRelease(all_people);

  // sort by name
  CFRange fullrange = CFRangeMake(0, CFArrayGetCount(people));
  CFArraySortValues(people,
                    fullrange,
                    (CFComparatorFunction)ABPersonComparePeopleByName,
                    NULL);

  // don't forget to autorelease the result to be a nice cocoa citizen
  NSMutableArray *arr = (__bridge NSMutableArray*)people;
  return arr;
}

