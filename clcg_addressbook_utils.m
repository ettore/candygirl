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


void clcg_addressbook_load_contacts(CLCGABCallback callback)
{
  ABAddressBookRef ab;

  // check existence of function, only defined in iOS 6
  if (&ABAddressBookCreateWithOptions != NULL) {
    // iOS 6+
    CFErrorRef error = nil;
    ab = ABAddressBookCreateWithOptions(NULL,&error);
    if (error) {
      callback(nil, NO, (NSError*)error);
    } else {
      ABAddressBookRequestAccessWithCompletion(ab, ^(bool granted, CFErrorRef err) {
        // the callback can occur in the background, but the address book must
        // be accessed on the thread it was created on
        dispatch_async(dispatch_get_main_queue(), ^{
          if (err || !granted) {
            callback(nil, granted, (NSError*)err);
          } else {
            NSMutableArray *people = clcg__process_ab(ab);
            callback(people, YES, nil);
            CFRelease(ab);
          }
        });
      });
    }
  } else {
    // iOS 4/5
    ab = ABAddressBookCreate();
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
  ABPersonSortOrdering sortorder = ABPersonGetSortOrdering();
  CFArraySortValues(people,
                    fullrange,
                    (CFComparatorFunction)ABPersonComparePeopleByName,
                    (void*)sortorder);

  // don't forget to autorelease the result to be a nice cocoa citizen
  NSMutableArray *arr = (NSMutableArray*)people;
  return [arr autorelease];
}
