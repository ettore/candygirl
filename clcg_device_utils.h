// Copyright (c) 2011, Ettore Pasquini
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


#ifndef CLCG_DEVICE_UTILS_H_
#define CLCG_DEVICE_UTILS_H_

#ifdef __cplusplus
extern "C" {
#endif

  /*! @abstract Show/hide spinner for network activity in status bar. */
  void clcg_show_network_activity(BOOL show);

  /** Removes a key from the prefs and synchronizes them. */
  void clcg_removepref(NSString *key);
  
  /** Adds `value' to the array pref identified by `key'. */
  void clcg_savepref_in_array(NSString *key, NSString *value);

  /** 
   Saves a pref value to user defaults.
   @param key   The user defaults key.
   @param value Value to save. The value parameter can be only property list
                objects: NSData, NSString, NSNumber, NSDate, NSArray, or
                NSDictionary. For NSArray and NSDictionary objects, their
                contents must be property list objects.
   */
  void clcg_savepref(NSString *key, id<NSCoding> value);
  
  /** Saves a boolean pref value to user defaults. */
  void clcg_savepref_bool(NSString *key, BOOL value);

  /** @return A boolean pref value from the user defaults. */
  BOOL clcg_getpref_bool(NSString *key);

  /** @return A string pref value from the user defaults. */
  NSString *clcg_getpref_str(NSString *key);

  /** @return An object from the user defaults. */
  id clcg_getpref_obj(NSString *key);

  /** @return A string with the resolution (in pixel) and the scale value. */
  NSString *clcg_device_resolution(void);
  
  /** @return YES if the device has camera capability. */
  BOOL clcg_has_camera(void);

  /** @return YES if the device has a Retina display. */
  BOOL clcg_has_retina(void);

  /** @return YES if the device is an iPad. */
  BOOL clcg_is_ipad(void);

  /** @return YES if the device is iPhone or iPod type device. */
  BOOL clcg_is_iphone(void);

  /** @return YES if the device is an iphone5 or bigger (including iPads). */
  BOOL clcg_geq_iphone5(void);

  /** @return YES if the device is an iphone6 or bigger (including iPads). */
  BOOL clcg_geq_iphone6(void);

  /**
   @discussion
   Determine if the current device OS is greater than or equals a given 
   version string.
   @param version A string indicating a iOS system version, such as "4.3.2".
   @return YES if the current device OS version is >= than given `version'.
   */
  BOOL clcg_os_geq(NSString* version);

  /**
   * @return Apple model name for current device.
   *
   * like "iPhone6,1" (iPhone 5s,model A1433, A1533 | GSM)
   * or "iPhone7,1" (iPhone 6 Plus)
   *
   */
  NSString *clcg_device_name();

#ifdef __cplusplus
}
#endif

#endif
