//
//  PPSecondViewController.h
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSavedPassphraseContext;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PPMasterPassphraseController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) PPSavedPassphraseContext *passphraseContext;
@property (weak, nonatomic) IBOutlet UITextField *passphraseField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)didTapDone:(id)sender;

@end
