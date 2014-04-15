//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import <UIKit/UIKit.h>

@interface DWWordLookupViewController : UITableViewController

/**
 The word list used to translate dice rolls to numbers.
 */
@property (nonatomic, assign, readonly) char **dicewareWordList;

/**
 Designated initializer.
 
 Creates a view controller that lets the user input dice values, and it displays the corresponding
 word in `dicewareWordList`.
 */
- (instancetype)initWithDicewareWordList:(char **)dicewareWordList;

@end
