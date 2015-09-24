//
//  User+Create.h
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "User.h"
#import <CloudKit/CloudKit.h>
#import <CoreData/CoreData.h>

@interface User (Create)

 +(User *) UserwithCKRecord:(CKRecord*) recordUser inManagedObjectContext:(NSManagedObjectContext*) context;
    
    


@end
