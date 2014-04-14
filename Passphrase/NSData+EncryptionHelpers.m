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

#import "NSData+EncryptionHelpers.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@implementation NSData (EncryptionHelpers)

- (NSString *)hexString {
  NSMutableString *outputString = [NSMutableString string];
  unsigned char *p = (unsigned char *)[self bytes];
  for (int i = 0; i < [self length]; i++) {
    [outputString appendFormat:@"%02X", *p];
    p++;
  }
  return outputString;
}

+ (NSData *)dataWithHexString:(NSString *)hexString {
  if (([hexString length] % 2) == 1) {
    
    //
    //  This can't be valid input... we have an odd number of characters.
    //
    
    return nil;
  }
  NSMutableData *buffer = [NSMutableData data];
  for (int byteOffset = 0; byteOffset < [hexString length]; byteOffset += 2) {
    NSRange range = NSMakeRange(byteOffset, 2);
    NSString *byteString = [hexString substringWithRange:range];
    NSScanner *scanner = [NSScanner scannerWithString:byteString];
    unsigned int value;
    [scanner scanHexInt:&value];
    [buffer appendBytes:&value length:1];
  }
  return buffer;
}

+ (NSData *)dataWithRandomBytes:(NSUInteger)count {
  
  NSMutableData *buffer = [NSMutableData dataWithLength:count];
  if (buffer != nil) {
    SecRandomCopyBytes(kSecRandomDefault, count, [buffer mutableBytes]);
  }
  return buffer;
}

- (NSData *)aesDecryptWithKey:(NSData *)key andIV:(NSData *)iv {
  NSMutableData *buffer = [NSMutableData dataWithLength:self.length];
  size_t moved;
  CCCryptorStatus status;
  
  status = CCCrypt(kCCDecrypt, 
                   kCCAlgorithmAES128, 
                   kCCOptionPKCS7Padding, 
                   [key bytes], 
                   [key length], 
                   [iv bytes], 
                   [self bytes], 
                   [self length], 
                   [buffer mutableBytes], 
                   [buffer length], 
                   &moved);
  if (status) {
    //
    //  There was an error. Return nil.
    //
    
    return nil;
  } else {
    [buffer setLength:moved];
    return buffer;
  }
}

- (NSString *)aesDecryptStringWithKey:(NSData *)key andIV:(NSData *)iv {
  
  NSData *decryptedData = [self aesDecryptWithKey:key andIV:iv];
  NSString *result;
  @try {
    
    result = [NSString stringWithUTF8String:decryptedData.bytes];
  }
  @catch (NSException *exception) {

    //
    //  NOTHING
    //
  }
  return result;
}

+ (NSData *)aesEncryptString:(NSString *)string withKey:(NSData *)key andIV:(NSData *)iv {
  
  const char *utf8 = [string UTF8String];
  NSData *clearbytes = [NSData dataWithBytes:utf8 length:strlen(utf8)];
  NSData *cipherbytes = [clearbytes aesEncryptWithKey:key andIV:iv];
  return cipherbytes;
}

- (NSData *)aesEncryptWithKey:(NSData *)key andIV:(NSData *)iv {
  NSMutableData *buffer = [NSMutableData dataWithLength:self.length];
  size_t moved;
  CCCryptorStatus status;
  
retry:
  status = CCCrypt(kCCEncrypt, 
                   kCCAlgorithmAES128, 
                   kCCOptionPKCS7Padding, 
                   [key bytes], 
                   [key length], 
                   [iv bytes], 
                   [self bytes], 
                   [self length], 
                   [buffer mutableBytes], 
                   [buffer length], 
                   &moved);
  
  if (status == kCCBufferTooSmall) {
    
    [buffer setLength:moved];
    goto retry;
    
  } else if (status) {
    
    //
    //  There was an error. Return nil.
    //
    
    return nil;
    
  } else {
    
    [buffer setLength:moved];
    return buffer;
  }
}

@end

@implementation NSMutableData (EncryptionHelpers)

- (void)aesDecryptInPlaceWithKey:(NSData *)key andIV:(NSData *)iv {
  size_t moved;
  CCCryptorStatus status;
  
  status = CCCrypt(kCCDecrypt, 
                   kCCAlgorithmAES128, 
                   kCCOptionPKCS7Padding, 
                   [key bytes], 
                   [key length], 
                   [iv bytes], 
                   [self bytes], 
                   [self length], 
                   [self mutableBytes], 
                   [self length], 
                   &moved);
  [self setLength:moved];
}

- (void)aesEncryptInPlaceWithKey:(NSData *)key andIV:(NSData *)iv {
  size_t moved;
  CCCryptorStatus status;
  NSUInteger originalLength = [self length];
  
retry:
  status = CCCrypt(kCCEncrypt, 
                   kCCAlgorithmAES128, 
                   kCCOptionPKCS7Padding, 
                   [key bytes], 
                   [key length], 
                   [iv bytes], 
                   [self bytes], 
                   originalLength, 
                   [self mutableBytes], 
                   [self length], 
                   &moved);
  
  if (status == kCCBufferTooSmall) {

    [self setLength:moved];
    goto retry;
    
  } else if (status == 0) {

    //
    //  If encryption succeeded, update the length.
    //
    
    [self setLength:moved];
  }
}


@end

