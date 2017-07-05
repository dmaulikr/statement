//
//  PastStatementsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementsViewController.h"
#import "PastStatementCell.h"
#import "PastStatementDetailsViewController.h"

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
    
    //NSLog(@"%@, %@", _oldPersonalStatementArray, _oldProfessionalStatementArray);
    
    /*Statement *examplePersonalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
    examplePersonalStatement.statementText = @"example personal3";
    examplePersonalStatement.comments = @"example personal comments";
    examplePersonalStatement.completed = 0;
    examplePersonalStatement.status = @"old";
    examplePersonalStatement.createdDate = [NSDate date];
    examplePersonalStatement.type = @"personal";
    
    Statement *exampleProfessionalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
    exampleProfessionalStatement.statementText = @"example professional3";
    exampleProfessionalStatement.comments = @"example professional comments";
    exampleProfessionalStatement.completed = 0;
    exampleProfessionalStatement.status = @"old";
    exampleProfessionalStatement.createdDate = [NSDate date];
    exampleProfessionalStatement.type = @"professional";
    
    [pastStatementsAppDelegate saveContext];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_pastPersonalTableView reloadData];
    [_pastProfessionalTableView reloadData];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _pastPersonalTableView) {
    
        return [_oldPersonalStatementArray count];
    }
    
    if (tableView == _pastProfessionalTableView) {
        
        return [_oldProfessionalStatementArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _pastPersonalTableView) {
        
        PastStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastPersonalStatement" forIndexPath:indexPath];
        
        Statement *statementIndexObject = _oldPersonalStatementArray[indexPath.row];
        //NSLog(@"%@", statementIndexObject.statementText);
        
        cell.statementText.text = statementIndexObject.statementText;
        cell.statementCreatedDate.text = [self setStringFromDate:statementIndexObject.createdDate];
        
        if (statementIndexObject.completed == 1) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Blue Filled Thumbs Down"];
        }
        
        if (statementIndexObject.completed == 2) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Blue Filled Thumbs Up"];
        }
        
        if (statementIndexObject.completed == 0) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Thinking Face Emoji"];
        }
        
        return cell;
        
    }
    
    if (tableView == _pastProfessionalTableView) {
        
        PastStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastProfessionalStatement" forIndexPath:indexPath];
        
        Statement *statementIndexObject = _oldProfessionalStatementArray[indexPath.row];
        //NSLog(@"%@", statementIndexObject);
        
        cell.statementText.text = statementIndexObject.statementText;
        cell.statementCreatedDate.text = [self setStringFromDate:statementIndexObject.createdDate];
        
        if (statementIndexObject.completed == 1) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Green Filled Thumbs Down"];
        }
        
        if (statementIndexObject.completed == 2) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Green Filled Thumbs Up"];
        }
        
        if (statementIndexObject.completed == 0) {
            
            cell.completionStatusImage.image = [UIImage imageNamed:@"Thinking Face Emoji"];
        }
        
        return cell;
    }
    
    UITableViewCell *cell;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == _pastPersonalTableView) {
        
        return @"Personal";
        
    } else {
        
        return @"Professional";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _pastPersonalTableView) {
        
        if (_oldPersonalStatementArray != nil) {
            
            // Assigns selectedStatement property which is passed to next VC
            
            _selectedStatement = _oldPersonalStatementArray[indexPath.row];
            [self performSegueWithIdentifier:@"statementDetailsSegue" sender:self];
        }
    }
    
    if (tableView == _pastProfessionalTableView) {
        
        if (_oldProfessionalStatementArray != nil) {
            
            // Assigns selectedStatement property which is passed to next VC
            
            _selectedStatement = _oldProfessionalStatementArray[indexPath.row];
            [self performSegueWithIdentifier:@"statementDetailsSegue" sender:self];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65;
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

#pragma mark - Helper Functions

- (NSString *)setStringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark - Segue Preparation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"statementDetailsSegue"]) {
        
        PastStatementDetailsViewController *viewController = [segue destinationViewController];
        [viewController setPastStatement:_selectedStatement];
    }
}

@end
