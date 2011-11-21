/*
 Copyright (c) 2011, Cubelogic. All rights reserved.
 
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
 
 Created by Ettore Pasquini on 10/19/11.
 
 */

#import <Foundation/Foundation.h>

/**
 * Does a snapshot of a view appending a title below it.
 */
UIImage *clcg_do_snapshot(UIView *v, NSString *title);


/**
 * Scenario: you want to hide the bottom bar when a VC of class 'hiding_vc_class'
 * is pushed on the stack.
 *
 * Usage: from your UINavigationController subclass, override 
 * pushViewController:animated: and call this function before calling super.
 * Use this function in conjunction with clcg_popping_vc_from_hiding().
 *
 * @param nc The Navigation Controller who's pushing the view controllers on
 *           the navigation stack.
 * @param vc The view conroller about to be pushed.
 * @param hiding_vc_class The specific class for which we want to hide the 
 *        bottom bar.
 */
void clcg_pushing_vc_for_hiding(UINavigationController *nc, 
                                UIViewController *vc, 
                                Class hiding_vc_class);


/**
 * Scenario: you want to show back the bottom bar when a VC of class 
 * 'hiding_vc_class' is popped from the stack.
 * 
 * Usage: from your UINavigationController subclass, override 
 * popViewControllerAnimated: and call this function before calling super.
 *
 * @param nc The Navigation Controller who's popping the view controllers on
 *           the navigation stack.
 * @param hiding_vc_class The specific class for which we want to hide the 
 *        bottom bar.
 */
void clcg_popping_vc_from_hiding(UINavigationController *nc, Class hiding_vc_class);


/**
 * Creates an UIActivityIndicatorView of given size in pixels and returns it. 
 * The returned instance is not autoreleased: the celler will have to
 * take care of releasing it when needed.
 */
UIActivityIndicatorView *clcg_new_spinny(CGFloat size);


/**
 * Creates an UIActivityIndicatorView of given size in pixels, attaches it to 
 * the accessory view of the table-view cell, and autoreleases it.
 */
void clcg_attach_spinny2cell(CGFloat size, UITableViewCell *cell);

