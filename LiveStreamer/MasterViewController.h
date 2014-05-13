//
//  MasterViewController.h
//  LiveStreamer
//
//  Created by Kai Waelti on 13/05/14.
//  Copyright (c) 2014 Kai Waelti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ELEditViewController.h"

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIImageView *toolbarLogo;
- (IBAction)feedbackPressed:(UIBarButtonItem *)sender;
- (IBAction)aboutPressed:(UIBarButtonItem *)sender;

@property ELEditViewController *editViewController;

@end
