//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
  @catch (NSException *) {
    
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
