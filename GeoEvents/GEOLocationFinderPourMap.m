//
//  GEOLocationFinderPourMap.m
//  GeoEvents
//
//  Created by Khalil Ciret on 18/09/2015.
//  Copyright © 2015 novediagroup. All rights reserved.
//

#import "GEOLocationFinderPourMap.h"

@implementation GEOLocationFinderPourMap

-(id) initWithGEOViewController:(GEOViewController *)controllerAInformer{
    self=[super init];
    if(self)
    {
        self.controllerAInformer=controllerAInformer;
        self.GPSFix=NO;
        self.locationCouranteApproximative= [[CLLocation alloc] init];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.locationCourantePrecise= [locations lastObject];
    if([self.locationCourantePrecise distanceFromLocation:self.locationCouranteApproximative] >50 )
    {
        self.locationCouranteApproximative= self.locationCourantePrecise;
        
        [self.controllerAInformer actualiserLaCarte];
        
        
        //Centrage de la carte une fois que les coordonnées GPS sont différentes de zéro
        if (self.locationCourantePrecise.coordinate.latitude!=0 && self.locationCourantePrecise.coordinate.longitude !=0)
        {
            [self.controllerAInformer desinscriptionDerniereNotification];
            [self.controllerAInformer inscriptionNotification];
            if(!self.GPSFix)
            {
                MKCoordinateRegion region;
                region.center= self.locationCourantePrecise.coordinate;
                region.span.latitudeDelta=0.3;
                region.span.longitudeDelta=0.3;
                [self.controllerAInformer.map setRegion:region animated:YES];
                self.GPSFix=YES;
            }
        }
    }
    
    
    
}

@end
