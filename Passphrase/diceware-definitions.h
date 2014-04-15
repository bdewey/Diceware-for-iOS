//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import <Foundation/Foundation.h>

/**
 How many rolls of a six-sided dice make up a diceword word? (5)
 */
extern const NSUInteger kDicewareRollCount;

/**
 How many words are in a diceware wordlist? (7776... i.e., 6^5)
 */
extern const NSUInteger kDicewareWordlistCount;

/**
 A diceware number is an unsigned integer in the range [0..7775]
 */
typedef NSUInteger PPDicewareNumber;

NS_INLINE void PPThrowIfInvalidDicewareNumber(PPDicewareNumber dicewareNumber) {
  if (dicewareNumber >= kDicewareWordlistCount) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Diceware number out of range"
                                 userInfo:@{@"diceware_number": @(dicewareNumber)}];
  }
}
