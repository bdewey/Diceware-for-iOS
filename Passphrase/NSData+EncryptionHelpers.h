//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
