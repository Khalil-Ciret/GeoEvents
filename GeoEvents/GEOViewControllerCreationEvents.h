//
//  GEOViewControllerCreationEvents.h
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "Evenements.h"
#import "Evenements+Create.h"

@interface GEOViewControllerCreationEvents : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfNom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *creationNouvelEvenement;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (strong, nonatomic) NSManagedObjectModel *modeleEv;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;



@end
