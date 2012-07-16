//
//  PPFirstViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPPassphraseGeneratorViewController.h"
#import "NSData+EncryptionHelpers.h"
#import "PPPassphraseGenerator.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PPPassphraseGeneratorViewController ()

- (NSString *)diceDigitsForIndex:(unsigned int)index;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPPassphraseGeneratorViewController
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
  
  NSArray *results = [PPPassphraseGenerator passphraseWithWordCount:5 includeDiceDigits:YES];
  for (int i = 0; i < results.count; i++) {
    
    NSString *randomWord = [results objectAtIndex:i];
    UILabel *label = [self.generatedWords objectAtIndex:i];
    label.text = randomWord;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)diceDigitsForIndex:(unsigned int)index {
  
  NSMutableString *result = [NSMutableString stringWithString:@"00000"];
  for (int i = 0; i < 5; i++) {
    
    int digit = (index % 6) + 1;
    index /= 6;
    [result replaceCharactersInRange:NSMakeRange(5-i-1, 1) withString:[NSString stringWithFormat:@"%d", digit]];
  }
  return result;
}

@end
