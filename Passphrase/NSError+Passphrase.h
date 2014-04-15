//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
