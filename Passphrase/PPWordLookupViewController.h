//
//  PPWordLookupViewController.h
//  Passphrase
//
//  Created by Brian Dewey on 4/14/14.
//  Copyright (c) 2014 Brian's Brain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPWordLookupViewController : UITableViewController

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
