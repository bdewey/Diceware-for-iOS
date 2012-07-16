//
//  PPResource+Passphrase.m
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "PPResource+Passphrase.h"

@implementation PPResource (Passphrase)

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (PPResource *)resourceWithTitle:(NSString *)title protectedByKey:(NSData *)key inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {

  NSData *iv = [NSData dataWithRandomBytes:kCCBlockSizeAES128];
  NSData *ciphertitle = [NSData aesEncryptString:title withKey:key andIV:iv];
  PPResource *resource = [NSEntityDescription insertNewObjectForEntityForName:kEntityResource inManagedObjectContext:managedObjectContext];
  resource.encryptedTitle = ciphertitle;
  resource.initializationVector = iv;
  resource.generationDate = [[NSDate date] timeIntervalSince1970];
  return resource;
}
@end
