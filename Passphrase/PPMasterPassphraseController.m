//
//  PPSecondViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "PPEncryptionMetadata.h"
#import "PPMasterPassphraseController.h"
#import "PPSavedPassphraseContext.h"
#import "PPSavedPassphraseContext.h"
#import "Rfc2898DeriveBytes.h"
#import "PPResourcesViewController.h"

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

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {

  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {

  [self setDoneButton:nil];
  [self setPassphraseField:nil];
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
