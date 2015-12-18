//
//  UIWindow+CLCG.m
//  PostalChess
//
//  Created by Ettore Pasquini on 11/18/12.
//  Copyright (c) 2012 Cubelogic. All rights reserved.
//

#import "UIWindow+CLCG.h"

@implementation UIWindow (Candygirl)

-(void)clcg_show:(UIView*)v
{
  [self addSubview:v];
  [self makeKeyAndVisible];
}

@end
