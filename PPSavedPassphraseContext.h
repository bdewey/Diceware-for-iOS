//
//  PPSavedPassphraseContext.h
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPEncryptionMetadata;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PPSavedPassphraseContext : NSObject

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSData *encryptionKey;

+ (NSURL *)defaultURL;
- (id)initWithFileURL:(NSURL *)url;
- (void)prepareDocumentWhenCreated:(void(^)(BOOL success))creationCallback whenOpened:(void(^)(BOOL success))openCallback;
- (BOOL)decryptDocumentEncryptionKeyWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector;
- (PPEncryptionMetadata *)initializeNewDocumentProtectedWithKey:(NSData *)key andInitializationVector:(NSData *)initializationVector;
- (PPEncryptionMetadata *)encryptionMetadata;

@end
