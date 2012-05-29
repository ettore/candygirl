//
//  UIApplicationCategory.h
//  Created by e p on 3/18/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Candygirl)

// returns keyWindow if not nil or the last element of the windows array
-(UIWindow*)mainWindow;

//adds v as a subview of the current window
-(void)show:(UIView*)v;

@end
