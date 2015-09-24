//
//  Evenements+Create.m
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "Evenements+Create.h"

@implementation Evenements (Create)

+(Evenements *) EvenementwithCKRecord:(CKRecord*) recordEvenement inManagedObjectContext:(NSManagedObjectContext*) context {
    
    Evenements* ev= nil;
    
    if(recordEvenement)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Evenements"];
        NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.recordName= %@",recordEvenement.recordID.recordName];
        request.predicate=predicate;
        NSError *error;
        NSArray *correspondances = [context executeFetchRequest:request error:&error];
        
        if([correspondances count])
        {
            ev = [correspondances lastObject];
        }
        else if (error) {
            abort();
        }
        else
        {
            ev = [NSEntityDescription insertNewObjectForEntityForName:@"Evenements" inManagedObjectContext:context];
            ev.recordName= recordEvenement.recordID.recordName;
            NSLog(@"recordName Enregistré: %@",ev.recordName);

            ev.nom=recordEvenement[@"nom"];
            ev.descriptionString=recordEvenement[@"description"];
            ev.date= recordEvenement[@"dateEmission"];
            
            
            CLLocation* locRecord= recordEvenement[@"lieu"];
            ev.latitude = [NSNumber numberWithDouble:locRecord.coordinate.latitude];
            ev.longitude = [NSNumber numberWithDouble:locRecord.coordinate.longitude];
            
            CKReference* refUserCourant = recordEvenement[@"user"];
            CKRecord *userCourant =  [[CKRecord alloc] initWithRecordType:@"User" recordID:[refUserCourant recordID]];
            ev.lancePar = [User UserwithCKRecord:userCourant inManagedObjectContext:context];
            [context save:nil];
        }
        
    }
    
    return ev;
    
}

+(void) effacerEvenement:(CKRecordID*) IDaEffacer inManagedObjectContext:(NSManagedObjectContext*) context {
    
    if(IDaEffacer)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Evenements"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.recordName=%@", IDaEffacer.recordName];
        request.predicate=predicate;
        NSError *error;
        NSArray *correspondances = [context executeFetchRequest:request error:&error];
        
        if([correspondances count])
        {
            [context deleteObject:[correspondances lastObject]];
        }
    }
    
    
}
@end

