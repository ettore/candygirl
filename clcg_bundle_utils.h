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


#ifndef CLCG_BUNDLE_UTILS_H_
#define CLCG_BUNDLE_UTILS_H_

#import <AudioToolbox/AudioToolbox.h>

#define CLCG_LOC(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

/**
 * Create a short sound, such as a tick, from a sampled sound on disk.
 * The actual sample should reside inside the app bundle.
 * This function does not play the actual sound: to play it, use the 
 * AudioServicesPlaySystemSound with the returned SystemSoundID.
 * Once you're done using the created sound, dispose it with 
 * AudioServicesDisposeSystemSoundID().
 */
SystemSoundID clcg_create_short_snd(NSString *filename, NSString *ext);

#endif //ifndef CLCG_BUNDLE_UTILS_H_
