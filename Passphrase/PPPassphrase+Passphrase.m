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
