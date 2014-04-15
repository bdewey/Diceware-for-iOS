//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
