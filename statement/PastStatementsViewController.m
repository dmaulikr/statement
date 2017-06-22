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
        cell.statementType.text = [self setStringFromDate:statementIndexObject.createdDate];
        
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
        
    } else {
        
        PastStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pastProfessionalStatement" forIndexPath:indexPath];
        
        Statement *statementIndexObject = _oldProfessionalStatementArray[indexPath.row];
        //NSLog(@"%@", statementIndexObject);
        
        cell.statementText.text = statementIndexObject.statementText;
        cell.statementType.text = [self setStringFromDate:statementIndexObject.createdDate];
        
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
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == _pastPersonalTableView) {
        
        return @"Personal";
        
    } else {
        
        return @"Professional";
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

@end
