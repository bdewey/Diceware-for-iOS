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

#import <CommonCrypto/CommonCryptor.h>
#import "PPEncryptionMetadata.h"
#import "PPMasterPassphraseController.h"
#import "PPSavedPassphraseContext.h"
#import "PPSavedPassphraseContext.h"
#import "Rfc2898DeriveBytes.h"
#import "PPResourcesViewController.h"
#import "PPPassphraseGenerator.h"

@interface PPMasterPassphraseController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPMasterPassphraseController

@synthesize delegate                                = _delegate;
@synthesize passphraseContext                       = _passphraseContext;
@synthesize passphraseField                         = _passphraseField;
@synthesize doneButton                              = _doneButton;
@synthesize suggestionLabel = _suggestionLabel;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {

  [super viewDidLoad];
  NSMutableString *examplePassphrase = [NSMutableString string];
  NSArray *words = [PPPassphraseGenerator passphraseWithWordCount:5 includeDiceDigits:NO];
  for (NSString *word in words) {
    
    if (examplePassphrase.length > 0) {
      
      [examplePassphrase appendString:@" "];
    }
    [examplePassphrase appendString:word];
  }
  _suggestionLabel.text = [NSString stringWithFormat:@"How about \"%@\"?", examplePassphrase];
	// Do any additional setup after loading the view, typically from a nib.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {

  [self setDoneButton:nil];
  [self setPassphraseField:nil];
  [self setSuggestionLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated {
  
  [self.passphraseField becomeFirstResponder];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"ShowResources"]) {
    
    PPResourcesViewController *resources = segue.destinationViewController;
    resources.passphraseContext = _passphraseContext;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)didTapDone:(id)sender {
  
  [self.passphraseField resignFirstResponder];
  _passphraseContext = [[PPSavedPassphraseContext alloc] initWithFileURL:[PPSavedPassphraseContext defaultURL]];
  NSMutableData *key = [NSMutableData dataWithLength:kCCKeySizeAES128];
  NSMutableData *iv  = [NSMutableData dataWithLength:kCCBlockSizeAES128];
  [_passphraseContext prepareDocumentWhenCreated:^(BOOL success) {
    
    if (!success) {
      
      [self.delegate masterPassphraseController:self didFailWithError:[NSError pp_ioError]];
      return;
    }
    NSData *salt = [NSData dataWithRandomBytes:kCCBlockSizeAES128];
    [Rfc2898DeriveBytes deriveKey:key andIV:iv fromPassword:_passphraseField.text andSalt:salt];
    PPEncryptionMetadata *metadata = [_passphraseContext initializeNewDocumentProtectedWithKey:key andInitializationVector:iv];
    metadata.salt = salt;
    [self.delegate masterPassphraseControllerDidFinish:self];
    
  } whenOpened:^(BOOL success) {
    
    if (!success) {

      [self.delegate masterPassphraseController:self didFailWithError:[NSError pp_ioError]];
      return;
    }
    
    PPEncryptionMetadata *metadata = [_passphraseContext encryptionMetadata];
    if (!metadata) {
      
      [self.delegate masterPassphraseController:self didFailWithError:[NSError pp_corruptError]];
      return;
    }
    [Rfc2898DeriveBytes deriveKey:key andIV:iv fromPassword:_passphraseField.text andSalt:metadata.salt];
    if ([_passphraseContext decryptDocumentEncryptionKeyWithKey:key andInitializationVector:iv]) {
      
      [self.delegate masterPassphraseControllerDidFinish:self];
      
    } else {
      
      _passphraseField.text = @"";
      [_passphraseField becomeFirstResponder];
    }
  }];
}

- (IBAction)didTapCancel:(id)sender {
  
  [self.delegate masterPassphraseControllerDidCancel:self];
}

#pragma mark - UITextFieldDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self didTapDone:self];
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)textFieldDidEndEditing:(UITextField *)textField {
  
  [textField resignFirstResponder];
}


@end
