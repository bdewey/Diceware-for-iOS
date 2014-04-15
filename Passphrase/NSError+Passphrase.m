//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import "NSError+Passphrase.h"

@implementation NSError (Passphrase)

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSError *)pp_ioError {
 
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"There was an error reading from the Passphrase file.", NSLocalizedDescriptionKey,
                            @"Restore your device from backup, or uninstall and reinstall Passphrase.", NSLocalizedRecoverySuggestionErrorKey,
                            nil];
  return [NSError errorWithDomain:kPPErrorDomain code:kPPErrorIOError userInfo:userInfo];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSError *)pp_corruptError {
  
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"The passphrase file is corrupt.", NSLocalizedDescriptionKey,
                            @"Restore your device from backup, or uninstall and reinstall Passphrase.", NSLocalizedRecoverySuggestionErrorKey,
                            nil];
  return [NSError errorWithDomain:kPPErrorDomain code:kPPErrorCorruptFile userInfo:userInfo];
}
@end
