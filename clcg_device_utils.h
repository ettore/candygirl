// Copyright (c) 2011, Goodreads
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


#ifdef __cplusplus
extern "C" {
#endif

  /** This group of functions save a pref value to defaults. */
  void clcg_savepref(NSString *key, NSString *value);
  void clcg_savepref_bool(NSString *key, BOOL value);

  /** Returns a string with the resolution (in pixel) and the scale value. */
  NSString *clcg_device_resolution();
  
  /** Returns YES if the device has camera capability. */
  BOOL clcg_has_camera();

  /** Returns YES if the device has a Retina display. */
  BOOL clcg_has_retina();
  
  /** Returns YES if the device is an iPad. */
  BOOL clcg_is_ipad();
 
  /** 
   * Returns YES if the OS version is >= than given version. The version string
   * can be something like "3.1".
   */
  BOOL clcg_os_geq(NSString* version);
  
#ifdef __cplusplus
}
#endif
