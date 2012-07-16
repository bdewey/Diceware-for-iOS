//
//  PPResourcesViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CoreData/CoreData.h>
#import "PPResourcesViewController.h"
#import "PPSavedPassphraseContext.h"
#import "PPResource.h"
#import "PPResource+Passphrase.h"
#import "PPPassphrase.h"
#import "PPPassphrase+Passphrase.h"
#import "PPNewResourceViewController.h"
#import "PPMasterPassphraseController.h"

@interface PPResourcesViewController () <
  NSFetchedResultsControllerDelegate,
  PPNewResourceViewControllerDelegate,
  PPMasterPassphraseControllerDelegate
>

@property (strong, nonatomic) NSFetchedResultsController *resourceResults;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPResourcesViewController

@synthesize passphraseContext                     = _passphraseContext;
@synthesize resourceResults                       = _resourceResults;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
  
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self.resourceResults performFetch:NULL];
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidUnload {
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
  
  if (!_passphraseContext) {
    
    [self performSegueWithIdentifier:@"GetSavedPassphraseContext" sender:self];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"PresentNewResourceController"]) {
    
    PPNewResourceViewController *controller = (PPNewResourceViewController *)[segue.destinationViewController topViewController];
    controller.delegate = self;
    
  } else if ([segue.identifier isEqualToString:@"GetSavedPassphraseContext"]) {
    
    PPMasterPassphraseController *controller = (PPMasterPassphraseController *)[segue.destinationViewController topViewController];
    controller.delegate = self;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Properties

////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)resourceResults {
  
  if (!_resourceResults && _passphraseContext) {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityResource];
    NSSortDescriptor *sortByResourceName = [NSSortDescriptor sortDescriptorWithKey:@"generationDate" 
                                                                         ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortByResourceName];
    _resourceResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                           managedObjectContext:_passphraseContext.document.managedObjectContext 
                                                             sectionNameKeyPath:nil 
                                                                      cacheName:nil];
    _resourceResults.delegate = self;
  }
  return _resourceResults;
}

#pragma mark - Table view data source

////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return [[self.resourceResults sections] count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resourceResults sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"ResourceCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  // Configure the cell...
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
  PPResource *resource = [self.resourceResults objectAtIndexPath:indexPath];
  NSString *resourceTitle = [resource.encryptedTitle aesDecryptStringWithKey:_passphraseContext.encryptionKey 
                                                                       andIV:resource.initializationVector];
  PPPassphrase *latestPassphrase = nil;
  for (PPPassphrase *passphrase in resource.passphrases) {
    
    if (passphrase.generationDate > latestPassphrase.generationDate) {
      
      latestPassphrase = passphrase;
    }
  }
  NSString *clearphrase = [latestPassphrase.encryptedPhrase aesDecryptStringWithKey:_passphraseContext.encryptionKey 
                                                                              andIV:latestPassphrase.initializationVector];
  cell.detailTextLabel.text = clearphrase;
  cell.textLabel.text = resourceTitle;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

#pragma mark - NSFetchedResultsControllerDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  
  [self.tableView beginUpdates];
}


////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

#pragma mark - PPNewResourceViewControllerDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newResourceViewControllerDidCancel:(PPNewResourceViewController *)sender {
  
  [sender dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newResourceViewControllerDidFinish:(PPNewResourceViewController *)sender {
  
  [sender dismissModalViewControllerAnimated:YES];
  PPResource *resource = [PPResource resourceWithTitle:sender.resourceNameTextField.text 
                                        protectedByKey:_passphraseContext.encryptionKey 
                                inManagedObjectContext:_passphraseContext.document.managedObjectContext];
  PPPassphrase *passphrase = [PPPassphrase passphraseForWords:sender.passphrase 
                                             protectedWithKey:_passphraseContext.encryptionKey 
                                       inManagedObjectContext:_passphraseContext.document.managedObjectContext];
  [resource addPassphrasesObject:passphrase];
  [_passphraseContext.document saveToURL:_passphraseContext.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

#pragma mark - PPMasterPassphraseControllerDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)masterPassphraseControllerDidCancel:(PPMasterPassphraseController *)controller {
 
  [controller dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)masterPassphraseControllerDidFinish:(PPMasterPassphraseController *)controller {
  
  self.passphraseContext = controller.passphraseContext;
  [controller dismissModalViewControllerAnimated:YES];
  [self.resourceResults performFetch:NULL];
  [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)masterPassphraseController:(PPMasterPassphraseController *)controller didFailWithError:(NSError *)error {
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

@end
