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
