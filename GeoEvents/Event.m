//
//  Event.m
//  GeoEvents
//
//  Created by Khalil Ciret on 08/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "Event.h"

@interface Event()
@property(nonatomic, readwrite) NSString *title;
@property(nonatomic, readwrite) NSString *subtitle;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;


@end
@implementation Event

-(id) initAvecCoordonnees:(CLLocationCoordinate2D)coordonnes avecNom:(NSString *)nom avecDescription:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        self.title=nom;
        self.coordinate= coordonnes;
        self.subtitle= description;
    }
    return self;
    
}

@end
