//
//  PastStatementsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementsViewController.h"

@interface PastStatementsViewController ()

@end

@implementation PastStatementsViewController

AppDelegate *pastStatementsAppDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pastStatementsAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    _context = [[pastStatementsAppDelegate persistentContainer] viewContext];
    _fetchController = [pastStatementsAppDelegate initializeFetchedResultsControllerForEntity:@"Statement" withSortDescriptor:@"createdDate"];
    
    _pastStatementsTableView.delegate = self;
    
    _oldStatementsArray = [self fetchOldStatements];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_oldStatementsArray count] > 0) {

        return [_oldStatementsArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastStatement"];
    
    return cell;
}

#pragma mark - Core Data Helper Functions

- (NSArray *)fetchOldStatements {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"status == %@", @"old"]];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *fetchedOldStatements = [_context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedOldStatements count] < 1) {
        
        return nil;
    }
    
    NSLog(@"%@", fetchedOldStatements);
    
    return fetchedOldStatements;
}

@end
