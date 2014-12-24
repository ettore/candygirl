//
//  UIWindowCategory.m
//  PostalChess
//
//  Created by Ettore Pasquini on 11/18/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "UIWindow+CLCG.h"

@implementation UIWindow (Candygirl)

-(void)show:(UIView*)v
{
  [self addSubview:v];
  [self makeKeyAndVisible];
}

@end
