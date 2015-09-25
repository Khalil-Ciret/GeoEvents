//
//  GEOTableViewControllerVingtQuatreHr.m
//  GeoEvents
//
//  Created by Khalil Ciret on 16/09/2015.
//  Copyright (c) 2015 novediagroup. All rights reserved.
//

#import "GEOTableViewControllerVingtQuatreHr.h"
#import "Evenements.h"


@interface GEOTableViewControllerVingtQuatreHr () <NSFetchedResultsControllerDelegate>

@end

@implementation GEOTableViewControllerVingtQuatreHr

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *toutLesEvenements24hSaufMiens = [[NSFetchRequest alloc] initWithEntityName:@"Evenements"];
    
    [toutLesEvenements24hSaufMiens setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
    NSPredicate *predicatTemps=  [NSPredicate predicateWithFormat:@"SELF.date > %@", [NSDate dateWithTimeIntervalSinceNow:-86000]];
    
    NSPredicate *predicatUser = [NSPredicate predicateWithFormat:@"SELF.lancePar != %@",self.userCourant];
            NSCompoundPredicate *predicatFinal = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicatTemps,predicatUser]];
            [toutLesEvenements24hSaufMiens setPredicate:predicatFinal];
            self.resController = [[NSFetchedResultsController alloc] initWithFetchRequest:toutLesEvenements24hSaufMiens managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName: nil];
            
            [self.resController setDelegate:self];
            
            NSError *error = nil;
            [self.resController performFetch:&error];
            if (error) {
                NSLog(@"Unable to perform fetch.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
    [self.tableView setUserInteractionEnabled:YES];
            
            [self.tableView reloadData];

    
    
    [self.tableView setDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.resController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSArray *sections=[self.resController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo= [sections objectAtIndex:section];
    return  [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evenement24" forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"evenement24" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    

    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Evenements* ev= [self.resController objectAtIndexPath:indexPath];
    cell.textLabel.text = ev.nom;
    cell.detailTextLabel.text = ev.descriptionString;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];

}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"Boum");
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"Bem");
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            NSLog(@"%d",[self.tableView numberOfRowsInSection:0]);
            [self.tableView reloadData ];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
                        NSLog(@"%d",[self.tableView numberOfRowsInSection:0]);
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/*

*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
