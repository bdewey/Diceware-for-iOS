//
//  PPPassphrase+Passphrase.m
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "PPPassphrase+Passphrase.h"

@implementation PPPassphrase (Passphrase)

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (PPPassphrase *)passphraseForWords:(NSArray *)words protectedWithKey:(NSData *)key inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  
  PPPassphrase *passphrase = [NSEntityDescription insertNewObjectForEntityForName:kEntityPassphrase 
                                                           inManagedObjectContext:managedObjectContext];
  passphrase.initializationVector = [NSData dataWithRandomBytes:kCCBlockSizeAES128];
  NSMutableString *cleartext = [NSMutableString string];
  for (NSString *word in words) {
    
    [cleartext appendFormat:@"%@ ", word];
  }
  NSData *cipherbytes = [NSData aesEncryptString:cleartext withKey:key andIV:passphrase.initializationVector];
  passphrase.encryptedPhrase = cipherbytes;
  passphrase.generationDate = [[NSDate date] timeIntervalSince1970];
  return passphrase;
}
@end
