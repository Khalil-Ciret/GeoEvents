//
//  User+CoreDataProperties.h
//  GeoEvents
//
//  Created by Khalil Ciret on 22/09/2015.
//  Copyright © 2015 novediagroup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *nbreEvent;
@property (nullable, nonatomic, retain) NSString *recordName;
@property (nullable, nonatomic, retain) NSNumber *currentUser;
@property (nullable, nonatomic, retain) NSSet<Evenements *> *aLance;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addALanceObject:(Evenements *)value;
- (void)removeALanceObject:(Evenements *)value;
- (void)addALance:(NSSet<Evenements *> *)values;
- (void)removeALance:(NSSet<Evenements *> *)values;

@end

NS_ASSUME_NONNULL_END
