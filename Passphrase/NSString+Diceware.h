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

#import <Foundation/Foundation.h>
#import "diceware-definitions.h"

@interface NSString (Diceware)

/**
 Converts a number in the range 0..7775 to the corresponding faces on dice.
 0 becomes 11111,
 7775 becomes 66666.
 */
+ (NSString *)pp_dicewareStringFromNumber:(PPDicewareNumber)number;

/**
 Converts the string representation of a diceware number to the corresponding integer.
 "11111" becomes 0.
 "66666" becomes 7775.
 */
- (PPDicewareNumber)pp_dicewareNumber;

+ (NSString *)pp_wordAtIndex:(NSUInteger)index fromDicewareWordlist:(char **)wordlist;

@end