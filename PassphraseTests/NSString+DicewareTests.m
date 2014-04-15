//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
