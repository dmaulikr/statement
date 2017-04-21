//
//  ViewController.m
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//
#import "CreateStatementViewController.h"
#import "AppDelegate.h"

@interface CreateStatementViewController ()

@end

@implementation CreateStatementViewController

#pragma mark - UIViewController

@synthesize createdStatement;

AppDelegate *appDelegate;
NSMutableArray *statementArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statementTextField.delegate = self;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [[appDelegate persistentContainer] viewContext];
    
    _fetchController = [appDelegate initializeFetchedResultsController];
    
    statementArray = [_fetchController.fetchedObjects mutableCopy];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [appDelegate saveContext];
}

- (IBAction)createStatement:(UITextField *)sender {
    
    /*for (NSManagedObject *object in _fetchController.fetchedObjects) {
        
     [_fetchController.managedObjectContext deleteObject:object];
    }*/
    
    self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
    self.createdStatement.statementText = _statementTextField.text;
    
    [statementArray addObject:createdStatement];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[statementArray indexOfObject:createdStatement] inSection:0];
    
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [_tableView endUpdates];
    
    [appDelegate saveContext];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (statementArray == nil) {
        return 0;
    } else {
        return [statementArray count];
    }
}

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statementCell"];
    Statement *statementIndexObject = (Statement *)[statementArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = statementIndexObject.statementText;
    
    return cell;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return TRUE;
}

@end
