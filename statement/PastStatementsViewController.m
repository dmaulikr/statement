//
//  PastStatementsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementsViewController.h"
#import "PastStatementCell.h"

@interface PastStatementsViewController ()

@end

@implementation PastStatementsViewController

AppDelegate *pastStatementsAppDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pastStatementsAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    _context = [[pastStatementsAppDelegate persistentContainer] viewContext];
    _fetchController = [pastStatementsAppDelegate initializeFetchedResultsControllerForEntity:@"Statement" withSortDescriptor:@"createdDate"];
    
    _pastPersonalTableView.delegate = self;
    _pastPersonalTableView.dataSource = self;
    _pastProfessionalTableView.delegate = self;
    _pastProfessionalTableView.dataSource = self;
    
    _oldPersonalStatementArray = [self fetchOldStatementsWithType:@"personal"];
    _oldProfessionalStatementArray = [self fetchOldStatementsWithType:@"professional"];
    
    NSLog(@"%@, %@", _oldPersonalStatementArray, _oldProfessionalStatementArray);
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
    
    if (_oldStatementsArray != nil) {
        
        Statement *statementIndexObject = _oldStatementsArray[indexPath.row];
        
        cell.textLabel.text = statementIndexObject.statementText;
    }
    
    return cell;
}

#pragma mark - Core Data Helper Functions

- (NSArray *)fetchOldStatementsWithType:(NSString *)type {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@ AND status == %@", type, @"old"]];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *fetchedOldStatements = [_context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedOldStatements count] < 1) {
        
        return nil;
    }
    
    //NSLog(@"%@", fetchedOldStatements);
    
    return fetchedOldStatements;
}

@end
