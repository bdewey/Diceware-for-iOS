//
//  PPSavedPassphraseContext.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CoreData/CoreData.h>
#import "PPSavedPassphraseContext.h"
#import "PPEncryptionMetadata.h"
#import "PPEncryptionMetadata+Passphrase.h"

@implementation PPSavedPassphraseContext

@synthesize document                          = _document;
@synthesize encryptionKey                     = _encryptionKey;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFileURL:(NSURL *)url {
  
  self = [super init];
  if (self) {
    
    _document = [[UIManagedDocument alloc] initWithFileURL:url];
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)unlockWithKey:(NSData *)key andInitializationVector:(NSData *)iv completion:(void (^)(BOOL success))completion {
  
  completion = [completion copy];
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.document.fileURL.path]) {
    
    [self.document openWithCompletionHandler:^(BOOL success) {
      
      if (success) {
        
        success = [self decryptDocumentEncryptionKeyWithKey:key andInitializationVector:iv];
      }
      if (completion) {
        
        completion(success);
      }
    }];
    
  } else {
    
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
      
      if (success) {
        
        success = [self initializeNewDocumentProtectedWithKey:key andInitializationVector:iv];
      }
      if (completion) {
        
        completion(success);
      }
    }];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)decryptDocumentEncryptionKeyWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector {
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityEncryptionMetadata];
  NSArray *metadataMatches = [self.document.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
  if (metadataMatches.count != 1) {
    
    return NO;
  }
  PPEncryptionMetadata *metadata = [metadataMatches objectAtIndex:0];
  _encryptionKey = [metadata.encryptionKey aesDecryptWithKey:key andIV:initializationVector];
  NSData *validationData = [metadata.encryptionValidation aesDecryptWithKey:_encryptionKey 
                                                                      andIV:metadata.encryptionValidationIV];
  NSString *validationString = [NSString stringWithUTF8String:validationData.bytes];
  return [validationString isEqualToString:kEncryptionValidationString];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)initializeNewDocumentProtectedWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector {
  
  _encryptionKey = [NSData dataWithRandomBytes:kCCKeySizeAES128];
  [PPEncryptionMetadata encryptionMetadataForKey:_encryptionKey 
                                protectedWithKey:key 
                         andInitializationVector:initializationVector 
                          inManagedObjectContext:_document.managedObjectContext];
  return YES;
}


@end
