//
//  NSObject+CLCG.h
//  Goodreads
//
//  Created by Pasquini, Ettore on 7/30/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (CLCG)

-(id)performGetter:(SEL)getter;

-(void)performSetter:(SEL)setter withObject:(id)value;

@end
