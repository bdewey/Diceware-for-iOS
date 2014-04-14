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

#import "NSString+FileSystemHelper.h"

#define kSidecarIdentifier        @"-sidecar"


@implementation NSString(FileSystemHelper)

-(NSString *)asPathInDocumentsFolder {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *homeDir = [paths objectAtIndex:0];
  return [homeDir stringByAppendingPathComponent:[self lastPathComponent]];
}

-(NSString *)asPathInTemporaryFolder {
  NSString *temp = NSTemporaryDirectory();
  return [temp stringByAppendingPathComponent:[self lastPathComponent]];
}

- (NSString *)stringAsSidecarPath {
  
  NSMutableArray *components = [NSMutableArray arrayWithArray:[self pathComponents]];
  NSString *lastComponent = [components lastObject];
  NSString *extension = [lastComponent pathExtension];
  lastComponent = [lastComponent stringByDeletingPathExtension];
  if ([lastComponent length] >= [kSidecarIdentifier length]) {
    NSUInteger index = [lastComponent length] - [kSidecarIdentifier length];
    NSString *suffix = [lastComponent substringFromIndex:index];
    if ([suffix isEqualToString:kSidecarIdentifier]) {
      
      //
      //  OK, this is a path that already matches the sidecar pattern.
      //  Just return the path. For safety, though, return a new copy of the
      //  path.
      //
      
      return [self copy];
    }
  }
  lastComponent = [lastComponent stringByAppendingString:kSidecarIdentifier];
  if ([extension length] > 0) {
    lastComponent = [lastComponent stringByAppendingPathExtension:extension];
  }
  [components replaceObjectAtIndex:([components count] - 1) withObject:lastComponent];
  return [NSString pathWithComponents:components];
}

@end
