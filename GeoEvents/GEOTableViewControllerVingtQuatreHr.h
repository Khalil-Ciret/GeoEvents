//
//  GEOTableViewControllerVingtQuatreHr.h
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "User+Create.h"

@interface GEOTableViewControllerVingtQuatreHr : UITableViewController
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController* resController;
@property(nonatomic, strong) User* userCourant;

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
@end
