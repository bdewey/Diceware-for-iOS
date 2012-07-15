//
//  PPSavedPassphraseContext.h
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSavedPassphraseContext : NSObject

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSData *encryptionKey;

- (id)initWithFileURL:(NSURL *)url;
- (void)unlockWithKey:(NSData *)key andInitializationVector:(NSData *)iv completion:(void(^)(BOOL success))completion;

@end
