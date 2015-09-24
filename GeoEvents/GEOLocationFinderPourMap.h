//
//  GEOLocationFinderPourMap.h
//  GeoEvents
//
//  Created by Khalil Ciret on 18/09/2015.
//  Copyright © 2015 novediagroup. All rights reserved.
//

#import "GEOLocationFinder.h"
#import "GEOViewController.h"
@interface GEOLocationFinderPourMap : GEOLocationFinder

@property(strong, nonatomic) CLLocation *locationCouranteApproximative; //Location approximative utilisée pour le rafraichissement des évènements automatique tout les 50 mètres
@property(strong, nonatomic) GEOViewController* controllerAInformer;

-(id) initWithGEOViewController :(GEOViewController* ) controllerAInformer;

@end
