//
//  PPPassphraseGenerator.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPPassphraseGenerator.h"
#import "NSData+EncryptionHelpers.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPPassphraseGenerator

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSArray *)passphraseWithWordCount:(NSUInteger)wordCount {

  return [PPPassphraseGenerator passphraseWithWordCount:wordCount includeDiceDigits:NO];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSArray *)passphraseWithWordCount:(NSUInteger)wordCount includeDiceDigits:(BOOL)includeDiceDigits {
  
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:wordCount];
  for (NSUInteger i = 0; i < wordCount; i++) {
    
    unsigned int trimmed = 0x1FFF;
    while (trimmed >= 7776) {
      NSData *randomBytes = [NSData dataWithRandomBytes:sizeof(int)];
      const unsigned int *bytes = randomBytes.bytes;
      trimmed = *bytes & 0x1FFF;
    }
    char *word = getDiceWd(trimmed);
    NSString *randomWord = [NSString stringWithUTF8String:word];
    if (includeDiceDigits) {
      
      randomWord = [NSString stringWithFormat:@"%@ %@", [PPPassphraseGenerator diceDigitsForIndex:trimmed], randomWord];
    }
    [results addObject:randomWord];
  }
  return results;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)diceDigitsForIndex:(unsigned int)index {
  
  NSMutableString *result = [NSMutableString stringWithString:@"00000"];
  for (int i = 0; i < 5; i++) {
    
    int digit = (index % 6) + 1;
    index /= 6;
    [result replaceCharactersInRange:NSMakeRange(5-i-1, 1) withString:[NSString stringWithFormat:@"%d", digit]];
  }
  return result;
}


@end
