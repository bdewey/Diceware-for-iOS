//
//  NSError+Passphrase.m
//  Passphrase
//
//  Created by Brian Dewey on 7/16/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

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
