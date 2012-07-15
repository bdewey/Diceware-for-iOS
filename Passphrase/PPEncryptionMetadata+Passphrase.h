//
//  PPEncryptionMetadata+Passphrase.h
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPEncryptionMetadata.h"

@interface PPEncryptionMetadata (Passphrase)

+ (PPEncryptionMetadata *)encryptionMetadataForKey:(NSData *)encryptionKey 
                                  protectedWithKey:(NSData *)protectingKey 
                           andInitializationVector:(NSData *)initializationVector 
                            inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
