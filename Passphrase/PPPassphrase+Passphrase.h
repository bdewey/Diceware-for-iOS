//
//  PPPassphrase+Passphrase.h
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPPassphrase.h"

@interface PPPassphrase (Passphrase)

+ (PPPassphrase *)passphraseForWords:(NSArray *)words protectedWithKey:(NSData *)key inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
