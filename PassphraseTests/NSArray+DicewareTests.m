//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
