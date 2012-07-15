//
//  PPPassphrase.h
//  Passphrase
//
//  Created by Brian Dewey on 7/14/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PPResource;

@interface PPPassphrase : NSManagedObject

@property (nonatomic) NSTimeInterval generationDate;
@property (nonatomic, retain) NSData * encryptedPhrase;
@property (nonatomic, retain) NSData * encryptedDescription;
@property (nonatomic, retain) NSData * initializationVector;
@property (nonatomic, retain) PPResource *resource;

@end
