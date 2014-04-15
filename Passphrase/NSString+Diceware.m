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
