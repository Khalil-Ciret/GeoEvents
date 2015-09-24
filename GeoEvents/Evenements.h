//
//  Evenements.h
//  GeoEvents
//
//  Created by Khalil Ciret on 17/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Evenements : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descriptionString;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSString * recordName;
@property (nonatomic, retain) User *lancePar;

@end
