//
//  GEOAppDelegate.h
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "GEOViewController.h"
#import "Evenements+Create.h"
#import "GEOLocationFinder.h"
#import "User+Create.h"

@interface GEOAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *
persistentStoreCoordinator;
@property (readonly, strong, nonatomic)  User * userCourant;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) UIWindow *window;

@end
