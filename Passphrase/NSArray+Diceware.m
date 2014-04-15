//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
