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

#import "NSArray+Diceware.h"

/**
 The number of dice rolls used to pick a diceware word
 */
static const NSUInteger kDicewareDiceRolls = 5;
static const NSUInteger powersOfSix[] = {
  6 * 6 * 6 * 6,
  6 * 6 * 6,
  6 * 6,
  6,
  1
};

@implementation NSArray (Diceware)

+ (NSArray *)pp_arrayFromDicewareNumber:(PPDicewareNumber)number
{
  PPThrowIfInvalidDicewareNumber(number);
  NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:kDicewareDiceRolls];
  
  for (NSUInteger i = 0; i < kDicewareDiceRolls; i++) {
    NSUInteger currentPower = powersOfSix[i];
    NSUInteger quotient = number / currentPower;
    number -= quotient * currentPower;
    [results addObject:@(quotient + 1)];
  }
  return [results copy];
}

@end
