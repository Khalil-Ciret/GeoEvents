//
//  User+Create.m
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "User+Create.h"


@implementation User (Create)

+(User *) UserwithCKRecord:(CKRecord*) recordUser inManagedObjectContext:(NSManagedObjectContext*) context {
    
    User* user= nil;
    
    if(recordUser)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSPredicate *predicate= [NSPredicate predicateWithFormat:@"recordName = %@", recordUser.recordID.recordName ];
        request.predicate=predicate;
        NSError *error;
        NSArray *correspondances = [context executeFetchRequest:request error:&error];
        
        if([correspondances count])
        {
            user = [correspondances lastObject];
        }
        else if (error) {
            abort();
        }
        else
        {
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            user.recordName= recordUser.recordID.recordName;
            user.nbreEvent=0;
        }
        
    }
    
    return user;
    
}
@end
