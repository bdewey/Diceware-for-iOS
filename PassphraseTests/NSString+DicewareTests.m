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
#import "diceware-definitions.h"
#import "diceware_wordlist.h"
#import "beale_wordlist.h"
#import "NSString+Diceware.h"

@interface NSString_Diceware : XCTestCase

@end

@implementation NSString_Diceware

- (void)testSimpleLookup
{
  XCTAssertEqualObjects(@"ablaze", [NSString pp_wordAtIndex:29 fromDicewareWordlist:beale_wordlist], @"");
}

- (void)testBoundaries
{
  XCTAssertEqualObjects(@"a", [NSString pp_wordAtIndex:0 fromDicewareWordlist:diceware_wordlist], @"");
  XCTAssertEqualObjects(@"@", [NSString pp_wordAtIndex:kDicewareWordlistCount-1 fromDicewareWordlist:diceware_wordlist], @"");
  XCTAssertThrowsSpecificNamed([NSString pp_wordAtIndex:kDicewareWordlistCount fromDicewareWordlist:diceware_wordlist], NSException, NSInternalInconsistencyException, @"");
}

- (void)testStringify
{
  XCTAssertEqualObjects(@"11111", [NSString pp_dicewareStringFromNumber:0], @"");
  XCTAssertEqualObjects(@"66666", [NSString pp_dicewareStringFromNumber:kDicewareWordlistCount-1], @"");
  XCTAssertEqualObjects(@"11121", [NSString pp_dicewareStringFromNumber:6], @"");
  XCTAssertThrowsSpecificNamed([NSString pp_dicewareStringFromNumber:kDicewareWordlistCount], NSException, NSInternalInconsistencyException, @"");
}

@end
