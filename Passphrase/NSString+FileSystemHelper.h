//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import <Foundation/Foundation.h>


@interface NSString(FileSystemHelper)

//
//  Returns a new string made by appending the last path component of the 
//  receiver to the user's Documents folder.
//

-(NSString *)asPathInDocumentsFolder;

//
//  Returns a new string made by appending the last path component of the 
//  receiver to the user's temporary folder.
//

-(NSString *)asPathInTemporaryFolder;

//
//  Returns the "sidecar" version of a filename. This is a path that has
//  "-sidecar" appended to the last path component, before the extension.
//  E.g., "/StrongBox/foo.key" becomes "/StrongBox/foo-sidecar.key".
//

- (NSString *)stringAsSidecarPath;

@end
