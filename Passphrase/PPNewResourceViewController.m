//
//  PPNewResourceViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPNewResourceViewController.h"
#import "PPPassphraseGenerator.h"

@interface PPNewResourceViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPNewResourceViewController

@synthesize delegate                              = _delegate;
@synthesize resourceNameTextField                 = _resourceNameTextField;
@synthesize passphraseDisplay                     = _passphraseDisplay;
@synthesize passphrase                            = _passphrase;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
  
  [super viewDidLoad];
  _passphrase = [PPPassphraseGenerator passphraseWithWordCount:5 includeDiceDigits:NO];
  NSMutableString *passphraseDisplayString = [NSMutableString string];
  for (NSString *word in _passphrase) {
    
    [passphraseDisplayString appendFormat:@"%@\n", word];
  }
  _passphraseDisplay.text = passphraseDisplayString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {
  
  [self setResourceNameTextField:nil];
  [self setPassphraseDisplay:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated {
  
  [_resourceNameTextField becomeFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)didTapCancel:(id)sender {
  
  [self.delegate newResourceViewControllerDidCancel:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)didTapDone:(id)sender {
  
  [self.delegate newResourceViewControllerDidFinish:self];
}
@end
