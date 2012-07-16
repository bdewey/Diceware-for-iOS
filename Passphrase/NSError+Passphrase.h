//
//  NSError+Passphrase.h
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPPErrorDomain                      @"kPPErrorDomain"

typedef enum {
  
  kPPErrorIOError,
  kPPErrorCorruptFile
  
} PPErrorCodes;

@interface NSError (Passphrase)

+ (NSError *)pp_ioError;
+ (NSError *)pp_corruptError;

@end
