//
//  CLCGModel.h
//  Cubelogic
//  Created by Ettore Pasquini on 10/31/12.
//

@interface CLCGModel : NSObject <NSCopying>
{
  // for search purposes: concatenation of searchable data
  NSString    *mSearchable;
}

@property(nonatomic,copy) NSString *searchable;

-(BOOL)containsWords:(NSArray*)words;
-(BOOL)matches:(NSPredicate*)pred;

@end
