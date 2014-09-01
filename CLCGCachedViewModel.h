//
//  CLCGCachedViewModel.h
//  Cubelogic
//
//  Created by Pasquini, Ettore on 8/24/14.
//


@interface CLCGCachedViewModel : NSObject

@property(nonatomic,strong) UIView *view;

-(CGFloat)cachedTextHeightForSubview:(UIView*)view
                               width:(CGFloat)w
                       useAttributed:(BOOL)use_attributed
                           lineLimit:(NSUInteger)line_limit;


@end
