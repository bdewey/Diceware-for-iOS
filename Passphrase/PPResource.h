//
//  PPResource.h
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PPPassphrase;

@interface PPResource : NSManagedObject

@property (nonatomic, retain) NSData * encryptedTitle;
@property (nonatomic, retain) NSData * initializationVector;
@property (nonatomic) NSTimeInterval generationDate;
@property (nonatomic, retain) NSSet *passphrases;
@end

@interface PPResource (CoreDataGeneratedAccessors)

- (void)addPassphrasesObject:(PPPassphrase *)value;
- (void)removePassphrasesObject:(PPPassphrase *)value;
- (void)addPassphrases:(NSSet *)values;
- (void)removePassphrases:(NSSet *)values;

@end
