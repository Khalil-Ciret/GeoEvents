//
//  Evenements+Create.h
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "Evenements.h"
#import "User+Create.h"
#import <CloudKit/CloudKit.h>

@interface Evenements (Create)

+(Evenements *) EvenementwithCKRecord:(CKRecord*) recordEvenement inManagedObjectContext:(NSManagedObjectContext*) context;

+(void) effacerEvenement:(CKRecordID*) IDaEffacer inManagedObjectContext:(NSManagedObjectContext*) context;
@end
