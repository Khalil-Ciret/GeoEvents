//
//  GEOViewControllerListeHistorique.m
//  GeoEvents
//
//  Created by Khalil Ciret on 14/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "GEOViewControllerListeHistorique.h"
#import "User+Create.h"
#define HAUTEUR_CELLULE 78;

@interface GEOViewControllerListeHistorique ()

@property (strong,nonatomic) NSArray* valeurs; //Of NSManagedObjects
@end

@implementation GEOViewControllerListeHistorique

- (IBAction)viderHistorique:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Vider l'historique?"
                                                                   message:@"Cette action sera définitive!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Quoi? Non!"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
    
    
    UIAlertAction* detruireHistorique = [UIAlertAction actionWithTitle:@"Adieu, historique." style:     UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                    
        NSFetchRequest *allEvents = [[NSFetchRequest alloc] init];
        [allEvents setEntity:[NSEntityDescription entityForName:@"Evenements" inManagedObjectContext:  self.managedObjectContext]] ;
        [allEvents setIncludesPropertyValues:NO]; //only fetch the managedObjectID
                                                              
        NSError *error = nil;
        NSArray *evs = [self.managedObjectContext executeFetchRequest:allEvents error:&error];
        
        for (NSManagedObject *ev in evs) {
            [self.managedObjectContext deleteObject:ev];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        [self.tableView reloadData];
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:detruireHistorique];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entite=[NSEntityDescription entityForName:@"Evenements"inManagedObjectContext:self.managedObjectContext];
    
    dispatch_semaphore_t semaphoreRequeteUserID=dispatch_semaphore_create(0);
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF.lancePar = %@", self.userCourant]];
    [request setEntity:entite];
    
    NSError* error=nil;

    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Requête non éxécutée:  %@", error);
    }
    else{
        self.valeurs= result;
    }
    self.tableauRecherche = [NSMutableArray arrayWithCapacity: [self.valeurs count]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - tableView Like a boss

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView ==self.searchDisplayController.searchResultsTableView)
        return [self.tableauRecherche count];
    else
        return [self.valeurs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CelluleHistorique";
    
     CelluleHistorique* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CelluleHistorique" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(tableView ==self.searchDisplayController.searchResultsTableView){
        
    cell.labelTitre.text=[[self.tableauRecherche objectAtIndex:indexPath.row] valueForKey:@"nom"];
    cell.labelDescription.text= [[self.tableauRecherche objectAtIndex:indexPath.row] valueForKey:@"descriptionString"];
    }
    
    else{
        
        cell.labelTitre.text=[[self.valeurs objectAtIndex:indexPath.row] valueForKey:@"nom"];
        cell.labelDescription.text= [[self.valeurs objectAtIndex:indexPath.row] valueForKey:@"descriptionString"];
        
        
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HAUTEUR_CELLULE;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.tableauRecherche removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.nom contains[c] %@",searchText];
    self.tableauRecherche = [NSMutableArray arrayWithArray:[self.valeurs filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
