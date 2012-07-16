//
//  PPSecondViewController.h
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSavedPassphraseContext;
@protocol PPMasterPassphraseControllerDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PPMasterPassphraseController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) id<PPMasterPassphraseControllerDelegate> delegate;
@property (strong, nonatomic) PPSavedPassphraseContext *passphraseContext;
@property (weak, nonatomic) IBOutlet UITextField *passphraseField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol PPMasterPassphraseControllerDelegate <NSObject>

- (void)masterPassphraseControllerDidCancel:(PPMasterPassphraseController *)controller;
- (void)masterPassphraseControllerDidFinish:(PPMasterPassphraseController *)controller;
- (void)masterPassphraseController:(PPMasterPassphraseController *)controller didFailWithError:(NSError *)error;

@end
