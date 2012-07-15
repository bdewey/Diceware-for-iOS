//
//  PPEncryptionMetadata.h
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PPEncryptionMetadata : NSManagedObject

@property (nonatomic, retain) NSData * encryptionKey;
@property (nonatomic, retain) NSData * encryptionValidation;
@property (nonatomic, retain) NSData * salt;
@property (nonatomic, retain) NSData * encryptionValidationIV;

@end
