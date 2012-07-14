//
//  PPFirstViewController.h
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPassphraseGenerator : UIViewController

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *generatedWords;
- (IBAction)didTapGenerate:(id)sender;

@end
