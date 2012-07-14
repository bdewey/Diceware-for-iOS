//
//  PPFirstViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPPassphraseGenerator.h"
#import "NSData+EncryptionHelpers.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PPPassphraseGenerator ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPPassphraseGenerator
@synthesize generatedWords;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  NSArray *testWords = [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Fourth", @"Fifth", nil];
  for (int i = 0; i < testWords.count; i++) {
    
    UILabel *label = [self.generatedWords objectAtIndex:i];
    label.text = [testWords objectAtIndex:i];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {
  
  [self setGeneratedWords:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)didTapGenerate:(id)sender {
  
  NSData *randomBytes = [NSData dataWithRandomBytes:5 * sizeof(int)];
  const unsigned int *bytes = randomBytes.bytes;
  for (int i = 0; i < 5; i++) {
    
    unsigned int trimmed = *bytes & 0x1FFF;
    char *word = getDiceWd(trimmed);
    NSString *randomWord = [NSString stringWithUTF8String:word];
    UILabel *label = [self.generatedWords objectAtIndex:i];
    label.text = randomWord;
    bytes++;
  }
}

@end
