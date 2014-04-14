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

#import <Foundation/Foundation.h>


@interface NSData (EncryptionHelpers)

//
//  Converts an NSData to a hex string representation. Each byte is represented
//  as a string from 00 to FF.
//

- (NSString *)hexString;

//
//  Converts a hex string to an NSData object.
//

+ (NSData *)dataWithHexString:(NSString *)hexString;

//
//  Creates an NSData with random bytes. Returns |nil| if there's an error
//  getting the random bytes.
//

+ (NSData *)dataWithRandomBytes:(NSUInteger)count;

//
//  Decrypts the buffer using a specific |key| and |iv| (initialization vector).
//  Returns the decrypted buffer.
//

- (NSData *)aesDecryptWithKey:(NSData *)key andIV:(NSData *)iv;

//
//  Decrypts a data block and inteprets the results as a UTF-8 string.
//

- (NSString *)aesDecryptStringWithKey:(NSData *)key andIV:(NSData *)iv;

//
//  Returns an encrypted version of a string.
//

+ (NSData *)aesEncryptString:(NSString *)string withKey:(NSData *)key andIV:(NSData *)iv;

//
//  Encrypts the buffer using a specific |key| and |iv| (initialization vector).
//  Returns the encrypted buffer.
//

- (NSData *)aesEncryptWithKey:(NSData *)key andIV:(NSData *)iv;

@end

@interface NSMutableData (EncryptionHelpers)

//
//  Decrypts a buffer in place using a specific |key| and |iv|.
//

- (void)aesDecryptInPlaceWithKey:(NSData *)key andIV:(NSData *)iv;

//
//  Encrypts a buffer in place using a specific |key| and |iv|.
//

- (void)aesEncryptInPlaceWithKey:(NSData *)key andIV:(NSData *)iv;
@end
