//
//  PPResource+Passphrase.h
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPResource.h"

@interface PPResource (Passphrase)

+ (PPResource *)resourceWithTitle:(NSString *)title protectedByKey:(NSData *)key inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
