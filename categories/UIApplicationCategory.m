//
//  UIApplicationCategory.m
//  Created by e p on 3/18/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "UIApplicationCategory.h"


@implementation UIApplication (Candygirl)


-(UIWindow*)mainWindow
{
  if ([self keyWindow])
    return [self keyWindow];
  
  return [[self windows] lastObject];
}


//adds v as a subview of the current window
-(void)show:(UIView*)v
{
  UIWindow *w = [self mainWindow];
  [w addSubview:v];
  [w makeKeyAndVisible];
}


@end
