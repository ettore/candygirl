//
//  CLCGImageView.h
//  Goodreads
//  Created by Ettore Pasquini on 6/4/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "CLCGImageLoader.h"

typedef void (^CLCGImageViewOnLoadCallback)(UIImage *img, int http_status);

@interface CLCGImageView : UIImageView

@property (nonatomic, copy) CLCGImageViewOnLoadCallback callback;

-(void)loadImageForURL:(NSString*)url retinaURL:(NSString*)retinaurl;

/*!
 * Adds an action to on touch-up event. The action signature is the standard:
 *   -(void)theAction:(id)sender;
 */
-(void)addTarget:(id)target onTapAction:(SEL)action;

@end
