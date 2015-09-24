
//  GEOViewControllerCreationEvents.m
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "GEOViewControllerCreationEvents.h"

@interface GEOViewControllerCreationEvents ()

@property (strong,nonatomic) CLLocationManager *locManager;
@property(strong, nonatomic) CLLocation *locationCourante;
@end

@implementation GEOViewControllerCreationEvents



- (IBAction)quitter:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
}

-(void) afficherMessageErreur: (NSString*) messageErreur{
    
    UIAlertController* alerte = [UIAlertController alertControllerWithTitle:@"Erreur!" message:messageErreur preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:^(UIAlertAction *action) {
    }];
    [alerte addAction:ok];
    [self presentViewController:alerte animated:YES completion:nil];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self verificationChamps:nil];
    self.locManager = [[CLLocationManager alloc] init];
    self.locationCourante = [[CLLocation alloc] init];
    NSURL * urlModele = [[NSURL alloc] initFileURLWithPath:@"ModelEvents.xcdatamodeld"];
    self.modeleEv = [[NSManagedObjectModel alloc] initWithContentsOfURL:urlModele];
    
    //Localisation de l'utilisateur
    if ([CLLocationManager locationServicesEnabled]){
        
        [self.locManager requestWhenInUseAuthorization];
        self.locManager.delegate=self;
        self.locManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        [self.locManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//Lors de la préparation ( avant le retour sur la carte ), on ajoute l'évènement qui vient d'être crée à la base de données

- (IBAction)CreationEvenement:(id) sender {
            CKContainer *container = [CKContainer defaultContainer];
            CKDatabase *publicDB = [container publicCloudDatabase];
            CKRecord *nouvelEvenement = [[CKRecord alloc] initWithRecordType:@"Evenements"];
            
            nouvelEvenement[@"nom"] = self.tfNom.text;
            nouvelEvenement[@"description"] = self.tfDescription.text;
            nouvelEvenement[@"lieu"] = self.locationCourante;
            nouvelEvenement[@"dateEmission"] = [NSDate date];
            [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
                
                if (error)
                {
                        [self afficherMessageErreur:@"Erreur : vous n'êtes pas identifié au Cloud!"];

                }
                else
                {
                    CKReference *userCourant = [[CKReference alloc] initWithRecordID:recordID action: CKReferenceActionNone ];
                    nouvelEvenement[@"user"] =userCourant;
                        

                    [Evenements  EvenementwithCKRecord:nouvelEvenement inManagedObjectContext:self.managedObjectContext];
                    
                      [publicDB saveRecord:nouvelEvenement completionHandler:^(CKRecord *record,NSError *error){
                        if (error){
                            [self afficherMessageErreur:@"Erreur pendant la sauvegarde de l'évènement!"];
                        }
                    
                     
                    }];

                }
        
            }];
        

        
        [self quitter:sender];
}

- (IBAction)verificationChamps:(id)sender {
    if ( [self.tfNom.text  length]==0 || [self.tfDescription.text length] ==0){
        [self.creationNouvelEvenement setEnabled:NO];
    }
    else{
        [self.creationNouvelEvenement setEnabled:YES];
    }
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.locationCourante= [locations lastObject];
}


@end
