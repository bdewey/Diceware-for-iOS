//
//  PPEncryptionMetadata+Passphrase.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "PPEncryptionMetadata+Passphrase.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPEncryptionMetadata (Passphrase)

+ (PPEncryptionMetadata *)encryptionMetadataForKey:(NSData *)encryptionKey 
                                  protectedWithKey:(NSData *)protectingKey 
                           andInitializationVector:(NSData *)initializationVector 
                            inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  
  PPEncryptionMetadata *encryptionMetadata = [NSEntityDescription insertNewObjectForEntityForName:kEntityEncryptionMetadata 
                                                                           inManagedObjectContext:managedObjectContext];
  
  const char *validationString = [kEncryptionValidationString UTF8String];
  int validationStringLength = strlen(validationString);
  NSData *validationBytes = [NSData dataWithBytes:validationString length:validationStringLength];
  NSData *validationIV = [NSData dataWithRandomBytes:kCCBlockSizeAES128];
  
  encryptionMetadata.encryptionValidation = [validationBytes aesEncryptWithKey:encryptionKey 
                                                                         andIV:validationIV];
  encryptionMetadata.encryptionValidationIV = validationIV;
  encryptionMetadata.encryptionKey = [encryptionKey aesEncryptWithKey:protectingKey andIV:initializationVector];
  return encryptionMetadata;
}
@end
