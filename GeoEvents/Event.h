//
//  Event.h
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Event : NSObject <MKAnnotation>
@property (nonatomic, readonly,copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

-(id)initAvecCoordonnees:(CLLocationCoordinate2D) coordonnes avecNom: (NSString *) nom avecDescription: (NSString *) description;

@end
