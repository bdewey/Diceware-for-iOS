//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import "NSArray+Diceware.h"
#import "NSString+Diceware.h"

#define THROW_FORMAT_EXCEPTION()     @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                      reason:@"String is not in diceware format" \
                                      userInfo:nil];


@implementation NSString (Diceware)

+ (NSString *)pp_wordAtIndex:(NSUInteger)index fromDicewareWordlist:(char **)wordlist
{
  PPThrowIfInvalidDicewareNumber(index);
  char *cstring = wordlist[index];
  return [NSString stringWithCString:cstring encoding:NSUTF8StringEncoding];
}

+ (NSString *)pp_dicewareStringFromNumber:(PPDicewareNumber)number
{
  NSMutableString *results = [[NSMutableString alloc] init];
  NSArray *components = [NSArray pp_arrayFromDicewareNumber:number];
  for (NSNumber *component in components) {
    [results appendFormat:@"%u", [component unsignedIntValue]];
  }
  return [results copy];
}

- (PPDicewareNumber)pp_dicewareNumber
{
  if (self.length != kDicewareRollCount) {
    THROW_FORMAT_EXCEPTION();
  }
  PPDicewareNumber number = 0;
  const char *cstring = [self cStringUsingEncoding:NSUTF8StringEncoding];
  for (NSUInteger i = 0; i < kDicewareRollCount; i++) {
    number *= 6;
    char digit = cstring[i];
    if (digit < '1' || digit > '6') {
      THROW_FORMAT_EXCEPTION();
    }
    number += (digit - '1');
  }
  PPThrowIfInvalidDicewareNumber(number);
  return number;
}

@end
