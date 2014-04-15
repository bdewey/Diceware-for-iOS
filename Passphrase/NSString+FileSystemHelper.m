//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

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
