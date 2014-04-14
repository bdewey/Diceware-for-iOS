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
