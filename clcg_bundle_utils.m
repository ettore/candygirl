// Copyright (c) 2011, Ettore Pasquini
// Copyright (c) 2011, Cubelogic
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

#import "clcg_bundle_utils.h"

SystemSoundID clcg_create_short_snd(NSString *filename, NSString *ext)
{
  OSStatus err;
  SystemSoundID snd_id;
  UInt32 flag = 0;
  NSBundle *bndl = [NSBundle mainBundle];
  NSString *path = [bndl pathForResource:filename ofType:ext];
  NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO]; 
  
  err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &snd_id);

  err = AudioServicesSetProperty(kAudioServicesPropertyIsUISound,
                                 sizeof(UInt32),
                                 &snd_id,
                                 sizeof(UInt32),
                                 &flag);

//  // do not set this unless you require lower i/o latency
//  float len = 0.8; // In seconds
//  err = AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, 
//                                sizeof(len), &len);
  
  return snd_id;
}
