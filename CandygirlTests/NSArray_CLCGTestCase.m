//
//  CLCG_str_utils_TestCase.m
//  Candygirl
//
//  Created by Ettore Pasquini on 12/15/15.
//  Copyright © 2015 Cubelogic. All rights reserved.
//

#import "CLCGTestCase.h"
#import "NSArray+CLCG.h"


@interface NSArray_CLCGTestCase : CLCGTestCase
@end


@implementation NSArray_CLCGTestCase


-(void)testThatItReducesEmptyArrayToInitialValue
{
  // given
  NSArray * const arr = @[];
  id (^block)(id, id) = ^id(id current_acc, id item) {
    return [current_acc stringByAppendingString:item];
  };

  // when
  NSString *result = [arr clcg_reduce:@"" block:block];

  // then
  XCTAssertEqualObjects(result, @"");
}


-(void)testThatItReducesNonEmptyArrayToValue
{
  // given
  NSArray * const arr = @[@"one", @"two", @"three"];
  id (^block)(id, id) = ^id(id current_acc, id item) {
    return [current_acc stringByAppendingString:item];
  };

  // when
  NSString *result = [arr clcg_reduce:@"" block:block];

  // then
  XCTAssertEqualObjects(result, @"onetwothree");
}


-(void)testThatNilsAreTrimmedOrMappedToNulls
{
  // given
  NSString * const nil_str = @"nil!";
  NSArray * const arr = @[@"a", nil_str, @"c"];
  id (^add_X_block)(id item) = ^id(id item) {
    if ([item isEqual:nil_str]) {
      return nil;
    } else {
      return [item stringByAppendingString:@"X"];
    }
  };

  // when
  NSArray *mapped = [arr clcg_map:add_X_block];
  NSArray *mapped_trim = [arr clcg_mapTrim:add_X_block];

  // then
  XCTAssertEqual([mapped count], 3u);
  XCTAssertEqualObjects(mapped[0], @"aX");
  XCTAssertEqualObjects(mapped[1], [NSNull null]);
  XCTAssertEqualObjects(mapped[2], @"cX");

  XCTAssertEqual([mapped_trim count], 2u);
  XCTAssertEqualObjects(mapped_trim[0], @"aX");
  XCTAssertEqualObjects(mapped_trim[1], @"cX");
}


-(void)testThatItMapsItemsUsingBlock
{
  // given
  NSArray * const arr = @[@"a", @"b", @"c"];
  id (^add_X_block)(id item) = ^id(id item) {
    return [item stringByAppendingString:@"X"];
  };

  // when
  NSArray *mapped = [arr clcg_map:add_X_block];
  NSArray *mapped_trim = [arr clcg_mapTrim:add_X_block];

  // then
  XCTAssertEqualObjects(mapped[0], @"aX");
  XCTAssertEqualObjects(mapped[1], @"bX");
  XCTAssertEqualObjects(mapped[2], @"cX");
  XCTAssertEqualObjects(mapped_trim[0], @"aX");
  XCTAssertEqualObjects(mapped_trim[1], @"bX");
  XCTAssertEqualObjects(mapped_trim[2], @"cX");
}


@end
