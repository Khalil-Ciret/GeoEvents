//
//  GEOAppDelegate.m
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "GEOAppDelegate.h"

@interface GEOAppDelegate ()
@property(strong,nonatomic) GEOLocationFinder* finder;
@property(readwrite,strong,nonatomic) User* userCourant;
@end
@implementation GEOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //TODO
    //Vérifier la connexion au cloud, fermer l'appli si il y'en à pas
    
    
    
    
    UINavigationController * navCont= (UINavigationController *) self.window.rootViewController;
    GEOViewController *premierControleur= [[navCont viewControllers] objectAtIndex:0];
    NSFetchRequest *requestUserCourant = [[NSFetchRequest alloc] init];
    [requestUserCourant setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    [requestUserCourant setIncludesPropertyValues:NO];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"SELF.currentUser = TRUE"];
    [requestUserCourant setPredicate: predicat];
    NSError *error = nil;
    NSArray* users= [self.managedObjectContext executeFetchRequest:requestUserCourant error:&error];
    if([users count])
    {
        self.userCourant=[users firstObject];
        premierControleur.userCourant=self.userCourant;
    }
    else
    {
        [[CKContainer defaultContainer ] fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userCourant= [User UserwithCKRecord:[[CKRecord alloc] initWithRecordType:@"Users" recordID:recordID]  inManagedObjectContext:self.managedObjectContext];
                self.userCourant.currentUser= [NSNumber numberWithBool:YES];
                premierControleur.userCourant=self.userCourant;
            
            });
 
        }];
        
    }
    
    
    //Lors de l'initialisation du finder, celui-ci s'occupe de faire la première mise à jour de la base de données
    //une fois que la location précise à été trouvée à l'aide du GPS.
    self.finder = [[GEOLocationFinder alloc] init];
    
    //Inscriptions pour les notifications push
    if ([application respondsToSelector:@selector (isRegisteredForRemoteNotifications)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    //Passage du managed object context

    premierControleur.managedObjectContext=self.managedObjectContext;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self majCompleteBDD];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"Yeepee,a notification ");

    CKQueryNotification * notification = [CKQueryNotification notificationFromRemoteNotificationDictionary:userInfo];
    
    if ([notification.alertBody isEqualToString:@""])
        [self effacerEvenement:notification.recordID];
    else
        [self ajoutEvenementsDansBDD:notification.recordID];
    

    UINavigationController * navCont= (UINavigationController *) self.window.rootViewController;
    GEOViewController *premierControleur= [[navCont viewControllers] objectAtIndex:0];
    [premierControleur actualiserLaCarte];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.theappcodellc.CoreDataTest” in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ModelEvents" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ModelEvents.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}


#pragma mark - Traitements des nouveaux evenements en temps réel

- (void) majCompleteBDD {
    
    [self initialiserGPS];
    CKContainer *container= [CKContainer defaultContainer];
    CKDatabase* publicDatabase = container.publicCloudDatabase;
    NSNumber *radius = [NSNumber numberWithInt:10000];
    
    
    //Création du prédicat composé adapté à la situation
    NSPredicate *predicateLieu = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation: (SELF.lieu, %@) < %f", self.finder.locationCourantePrecise, radius];
    NSPredicate *predicateTemps = [NSPredicate predicateWithFormat:@"SELF.dateEmission > %@" , [ NSDate dateWithTimeIntervalSinceNow:-3600*24]];
    NSArray *predicates = [NSArray arrayWithObjects:predicateLieu, predicateTemps, nil];
    NSCompoundPredicate *predicateFinal = [NSCompoundPredicate andPredicateWithSubpredicates: predicates];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Evenements" predicate: predicateFinal];
                                           
    [publicDatabase performQuery:query inZoneWithID: nil completionHandler:^(NSArray * results, NSError *error)
     {
         if (!error)
         {
             for(CKRecord *resultats in results)
             {
                 [Evenements EvenementwithCKRecord:resultats inManagedObjectContext: self.managedObjectContext];
                 
             }
             
         }
     }];
}
                                           
                                           
- (void) ajoutEvenementsDansBDD : (CKRecordID*)  IDEvenement{
    
    CKDatabase *pbdatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    [pbdatabase fetchRecordWithID:IDEvenement completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if(!error)
            [Evenements EvenementwithCKRecord:record inManagedObjectContext:self.managedObjectContext];
        else NSLog(@"Erreur lors de la récupération de l'évènement pour la mise en cache %@", error);
    }];

}
-(void) effacerEvenement:(CKRecordID *) IDAeffacer{
                                               
    [Evenements effacerEvenement:IDAeffacer inManagedObjectContext:self.managedObjectContext];
    
    [self.managedObjectContext save:nil];
}

-(void) initialiserGPS {
    
    self.finder.GPSFix=NO;
    
}
@end;

