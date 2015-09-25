//
//  GEOViewController.m
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "GEOViewController.h"
#import "GEOLocationFinderPourMap.h"
@interface GEOViewController ()


@property(strong, nonatomic) CKNotificationInfo* abonnementActuel;
@property(strong, nonatomic) GEOLocationFinderPourMap* finder;
@property(strong, nonatomic) NSString *idAbonnementCourant;
@end

@implementation GEOViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.idAbonnementCourant = [[NSString alloc] init];
    self.finder = [[GEOLocationFinderPourMap alloc] initWithGEOViewController:self];
    [self inscriptionNotificationSilencieuseAnnulationEvent];

    
}

-(IBAction)howAboutALittleTest:(UIStoryboardSegue* )seguisegue{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueMapEvent"])
    {
        // Get reference to the destination view controller
        GEOViewControllerCreationEvents *vce = (GEOViewControllerCreationEvents*) [[segue destinationViewController] topViewController];
        
        // Pass any objects to the view controller here, like...
        [vce setManagedObjectContext:self.managedObjectContext];
    }

    else{
        GEOViewControllerListeHistorique *vclh = (GEOViewControllerListeHistorique*) [[segue destinationViewController]topViewController];
        
        [vclh setUserCourant:self.userCourant];
        [vclh setManagedObjectContext:self.managedObjectContext];
        
}
}

- (MKOverlayRenderer *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

-(void) actualiserLaCarte{
    
    //On accède à la base de données publique
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDB = [container publicCloudDatabase];
    [self.map setShowsUserLocation:YES];
    
    [self.map setDelegate:self];

    
    //On récupère les énènements dans un rayon de 10 kilomètres
    NSNumber *radius = [NSNumber numberWithInt:10000];
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(SELF.lieu, %@) < %f", self.finder.locationCourantePrecise, radius];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Evenements" predicate: predicat];
    
    
    [publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if(!error)
        {
            //On compare les locations pour chaque évènement
            //Si la location est à moins de 10 km alors on l'ajoute sur la carte
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.map removeAnnotations:self.map.annotations];
                for(CKRecord *resultats in results){
                    CLLocation *loc = resultats[@"lieu"];
                        Event *evenement = [[Event alloc] initAvecCoordonnees:loc.coordinate avecNom:resultats[@"nom"] avecDescription:resultats[@"description"]];
                        [self.map addAnnotation:evenement];
                }
                
            });
        }
        else
        {
            NSLog(@"Erreur %@", error);
        }
        
        
        
        
        
    }];
    
    
}


//ヽ༼ຈل͜ຈ༽ﾉ RIOT ヽ༼ຈل͜ຈ༽ﾉ 
-(void)inscriptionNotification
{
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(SELF.lieu, %@) < 10000", self.finder.locationCourantePrecise];
    CKSubscription *abonnement = [[CKSubscription alloc] initWithRecordType:@"Evenements" predicate:predicat options:CKSubscriptionOptionsFiresOnRecordCreation];
    
    CKNotificationInfo *notificationInfo=[CKNotificationInfo new];
    notificationInfo.alertBody=@"Un évènement se passe près de votre localisation!";
    notificationInfo.shouldSendContentAvailable=YES;
    abonnement.notificationInfo=notificationInfo;
    
    self.userCourant.currentSubscriptionID=abonnement.subscriptionID;
    CKDatabase *publicDatabase= [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase saveSubscription:abonnement completionHandler:^(CKSubscription *subscription, NSError *error){
        if (error)
            NSLog(@"Erreur %@", error);
        else
            NSLog(@"Nouvel Abonnement bien pris en compte.");
    }];
    
}

-(void) inscriptionNotificationSilencieuseAnnulationEvent
{

    CKSubscription *abonnement = [[CKSubscription alloc] initWithRecordType:@"Evenements" predicate:[NSPredicate predicateWithFormat:@"TRUEPREDICATE"] options:CKSubscriptionOptionsFiresOnRecordDeletion];
    CKNotificationInfo *notificationInfo=[CKNotificationInfo new];
    notificationInfo.shouldSendContentAvailable=YES;
    notificationInfo.alertBody=@"";
    notificationInfo.desiredKeys = @[@"nom"];
    abonnement.notificationInfo=notificationInfo;
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
  
    [publicDatabase saveSubscription:abonnement completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
        if (error)
            NSLog(@"Erreur effaçage %@", error);
        else
            NSLog(@"Abonnement effaçage bien pris en compte.");
         [self.managedObjectContext save:nil];
    }];
    

}

-(void) desinscriptionDerniereNotification
{
    if (self.userCourant.currentSubscriptionID){
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase deleteSubscriptionWithID:self.userCourant.currentSubscriptionID completionHandler:^(NSString *subscriptionID, NSError *error){
        if (error)
            NSLog(@"Erreur %@", error);
        else
            NSLog(@"Désinscription du dernier abonnement.");
        
    }];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
*/





@end
