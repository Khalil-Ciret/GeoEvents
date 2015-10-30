//
//  GEOLocationFinder.m
//  GeoEvents
//
//  Created by Khalil Ciret on 18/09/2015.
//  Copyright © 2015 novediagroup. All rights reserved.
//

#import "GEOLocationFinder.h"
#import "GEOAppDelegate.h"

@implementation GEOLocationFinder

-(id) init {
    
    
    self.GPSFix=NO;
    self.locManager = [[CLLocationManager alloc] init];
    self.locationCourantePrecise = [[CLLocation alloc] init];
    [self.locManager setDelegate:self];
    //Localisation de l'utilisateur
    if ([CLLocationManager locationServicesEnabled]){
        
        [self.locManager requestWhenInUseAuthorization];
        self.locManager.delegate=self;
        self.locManager.desiredAccuracy=kCLLocationAccuracyBest;
        [self.locManager startUpdatingLocation];
    }
    
    return self;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    do {
        self.locationCourantePrecise= [locations lastObject];
    } while (self.locationCourantePrecise.coordinate.longitude==0);
    if(!self.GPSFix)
    {
        

                NSLog(@" GPS accroché");
    }
    self.GPSFix=YES;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}

@end
