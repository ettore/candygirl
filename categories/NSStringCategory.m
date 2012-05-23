//
//  NSStringCategory.m
//  Goodreads
//
//  Created by Ettore Pasquini on 5/22/12.
//  Copyright (c) 2012 Goodreads. All rights reserved.
//

#import "NSStringCategory.h"

@implementation NSString (Candygirl)

-(NSString*)encodeURL
{
  NSString *s;
  
  s = NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                (__bridge CFStringRef)self, 
                                                                NULL, 
                                                                CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                kCFStringEncodingUTF8));
	if (s)
		return [s autorelease];
	
	return @"";
}

@end
