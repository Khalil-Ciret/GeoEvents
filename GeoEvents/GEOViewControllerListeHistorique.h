//
//  GEOViewControllerListeHistorique.h
//  GeoEvents
//
//  Created by Khalil Ciret on 14/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Evenements.h"
#import "CelluleHistorique.h"
#import <CloudKit/CloudKit.h>

@interface GEOViewControllerListeHistorique : UITableViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) IBOutlet UISearchBar *rechercheEvents;
@property (strong, nonatomic) NSMutableArray *tableauRecherche;
@property (strong, nonatomic) User* userCourant;


@end
