//
//  PPResourcesViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 7/15/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PPResourcesViewController.h"
#import "PPSavedPassphraseContext.h"
#import "PPResource.h"
#import "PPNewResourceViewController.h"

@interface PPResourcesViewController () <
  NSFetchedResultsControllerDelegate,
  PPNewResourceViewControllerDelegate
>

@property (strong, nonatomic) NSFetchedResultsController *resourceResults;
- (IBAction)didTapAdd:(id)sender;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"PresentNewResourceController"]) {
    
    PPNewResourceViewController *controller = (PPNewResourceViewController *)[segue.destinationViewController topViewController];
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
  
  if (!_resourceResults) {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityResource];
    NSSortDescriptor *sortByResourceName = [NSSortDescriptor sortDescriptorWithKey:@"encryptedTitle" 
                                                                         ascending:YES 
                                                                        comparator:^NSComparisonResult(id obj1, id obj2) {
      
      PPResource *resource1 = obj1;
      PPResource *resource2 = obj2;
      NSString *title1 = [resource1.encryptedTitle aesDecryptStringWithKey:_passphraseContext.encryptionKey 
                                                                     andIV:resource1.initializationVector];
      NSString *title2 = [resource2.encryptedTitle aesDecryptStringWithKey:_passphraseContext.encryptionKey 
                                                                     andIV:resource2.initializationVector];
      return [title1 caseInsensitiveCompare:title2];
    }];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortByResourceName];
    _resourceResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                           managedObjectContext:_passphraseContext.document.managedObjectContext 
                                                             sectionNameKeyPath:nil 
                                                                      cacheName:nil];
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
  PPResource *resource = [self.resourceResults objectAtIndexPath:indexPath];
  NSString *resourceTitle = [resource.encryptedTitle aesDecryptStringWithKey:_passphraseContext.encryptionKey 
                                                                       andIV:resource.initializationVector];
  cell.textLabel.text = resourceTitle;
  
  return cell;
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

#pragma mark - PPNewResourceViewControllerDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newResourceViewControllerDidCancel:(PPNewResourceViewController *)sender {
  
  [sender dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newResourceViewControllerDidFinish:(PPNewResourceViewController *)sender {
  
  [sender dismissModalViewControllerAnimated:YES];
}

#pragma mark - Instance methods

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didTapAdd:(id)sender {
  
}

@end
