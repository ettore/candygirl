// Copyright (c) 2012, Cubelogic
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
//
//  Created by ep on 1/8/12.
//


@interface UIView (Candygirl)

/** Moves the X position of the view to the center of its superview. */
-(void)centerHorizontally;

/**
 * Moves the X position of the view to the center of its superview, plus an
 * additional offset. */
-(void)centerHorizontallyWithOffset:(CGFloat)offset;

/** Moves the Y position of the view to the center of its superview. */
-(void)centerVertically;

/** 
 * Moves the Y position of the view to the center of its superview, plus an
 * additional offset. */
-(void)centerVerticallyWithOffset:(CGFloat)offset;

-(void)resizeHeightForText:(NSString*)txt font:(UIFont*)font;
-(UIView*)findFirstResponder;

-(CGFloat)x;
-(void)setX:(CGFloat)x;
-(CGFloat)y;
-(void)setY:(CGFloat)y;
-(CGFloat)w;
-(void)setW:(CGFloat)w;
-(CGFloat)h;
-(void)setH:(CGFloat)h;

/*! The ordinate position below this view, i.e. Y + Height. */
-(CGFloat)low;

/*! The abscissa position at the right of this view, i.e. X + Width. */
-(CGFloat)r;

/*! @return The view size. */
-(CGSize)sz;

/*! Set view size leaving origin unchanged. */
-(void)setSz:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

@end
