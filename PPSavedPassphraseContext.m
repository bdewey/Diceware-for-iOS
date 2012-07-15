//
//  PPSavedPassphraseContext.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CoreData/CoreData.h>
#import "NSString+FileSystemHelper.h"
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

+ (NSURL *)defaultURL {
 
  NSString *path = [@"vault.dat" asPathInDocumentsFolder];
  return [NSURL fileURLWithPath:path isDirectory:NO];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareDocumentWhenCreated:(void (^)(BOOL))creationCallback whenOpened:(void (^)(BOOL))openCallback {
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.document.fileURL.path]) {
    
    [self.document openWithCompletionHandler:^(BOOL success) {
      
      if (openCallback) {
        
        openCallback(success);
      }
    }];
    
  } else {
    
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
      
      if (creationCallback) {
        
        creationCallback(success);
      }
    }];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)decryptDocumentEncryptionKeyWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector {
  
  PPEncryptionMetadata *metadata = [self encryptionMetadata];
  if (!metadata) {
    
    return NO;
  }
  _encryptionKey = [metadata.encryptionKey aesDecryptWithKey:key andIV:initializationVector];
  NSData *validationData = [metadata.encryptionValidation aesDecryptWithKey:_encryptionKey 
                                                                      andIV:metadata.encryptionValidationIV];
  NSString *validationString = nil;
  @try {
    validationString = [NSString stringWithUTF8String:validationData.bytes];
  }
  @finally {
    
    //
    //  NOTHING
    //
  }
  return [validationString isEqualToString:kEncryptionValidationString];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (PPEncryptionMetadata *)initializeNewDocumentProtectedWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector {
  
  _encryptionKey = [NSData dataWithRandomBytes:kCCKeySizeAES128];
  return [PPEncryptionMetadata encryptionMetadataForKey:_encryptionKey 
                                protectedWithKey:key 
                         andInitializationVector:initializationVector 
                          inManagedObjectContext:_document.managedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (PPEncryptionMetadata *)encryptionMetadata {
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityEncryptionMetadata];
  NSArray *metadataMatches = [self.document.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
  if (metadataMatches.count != 1) {
    
    return nil;
  }
  return [metadataMatches objectAtIndex:0];
}


@end
