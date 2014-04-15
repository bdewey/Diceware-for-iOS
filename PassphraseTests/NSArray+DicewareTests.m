//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import <XCTest/XCTest.h>

#import "NSArray+Diceware.h"

@interface NSArray_DicewareTests : XCTestCase

@end

@implementation NSArray_DicewareTests

- (void)setUp
{
  [super setUp];
  // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
  // Put teardown code here; it will be run once, after the last test case.
  [super tearDown];
}

- (void)testBoundaries
{
  XCTAssertEqualObjects((@[@1, @1, @1, @1, @1]), [NSArray pp_arrayFromDicewareNumber:0], @"");
  XCTAssertEqualObjects((@[@1, @1, @1, @2, @1]), [NSArray pp_arrayFromDicewareNumber:6], @"");
  XCTAssertEqualObjects((@[@6, @6, @6, @6, @6]), [NSArray pp_arrayFromDicewareNumber:kDicewareWordlistCount-1], @"");
  XCTAssertThrowsSpecificNamed([NSArray pp_arrayFromDicewareNumber:kDicewareWordlistCount], NSException, NSInternalInconsistencyException, @"");
}

@end
