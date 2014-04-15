//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import <Foundation/Foundation.h>
#import "diceware-definitions.h"

@interface NSArray (Diceware)

/**
 Converts a diceware number into an array of dice-roll values.
 0 becomes @[1, 1, 1, 1, 1]
 7775 is @[6, 6, 6, 6, 6]
 */
+ (NSArray *)pp_arrayFromDicewareNumber:(PPDicewareNumber)number;

@end
