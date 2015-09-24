//
//  GEOViewController.h
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "Event.h"
#import "GEOViewControllerCreationEvents.h"
#import "GEOViewControllerListeHistorique.h"
@import MapKit;

@interface GEOViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) User *userCourant;

-(void)inscriptionNotification;
-(void) desinscriptionDerniereNotification;
-(void) actualiserLaCarte;


@end
