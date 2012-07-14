//
//  PPSecondViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPSecondViewController.h"

@interface PPSecondViewController ()

@end

@implementation PPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
