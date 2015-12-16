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

@interface NSArray (Candygirl)


/*!
 @abstract Map all elements via a given block.

 @discussion
 This method traverses the array sequentially and builds a new array where the
 Nth element is the result of calling the given block with the Nth element of
 the original array. If a given item is mapped to nil (i.e. block returns nil),
 the returned array will contain NSNull instead.

 @param block The function to be applied to all elements of the array.

 @return A new array where each element is the result of calling `block`
 on every item of the original array.
 */
-(NSArray*)clcg_map:(id(^)(id item))block;


/*!
 @abstract Safely map all elements via a given block.

 @discussion
 This method traverses the array sequentially and builds a new array where the
 Nth element is the result of calling the given block with the Nth element of
 the original array. If a given item is mapped to nil (i.e. block returns nil), 
 the returned array will not include it.
 
 @param block The function to be applied to all elements of the array.

 @return A new array where each element is the result of calling `block`
         on every item of the original array, minus the items for which block
         returns nil.
 */
-(NSArray*)clcg_mapTrim:(id(^)(id item))block;


/*!
 @abstract Reduces all elements to a single value.

 @discussion
 Combines (i.e. reduces, folds) all elements of the receiving array
 into an accumulated result by running the given block on each element.
 
 Note: The return type of `block`, the type of `current_acc` and the type 
 of `initial_acc` must match.

 @param initial_acc This is the initial value that will be passed
    to the block the first time it is executed.
 @param block The function that will be run on the current value of the
    accumulator using a given item of the array. Must return the new value
    of the accumulator.

 @return The final value of the accumulator. The type of the returned object
 will match the one returned by `block`.
 */
-(id)clcg_reduce:(id)initial_acc
           block:(id(^)(id current_acc, id item))block;



@end

