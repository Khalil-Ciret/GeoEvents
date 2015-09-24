//
//  GEOLocationFinder.h
//  GeoEvents
//
//  Created by Khalil Ciret on 18/09/2015.
//  Copyright © 2015 novediagroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GEOLocationFinder : NSObject
<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocation *locationCourantePrecise; //Location utilisée pour le placement des annotations sur la carte
@property (strong,nonatomic) CLLocationManager *locManager;
@property (nonatomic) BOOL GPSFix; //Permet de savoir quand le GPS est fixé pour zoomer





@end
